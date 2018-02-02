//
//  OccupationTypeViewController.h
//  BVSEnquiry
//
//  Created by Kutung-PC43 on 30/09/16.
//  Copyright © 2016 Kutung. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ApplyOccupationTypePickerDelegate <NSObject,UIPickerViewDelegate>

-(void)sendSelectedApplyOccupationTypePickerValue:(NSString *)currentText;

@end

@interface OccupationTypeViewController : UIViewController
{
     IBOutlet UIPickerView *pickerView;
}

@property (nonatomic,strong) NSArray *pickerArray;
@property (nonatomic,strong) id <ApplyOccupationTypePickerDelegate>delegate;
@property (nonatomic,strong) NSString *selectedString;

@property (nonatomic,strong) IBOutlet UIPickerView *pickerView;
+ (OccupationTypeViewController*)sharedSingleton;

@end
