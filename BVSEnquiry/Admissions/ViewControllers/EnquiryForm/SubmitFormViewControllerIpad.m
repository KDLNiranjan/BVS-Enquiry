 //
//  SubmitFormViewControllerIpad.m
//  BVSEnquiry
//
//  Created by Kutung iMac 01 on 13/10/15.
//  Copyright (c) 2015 Kutung. All rights reserved.
//

#import "SubmitFormViewControllerIpad.h"
#import "SubmitFormDetailViewController.h"
#import <objc/runtime.h>
#import "AFNetworkReachabilityManager.h"

@interface SubmitFormViewControllerIpad ()
@property (strong, nonatomic) IBOutlet UIButton *btnRelationOfChild;
@property (strong, nonatomic) IBOutlet UIButton *btnOccupationType;

@property (strong, nonatomic) IBOutlet UIView *vewDiscloserForNameField;

@property (weak, nonatomic) IBOutlet UIButton *btntest1;
@property (weak, nonatomic) IBOutlet UIButton *btntest2;
@property (weak, nonatomic) IBOutlet UIButton *btntest3;
@end

@implementation SubmitFormViewControllerIpad

const char MyConstantKey;

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    // Do any additional setup after loading the view from its nib.
    
    self.view.frame=screensize;
    
    self.view.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    //initialize APICall
    apiCall = [[ApiCall alloc] init];
    apiCall.delegate = self;
    
    
    presentGradeArray=[NSMutableArray new];
    applyStdClassArray=[NSMutableArray new];
    
    [self getPresentStdClassesList];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationItem setHidesBackButton:YES];
    [self initializeView];
    [self registerForKeyboardNotifications];
    

// formScrollView.frame=CGRectMake(0, 70, screensize.size.width, 620);
// contentsize is setted in xib. no need to set it in code
// formScrollView.contentSize=CGSizeMake(screensize.size.width, screensize.size.height);
// 0 70 1024 620 from xib values. no need to change.
    
    PresentStdPickerViewController *presentStdPickerViewController=[PresentStdPickerViewController sharedSingleton];
    
    if(presentStdPickerViewController.selectedPickerDict.count>0)
    {
        [presentStdPickerViewController.selectedPickerDict removeAllObjects];
        presentStdPickerViewController.selectedIndex = 0;
    }
    
    formScrollView.contentOffset=CGPointMake(0, 0);
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [childNameTextField becomeFirstResponder];
    
    emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    confirmEmailIdTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
}

-(void)initializeView
{
    self.view.backgroundColor=appButtonColor;
    
    // creating header view navigation bar
    [self createHeaderViewForNavigationBar];
    
    // creating how did you find us view
    [self createHowDidYouFindUs];
    
    dataDictionary=[NSMutableDictionary new];

    // total fields are 23 including segment..
    [dataDictionary setValue:@"" forKey:@"ChildName"];
    [dataDictionary setValue:@"" forKey:@"ChildDOB"];
    [dataDictionary setValue:@"" forKey:@"ChildPresentSTD"];
    [dataDictionary setValue:@"" forKey:@"ChildApplyingSTD"];
    [dataDictionary setValue:@"" forKey:@"Address1"];
    [dataDictionary setValue:@"" forKey:@"Address2"];
    [dataDictionary setValue:@"" forKey:@"City"];
    [dataDictionary setValue:@"" forKey:@"State"];
    [dataDictionary setValue:@"" forKey:@"Pincode"];
    [dataDictionary setValue:@"" forKey:@"ChildPresentSchool"];
    [dataDictionary setValue:@"" forKey:@"Hobbies"];
    [dataDictionary setValue:@"" forKey:@"EnquiredBy"];
    [dataDictionary setValue:@"" forKey:@"RelationshipWithChild"];
    [dataDictionary setValue:@"" forKey:@"EmailId"];
    [dataDictionary setValue:@"" forKey:@"ConfirmEmail"];
    [dataDictionary setValue:@"" forKey:@"MobileNumber"];
    [dataDictionary setValue:@"" forKey:@"ConfirmMobile"];
    [dataDictionary setValue:@"" forKey:@"ContactNumber"];
    [dataDictionary setValue:@"" forKey:@"ParentName"];
    [dataDictionary setValue:@"" forKey:@"ParentOccupation"];
    [dataDictionary setValue:@"" forKey:@"ParentNote"];
    [dataDictionary setValue:@"" forKey:@"SibilingDetail"];
    [dataDictionary setValue:@"" forKey:@"Referral"];
    [dataDictionary setValue:@"" forKey:@"OccupationType"];   //OccupationType
    

    keysDataDictionary=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"ChildName",@"1",@"ChildDOB",@"2",@"ChildPresentSTD",@"3",@"ChildApplyingSTD",@"4",@"Address1",@"5",@"Address2",@"6",@"City",@"7",@"State",@"8",@"Pincode",@"9",@"ChildPresentSchool",@"10",@"Hobbies",@"11",@"EnquiredBy",@"12",@"RelationshipWithChild",@"13",@"EmailId",@"14",@"MobileNumber",@"15",@"ContactNumber",@"16",@"ConfirmEmail",@"17",@"ConfirmMobile",@"18",@"ParentName",@"19",@"ParentOccupation",@"20",@"ParentNote",@"21",@"SibilingDetail",@"22",@"OccupationType",@"25",nil];  //OccupationType

    // after 17th tag,100 is for sibling and other next 100 is for referal,not compulsory
  
    //  requiredFieldsArray =[[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"100",@"6",@"7",@"8",@"100",@"100",@"11",@"12",@"13",@"14",@"100",@"16",@"17",@"100",@"100",@"19",@"20",@"21",@"100", nil];
    requiredFieldsArray =[[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"100",@"7",@"8",@"9",@"100",@"100",@"12",@"13",@"14",@"15",@"100",@"17",@"18",@"19",@"20",@"100",@"100",@"100",@"25", nil];//OccupationType
    
     // after 17th tag,100 is for sibling and other next 100 is for referal,not compulsory
    dummyRequiredFieldsArray =[[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"100",@"7",@"8",@"9",@"100",@"100",@"12",@"13",@"14",@"15",@"100",@"17",@"18",@"19",@"20",@"100",@"100",@"100",@"25",nil];//OccupationType

    [self initializeTextFields];
    
    clearButtonView.layer.cornerRadius=20.0f;
    submitButtonView.layer.cornerRadius=20.0f;

}

-(void)sampleInitialization
{
    childNameTextField.text=@"dfd";
    dobTextField.text=@"dfd";
    presentStdTextField.text=@"dfd";
    applyingForStdTextField.text=@"dfd";
    address1TextField.text=@"dfd";
    cityTextField.text=@"dfd";
    stateTextField.text=@"dfd";
    
    enquiredByTextField.text=@"dfd";
    relationWithChildTextField.text=@"dfd";
    emailTextField.text=@"mahesh@kutung.in";
    confirmEmailIdTextField.text=@"mahesh@gmail.com";
    parentNameTextField.text=@"dfd";
    parentOccTextField.text=@"dfd";
}

-(UIView *)createHeaderViewForNavigationBar
{
    int headerHeight;
    int leftButtonWidth;
    int leftButtonHeight;
    int leftButtonYaxis;
    int fontSize;
    int rightButtonYaxis;
    
    fontSize=30;
    headerHeight=60;
    leftButtonWidth=40;
    leftButtonHeight=40;
    leftButtonYaxis=headerHeight/2-20;
    rightButtonYaxis=headerHeight/2-20;

    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, screensize.size.width, headerHeight)];
    
    headerView.backgroundColor=appWhiteColor;
    
    // image view...
    UIImageView *logoImgView=[[UIImageView alloc]initWithFrame:CGRectMake(30, 5, 160, 40)];//Height:50
    logoImgView.image=[UIImage imageNamed:@"nav_logo.png"];
    logoImgView.tintColor=appGrayColor;
    [headerView addSubview:logoImgView];
    
    [self.view addSubview:headerView];
    
    UILabel *lblSubTitle=[[UILabel alloc]initWithFrame:CGRectMake(logoImgView.frame.origin.x+30,logoImgView.frame.size.height, logoImgView.frame.size.width,20)];
    lblSubTitle.font=[UIFont fontWithName:@"Arial" size:8];
    lblSubTitle.textColor=[UIColor blackColor];
    lblSubTitle.text=@"Affiliated to CBSE (No.1930692)";
    [headerView addSubview:lblSubTitle];
    
    int yAxis =headerView.frame.origin.y + headerView.frame.size.height + 1;
    
    //Create timeTitle Label
    UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, yAxis, screensize.size.width, 1)];
    lineLabel.backgroundColor=[UIColor darkGrayColor];
    lineLabel.alpha=0.3f;
    //Update labelSize
  //  [headerView addSubview:lineLabel];
    
    //Title label
    //Create timeTitle Label
    CGSize titleSize=[self getSizebasedOnText:@"New admission" FontName:CustomLight(22) AndWidth:screensize.size.width];
  //  UILabel *navTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(logoImgView.frame.size.width + logoImgView.frame.origin.x + 30, 0, titleSize.width, headerHeight)];
    UILabel *navTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width/2) - (titleSize.width/2), 0, titleSize.width, headerHeight)];

    navTitleLabel.backgroundColor=appClearColor;
    navTitleLabel.text=@"New admission";
    navTitleLabel.font=CustomLight(22);
    navTitleLabel.textColor=navTitleColor;
    navTitleLabel.textAlignment=NSTextAlignmentLeft;
    navTitleLabel.alpha=1.0f;
    //Update labelSize
    [headerView addSubview:navTitleLabel];
    
    
    //home button...
    UIButton *homeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    homeButton.frame=CGRectMake(self.view.frame.size.width - 120, 0, 120, headerHeight);
    [homeButton addTarget:self action:@selector(homeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    homeButton.backgroundColor=appClearColor;
    [headerView addSubview:homeButton];
    
    // home image view...
    UIImageView *homeButtonImgView=[[UIImageView alloc]initWithFrame:CGRectMake(50, rightButtonYaxis, 40, 40)];
    homeButtonImgView.image=[UIImage imageNamed:@"home.png"];
    // logoImgView.tintColor=appGrayColor;
    [homeButton addSubview:homeButtonImgView];
    [self.view addSubview:headerView];
    return headerView;
}


-(void)createHowDidYouFindUs
{
    // segment control...
    
    NSArray *fifthSectionFirstRowArray=[[NSArray alloc]initWithObjects:@"Friends",@"Newspaper",@"Website",@"Pamphlet",@"Others",nil];
    
    for (UIView* aSubV in segmentControl.subviews)
    {
        [aSubV removeFromSuperview];
    }
    
    segmentControl= [[UISegmentedControl alloc]initWithItems:fifthSectionFirstRowArray];
    
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                CustomRegular(17), NSFontAttributeName,
                                appLightGrayColor, NSForegroundColorAttributeName,
                                nil];
    [segmentControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:appWhiteColor forKey:NSForegroundColorAttributeName];
    [segmentControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    [segmentControl addTarget:self action:@selector(segmentedControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
    segmentControl.frame=CGRectMake(10, 45, 700, 40);
    segmentControl.layer.borderColor=appLightGrayColor.CGColor;
    segmentControl.layer.cornerRadius=5.0;

    if([[dataDictionary valueForKey:@"Referral"] isKindOfClass:[NSNull class]])
    {
        //  segmentControl.selectedSegmentIndex = 0;
    }
    else
    {
        int selectedIndex=(int)[[dataDictionary valueForKey:@"Referral"] integerValue]-1;
        segmentControl.selectedSegmentIndex =selectedIndex;
    }
    
    if (scaleForRetina == 2.0)
    {
        // retina screen;
        segmentControl.layer.borderWidth = 1.5;
    }
    else
    {
        // non-retina screen
        segmentControl.layer.borderWidth = 1.0;
    }
    
    for (int i=0; i<[segmentControl.subviews count]; i++)
    {
        [[segmentControl.subviews objectAtIndex:i] setTintColor:appGrayColor];
    }
    
   [findUsView addSubview:segmentControl];
    
}

-(void)initializeTextFields
{
    childNameTextField=[self getTextFieldAttributes:childNameTextField];
    dobTextField=[self getTextFieldAttributes:dobTextField];
    presentStdTextField=[self getTextFieldAttributes:presentStdTextField];
    applyingForStdTextField=[self getTextFieldAttributes:applyingForStdTextField];
    address1TextField=[self getTextFieldAttributes:address1TextField];
    address2TextField=[self getTextFieldAttributes:address2TextField];
    cityTextField=[self getTextFieldAttributes:cityTextField];
    stateTextField=[self getTextFieldAttributes:stateTextField];
    pincodeTextField=[self getTextFieldAttributes:pincodeTextField];
    presentSchoolTextField=[self getTextFieldAttributes:presentSchoolTextField];
    hobbiesTextField=[self getTextFieldAttributes:hobbiesTextField];
    enquiredByTextField=[self getTextFieldAttributes:enquiredByTextField];
    relationWithChildTextField=[self getTextFieldAttributes:relationWithChildTextField];
    emailTextField=[self getTextFieldAttributes:emailTextField];
    confirmEmailIdTextField=[self getTextFieldAttributes:confirmEmailIdTextField];
    mobileTextField=[self getTextFieldAttributes:mobileTextField];
    confirmMobileTextField=[self getTextFieldAttributes:confirmMobileTextField];
    landlineTextField=[self getTextFieldAttributes:landlineTextField];
    parentNameTextField=[self getTextFieldAttributes:parentNameTextField];
    parentOccTextField=[self getTextFieldAttributes:parentOccTextField];
    parentOccupationType=[self getTextFieldAttributes:parentOccupationType];
    //for textview
    siblingsTextView=[self getTextViewAttributes:siblingsTextView];
    parentsNotesTextView=[self getTextViewAttributes:parentsNotesTextView];
}

-(UITextField *)getTextFieldAttributes:(UITextField *)cTextField
{
    cTextField.layer.cornerRadius=5.0;
    cTextField.layer.borderColor=appLightGrayColor.CGColor;
    [cTextField setBorderStyle:UITextBorderStyleNone];
    cTextField.font=CustomRegular(17);
    cTextField.textColor=appBlackColor;
    cTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    
    CGRect tfFrame=cTextField.frame;
    tfFrame.size.height=50;
    cTextField.frame=tfFrame;
    
    if (scaleForRetina == 2.0)
    {
        // retina screen;
        cTextField.layer.borderWidth = 1.5;
    }
    else
    {
        // non-retina screen
        cTextField.layer.borderWidth = 1.0;
    }
    
    cTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
    return cTextField;
}

-(UITextView *)getTextViewAttributes:(UITextView *)cTextView
{
    // siblings textfield...
    cTextView.font=CustomRegular(17);
    cTextView.textColor=appBlackColor;
    cTextView.layer.cornerRadius=5.0;
    cTextView.layer.borderColor=appLightGrayColor.CGColor;
    
    if (scaleForRetina == 2.0)
    {
        // retina screen;
        cTextView.layer.borderWidth = 1.5;
    }
    else
    {
        // non-retina screen
        cTextView.layer.borderWidth = 1.0;
    }
    
    cTextView.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);

    return cTextView;

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

#pragma mark - IBActions
-(IBAction)segmentedControlValueDidChange:(UISegmentedControl *)segment
{
    [currentTextField resignFirstResponder];
    [currentTextView resignFirstResponder];
    
    for (int i=0; i<[segment.subviews count]; i++)
    {
       // [[segment.subviews objectAtIndex:i] setTintColor:[UIColor colorWithRed:21.0f/255.0f green:152.0f/255.0f blue:63.0f/255.0f alpha:1.0]]; // selected segment background green color
        
        if ([[segment.subviews objectAtIndex:i]isSelected])
        {
            [[segment.subviews objectAtIndex:i] setTintColor:appButtonColor]; // selected segment background green color
            //    R-36 G-120 B-192
        }
        else
        {
            [[segment.subviews objectAtIndex:i] setTintColor:appLightGrayColor]; // selected segment background green color
        }
    }
    
    NSString *referralString=@"";
    switch (segment.selectedSegmentIndex)
    {
        case 0:
        {
            //action for the first button (Current)
            referralString=@"1";
            break;
        }
        case 1:
        {
            //action for the first button (Current)
            referralString=@"2";
            break;
        }
        case 2:
        {
            //action for the first button (Current)
            referralString=@"3";
            break;
        }
        case 3:
        {
            //action for the first button (Current)
            referralString=@"4";
            break;
        }
        case 4:
        {
            //action for the first button (Current)
            referralString=@"5";
            break;
        }
    }
    
    
    [dataDictionary setValue:referralString forKey:@"Referral"];
}

- (IBAction)showDatePickerPopover:(id)sender
{
    [self resignKeyboard];
    // here is code for finding the row and section of a textfield being edited in a uicollectionview
    
    CGRect pFrame=dobButton.frame;
    pFrame.origin.x=pFrame.origin.x + 30;
    pFrame.origin.y=pFrame.origin.y + 85;
   // cell.frame=pFrame;
    CustomDatePickerViewController *datePickerViewController=[CustomDatePickerViewController sharedSingleton];
    
    datePickerViewController.delegate=self;
    
    popoverController = [[UIPopoverController alloc] initWithContentViewController:datePickerViewController];
    popoverController.popoverContentSize = CGSizeMake(320.0, 400.0);
    [popoverController presentPopoverFromRect:pFrame
                                       inView:self.view
                     permittedArrowDirections:UIPopoverArrowDirectionUp
                                     animated:YES];
    
}

- (IBAction)showPresentStandardPickerPopover:(id)sender
{
    PresentStdPickerViewController *presentStdPickerViewController=[PresentStdPickerViewController sharedSingleton];
    formScrollView.contentOffset=CGPointMake(0, 0);
    [self resignKeyboard];
    
    // here is code for finding the row and section of a textfield being edited in a uicollectionview
    CGRect pFrame;
    pFrame=presentStdButton.frame;
    pFrame.origin.x=pFrame.origin.x + 30;
    pFrame.origin.y=pFrame.origin.y + 85;
    
    //---------------------------------------------
    //clearing values of applying std first...
    ApplyStdViewController *appPickerViewController=[ApplyStdViewController sharedSingleton];
    if(appPickerViewController.pickerArray.count>0)[appPickerViewController.pickerArray removeAllObjects];
        appPickerViewController.selectedDict=nil;
    applyingForStdTextField.text = @"";
    
    //----------------------------------------------
    presentStdPickerViewController.delegate=self;
    presentStdPickerViewController.pickerArray = presentGradeArray;
    [presentStdPickerViewController.pickerView reloadAllComponents];
    
    if(presentStdPickerViewController.selectedPickerDict.count > 0)
    {
        [presentStdPickerViewController.selectedPickerDict removeAllObjects];
        presentStdPickerViewController.selectedIndex = 0;
    }
    
    NSLog(@"presentStdPickerViewController.pickerArray.count is %lu", (unsigned long)presentStdPickerViewController.pickerArray.count);
    
    isPresentPickerSelected = YES;
    
    if(presentStdPickerViewController.pickerArray.count == 0)
    {
        [myappDelegate startSpinner];
        [self getPresentStdClassesList];
    }
    else
    {
        popoverController = [[UIPopoverController alloc] initWithContentViewController:presentStdPickerViewController];
        popoverController.popoverContentSize = CGSizeMake(320.0, 400.0);
        [popoverController presentPopoverFromRect:pFrame
                                           inView:self.view
                         permittedArrowDirections:UIPopoverArrowDirectionUp
                                         animated:YES];
    }
}

- (IBAction)showApplingStandardPickerPopover:(id)sender
{
    [self resignKeyboard];
    
    if([presentStdTextField.text length] == 0)
    {
        [self showAlertMessage:@"Alert" WithMessage:@"Please choose present grade field first" Delegate:nil CancelButtonTitle:@"Ok" OtherButtonTitle:nil AndTag:0];
    }
    else
    {
        // here is code for finding the row and section of a textfield being edited in a uicollectionview
        
        CGRect pFrame;
        
        pFrame=applyingForStdButton.frame;
        pFrame.origin.x=pFrame.origin.x + 30;
        pFrame.origin.y=pFrame.origin.y + 85;
        
        ApplyStdViewController *applyStdPickerViewController=[ApplyStdViewController sharedSingleton];
        
        applyStdPickerViewController.delegate=self;
        
        applyStdPickerViewController.pickerArray = applyStdClassArray;
        
        [applyStdPickerViewController.pickerView reloadAllComponents];
        
        popoverController = [[UIPopoverController alloc] initWithContentViewController:applyStdPickerViewController];
        popoverController.popoverContentSize = CGSizeMake(320.0, 400.0);
        [popoverController presentPopoverFromRect:pFrame
                                           inView:self.view
                         permittedArrowDirections:UIPopoverArrowDirectionUp
                                         animated:YES];
    }
}


-(IBAction)clearButtonClicked:(id)sender
{
    // clearing previous date from date picker
    CustomDatePickerViewController *datePickerViewController=[CustomDatePickerViewController sharedSingleton];
    datePickerViewController.datePicker.date=[NSDate date];
    
    // clearing previous selected value fromr picker
    PresentStdPickerViewController *presentStdPickerViewController=[PresentStdPickerViewController sharedSingleton];
  //  presentStdPickerViewController.selectedString=@"";
    presentStdPickerViewController.selectedPickerDict=nil;
    presentStdPickerViewController.selectedIndex = 0;
    
    ApplyStdViewController *appPickerViewController=[ApplyStdViewController sharedSingleton];
    appPickerViewController.selectedDict=nil;
    
    // clearing remaining fields
    [self clearAllTextFieldsData];

    // checking
    if(dataDictionary.count>0)
    {
        for(int i=0;i<dataDictionary.count;i++)
        {
            UITextField *tField = (UITextField *)[self.view viewWithTag:[[requiredFieldsArray objectAtIndex:i] integerValue]];
            
            if([tField class] != [UITextField class])
            {
                tField = [[UITextField alloc]init];
            }
            
            if([tField.text isEqualToString:@""] || tField.text==nil || [tField.text isKindOfClass:[NSNull class]])
            {
                tField.layer.borderColor=appLightGrayColor.CGColor;
                [dummyRequiredFieldsArray addObject:[requiredFieldsArray objectAtIndex:i]];
            }
            else
            {
                tField.layer.borderColor=appLightGrayColor.CGColor;
                [dummyRequiredFieldsArray removeObject:[requiredFieldsArray objectAtIndex:i]];
            }
        }
    }
    
    if(dataDictionary.count>0)
        [dataDictionary removeAllObjects];
    
    [self clearAllDictionaryDataWithEmptyValue];

    formScrollView.contentOffset=CGPointMake(0, 0);
}

- (IBAction)nextButtonClicked:(id)sender
{
    if([childNameTextField isFirstResponder])
        [address1TextField becomeFirstResponder];
    else if([address1TextField isFirstResponder])
        [address2TextField becomeFirstResponder];
    else if([address2TextField isFirstResponder])
        [cityTextField becomeFirstResponder];
    else if([cityTextField isFirstResponder])
        [stateTextField becomeFirstResponder];
    else if([stateTextField isFirstResponder])
        [pincodeTextField becomeFirstResponder];
    else if([pincodeTextField isFirstResponder])
        [presentSchoolTextField becomeFirstResponder];
    else if([presentSchoolTextField isFirstResponder])
        [hobbiesTextField becomeFirstResponder];
    else if([hobbiesTextField isFirstResponder])
        [enquiredByTextField becomeFirstResponder];
    else if([enquiredByTextField isFirstResponder])
        [relationWithChildTextField becomeFirstResponder];
    else if([relationWithChildTextField isFirstResponder])
        [emailTextField becomeFirstResponder];
    else if([emailTextField isFirstResponder])
        [mobileTextField becomeFirstResponder];
    else if([mobileTextField isFirstResponder])
        [landlineTextField becomeFirstResponder];
    else if([landlineTextField isFirstResponder])
        [parentNameTextField becomeFirstResponder];
    else if([parentNameTextField isFirstResponder])
        [parentOccTextField becomeFirstResponder];
    else if([parentOccTextField isFirstResponder])
        [siblingsTextView becomeFirstResponder];
    else if([siblingsTextView isFirstResponder])
        [childNameTextField becomeFirstResponder];

    if(previousTextField.text ==nil || [previousTextField.text isEqualToString:@""] || [previousTextField.text isKindOfClass:[NSNull class]])
    {
        if(previousTextField==address2TextField || previousTextField==presentSchoolTextField || previousTextField==hobbiesTextField || previousTextField==landlineTextField)
        {
            previousTextField.layer.borderColor=appLightGrayColor.CGColor;
        }
        else
        {
            previousTextField.layer.borderColor=appRedcolor.CGColor;

        }

    }
    else
    {
        previousTextField.layer.borderColor=appLightGrayColor.CGColor;
    }

}
- (IBAction)previousButtonClicked:(id)sender
{
    if([siblingsTextView isFirstResponder])
        [parentOccTextField becomeFirstResponder];
    else if([parentOccTextField isFirstResponder])
        [parentNameTextField becomeFirstResponder];
    else if([parentNameTextField isFirstResponder])
        [landlineTextField becomeFirstResponder];
    else if([landlineTextField isFirstResponder])
        [mobileTextField becomeFirstResponder];
    else if([mobileTextField isFirstResponder])
        [emailTextField becomeFirstResponder];
    else if([emailTextField isFirstResponder])
        [relationWithChildTextField becomeFirstResponder];
    else if([relationWithChildTextField isFirstResponder])
        [enquiredByTextField becomeFirstResponder];
    else if([enquiredByTextField isFirstResponder])
        [hobbiesTextField becomeFirstResponder];
    else if([hobbiesTextField isFirstResponder])
        [presentSchoolTextField becomeFirstResponder];
    else if([presentSchoolTextField isFirstResponder])
        [pincodeTextField becomeFirstResponder];
    else if([pincodeTextField isFirstResponder])
        [stateTextField becomeFirstResponder];
    else if([stateTextField isFirstResponder])
        [cityTextField becomeFirstResponder];
    else if([cityTextField isFirstResponder])
        [address2TextField becomeFirstResponder];
    else if([address2TextField isFirstResponder])
        [address1TextField becomeFirstResponder];
    else if([address1TextField isFirstResponder])
        [childNameTextField becomeFirstResponder];
    else if([childNameTextField isFirstResponder])
        [siblingsTextView becomeFirstResponder];
    
    if(previousTextField.text ==nil || [previousTextField.text isEqualToString:@""] || [previousTextField.text isKindOfClass:[NSNull class]])
    {
        if(previousTextField==address2TextField || previousTextField==presentSchoolTextField || previousTextField==hobbiesTextField || previousTextField==landlineTextField)
        {
            previousTextField.layer.borderColor=appLightGrayColor.CGColor;
        }
        else
        {
            previousTextField.layer.borderColor=appRedcolor.CGColor;
            
        }
        
    }
    else
    {
        previousTextField.layer.borderColor=appLightGrayColor.CGColor;
    }
}

-(IBAction)submitButtonClicked:(id)sender
{
    [self resignKeyboard];
    
    [self requiredFieldsValidation];
 
 //  [self loadSubmitFormDetailViewControllerWithEnquiryNumber:@"SampleID001"];
    NSLog(@"dataDictionary/submit is %@",dataDictionary);
}

-(IBAction)homeButtonClicked:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)requiredFieldsValidation
{
    if(dataDictionary.count>0)
    {
        for(int i=0;i<dataDictionary.count;i++)
        {
            UITextField *tField = (UITextField *)[self.view viewWithTag:[[requiredFieldsArray objectAtIndex:i] integerValue]];
            
            if([tField class] != [UITextField class])
            {
                tField = [[UITextField alloc]init];
            }
            
            if([tField.text isEqualToString:@""] || tField.text==nil || [tField.text isKindOfClass:[NSNull class]])
            {
                tField.layer.borderColor=appRedcolor.CGColor;
                [dummyRequiredFieldsArray addObject:[requiredFieldsArray objectAtIndex:i]];
            }
            else
            {
                tField.layer.borderColor=appLightGrayColor.CGColor;
                [dummyRequiredFieldsArray removeObject:[requiredFieldsArray objectAtIndex:i]];
            }
        }
    }
   
    int minValue;
    UITextField *becomeFirstTextField;
    
    if(dataDictionary.count>0)
    {
        minValue = [[dummyRequiredFieldsArray objectAtIndex:0] intValue];
        for (unsigned i = 1; i < [dummyRequiredFieldsArray count]; i++)
        {
            if([[dummyRequiredFieldsArray objectAtIndex:i] intValue] < minValue)
                minValue = [[dummyRequiredFieldsArray objectAtIndex:i] intValue];
        }
        
         becomeFirstTextField= (UITextField *)[self.view viewWithTag:minValue];
    }

     NSLog(@"minValue:%d",minValue);
    
    if(minValue == 100)
    {
        if(![self isValidPinCode:[dataDictionary valueForKey:@"Pincode"]])
        {
            return;
        }
        else if(![self emailValidation:[dataDictionary valueForKey:@"EmailId"]])
        {
            return;
        }
        else if(![self isEmailAndConfirmEmailBeTheSame:[dataDictionary valueForKey:@"EmailId"] AndConfirm:[dataDictionary valueForKey:@"ConfirmEmail"]])
        {
            return;
        }
        else if(![self checkMobileNumberDigits:[dataDictionary valueForKey:@"MobileNumber"] AndAlertMessage:@"Please Enter a Valid Mobile number"])
        {
            return;
        }
        else if(![self isMobileAndConfirmMobileBeTheSame:[dataDictionary valueForKey:@"MobileNumber"] AndConfirm:[dataDictionary valueForKey:@"ConfirmMobile"]])
        {
            return;
        }
        else
        {
            NSLog(@"validation success");
            [myappDelegate startSpinner];
            [self submitFormDataToServer:dataDictionary];
        }
    }
    else
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Please fill the details" message:@"Fields marked * are required fields." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alertView.tag=19;
        [alertView show];
        
        objc_setAssociatedObject(alertView, &MyConstantKey, becomeFirstTextField, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }
}

#pragma mark - UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==19) // required fields validation alert
    {
        UITextField *bTextField = objc_getAssociatedObject(alertView, &MyConstantKey);
        
        if(bTextField.tag==2)
        {
            [self showDatePickerPopover:nil];
        }
        else if(bTextField.tag==3)
        {
            [self showPresentStandardPickerPopover:nil];
        }
        else if(bTextField.tag==4)
        {
            [self showApplingStandardPickerPopover:nil];
        }
        else if(bTextField.tag==8)
        {
            [self btnStatePicker:nil];
        }else if (bTextField.tag==13)
        {
            [self btnRelationOfChild:nil];
        }else if (bTextField.tag==25)
        {
            [self btnOccupationType:_btnOccupationType];
        }
        else
        {
            [bTextField becomeFirstResponder];
        }

    }
    else if(alertView.tag==20) // email validation alert
    {
        emailTextField.layer.borderColor=appRedcolor.CGColor;
        [emailTextField becomeFirstResponder];
    }
    else if(alertView.tag==21) // mobile number validation alert
    {
        mobileTextField.layer.borderColor=appRedcolor.CGColor;
        [mobileTextField becomeFirstResponder];

    }
    else if(alertView.tag==22) // pincode validation alert
    {
        pincodeTextField.layer.borderColor=appRedcolor.CGColor;
        [pincodeTextField becomeFirstResponder];
    }
    else if(alertView.tag==23) // email and confirm email validation alert
    {
        confirmEmailIdTextField.layer.borderColor=appRedcolor.CGColor;
        [confirmEmailIdTextField becomeFirstResponder];
    }
    else if(alertView.tag==24) // mobile and confirm mobile validation alert
    {
        confirmMobileTextField.layer.borderColor=appRedcolor.CGColor;
        [confirmMobileTextField becomeFirstResponder];
    }
    
}


#pragma mark - Api Call

-(void)submitFormDataToServer:(NSMutableDictionary *)dict
{
    /*
     {
     "ChildName" : "Mahesh Babu",
    	"ChildDOB" : "10/06/1996",
    	"ChildPresentSTD" : "6th",
    	"ChildPresentSchool" : "St. Bede’s Anglo Indian higher secondary school",
    	"Hobbies" : "Swimming, skating",
    	"Address1" : "No:7, Adam street, Santhome",
    	"Address2" : "",
    	"City" : "Chennai",
    	"State" : "Tamil Nadu",
    	"Pincode" : "600004",
    	"EnquiredBy" : "Peri",
    	"RelationshipWithChild" : "Father",
    	"EmailId" :"peri@kakinada.com",
    	"ContactNumber" : "9176871924",
     "MobileNumber" : "9276871927",
    	"ParentName" : "Peri",
    	"ParentOccupation" : "Priest",
    	"SibilingDetail" : "5th Standard at St. Bede’s",
    	"Referral" : "1"
     }
     */
    
    NSMutableDictionary * postvalues = [[NSMutableDictionary alloc]init];
    postvalues=dict;
    
    [apiCall callApisWithParameters:postvalues postmethod:@"POST" withUrl:@"enquiry/create" AndRequestType:@"enquiry/create"];
}

-(void)getPresentStdClassesList
{
    NSMutableDictionary * postvalues = [[NSMutableDictionary alloc]init];
    [apiCall callApisWithParameters:postvalues postmethod:@"POST" withUrl:@"class/list" AndRequestType:@"presentstandard"];
}

-(void)getApplyStdClassesListWithClassID:(NSString *)classID
{
    NSMutableDictionary * postvalues = [[NSMutableDictionary alloc]init];
    [postvalues setValue:classID forKey:@"present_grade"];
    [apiCall callApisWithParameters:postvalues postmethod:@"POST" withUrl:@"class/list" AndRequestType:@"applystandard"];
}

#pragma mark - API Delegates
-(void)successWithResponse :(id)response andRequestType :(NSString *)requestType
{
    if ([requestType isEqualToString:@"enquiry/create"])
    {
        NSLog(@"response/successWithResponse is %@",response);
        
        /*
         Success
         {
         "Status" : "SUCCESS",
         "EnquiryNumber" : "ENQ001",
         "StatusMessage": "Enquiry saved successfully"
         }
         
         Failure
         {
         "Status":"FAILURE",
         "StatusMessage": "Enquiry not saved. Please try again"
         }
         */
        
        NSDictionary *resultDict=(NSDictionary *)response;
        if([[resultDict objectForKey:@"Status"] isEqualToString:@"SUCCESS"])
        {
            [self loadSubmitFormDetailViewControllerWithEnquiryNumber:[resultDict objectForKey:@"EnquiryNumber"]];
        }
        else if([[resultDict objectForKey:@"Status"] isEqualToString:@"FAILURE"])
        {
            [self showAlertMessage:@"" WithMessage:[resultDict objectForKey:@"StatusMessage"] Delegate:nil CancelButtonTitle:@"Ok" OtherButtonTitle:nil AndTag:0];
        }
    }
    else if ([requestType isEqualToString:@"presentstandard"])
    {
        if(presentGradeArray.count>0)
        {
            [presentGradeArray removeAllObjects];
        }
        
        // @"No Schooling",@"Play School"
        
       /* 
        {
            ClassId = 1;
            "class_name" = "Pre-KG";
            status = 0;
        }
        */
        
        NSMutableArray *classArray = [NSMutableArray new];
      //  NSMutableDictionary *dict = [NSMutableDictionary new];

        classArray = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"ClassId",@"No Schooling",@"class_name",@"0",@"status",nil],
                                                    [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"ClassId",@"Play School",@"class_name",@"0",@"status",nil],
                      nil];
        
        [presentGradeArray addObjectsFromArray:classArray];
        
        [presentGradeArray addObjectsFromArray:[NSMutableArray arrayWithArray:[response objectForKey:@"Classes"]]];

        
        PresentStdPickerViewController *presentStdPickerViewController=[PresentStdPickerViewController sharedSingleton];
        
        presentStdPickerViewController.pickerArray = presentGradeArray;
        
        [presentStdPickerViewController.pickerView reloadAllComponents];
        
        CGRect pFrame;
        
        pFrame=presentStdButton.frame;
        pFrame.origin.x=pFrame.origin.x + 30;
        pFrame.origin.y=pFrame.origin.y + 85;

        
        popoverController = [[UIPopoverController alloc] initWithContentViewController:presentStdPickerViewController];
        popoverController.popoverContentSize = CGSizeMake(320.0, 400.0);
        
        if(isPresentPickerSelected == YES)
        {
            [popoverController presentPopoverFromRect:pFrame
                                               inView:self.view
                             permittedArrowDirections:UIPopoverArrowDirectionUp
             
                                             animated:YES];
        }
        isPresentPickerSelected = NO;
        
        // [self sortArrayWithName:applyStdClassArray]; // dont sort it again... already sorted by webservice
    }
    else if ([requestType isEqualToString:@"applystandard"])
    {
        if(applyStdClassArray.count>0)
        {
            [applyStdClassArray removeAllObjects];
        }
        
        applyStdClassArray = [NSMutableArray arrayWithArray:[response objectForKey:@"Classes"]];
    }
    
    [myappDelegate stopSpinner];
    
}

-(void)failedWithError :(NSString *)error
{
    [myappDelegate stopSpinner];
    
    if (error.length >0)
    {
        NSLog(@"error is %@",error);
        
       // PresentStdPickerViewController *presentStdPickerViewController=[PresentStdPickerViewController sharedSingleton];
        
       // if(presentStdPickerViewController.pickerArray.count>0)
        //    [presentStdPickerViewController.pickerArray removeAllObjects];
        
//        if(presentStdPickerViewController.selectedPickerDict.count>0)
//        {
//            [presentStdPickerViewController.selectedPickerDict removeAllObjects];
//        }
//        
//        [presentStdPickerViewController.pickerView reloadAllComponents];
        
// Muthukumaresh Founded...
        [self showAlertMessage:@"Alert" WithMessage:error Delegate:nil CancelButtonTitle:@"Ok" OtherButtonTitle:nil AndTag:0];
     //   [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)sortArrayWithName:(NSMutableArray *)filteredArray
{
    NSSortDescriptor *sortDescriptor1;//, *sortDescriptor2;
    sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"ClassId" ascending:YES];
    //   sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"timeOnly" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor1];
    //  NSArray *sortDescriptors=[NSArray arrayWithObjects:sortDescriptor1,sortDescriptor2, nil];
    [filteredArray sortUsingDescriptors:sortDescriptors];
}

#pragma mark - Custom Methods
-(void)clearAllTextFieldsData
{
    childNameTextField.text=@"";
    dobTextField.text=@"";
    presentStdTextField.text=@"";
    applyingForStdTextField.text=@"";
    address1TextField.text=@"";
    address2TextField.text=@"";
    cityTextField.text=@"";
    stateTextField.text=@"";
    pincodeTextField.text=@"";
    presentSchoolTextField.text=@"";
    hobbiesTextField.text=@"";
    enquiredByTextField.text=@"";
    relationWithChildTextField.text=@"";
    emailTextField.text=@"";
    confirmEmailIdTextField.text=@"";
    mobileTextField.text=@"";
    confirmMobileTextField.text=@"";
    landlineTextField.text=@"";
    parentNameTextField.text=@"";
    parentOccTextField.text=@"";
    parentOccupationType.text=@"";
    siblingsTextView.text=@"";
    parentsNotesTextView.text=@"";
    previousTextField=nil;
    currentTextField=nil;
    currentTextView=nil;
}

-(void)clearAllDictionaryDataWithEmptyValue
{
    [dataDictionary setValue:@"" forKey:@"ChildName"];
    [dataDictionary setValue:@"" forKey:@"ChildDOB"];
    [dataDictionary setValue:@"" forKey:@"ChildPresentSTD"];
    [dataDictionary setValue:@"" forKey:@"ChildApplyingSTD"];
    [dataDictionary setValue:@"" forKey:@"Address1"];
    [dataDictionary setValue:@"" forKey:@"Address2"];
    [dataDictionary setValue:@"" forKey:@"City"];
    [dataDictionary setValue:@"" forKey:@"State"];
    [dataDictionary setValue:@"" forKey:@"Pincode"];
    [dataDictionary setValue:@"" forKey:@"ChildPresentSchool"];
    [dataDictionary setValue:@"" forKey:@"Hobbies"];
    [dataDictionary setValue:@"" forKey:@"EnquiredBy"];
    [dataDictionary setValue:@"" forKey:@"RelationshipWithChild"];
    [dataDictionary setValue:@"" forKey:@"EmailId"];
    [dataDictionary setValue:@"" forKey:@"ConfirmEmail"];
    [dataDictionary setValue:@"" forKey:@"MobileNumber"];
    [dataDictionary setValue:@"" forKey:@"ConfirmMobile"];
    [dataDictionary setValue:@"" forKey:@"ContactNumber"];
    [dataDictionary setValue:@"" forKey:@"ParentName"];
    [dataDictionary setValue:@"" forKey:@"ParentOccupation"];
    [dataDictionary setValue:@"" forKey:@"ParentNote"];
    [dataDictionary setValue:@"" forKey:@"SibilingDetail"];
    [dataDictionary setValue:@"" forKey:@"Referral"];
    [dataDictionary setValue:@"" forKey:@"OccupationType"];   //OccupationType
    
    if([[dataDictionary valueForKey:@"Referral"] isKindOfClass:[NSNull class]] )
    {
        segmentControl.layer.borderColor=appLightGrayColor.CGColor;
        
        for (int i=0; i<[segmentControl.subviews count]; i++)
        {
            [[segmentControl.subviews objectAtIndex:i] setTintColor:appWhiteColor];
        }
    }
    else
    {
        int selectedIndex=(int)[[dataDictionary valueForKey:@"Referral"] integerValue]-1;
        segmentControl.selectedSegmentIndex =selectedIndex;
       // segmentControl.layer.borderColor=appWhiteColor.CGColor;
        
        for (int i=0; i<[segmentControl.subviews count]; i++)
        {
            [[segmentControl.subviews objectAtIndex:i] setTintColor:appLightGrayColor];
        }
    }

}
#pragma mark - CustomPicker Delegate Methods
-(void)sendSelectedDate:(NSString *)selectedDateStr
{
    [self resignKeyboard];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSDate *dobDate = [dateFormat dateFromString:selectedDateStr];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString=[dateFormat stringFromDate:dobDate];

    [dataDictionary setValue:dateString forKey:[keysDataDictionary valueForKey:@"2"]];
    
    dobTextField.text=selectedDateStr;
    
    if(dobTextField.text ==nil || [dobTextField.text isEqualToString:@""] || [dobTextField.text isKindOfClass:[NSNull class]])
    {
       
        dobTextField.layer.borderColor=appLightGrayColor.CGColor;
    }
    else
    {
        dobTextField.layer.borderColor=appLightGrayColor.CGColor;
    }
}

-(void)sendSelectedPickerValue:(NSMutableDictionary *)selectedPickDict
{
    [self resignKeyboard];
    
    NSLog(@"selectedPickDict classid is %@",[selectedPickDict valueForKey:@"ClassId"]);
    applyStdClassIDString = [selectedPickDict valueForKey:@"ClassId"];
    
    [dataDictionary setValue:[selectedPickDict valueForKey:@"class_name"] forKey:[keysDataDictionary valueForKey:@"3"]];
  
    presentStdTextField.text=[dataDictionary valueForKey:[keysDataDictionary valueForKey:@"3"]];
    NSLog(@"mkmkmkmk%@",presentStdTextField.text);
    
    if(presentStdTextField.text ==nil || [presentStdTextField.text isEqualToString:@""] || [presentStdTextField.text isKindOfClass:[NSNull class]])
    {
        presentStdTextField.layer.borderColor=appLightGrayColor.CGColor;
    }
    else
    {
        presentStdTextField.layer.borderColor=appLightGrayColor.CGColor;
    }
    
    [myappDelegate startSpinner];
    [self getApplyStdClassesListWithClassID:applyStdClassIDString];
    
}

-(void)sendSelectedApplyStdPickerValue:(NSMutableDictionary *)selectedPickDict
{
    [self resignKeyboard];
    
    [dataDictionary setValue:[selectedPickDict objectForKey:@"ClassId"] forKey:[keysDataDictionary valueForKey:@"4"]];

    applyingForStdTextField.text=[selectedPickDict objectForKey:@"class_name"];

    if(applyingForStdTextField.text ==nil || [applyingForStdTextField.text isEqualToString:@""] || [applyingForStdTextField.text isKindOfClass:[NSNull class]])
    {
        applyingForStdTextField.layer.borderColor=appLightGrayColor.CGColor;
    }
    else
    {
        applyingForStdTextField.layer.borderColor=appLightGrayColor.CGColor;
    }
}

-(void)loadSubmitFormDetailViewControllerWithEnquiryNumber:(NSString *)enquiryNumber
{
    SubmitFormDetailViewController *formDetailVC = [[SubmitFormDetailViewController alloc] initWithNibName:@"SubmitFormDetailViewController" bundle:nil];
    formDetailVC.enquiryNumberString=enquiryNumber;
    
    [self.navigationController pushViewController:formDetailVC animated:YES];
    
    [self clearButtonClicked:nil];
    
}

#pragma mark - Keyboard Activity

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
    formScrollView.contentInset = contentInsets;
    formScrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, currentTextField.frame.origin) )
    {
        float tHeight=0.0;
        if(currentTextField==hobbiesTextField || currentTextField==presentSchoolTextField)
        {
            tHeight=kbSize.height-300;
        }
        else
        {
            tHeight=kbSize.height;
        }
        CGPoint scrollPoint = CGPointMake(0.0, currentTextField.frame.origin.y-tHeight);
        [formScrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (void)keyboardWasHidden:(NSNotification *)aNotification
{
    [UIView commitAnimations];
    
  //  [currentTextField resignFirstResponder];
  //  [currentTextView resignFirstResponder];
    
    formScrollView.contentInset = UIEdgeInsetsZero;
    formScrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
    
}

-(void)resignKeyboard
{
    [UIView commitAnimations];
    
    [currentTextField resignFirstResponder];
    [currentTextView resignFirstResponder];
    
    formScrollView.contentOffset=CGPointMake(0, 0);
}

#pragma mark - UITextField Delegates

-(BOOL)textFieldShouldBeginEditing: (UITextField *)textField

{
    currentTextField=textField;
    
    UIToolbar * keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    
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
    
    return YES;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
  //  NSLog(@"final tag/textfieldDidEndEditing is %@",[NSString stringWithFormat:@"%ld",(long)textField.tag]);
    
    NSArray *allKeysArray=[keysDataDictionary allKeys];
    
    if([allKeysArray containsObject:[NSString stringWithFormat:@"%ld",(long)textField.tag]])
    {
        [dataDictionary setValue:textField.text forKey:[keysDataDictionary valueForKey:[NSString stringWithFormat:@"%ld",(long)textField.tag]]];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{

    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *invalidCharSet;
    
    if([[keysDataDictionary valueForKey:[NSString stringWithFormat:@"%ld",(long)textField.tag]]isEqualToString:@"MobileNumber"])
    {
        invalidCharSet  = [[NSCharacterSet characterSetWithCharactersInString:Numberonly] invertedSet];
        NSString *filteredString = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        
        if ([string isEqualToString:filteredString])
        {
            if(textField.text.length+string.length<=10)
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
    else if([[keysDataDictionary valueForKey:[NSString stringWithFormat:@"%ld",(long)textField.tag]]isEqualToString:@"ConfirmMobile"])
    {
        invalidCharSet  = [[NSCharacterSet characterSetWithCharactersInString:Numberonly] invertedSet];
        NSString *filteredString = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        
        if ([string isEqualToString:filteredString])
        {
            if(textField.text.length+string.length<=10)
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
    else if([[keysDataDictionary valueForKey:[NSString stringWithFormat:@"%ld",(long)textField.tag]]isEqualToString:@"ContactNumber"])
    {
      //  invalidCharSet  = [[NSCharacterSet characterSetWithCharactersInString:Numberonly] invertedSet];
        invalidCharSet  = [[NSCharacterSet characterSetWithCharactersInString:@" -0123456789"] invertedSet];

        NSString *filteredString = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        
        if ([string isEqualToString:filteredString])
        {
            if(textField.text.length+string.length<=15)
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
    else if([[keysDataDictionary valueForKey:[NSString stringWithFormat:@"%ld",(long)textField.tag]]isEqualToString:@"Pincode"])
    {
        invalidCharSet  = [[NSCharacterSet characterSetWithCharactersInString:Numberonly] invertedSet];
        NSString *filteredString = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        
        if ([string isEqualToString:filteredString])
        {
            if(textField.text.length+string.length<=6)
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
    else if([[keysDataDictionary valueForKey:[NSString stringWithFormat:@"%ld",(long)textField.tag]]isEqualToString:@"Address1"] || [[keysDataDictionary valueForKey:[NSString stringWithFormat:@"%ld",(long)textField.tag]]isEqualToString:@"Address2"])
    {
        invalidCharSet  = [[NSCharacterSet characterSetWithCharactersInString:@"/0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz,'&#@-_ "] invertedSet];
    }
    else if([[keysDataDictionary valueForKey:[NSString stringWithFormat:@"%ld",(long)textField.tag]]isEqualToString:@"EmailId"])
    {
        invalidCharSet  = [[NSCharacterSet characterSetWithCharactersInString:@"_-@.0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"] invertedSet];
    }
    else if([[keysDataDictionary valueForKey:[NSString stringWithFormat:@"%ld",(long)textField.tag]]isEqualToString:@"ConfirmEmail"])
    {
        invalidCharSet  = [[NSCharacterSet characterSetWithCharactersInString:@"_-@.0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"] invertedSet];
    }
    else if([[keysDataDictionary valueForKey:[NSString stringWithFormat:@"%ld",(long)textField.tag]]isEqualToString:@"ChildName"] || [[keysDataDictionary valueForKey:[NSString stringWithFormat:@"%ld",(long)textField.tag]]isEqualToString:@"EnquiredBy"] || [[keysDataDictionary valueForKey:[NSString stringWithFormat:@"%ld",(long)textField.tag]]isEqualToString:@"ParentName"])
    {
        invalidCharSet  = [[NSCharacterSet characterSetWithCharactersInString:@" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.',_"] invertedSet];
        NSString *filteredString = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        
        if ([string isEqualToString:filteredString])
        {
            if(textField.text.length+string.length<=25)
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
    else if([[keysDataDictionary valueForKey:[NSString stringWithFormat:@"%ld",(long)textField.tag]]isEqualToString:@"ChildPresentSchool"])
    {
        invalidCharSet  = [[NSCharacterSet characterSetWithCharactersInString:@" ',.0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"] invertedSet];
    }
    else if([[keysDataDictionary valueForKey:[NSString stringWithFormat:@"%ld",(long)textField.tag]]isEqualToString:@"Hobbies"])
    {
        invalidCharSet  = [[NSCharacterSet characterSetWithCharactersInString:@" .,'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"] invertedSet];
    }
    else if([[keysDataDictionary valueForKey:[NSString stringWithFormat:@"%ld",(long)textField.tag]]isEqualToString:@"RelationshipWithChild"])
    {
        invalidCharSet  = [[NSCharacterSet characterSetWithCharactersInString:@" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"] invertedSet];
    }
    else if([[keysDataDictionary valueForKey:[NSString stringWithFormat:@"%ld",(long)textField.tag]]isEqualToString:@"ParentOccupation"])
    {
        invalidCharSet  = [[NSCharacterSet characterSetWithCharactersInString:@" .&/,ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"] invertedSet];
    }
    else
    {
        invalidCharSet  = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz. "] invertedSet];
        
        NSString *filteredString = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        
        if ([string isEqualToString:filteredString])
        {
            if(textField.text.length+string.length<=25)
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
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
    
    return [string isEqualToString:filtered];
    
}

#pragma mark - UITextView Delegates
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    currentTextView=textView;
    
    UIToolbar * keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    
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
    
    
    textView.inputAccessoryView = keyboardToolBar;
    return YES;
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self animateviewForIpad:formScrollView:textView];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.tag==22)  // sibiling details
    {
        [dataDictionary setValue:textView.text forKey:[keysDataDictionary valueForKey:@"22"]];

    }
    else // parent notes
    {
        [dataDictionary setValue:textView.text forKey:[keysDataDictionary valueForKey:@"21"]];
    }
  //  NSLog(@"dataDictionary/textViewDidEndEditing is %@",dataDictionary);
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSCharacterSet *invalidCharSet;
    
    invalidCharSet  = [[NSCharacterSet characterSetWithCharactersInString:@" ,'/-.0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"] invertedSet];
    
    NSString *filtered = [[text componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
    
    if([text isEqualToString:@"\n"])
    {
        return YES;
    }
    
    return [text isEqualToString:filtered];
    
    return YES;
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
            [temscrlv setContentOffset:CGPointMake(0, scrollfrm.origin.y-100) animated:YES];
        }
    }
}

#pragma mark - Alert Message
-(void)showAlertMessage:(NSString *)titleString WithMessage:(NSString *)messageString Delegate:(id)delegate CancelButtonTitle:(NSString *)cancelTitle OtherButtonTitle:(NSString *)otherTitle AndTag:(int)tag
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:titleString message:messageString delegate:delegate cancelButtonTitle:cancelTitle otherButtonTitles:otherTitle, nil];
    alertView.tag=tag;
    [alertView show];
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

#pragma mark - Mobile Number Validation

-(BOOL)checkMobileNumberDigits:(NSString *)mobNumber AndAlertMessage:(NSString *)alertMessageStr
{
    //  NSString *phoneRegex = @"^[7-9][0-9]{9}$";
    // NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    NSString *s = mobNumber; // a string
    unichar c = [s characterAtIndex:0];
    if (c >= '0' && c <= '6')
    {
        [self showAlertMessage:@"Please enter valid mobile number" WithMessage:@"" Delegate:self CancelButtonTitle:@"Ok" OtherButtonTitle:nil AndTag:21];
    }
    else if ([mobNumber length]<10)
    {
        [self showAlertMessage:@"Alert" WithMessage:alertMessageStr Delegate:nil CancelButtonTitle:@"Ok" OtherButtonTitle:nil AndTag:0];
    }
    else
    {
        return YES;
    }
    return NO;
}

#pragma mark - Pincode Validation
-(BOOL)isValidPinCode:(NSString*)pincode
{
    NSString *pinRegex = @"^[0-9]{6}$";
    NSPredicate *pinTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pinRegex];
    
    NSString *s = pincode; // a string
  //  NSLog(@"pincode is %@",s);
    unichar c = [s characterAtIndex:0];
    if (c == '0')
    {
        [self showAlertMessage:@"Alert" WithMessage:@"Pincode should not start with the digit zero" Delegate:self CancelButtonTitle:@"Ok" OtherButtonTitle:nil AndTag:22];
    }
    else
    {
        BOOL pinValidates = [pinTest evaluateWithObject:pincode];
        if (pinValidates==NO)
        {
            [self showAlertMessage:@"Alert" WithMessage:@"Please Enter Valid Pincode" Delegate:nil CancelButtonTitle:@"Ok" OtherButtonTitle:nil AndTag:0];
        }
        
        return pinValidates;
    }
    return NO;
    
}

-(BOOL)isEmailAndConfirmEmailBeTheSame:(NSString*)email AndConfirm:(NSString *)confirmStr
{
    BOOL isValid=YES;
    if(![email isEqualToString:confirmStr])
    {
        isValid=NO;
        [self showAlertMessage:@"Email ID and Confirm Email ID fields should be same" WithMessage:@"" Delegate:self CancelButtonTitle:@"Ok" OtherButtonTitle:nil AndTag:23];
    }
    return isValid;
}

-(BOOL)isMobileAndConfirmMobileBeTheSame:(NSString*)mobile AndConfirm:(NSString *)confirmStr
{
    BOOL isValid=YES;
    if(![mobile isEqualToString:confirmStr])
    {
        isValid=NO;
        
        [self showAlertMessage:@"Mobile No and Confirm Mobile No fields should be same" WithMessage:@"" Delegate:self CancelButtonTitle:@"Ok" OtherButtonTitle:nil AndTag:24];
    }
    return isValid;
}
//New Design
//button for Disclosure View
- (IBAction)btnDisclosureView:(id)sender
{
//    if (_vewDiscloserForNameField.isHidden) {
//        self.vewDiscloserForNameField.hidden=NO;
//    }else
//    {
//        self.vewDiscloserForNameField.hidden=YES;
//    }
    UIButton *getButton=(UIButton*)sender;
    DiscloserButton *disCloserBtn=[[DiscloserButton alloc]init];
    popoverController = [[UIPopoverController alloc] initWithContentViewController:disCloserBtn];
    popoverController.popoverContentSize = CGSizeMake(127.0,37.0);
    [popoverController presentPopoverFromRect:getButton.frame
                                       inView:getButton.superview                     //self.view
                     permittedArrowDirections:UIPopoverArrowDirectionLeft
                                     animated:YES];

    
}


//State Button Action
- (IBAction)btnStatePicker:(id)sender
{
    [self resignKeyboard];
    // here is code for finding the row and section of a textfield being edited in a uicollectionview
    
    CGRect pFrame=stateButton.frame;
    pFrame.origin.x=pFrame.origin.x + 30;
    pFrame.origin.y=pFrame.origin.y + 85;
    // cell.frame=pFrame;
    StateViewController *statePickerViewController=[StateViewController sharedSingleton];
      statePickerViewController.pickerArray=[self arrState];
    statePickerViewController.delegate=self;
    
    popoverController = [[UIPopoverController alloc] initWithContentViewController:statePickerViewController];
    popoverController.popoverContentSize = CGSizeMake(320.0, 400.0);
    [popoverController presentPopoverFromRect:pFrame
                                       inView:self.view
                     permittedArrowDirections:UIPopoverArrowDirectionUp
                                     animated:YES];
    
}

//Get the States for array
-(NSArray*)arrState
{
    return @[@"Andhra Pradesh",@"Arunachal Pradesh",@"Assam",@"Bihar",@"Chhattisgarh",@"Goa",@"Gujarat",@"Haryana",@"Himachal Pradesh",@"Jammu & Kashmir",@"Jharkhand",@"Karnataka",@"Kerala",@"Madhya Pradesh",@"Maharashtra",@"Manipur",@"Meghalaya",@"Mizoram",@"Nagaland",@"Orissa",@"Punjab",@"Rajasthan",@"Sikkim",@"Tamil Nadu",@"Telangana",@"Tripura",@"Uttar Pradesh",@"Uttarakhand",@"West Bengal"];
}

//Delegate For State Picker
-(void)sendSelectedApplyStatePickerValue:(NSString *)selectedPickDict
{
    [self resignKeyboard];
    
    [dataDictionary setValue:selectedPickDict forKey:[keysDataDictionary valueForKey:@"8"]];
    
    stateTextField.text=selectedPickDict;
    
    if(stateTextField.text ==nil || [stateTextField.text isEqualToString:@""] || [stateTextField.text isKindOfClass:[NSNull class]])
    {
        stateTextField.layer.borderColor=appLightGrayColor.CGColor;
    }
    else
    {
        stateTextField.layer.borderColor=appLightGrayColor.CGColor;
    }
}

//Relation for child
- (IBAction)btnRelationOfChild:(id)sender {
    
    
    [self resignKeyboard];
    // here is code for finding the row and section of a textfield being edited in a uicollectionview
    
    CGRect pFrame=_btnRelationOfChild.frame;
    pFrame.origin.x=pFrame.origin.x + 30;
    pFrame.origin.y=pFrame.origin.y +0;//85
    // cell.frame=pFrame;
    RelationshipWithChildViewController *relationshipePickerViewController=[RelationshipWithChildViewController sharedSingleton];
    relationshipePickerViewController.pickerArray=[self arrRelationOfChild];
    relationshipePickerViewController.delegate=self;
    
    popoverController = [[UIPopoverController alloc] initWithContentViewController:relationshipePickerViewController];
    popoverController.popoverContentSize = CGSizeMake(320.0,400.0);
    [popoverController presentPopoverFromRect:pFrame
                                       inView:_btnRelationOfChild.superview                     //self.view
                     permittedArrowDirections:UIPopoverArrowDirectionDown
                                     animated:YES];
}

//Get the States for array
-(NSArray*)arrRelationOfChild
{
    return @[@"Father / Mother",@"Neighbour",@"Friend",@"Grandfather / Grandmother",@"Uncle / Aunt",@"Others"];
}

-(void)sendSelectedApplyRelationOfChildPickerValue:(NSString *)selectedPickDict
{
  //  [self resignKeyboard];
    
    if ([selectedPickDict isEqualToString:@"Others"])
    {
        relationWithChildTextField.text=@"";
        relationWithChildTextField.userInteractionEnabled=YES;
        [relationWithChildTextField becomeFirstResponder];
        
    }
    else
    {
    
        [dataDictionary setValue:selectedPickDict forKey:[keysDataDictionary valueForKey:@"13"]];
    
        relationWithChildTextField.text=selectedPickDict;
    
        if(relationWithChildTextField.text ==nil || [relationWithChildTextField.text isEqualToString:@""] || [relationWithChildTextField.text isKindOfClass:[NSNull class]])
        {
            relationWithChildTextField.layer.borderColor=appLightGrayColor.CGColor;
        }
        else
        {
            relationWithChildTextField.layer.borderColor=appLightGrayColor.CGColor;
        }
    }
}

//Get the Occupation Type
- (IBAction)btnOccupationType:(id)sender
{
   // [self resignKeyboard];
  
    UIButton *getBtn=(UIButton*)sender;
    int getVal=getBtn.superview.frame.origin.y;
    [UIView commitAnimations];
    [currentTextField resignFirstResponder];
    [currentTextView resignFirstResponder];
    formScrollView.contentOffset=CGPointMake(0, getVal-100);
    
    // here is code for finding the row and section of a textfield being edited in a uicollectionview
    
    CGRect pFrame=_btnOccupationType.frame;
    pFrame.origin.x=pFrame.origin.x + 30;
    pFrame.origin.y=pFrame.origin.y +0;//85
    // cell.frame=pFrame;
    OccupationTypeViewController *occupationTypePickerViewController=[OccupationTypeViewController sharedSingleton];
    occupationTypePickerViewController.pickerArray=[self arrOccupationType];
    occupationTypePickerViewController.delegate=self;
    
    popoverController = [[UIPopoverController alloc] initWithContentViewController:occupationTypePickerViewController];
    popoverController.popoverContentSize = CGSizeMake(320.0,200);
    [popoverController presentPopoverFromRect:pFrame
                                       inView:_btnOccupationType.superview                     //self.view
                     permittedArrowDirections:UIPopoverArrowDirectionDown
                                     animated:YES];

}

-(void)sendSelectedApplyOccupationTypePickerValue:(NSString *)currentText
{
     [dataDictionary setValue:currentText forKey:[keysDataDictionary valueForKey:@"25"]];
    parentOccupationType.text=currentText;
    
}



-(NSArray*)arrOccupationType
{
    return @[@"Salaried",@"Self-Employed"];
}

@end
