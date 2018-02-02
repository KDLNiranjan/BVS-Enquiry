//
//  ApplyStdViewController.h
//  BVSEnquiry
//
//  Created by Kutung iMac 01 on 16/10/15.
//  Copyright (c) 2015 Kutung. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ApplyStdPickerDelegate <NSObject,UIPickerViewDelegate>

-(void)sendSelectedApplyStdPickerValue:(NSMutableDictionary *)selectedPickDict;

@end


@interface ApplyStdViewController : UIViewController
{
    IBOutlet UIPickerView *pickerView;
}

@property (nonatomic,strong) NSMutableArray *pickerArray;
@property (nonatomic,strong) id <ApplyStdPickerDelegate>delegate;
@property (nonatomic,strong) NSMutableDictionary *selectedDict;

@property (nonatomic,strong) IBOutlet UIPickerView *pickerView;
+ (ApplyStdViewController*)sharedSingleton;

@end
