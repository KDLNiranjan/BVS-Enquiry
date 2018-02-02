//
//  StateViewController.h
//  BVSEnquiry
//
//  Created by Kutung-PC43 on 29/09/16.
//  Copyright © 2016 Kutung. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ApplyStatePickerDelegate <NSObject,UIPickerViewDelegate>

-(void)sendSelectedApplyStatePickerValue:(NSString *)selectedPickDict;

@end


@interface StateViewController : UIViewController
{
      IBOutlet UIPickerView *pickerView;
}


@property (nonatomic,strong) NSArray *pickerArray;
@property (nonatomic,strong) id <ApplyStatePickerDelegate>delegate;
@property (nonatomic,strong) NSString *selectedString;

@property (nonatomic,strong) IBOutlet UIPickerView *pickerView;
+ (StateViewController*)sharedSingleton;
@end
