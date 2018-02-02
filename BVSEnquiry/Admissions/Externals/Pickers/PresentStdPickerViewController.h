//
//  PresentStdPickerViewController.h
//  BVSEnquiry
//
//  Created by Kutung iMac 01 on 16/10/15.
//  Copyright (c) 2015 Kutung. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PresentStdPickerDelegate <NSObject,UIPickerViewDelegate>

-(void)sendSelectedPickerValue:(NSMutableDictionary *)selectedPickSDict;

@end

@interface PresentStdPickerViewController : UIViewController
{
    IBOutlet UIPickerView *pickerView;
    
    NSDictionary *mySelectedDict;
    
    int selectedIndex;
}

@property (nonatomic) int selectedIndex;

@property (nonatomic,strong) NSMutableArray *pickerArray;

@property (nonatomic,strong) id <PresentStdPickerDelegate>delegate;

//@property (nonatomic,strong) NSString *selectedString;

@property (nonatomic,strong) NSMutableDictionary *selectedPickerDict;

@property (nonatomic,strong) IBOutlet UIPickerView *pickerView;

+ (PresentStdPickerViewController*)sharedSingleton;

@end
