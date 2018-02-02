//
//  ParentVisitingFormViewController.h
//  BVSEnquiry
//
//  Created by Kutung PC 35 on 14/06/16.
//  Copyright © 2016 Kutung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiCall.h"

@interface ParentVisitingFormViewController : UIViewController<ApiCallDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    ApiCall *apiCall;
    IBOutlet UIScrollView *formScrollView, *visitReasonScrollView;

    IBOutlet UIView *clearButtonView, *submitButtonView, *radioButtonsBackgroundView, *radioSelectionView, *guardianView, *makeApptView;
    IBOutlet UILabel *studentNameLabel, *parentNameLabel, *studentClassLabel, *studentIDLabel, *studentEmailLabel, *commentsLabel;
    IBOutlet UIButton *submitButton, *visitReasonButton;
    
    IBOutlet UITextView *commentsTextView;
    IBOutlet UITextField *reasonForVisitTextField, *guardianTextField;
    
    UIPopoverController *popoverController;
    
    NSMutableDictionary *visitReasonDict;
    NSMutableArray *visitReasonArray, *radioButtonsArray, *checkButtonsArray, *chooseRelationArray;
    
    NSString *chooseRelationString;
    
}

@property (nonatomic, strong) NSDictionary *childDetailsDict;
@end
