//
//  ApplyStdViewController.m
//  BVSEnquiry
//
//  Created by Kutung iMac 01 on 16/10/15.
//  Copyright (c) 2015 Kutung. All rights reserved.
//

#import "ApplyStdViewController.h"

@interface ApplyStdViewController ()

@end

@implementation ApplyStdViewController

@synthesize delegate,pickerView,selectedDict, pickerArray;

+ (ApplyStdViewController*)sharedSingleton
{
    static ApplyStdViewController * sharedSingleton;
    if(!sharedSingleton)
    {
        @synchronized(sharedSingleton)
        {
            sharedSingleton = [[ApplyStdViewController alloc]initWithNibName:@"ApplyStdViewController" bundle:nil];
        }
    }
    
    return sharedSingleton;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
  //  pickerArray=[[NSMutableArray alloc] initWithObjects:@"Pre-KG",@"LKG",@"UKG",@"1st Std",@"2nd Std",@"3rd Std",@"4th Std",@"5th Std",@"6th Std",@"7th Std", nil];
    
 //   pickerArray=[NSMutableArray new];

    [self createDoneButton];
}

-(void)viewWillAppear:(BOOL)animated
{
    // for prepopulating already selected value in picker clicked on button
    
    for(int i=0;i<pickerArray.count;i++)
    {
        NSDictionary *dict=[pickerArray objectAtIndex:i];
        if([[self checkForNumberOrString:[self.selectedDict objectForKey:@"ClassId"]] isEqualToString:[self checkForNumberOrString:[dict objectForKey:@"ClassId"]]])
        {
            [pickerView selectRow:[pickerArray indexOfObject:self.selectedDict] inComponent:0 animated:YES];
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
    if (pickerArray.count > 0)
    {   //ethayan
        if(selectedDict == nil ||[selectedDict isKindOfClass:[NSNull class]])
        {
            selectedDict=[pickerArray objectAtIndex:0];
        }
        [delegate sendSelectedApplyStdPickerValue:selectedDict];
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
    return [[pickerArray objectAtIndex:row] valueForKey:@"class_name"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    /*
     {
     "ClassId": "50",
     "class_name": "6th",
     "status": "0"
     },
     */
    if (pickerArray.count > 0)
    {  //ethayan
      //  NSLog(@"picked value is %@",[pickerArray objectAtIndex:row]);
        selectedDict=[pickerArray objectAtIndex:row];
    }
}

@end


