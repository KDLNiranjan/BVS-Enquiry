//
//  StudentIDViewController.h
//  BVSEnquiry
//
//  Created by Kutung PC 35 on 17/06/16.
//  Copyright © 2016 Kutung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiCall.h"
#import "AutocompletionTableView.h"

@interface StudentIDViewController : UIViewController<ApiCallDelegate, UITextFieldDelegate, AutocompletionTableViewDelegate>
{
    IBOutlet UITextField *studentIdTextfield;
    
    IBOutlet UIScrollView *studentIdScrollView;

    IBOutlet UIView *proceedButtonView, *studentIdView, *studentEmailView, *studentIdCancelView, *studentEmailCancelView;
    
    NSString *studentIdString, *studentEmailString;
    
    ApiCall *apiCall;
    
}
@property (nonatomic, strong) AutocompletionTableView *autoCompleter;
@property (strong, nonatomic) IBOutlet UITextField *studentEmailIdTextfield;

@end
