//
//  StudentIDViewController.m
//  BVSEnquiry
//
//  Created by Kutung PC 35 on 17/06/16.
//  Copyright © 2016 Kutung. All rights reserved.
//

#import "StudentIDViewController.h"
#import <objc/runtime.h>
#import "ParentVisitingFormViewController.h"

@interface StudentIDViewController ()
{
    NSString *finalString;
    NSMutableArray *studentEmailIDsArray;
}

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation StudentIDViewController

@synthesize autoCompleter;
@synthesize studentEmailIdTextfield;
//@synthesize studentEmailIdTextfield = _studentEmailIdTextfield;

const char constantKey;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationItem setHidesBackButton:YES];
    
    self.view.frame=screensize;
    
    [self initializeView];
    [self registerForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initializeAutoCompleteTableView
{
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:2];
    [options setValue:[NSNumber numberWithBool:YES] forKey:ACOCaseSensitive];
    [options setValue:nil forKey:ACOUseSourceFont];
    
    autoCompleter = [[AutocompletionTableView alloc] initWithTextField:self.studentEmailIdTextfield inViewController:studentIdScrollView withOptions:options];
    autoCompleter.autoCompleteDelegate = self;
    autoCompleter.suggestionsDictionary = studentEmailIDsArray;
    autoCompleter.studentEmailView = studentEmailView;
}

-(void)initializeView
{
    self.view.backgroundColor=appWhiteColor;
    
    // creating header view navigation bar
    [self createHeaderViewForNavigationBar];
    
    //initialize APICall
    apiCall = [[ApiCall alloc] init];
    apiCall.delegate = self;
    
    studentEmailIDsArray = [NSMutableArray new];
    
    studentIdScrollView.frame=CGRectMake(0, 20, screensize.size.width, 748);
    studentIdScrollView.contentOffset=CGPointMake(0, 0);
    
    studentIdTextfield=[self getTextFieldAttributes:studentIdTextfield];
   // self.studentEmailIdTextfield=[self getTextFieldAttributes:self.studentEmailIdTextfield];

    [self initializeAutoCompleteTableView];
    [self.studentEmailIdTextfield addTarget:self.autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];

    CGRect tblFrame = autoCompleter.frame;
    tblFrame.origin.x =studentEmailView.frame.origin.x;
    tblFrame.origin.y = studentEmailView.frame.origin.y+studentEmailView.frame.size.height+10;
    tblFrame.size.width = studentEmailView.frame.size.width;
    tblFrame.size.height = 120;
    autoCompleter.frame = tblFrame;
    
    // assigning cornerRadius and border color for clear and proceed buttons.
    proceedButtonView.layer.cornerRadius=20.0f;
    proceedButtonView.layer.borderColor=appWhiteColor.CGColor;
    proceedButtonView.layer.borderWidth=1.0f;

    studentIdView.layer.cornerRadius=8.0;
    studentIdView.layer.borderColor=appDarkGrayColor.CGColor;
    studentEmailView.layer.cornerRadius=8.0;
    studentEmailView.layer.borderColor=appDarkGrayColor.CGColor;
   
    studentIdCancelView.hidden=YES;
    studentEmailCancelView.hidden = YES;
    
    [myappDelegate.allStudentsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        /*
         {
         "father_name" = Shankar;
         standard = "L K G";
         "student_email" = "shivesh.shankar@babajividhyashram.org";
         "student_id" = 160538;
         "student_name" = Shivesh;
         }
         */
        NSDictionary *dict = obj;
        NSString *str = [dict valueForKey:@"student_email"];

        NSArray *arr = [str componentsSeparatedByCharactersInSet:
                        [NSCharacterSet characterSetWithCharactersInString:@"@"]];
        
        [studentEmailIDsArray addObject:arr[0]];
    }];
    
}


-(UIView *)createHeaderViewForNavigationBar
{
    int headerHeight;
    int rightButtonYaxis;
    int fontSize;
    
    fontSize=30;
    headerHeight=70;
    rightButtonYaxis=headerHeight/2-20;
    
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, screensize.size.width, headerHeight)];
    
    headerView.backgroundColor=appWhiteColor;
    
    // image view...
    UIImageView *logoImgView=[[UIImageView alloc]initWithFrame:CGRectMake(30, 0, 160, 50)];
    logoImgView.image=[UIImage imageNamed:@"nav_logo.png"];
    logoImgView.tintColor=appGrayColor;
    [headerView addSubview:logoImgView];
    
    UILabel *lblSubTitle=[[UILabel alloc]initWithFrame:CGRectMake(logoImgView.frame.origin.x+30,logoImgView.frame.size.height, logoImgView.frame.size.width,20)];
    lblSubTitle.font=[UIFont fontWithName:@"Arial" size:8];
    lblSubTitle.textColor=[UIColor blackColor];
    lblSubTitle.text=@"Affiliated to CBSE (No.1930692)";
    [headerView addSubview:lblSubTitle];
    
   //home button...
    UIButton *homeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    homeButton.frame=CGRectMake(self.view.frame.size.width - 120, 0, 120, headerHeight);
    [homeButton addTarget:self action:@selector(homeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    homeButton.backgroundColor=appClearColor;
    [headerView addSubview:homeButton];

    // home image view...
    UIImageView *homeButtonImgView=[[UIImageView alloc]initWithFrame:CGRectMake(50, rightButtonYaxis, 40, 40)];
    homeButtonImgView.image=[UIImage imageNamed:@"home.png"];
    [homeButton addSubview:homeButtonImgView];
    [self.view addSubview:headerView];
    
    
    //Create  Label
    CGSize titleSize=[self getSizebasedOnText:@"Appointment" FontName:CustomLight(22) AndWidth:screensize.size.width];
//    UILabel *navTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(logoImgView.frame.size.width + logoImgView.frame.origin.x + 30, 0, titleSize.width, headerHeight)];
    UILabel *navTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width/2) - (titleSize.width/2), 0, titleSize.width, headerHeight)];

    navTitleLabel.backgroundColor=appClearColor;
    navTitleLabel.text=@"Appointment";
    navTitleLabel.font=CustomLight(22);
    navTitleLabel.textColor=navTitleColor;
    navTitleLabel.textAlignment=NSTextAlignmentLeft;
    navTitleLabel.alpha=1.0f;
    //Update labelSize
    [headerView addSubview:navTitleLabel];
    
    return headerView;
}

-(UITextField *)getTextFieldAttributes:(UITextField *)cTextField
{
  //  cTextField.layer.cornerRadius=8.0;
  //  cTextField.layer.borderColor=appDarkGrayColor.CGColor;
    [cTextField setBorderStyle:UITextBorderStyleNone];
    cTextField.font=CustomLight(18);
    cTextField.textColor=appDarkGrayColor;
  //  cTextField.backgroundColor=appWhiteColor;
    cTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    
    CGRect tfFrame=cTextField.frame;
    tfFrame.size.height=45;
    cTextField.frame=tfFrame;
    
    if (scaleForRetina == 2.0)
    {
        // retina screen;
       // cTextField.layer.borderWidth = 1.5;
    }
    else
    {
        // non-retina screen
      //  cTextField.layer.borderWidth = 1.0;
    }

    cTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
    return cTextField;
}

#pragma mark - UITextField Delegates

-(BOOL)textFieldShouldBeginEditing: (UITextField *)textField
{
    UIToolbar * keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    
    keyboardToolBar.barStyle = UIBarStyleDefault;
    
    UIButton *doneButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    doneButton.frame=CGRectMake(screensize.size.width, 5, 100, 40);
    doneButton.layer.cornerRadius=3.0f;
    [doneButton setTitleColor:appWhiteColor forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(resignKeyboard) forControlEvents:UIControlEventTouchUpInside];
    doneButton.backgroundColor=appButtonColor;
    doneButton.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    UIBarButtonItem *doneBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:doneButton];
    
    [keyboardToolBar setItems: [NSArray arrayWithObjects:
                                [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                doneBarButtonItem,nil]];
    
    
    textField.inputAccessoryView = keyboardToolBar;

    if(textField == self.studentEmailIdTextfield)
    {
        studentEmailCancelView.hidden = NO;
        studentIdCancelView.hidden=YES;

    }
    else
    {
        studentIdCancelView.hidden=NO;
        studentEmailCancelView.hidden = YES;

    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateviewForIpad:studentIdScrollView:textField];

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == studentIdTextfield)
        studentIdTextfield.text=textField.text;
    else if(textField == self.studentEmailIdTextfield)
        self.studentEmailIdTextfield.text=textField.text;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    studentIdCancelView.hidden=YES;
    studentEmailCancelView.hidden = YES;

    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *invalidCharSet;
    
    if(textField == studentIdTextfield)
    {
        invalidCharSet  = [[NSCharacterSet characterSetWithCharactersInString:Numberonly] invertedSet];
        NSString *filteredString = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        
        if ([string isEqualToString:filteredString])
        {
            if(textField.text.length+string.length<=7)
            {
                return YES;
            }
            else
            {
                return NO;
            }
        }
        else
        {
            return NO;
        }
    }
    else // emailid textfield
    {        
//        if([string isEqualToString:@"@"])
//        {
//            NSString *originalString = textField.text;
//            NSString *appendedString = @"@babajividhyashram.org";
//            finalString = [originalString stringByAppendingString:appendedString];
//            textField.text = finalString;
//            return NO;
//        }

        invalidCharSet  = [[NSCharacterSet characterSetWithCharactersInString:@"_-@.0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"] invertedSet];
        NSString *filteredString = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        
        return [string isEqualToString:filteredString];
    }
}

-(void)animateviewForIpad :(UIView *)myview :(id)animatetextfield
{
    CGRect actualframe = [animatetextfield convertRect:[animatetextfield bounds] toView:myview];
    if ((actualframe.origin.y+60) >= (myappDelegate.window.frame.size.height-630))
    {
        CGRect scrollfrm = [animatetextfield convertRect:[animatetextfield bounds] toView:myview];
        
        if ([myview isKindOfClass:[UIScrollView class]])
        {
            UIScrollView *temscrlv=(UIScrollView *)myview;
            [temscrlv setContentOffset:CGPointMake(0, scrollfrm.origin.y-5) animated:YES];
        }
    }
}

#pragma mark - Email Validation
-(BOOL)emailValidation:(NSString *)text
{
    NSString *userName = [NSString stringWithFormat:@"%@",text];
    NSString *userNameTrim = [userName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    BOOL isValid = [emailTest evaluateWithObject:userNameTrim];
    
    if (isValid==NO)
    {
        [self showAlertMessage:@"Alert" WithMessage:@"Please Enter Valid Email" Delegate:self CancelButtonTitle:@"Ok" OtherButtonTitle:nil AndTag:20];
    }
    return isValid;
}

#pragma mark - Pincode Validation
-(BOOL)isValidStudentID:(NSString*)studentID
{
 //   NSString *pinRegex = @"^[0-9]{6}$";
 //   NSPredicate *pinTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pinRegex];
    
    NSString *s = studentID; // a string
    //  NSLog(@"pincode is %@",s);
    unichar c = [s characterAtIndex:0];
    if (c == '0')
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Student ID should not start with the digit zero" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alertView.tag=19;
        [alertView show];
        
        objc_setAssociatedObject(alertView, &constantKey, studentIdTextfield, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    else
    {
        return YES;
    }
    
    return NO;
}

-(void)resignKeyboard
{
    [UIView commitAnimations];
  
    [studentIdTextfield resignFirstResponder];
    [self.studentEmailIdTextfield resignFirstResponder];

    studentIdCancelView.hidden=YES;
    studentEmailCancelView.hidden = YES;

    studentIdScrollView.contentOffset=CGPointMake(0, 0);
    
    [autoCompleter hideOptionsView];

}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)deRegisterForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification *)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    studentIdScrollView.contentInset = contentInsets;
    studentIdScrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, studentIdTextfield.frame.origin) )
    {
        float tHeight=0.0;
        
        tHeight=kbSize.height;
        
        CGPoint scrollPoint = CGPointMake(0.0, studentIdTextfield.frame.origin.y-tHeight);
        [studentIdScrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (void)keyboardWasHidden:(NSNotification *)aNotification
{
    [UIView commitAnimations];
    
    //  [currentTextField resignFirstResponder];
    //  [currentTextView resignFirstResponder];
    
    studentIdScrollView.contentInset = UIEdgeInsetsZero;
    studentIdScrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
    
}


#pragma mark - Get Size Based on Text

-(CGSize)getSizebasedOnText :(NSString *)text FontName :(UIFont *)font AndWidth : (int)width
{
    CGSize constraintSize1 = CGSizeMake(width, 1000.f);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init]; paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGRect rect = [text boundingRectWithSize:constraintSize1
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName: paragraphStyle.copy}
                                     context:nil];
    
    return rect.size;
}

#pragma mark UIButton Actions
-(IBAction)clearButtonClicked:(id)sender
{
    [self.studentEmailIdTextfield becomeFirstResponder];
    
    studentIdTextfield.text=@"";
    self.studentEmailIdTextfield.text=@"";
    
    [autoCompleter hideOptionsView];

}

-(IBAction)continueButtonClicked:(id)sender
{
    // @"@babajividhyashram.org"
    
//    [studentIdTextfield resignFirstResponder];
//    [self.studentEmailIdTextfield resignFirstResponder];
    
    [self resignKeyboard];

    if(([studentIdTextfield.text isEqualToString:@""] || [studentIdTextfield.text isKindOfClass:[NSNull class]] || studentIdTextfield.text==nil) && ([self.studentEmailIdTextfield.text isEqualToString:@""] || [self.studentEmailIdTextfield.text isKindOfClass:[NSNull class]] || self.studentEmailIdTextfield.text==nil))
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please enter Student ID or Student email ID" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alertView.tag=19;
        [alertView show];
        
        objc_setAssociatedObject(alertView, &constantKey, self.studentEmailIdTextfield, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }
    else
    {
        if(self.studentEmailIdTextfield.text.length>0)
        {
            studentIdString=@"";
            studentEmailString = [NSString stringWithFormat:@"%@@babajividhyashram.org",self.studentEmailIdTextfield.text];
            
            [myappDelegate startSpinner];
            [self getChildDetailsFromServer];
            
        }
        else if(studentIdTextfield.text.length>0)
        {
            if(![self isValidStudentID:studentIdTextfield.text])
            {
                return;
            }
            else
            {
                studentIdString=studentIdTextfield.text;
                studentEmailString=@"";
                
                [myappDelegate startSpinner];
                [self getChildDetailsFromServer];
            }

        }
    }
}


-(IBAction)homeButtonClicked:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==19) // required fields validation alert
    {
        UITextField *bTextField = objc_getAssociatedObject(alertView, &constantKey);
        [bTextField becomeFirstResponder];
    }
}

#pragma mark - Api Call

-(void)getChildDetailsFromServer
{
    /*
     {
     "StudentId" : "150001"
     }
     */
    
    NSMutableDictionary * postvalues = [[NSMutableDictionary alloc]init];
    [postvalues setValue:studentIdString forKey:@"StudentId"];
    [postvalues setValue:studentEmailString forKey:@"EmailId"];
    
    [apiCall callApisWithParameters:postvalues postmethod:@"POST" withUrl:@"appointment/student_details" AndRequestType:@"appointment/student_details"];
}

#pragma mark - API Delegates
-(void)successWithResponse :(id)response andRequestType :(NSString *)requestType
{
    if ([requestType isEqualToString:@"appointment/student_details"])
    {
        NSLog(@"response/successWithResponse is %@",response);
        
        /*
         Success
         {
         "Status" : "SUCCESS",
         "Student":
         {
         "ChildName" : "AKSHADHA",
         "FatherName" : "VIGHNESH",
         "Standard" : "L K G"
         }
         }
         Failure
         {
         "Status":"FAILURE",
         "StatusMessage": "Student Not Found"
         }
         */
        
        NSDictionary *resultDict=(NSDictionary *)response;
        if([[resultDict objectForKey:@"Status"] isEqualToString:@"SUCCESS"])
        {
            [self loadParentVisitingFormViewControllerWithChildDetails:[resultDict objectForKey:@"Student"]];
        }
        else if([[resultDict objectForKey:@"Status"] isEqualToString:@"FAILURE"])
        {
            [self showAlertMessage:@"Alert!" WithMessage:[resultDict objectForKey:@"StatusMessage"] Delegate:nil CancelButtonTitle:@"Ok" OtherButtonTitle:nil AndTag:0];
        }
    }
    
    [myappDelegate stopSpinner];
    
}

-(void)failedWithError :(NSString *)error
{
    [myappDelegate stopSpinner];
    
    if (error.length >0)
    {
        NSLog(@"error is %@",error);
        
        [self showAlertMessage:@"Alert" WithMessage:[error description] Delegate:nil CancelButtonTitle:@"Ok" OtherButtonTitle:nil AndTag:0];
    }
}

-(void)loadParentVisitingFormViewControllerWithChildDetails:(NSDictionary *)childDetails
{
    ParentVisitingFormViewController *parentAppointmentFormVC = [[ParentVisitingFormViewController alloc] initWithNibName:@"ParentVisitingFormViewController" bundle:nil];
    parentAppointmentFormVC.childDetailsDict=childDetails;
    [self.navigationController pushViewController:parentAppointmentFormVC animated:YES];
    [self clearButtonClicked:nil];
}

#pragma mark - Alert Message
-(void)showAlertMessage:(NSString *)titleString WithMessage:(NSString *)messageString Delegate:(id)delegate CancelButtonTitle:(NSString *)cancelTitle OtherButtonTitle:(NSString *)otherTitle AndTag:(int)tag
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:titleString message:messageString delegate:delegate cancelButtonTitle:cancelTitle otherButtonTitles:otherTitle, nil];
    alertView.tag=tag;
    [alertView show];
}

#pragma mark - AutoCompleteTableViewDelegate

- (NSArray*) autoCompletion:(AutocompletionTableView*) completer suggestionsFor:(NSString*) string
{
    // with the prodided string, build a new array with suggestions - from DB, from a service, etc.
    return studentEmailIDsArray;
}

- (void) autoCompletion:(AutocompletionTableView*) completer didSelectAutoCompleteSuggestionWithIndex:(NSInteger) index
{
    // invoked when an available suggestion is selected
  //  NSLog(@"%@ - Suggestion chosen: %d", completer, index);
    
    [self resignKeyboard];
}

- (void) autoCompletion:(AutocompletionTableView*) completer didSelectAutoCompleteSuggestionWithIndex:(NSInteger)index AndSelectedString:(NSString *)selectedString
{
    // invoked when an available suggestion is selected

    selectedString = [NSString stringWithFormat:@"%@@babajividhyashram.org",selectedString];

    [myappDelegate.allStudentsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         /*
          {
          "father_name" = Shankar;
          standard = "L K G";
          "student_email" = "shivesh.shankar@babajividhyashram.org";
          "student_id" = 160538;
          "student_name" = Shivesh;
          }
          */
        
         NSDictionary *dict = obj;
         NSString *studentEmailStr = [dict valueForKey:@"student_email"];

         if([studentEmailStr isEqualToString:selectedString])
         {
             NSLog(@"dict is %@",dict);
         }
     }];
    
    [self resignKeyboard];
}

@end
