//
//  RelationshipWithChildViewController.h
//  BVSEnquiry
//
//  Created by Kutung-PC43 on 29/09/16.
//  Copyright © 2016 Kutung. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ApplyRelationOfChildePickerDelegate <NSObject,UIPickerViewDelegate>

-(void)sendSelectedApplyRelationOfChildPickerValue:(NSString *)selectedPickDict;

@end


@interface RelationshipWithChildViewController : UIViewController
{
      IBOutlet UIPickerView *pickerView;
}

@property (nonatomic,strong) NSArray *pickerArray;
@property (nonatomic,strong) id <ApplyRelationOfChildePickerDelegate>delegate;
@property (nonatomic,strong) NSString *selectedString;

@property (nonatomic,strong) IBOutlet UIPickerView *pickerView;
+ (RelationshipWithChildViewController*)sharedSingleton;
@end
