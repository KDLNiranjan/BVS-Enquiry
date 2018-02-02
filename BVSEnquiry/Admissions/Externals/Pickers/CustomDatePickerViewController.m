//
//  CustomDatePickerViewController.m
//  BVSEnquiry
//
//  Created by Kutung iMac 01 on 29/09/15.
//  Copyright (c) 2015 Kutung iMac 01. All rights reserved.
//

#import "CustomDatePickerViewController.h"

@interface CustomDatePickerViewController ()

@end

@implementation CustomDatePickerViewController

@synthesize delegate,datePicker;

+ (CustomDatePickerViewController*)sharedSingleton
{
    static CustomDatePickerViewController * sharedSingleton;
    if(!sharedSingleton)
    {
        @synchronized(sharedSingleton)
        {
            sharedSingleton = [[CustomDatePickerViewController alloc]initWithNibName:@"CustomDatePickerViewController" bundle:nil];
        }
    }
    return sharedSingleton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // self.view.backgroundColor=appRedcolor;

    datePicker.datePickerMode = UIDatePickerModeDate;

}

-(void)viewWillAppear:(BOOL)animated
{
    // 2015-10-14 14:56:09 +0000
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    datePicker.minimumDate = [dateFormatter dateFromString:@"01/01/2001"];
    
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    
  //  NSInteger year = components.year;
    NSInteger month = components.month;
    NSInteger day = components.day;
    NSInteger minimumMonth = month - 3;
    NSInteger minimumDay = day - 31;
    [components setYear:-1];
    [components setMonth:-minimumMonth];
    [components setDay:-minimumDay];
    NSDate *maxDate = [calendar dateByAddingComponents:components toDate:currentDate options:0];
    [datePicker setMaximumDate:maxDate];
    
    UIButton *doneButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    doneButton.frame=CGRectMake(self.view.frame.size.width/2-50,datePicker.frame.origin.y + datePicker.frame.size.height + 20, 100, 40);
    doneButton.layer.cornerRadius=3.0f;
    [doneButton setTitleColor:appWhiteColor forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    doneButton.backgroundColor=appButtonColor;
    doneButton.titleLabel.font=CustomRegular(20);
    doneButton.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    [self.view addSubview:doneButton];
    
    [datePicker setDate:datePicker.date animated:YES]; // for prepopulating already selected date in datepicker clicked on button
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)doneButtonClicked:(id)sender
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    
    NSString *dateString = [dateFormat stringFromDate:datePicker.date];
    
    [delegate sendSelectedDate:dateString];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
