//
//  SubmitFormDetailViewController.h
//  BVSEnquiry
//
//  Created by Kutung iMac 01 on 28/09/15.
//  Copyright (c) 2015 Kutung iMac 01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubmitFormDetailViewController : UIViewController
{
    IBOutlet UILabel *detailLabel;
    IBOutlet UILabel *counterNumberLabel;
    IBOutlet UILabel *redirectLabel;

    IBOutlet UIButton *startNewButton;
    
    IBOutlet UIView *startNewButtonView;
}
@property (nonatomic,strong) NSString *enquiryNumberString;

@end
