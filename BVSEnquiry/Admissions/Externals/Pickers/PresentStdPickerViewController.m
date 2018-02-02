//
//  PresentStdPickerViewController.m
//  BVSEnquiry
//
//  Created by Kutung iMac 01 on 16/10/15.
//  Copyright (c) 2015 Kutung. All rights reserved.
//

#import "PresentStdPickerViewController.h"

@interface PresentStdPickerViewController ()

@end

@implementation PresentStdPickerViewController

@synthesize delegate,pickerView,selectedPickerDict, pickerArray, selectedIndex;

+ (PresentStdPickerViewController*)sharedSingleton
{
    static PresentStdPickerViewController * sharedSingleton;
    
    if(!sharedSingleton)
    {
        @synchronized(sharedSingleton)
        {
            sharedSingleton = [[PresentStdPickerViewController alloc]initWithNibName:@"PresentStdPickerViewController" bundle:nil];
        }
    }
    
    return sharedSingleton;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
     selectedIndex = 0;
    
  //  pickerArray=[[NSMutableArray alloc] initWithObjects:@"No Schooling",@"Play School",@"Pre-KG",@"LKG",@"UKG",@"1st Grade",@"2nd Grade",@"3rd Grade",@"4th Grade",@"5th Grade",@"6th Grade",@"7th Grade",nil];
    
    [self createDoneButton];
}

-(void)viewWillAppear:(BOOL)animated
{
    // Modified on 20/01/17 by Mahesh
    // for prepopulating already selected value in picker clicked on button
    selectedPickerDict = [NSMutableDictionary new];
    
    for(int i=0;i<pickerArray.count;i++)
    {
        NSDictionary *dict=[pickerArray objectAtIndex:i];
        
        if([[self checkForNumberOrString:[self.selectedPickerDict objectForKey:@"ClassId"]] isEqualToString:[self checkForNumberOrString:[dict objectForKey:@"ClassId"]]])
        {
            [pickerView selectRow:[pickerArray indexOfObject:self.selectedPickerDict] inComponent:0 animated:YES];
            
            break;
        }
        else
        {
            [pickerView selectRow:0 inComponent:0 animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createDoneButton
{
    UIButton *doneButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    doneButton.frame=CGRectMake(self.view.frame.size.width/2-50,pickerView.frame.origin.y + pickerView.frame.size.height + 20, 100, 40);
    doneButton.layer.cornerRadius=3.0f;
    [doneButton setTitleColor:appWhiteColor forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    doneButton.backgroundColor=appButtonColor;
    doneButton.titleLabel.font=CustomRegular(20);
    doneButton.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    [self.view addSubview:doneButton];
}

// Added this method on 20/01/17 by Mahesh
-(NSString *)checkForNumberOrString:(id) movieObjectString
{
    if([movieObjectString isKindOfClass:[NSNumber class]])
    {
        movieObjectString=[movieObjectString stringValue];
    }
    
    return movieObjectString;
    
}

- (IBAction)doneButtonClicked:(id)sender
{
    // Commented on 20/01/17 by Mahesh
//    if(selectedString ==nil || [selectedString isEqualToString:@""] ||[selectedString isKindOfClass:[NSNull class]])
//    {
//        selectedString=@"No Schooling";
//    }
    
    // Modified on 03/02/17 by Mahesh
    if (pickerArray.count > 0)
    {
        NSLog(@"selectedIndex is %d",selectedIndex);
         [selectedPickerDict addEntriesFromDictionary:[pickerArray objectAtIndex:selectedIndex]];
        [delegate sendSelectedPickerValue:selectedPickerDict];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIPickerView Delegates
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
   // NSLog(@"picked value is %@",pickerArray);
    
    NSDictionary *dict = [pickerArray objectAtIndex:row];
    
    return [dict valueForKey:@"class_name"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSMutableDictionary *dict = [pickerArray objectAtIndex:row];
    
    if(selectedPickerDict.count>0)
    {
        [selectedPickerDict removeAllObjects];
    }
    selectedIndex = (NSInteger)row;
    
    [selectedPickerDict addEntriesFromDictionary:dict];// Modified on 20/01/17 by Mahesh
    
}

@end

