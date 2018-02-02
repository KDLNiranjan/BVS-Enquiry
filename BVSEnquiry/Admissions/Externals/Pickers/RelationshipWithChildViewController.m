//
//  RelationshipWithChildViewController.m
//  BVSEnquiry
//
//  Created by Kutung-PC43 on 29/09/16.
//  Copyright © 2016 Kutung. All rights reserved.
//

#import "RelationshipWithChildViewController.h"

@interface RelationshipWithChildViewController ()

@end

@implementation RelationshipWithChildViewController
@synthesize delegate,pickerView,selectedString, pickerArray;


+ (RelationshipWithChildViewController*)sharedSingleton
{
    static RelationshipWithChildViewController * sharedSingleton;
    if(!sharedSingleton)
    {
        @synchronized(sharedSingleton)
        {
            sharedSingleton = [[RelationshipWithChildViewController alloc]initWithNibName:@"StateViewController" bundle:nil];
        }
    }
    
    return sharedSingleton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [self createDoneButton];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    // for prepopulating already selected value in picker clicked on button
    
    if([pickerArray containsObject:self.selectedString])
    {
        [pickerView selectRow:[pickerArray indexOfObject:self.selectedString] inComponent:0 animated:YES];
    }
    else
    {
        [pickerView selectRow:0 inComponent:0 animated:YES];
        
    }
}


-(void)createDoneButton
{
    UIButton *doneButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    doneButton.frame=CGRectMake(self.view.frame.size.width/2-50,pickerView.frame.origin.y + pickerView.frame.size.height+87, 100, 40);//pickerView.frame.origin.y + pickerView.frame.size.height+5
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
    if(selectedString ==nil ||[selectedString isKindOfClass:[NSNull class]])
    {
        selectedString=[pickerArray objectAtIndex:0];
    }
    
    [delegate sendSelectedApplyRelationOfChildPickerValue:selectedString];
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
    return [pickerArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedString=[pickerArray objectAtIndex:row];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
