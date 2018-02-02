//
//  CustomDatePickerViewController.h
//  BVSEnquiry
//
//  Created by Kutung iMac 01 on 29/09/15.
//  Copyright (c) 2015 Kutung iMac 01. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomDatePickerDelegate <NSObject>

-(void)sendSelectedDate:(NSString *)selectedDateStr;

@end

@interface CustomDatePickerViewController : UIViewController
{
     IBOutlet UIDatePicker *datePicker;
}

@property (nonatomic,strong) id <CustomDatePickerDelegate>delegate;
@property (nonatomic,strong) IBOutlet UIDatePicker *datePicker;

+ (CustomDatePickerViewController*)sharedSingleton;

@end
