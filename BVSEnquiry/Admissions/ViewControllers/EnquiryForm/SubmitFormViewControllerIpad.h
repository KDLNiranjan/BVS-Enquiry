//
//  SubmitFormViewControllerIpad.h
//  BVSEnquiry
//
//  Created by Kutung iMac 01 on 13/10/15.
//  Copyright (c) 2015 Kutung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiCall.h"
#import "CustomDatePickerViewController.h"
#import "PresentStdPickerViewController.h"
#import "ApplyStdViewController.h"
#import "StateViewController.h"
#import "RelationshipWithChildViewController.h"
#import "OccupationTypeViewController.h"
#import "DiscloserButton.h"

@interface SubmitFormViewControllerIpad : UIViewController<ApiCallDelegate,
                                                            CustomDatePickerDelegate,
                                                            PresentStdPickerDelegate,
                                                            ApplyStdPickerDelegate,
                                                            ApplyStatePickerDelegate,
                                                            ApplyRelationOfChildePickerDelegate,
                                                            ApplyOccupationTypePickerDelegate,
                                                            UIAlertViewDelegate>
{
    IBOutlet UIScrollView *formScrollView;
    
    IBOutlet UIView *findUsView, *submitButtonView, *clearButtonView;
    
    ApiCall *apiCall;
    
    NSMutableDictionary *keysDataDictionary,*dataDictionary;

    NSMutableArray *requiredFieldsArray, *dummyRequiredFieldsArray, *presentGradeArray, *applyStdClassArray;
    
    NSString *applyStdClassIDString;
    
    UITextField *currentTextField, *previousTextField;
    
    IBOutlet UITextField *childNameTextField, *dobTextField, *presentStdTextField,*applyingForStdTextField, *address1TextField,*address2TextField, *cityTextField, *stateTextField, *pincodeTextField, *presentSchoolTextField, *hobbiesTextField, *enquiredByTextField, *relationWithChildTextField, *emailTextField, *confirmEmailIdTextField, *mobileTextField, *confirmMobileTextField, *landlineTextField, *parentNameTextField, *parentOccTextField;
    
    IBOutlet UITextField *parentOccupationType;
    
    UITextView *currentTextView;
    
    IBOutlet UITextView *siblingsTextView, *parentsNotesTextView;

    UIPopoverController *popoverController;
    
    IBOutlet UIButton *dobButton,*presentStdButton, *applyingForStdButton;
    
    IBOutlet UIButton *stateButton;
    
    UISegmentedControl *segmentControl;
    
    BOOL isPresentPickerSelected;
}
@end
