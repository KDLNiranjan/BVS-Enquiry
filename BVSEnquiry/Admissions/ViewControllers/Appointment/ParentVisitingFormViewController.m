//
//  ParentVisitingFormViewController.m
//  BVSEnquiry
//
//  Created by Kutung PC 35 on 14/06/16.
//  Copyright © 2016 Kutung. All rights reserved.
//

#import "ParentVisitingFormViewController.h"
#import "RadioButton.h"
#import "SuccessApptViewController.h"
#import <objc/runtime.h>

@interface ParentVisitingFormViewController ()
{
    CGRect previousRect;
}
@end

@implementation ParentVisitingFormViewController

const char visitConstantKey;

@synthesize childDetailsDict;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationItem setHidesBackButton:YES];
    
    [self initializeView];
    [self registerForKeyboardNotifications];

    previousRect = CGRectZero;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initializeView
{
    // creating header view navigation bar
    [self createHeaderViewForNavigationBar];
    
    //initialize APICall
    apiCall = [[ApiCall alloc] init];
    apiCall.delegate = self;
    
    visitReasonArray=[NSMutableArray new];
    chooseRelationArray =[[NSMutableArray alloc]initWithObjects:@"Father", @"Mother", @"Others", nil];
   
    formScrollView.contentOffset=CGPointMake(0, 0);

    // assigning cornerRadius and border color for clear and proceed buttons.
    clearButtonView.layer.cornerRadius=20.0f;
    submitButtonView.layer.cornerRadius=20.0f;
    submitButtonView.layer.borderColor=[UIColor colorWithRed:165.0f/255.0f green:23.0f/255.0f blue:35.0f/255.0f alpha:1.0].CGColor;
    submitButtonView.layer.borderWidth=2.0f;
    
    [self assignLabelValues];
    
    //textfield
    reasonForVisitTextField=[self getTextFieldAttributes:reasonForVisitTextField];
    reasonForVisitTextField.userInteractionEnabled=NO;
    reasonForVisitTextField.placeholder=@"Choose";
  
    // textview
    commentsTextView=[self getTextViewAttributes:commentsTextView];
    commentsTextView.hidden=YES;
    commentsLabel.hidden=YES;
    [self setFrameToSubmitAndClearButtonWhenRemainingVisitReasonClicked];
    
    [self createUIViewForRadioSelectionToChooseRelationship];

    [myappDelegate startSpinner];
    [self getReasonForVisitList];
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
    // logoImgView.tintColor=appGrayColor;
    [homeButton addSubview:homeButtonImgView];
    [self.view addSubview:headerView];
    
    //Create  Label
    CGSize titleSize=[self getSizebasedOnText:@"Appointment" FontName:CustomLight(22) AndWidth:screensize.size.width];
   // UILabel *navTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(logoImgView.frame.size.width + logoImgView.frame.origin.x + 30, 0, titleSize.width, headerHeight)];
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

-(void)createUIViewForRadioSelectionToChooseRelationship
{
    radioSelectionView.backgroundColor=appClearColor;

    NSInteger xAxisForEachDateView=0;
    radioButtonsArray = [NSMutableArray arrayWithCapacity:3];

    for(int i=0;i<chooseRelationArray.count;i++)
    {
        NSString* optionTitle = chooseRelationArray[i];
        radioButtonsBackgroundView=[[UIView alloc]initWithFrame:CGRectMake(xAxisForEachDateView,0,100, 45)];
        radioButtonsBackgroundView.backgroundColor=appClearColor;
        [radioSelectionView addSubview:radioButtonsBackgroundView];
        
        RadioButton* btn = [[RadioButton alloc] initWithFrame:CGRectMake(0, 0, 100, 45)];

        [btn addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:optionTitle forState:UIControlStateNormal];
        
        [btn setTitleColor:appLightGrayColor forState:UIControlStateNormal];
        [btn setTitleColor:appButtonColor forState:UIControlStateSelected];

        btn.titleLabel.font = CustomRegular(17);
        [btn setImage:[UIImage imageNamed:@"radio_unselected.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"radio_selected.png"] forState:UIControlStateSelected];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
        btn.titleLabel.text=optionTitle;
        btn.tag=i;
        [radioButtonsBackgroundView addSubview:btn];
        [radioButtonsArray addObject:btn];
        
        xAxisForEachDateView=radioButtonsBackgroundView.frame.origin.x+radioButtonsBackgroundView.frame.size.width+20;

    }
    
    [radioButtonsArray[0] setGroupButtons:radioButtonsArray]; // Setting buttons into the group
    [radioButtonsArray[0] setSelected:NO]; // Making the first button initially selected
    
    [self createGuardianView];
    guardianView.hidden=YES;
}

-(void)createScrollViewForReasonForVisit
{
    UIView *visitReasonView = [self createUIViewForVisitReason];
    [visitReasonScrollView addSubview:visitReasonView];
    
    CGRect contentRect = CGRectZero;
    for (UIView *view in visitReasonScrollView.subviews)
    {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    visitReasonScrollView.contentSize = contentRect.size;
}

-(UIView *)createUIViewForVisitReason
{
    int xAxis=57;
    int yAxis=0;
    
    UIView *cView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, visitReasonScrollView.frame.size.width, 100)];
    cView.backgroundColor=appClearColor;
    NSInteger buttonsCount=visitReasonArray.count;
    
    NSMutableArray *buttonsArray = [NSMutableArray arrayWithCapacity:buttonsCount];
    NSMutableDictionary *buttonsDict=[NSMutableDictionary new];
    visitReasonDict=[NSMutableDictionary new];
    
    checkButtonsArray = [NSMutableArray arrayWithCapacity:buttonsCount];
    buttonsArray=checkButtonsArray;
    buttonsDict=visitReasonDict;
    
    for (int i=0; i<buttonsCount; i++)
    {
        [buttonsDict setObject:@"0" forKey:[NSString stringWithFormat:@"%d",i]];
        
        NSDictionary *dict =[visitReasonArray objectAtIndex:i];
        UIButton *checkButton=[self createUIButtonForCheckBoxWithXAxis:xAxis AndYAxis:yAxis ButtonText:[dict valueForKey:@"reason"] ButtonTag:i];
        [cView addSubview:checkButton];
        [buttonsArray addObject:checkButton];
        
        NSInteger numberOfColumns;
        NSInteger yAxisPos;
        
        numberOfColumns=2;
        yAxisPos=45;
        
        if((i+1)%numberOfColumns==0)
        {
            xAxis=57;
            yAxis+=yAxisPos + 5;
        }
        else
        {
            xAxis+=420;
        }
        
        CGRect cViewFrame=cView.frame;
        cViewFrame.size.height=checkButton.frame.origin.y + checkButton.frame.size.height + 0;
        cView.frame=cViewFrame;
    }
    
    return cView;
}


-(UIButton *)createUIButtonForCheckBoxWithXAxis:(NSInteger)xAxis AndYAxis:(NSInteger)yAxis ButtonText:(NSString *)buttonText ButtonTag:(NSInteger)buttonTag
{
    CGSize reasonTitleSize=[self getSizebasedOnText:buttonText FontName:CustomRegular(17) AndWidth:visitReasonScrollView.frame.size.width-500];

    // uibutton button
    UIButton *checkboxButton=[UIButton buttonWithType:UIButtonTypeCustom];
    checkboxButton.frame=CGRectMake(xAxis, yAxis, reasonTitleSize.width+50, reasonTitleSize.height + 5);
    checkboxButton.showsTouchWhenHighlighted=NO;
    checkboxButton.tag=buttonTag;
    checkboxButton.contentHorizontalAlignment=NSTextAlignmentCenter;
   // [checkboxButton setBackgroundImage:[UIImage imageNamed:@"check_unselected.png"] forState:UIControlStateNormal];
    [checkboxButton addTarget:self action:@selector(checkBoxButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // Uiimageview...
    UIImageView *checkboxImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, checkboxButton.frame.size.height/2-10, 20, 20)];
    checkboxImageView.image=[UIImage imageNamed:@"check_unselected.png"];
    [checkboxButton addSubview:checkboxImageView];
    
    UILabel *reasonTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(checkboxImageView.frame.origin.x + checkboxImageView.frame.size.width + 10, (checkboxButton.frame.size.height/2)-(reasonTitleSize.height/2), reasonTitleSize.width, reasonTitleSize.height)];
    reasonTitleLabel.text=buttonText;
    reasonTitleLabel.textColor=[UIColor colorWithRed:157.0f/255.0f green:157.0f/255.0f blue:157.0f/255.0f alpha:1.0];
    reasonTitleLabel.textAlignment=NSTextAlignmentLeft;
    reasonTitleLabel.backgroundColor=appClearColor;
    reasonTitleLabel.font=CustomRegular(17);
    reasonTitleLabel.numberOfLines=0;
    [checkboxButton addSubview:reasonTitleLabel];
    
    [visitReasonDict setObject:@"0" forKey:[NSString stringWithFormat:@"%ld",(long)buttonTag]];
    
    return checkboxButton;
}

-(void)createGuardianView
{
    guardianView =[[UIView alloc]initWithFrame:CGRectMake(radioButtonsBackgroundView.frame.origin.x + radioButtonsBackgroundView.frame.size.width +10, 5, 300, 35)];
    guardianView.backgroundColor=appClearColor;
    
    [radioSelectionView addSubview:guardianView];
    [radioSelectionView bringSubviewToFront:guardianView];
    
    [self createUITextfieldForGuardianName];
}

-(void)createUITextfieldForGuardianName
{
    guardianTextField=[[UITextField alloc]initWithFrame:CGRectMake(10, 0, guardianView.frame.size.width-20, 35)];
    guardianTextField.delegate=self;
    [guardianView addSubview:guardianTextField];
    guardianTextField.text=@"";
    [guardianTextField setBorderStyle:UITextBorderStyleNone];
    guardianTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    
    guardianTextField.layer.cornerRadius=5.0;
    guardianTextField.layer.borderColor=appLightGrayColor.CGColor;
    guardianTextField.font=CustomRegular(17);
    guardianTextField.textColor=appBlackColor;
    
    if (scaleForRetina == 2.0)
    {
        // retina screen;
        guardianTextField.layer.borderWidth = 1.5;
    }
    else
    {
        // non-retina screen
        guardianTextField.layer.borderWidth = 1.0;
    }
    
    guardianTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
    
    guardianTextField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Enter your name"
                                    attributes:@{
                                                 NSForegroundColorAttributeName: appLightGrayColor,
                                                 NSFontAttributeName : CustomRegular(17)
                                                 }
     ];
    
}

-(void)setFrameToSubmitAndClearButtonWhenOthersVisitReasonClicked
{
    submitButtonView.frame=CGRectMake(55,528,120,40);
    clearButtonView.frame=CGRectMake(submitButtonView.frame.origin.x + submitButtonView.frame.size.width + 20,528,80,40);
    makeApptView.frame=CGRectMake(32,160,958,600);
    formScrollView.contentSize=CGSizeMake(1024,800);
    formScrollView.contentOffset=CGPointMake(0, 0);
}

-(void)setFrameToSubmitAndClearButtonWhenRemainingVisitReasonClicked
{
    submitButtonView.frame=CGRectMake(55,440,120,40);
    clearButtonView.frame=CGRectMake(submitButtonView.frame.origin.x + submitButtonView.frame.size.width + 20,440,80,40);
    makeApptView.frame=CGRectMake(32,160,958,520);
    formScrollView.contentSize=CGSizeMake(1024,750);
    formScrollView.contentOffset=CGPointMake(0, 0);
}

-(void)getSelectedColorUIButtonTitleWithButton:(UIButton *)globalButton
{
    for(id customView in [globalButton subviews])
    {
        if([customView isKindOfClass:[UILabel class]])
        {
            UILabel *label=(UILabel *)customView;
            label.textColor=appButtonColor;
        }
        
        if([customView isKindOfClass:[UIImageView class]])
        {
            UIImageView *imgView=(UIImageView *)customView;
            
            imgView.image=[UIImage imageNamed:@"check_selected.png"];
        }
        
    }
}

-(void)getUnselectedColorUIButtonTitleWithButton:(UIButton *)globalButton
{
    for(id customView in [globalButton subviews])
    {
        if([customView isKindOfClass:[UILabel class]])
        {
            UILabel *label=(UILabel *)customView;
            label.textColor=[UIColor colorWithRed:157.0f/255.0f green:157.0f/255.0f blue:157.0f/255.0f alpha:1.0];
        }
        
        if([customView isKindOfClass:[UIImageView class]])
        {
            UIImageView *imgView=(UIImageView *)customView;
            
            imgView.image=[UIImage imageNamed:@"check_unselected.png"];
        }
    }
}

-(void)checkForOthersVisitReason
{
    NSMutableArray *idArray=[[NSMutableArray alloc]init];
    NSMutableArray *reasonArray=[[NSMutableArray alloc]init];

    for(int i=0;i<visitReasonDict.count;i++)
    {
        NSString *string =[visitReasonDict valueForKey:[NSString stringWithFormat:@"%d",i]];
        if([string isEqualToString:@"1"])
        {
            NSDictionary *dict =[visitReasonArray objectAtIndex:i];
            [idArray addObject:[self checkForNumberOrString:[dict valueForKey:@"id"]]];
            [reasonArray addObject:[dict valueForKey:@"reason"]];
        }
    }
    
    if([reasonArray containsObject:@"Others"])
    {
        [self setFrameToSubmitAndClearButtonWhenOthersVisitReasonClicked];
    }
    else
    {
        [self setFrameToSubmitAndClearButtonWhenRemainingVisitReasonClicked];
    }
}

-(void)loadSuccuessApptViewController
{
    SuccessApptViewController *parentAppointmentFormVC = [[SuccessApptViewController alloc] initWithNibName:@"SuccessApptViewController" bundle:nil];
    
    [self.navigationController pushViewController:parentAppointmentFormVC animated:YES];
    
    //  [self clearButtonClicked:nil];
}

#pragma mark - Keyboard Methods
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
    
    if (!CGRectContainsPoint(aRect, guardianTextField.frame.origin) )
    {
        float tHeight=0.0;
      
        tHeight=kbSize.height;

        CGPoint scrollPoint = CGPointMake(0.0, guardianTextField.frame.origin.y-tHeight);
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

-(void)assignLabelValues
{
    //    {
    //        "application_number" = "15-16-0006";
    //        "batch_id" = 1;
    //        "father_name" = VIGHNESH;
    //        id = 1;
    //        "mobile_no1" = 9962492850;
    //        "mobile_no2" = 9500015360;
    //        "mobile_no3" = "";
    //        standard = "L K G";
    //        "student_email" = "akshadha.vighnesh@babajividhyashram.org";
    //        "student_id" = 150001;
    //        "student_name" = AKSHADHA;
    //    }
    
    studentNameLabel.text=[childDetailsDict objectForKey:@"student_name"];
    parentNameLabel.text=[childDetailsDict objectForKey:@"father_name"];
    studentClassLabel.text=[childDetailsDict objectForKey:@"standard"];
    studentIDLabel.text=[self checkForNumberOrString:[childDetailsDict objectForKey:@"student_id"]];
    studentEmailLabel.text=[childDetailsDict objectForKey:@"student_email"];
}

-(NSString *)checkForNumberOrString:(id) movieObjectString
{
    if([movieObjectString isKindOfClass:[NSNumber class]])
    {
        movieObjectString=[movieObjectString stringValue];
    }
    
    return movieObjectString;
    
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

-(void)resignKeyboard
{
    [commentsTextView resignFirstResponder];
    [guardianTextField resignFirstResponder];
    
    formScrollView.contentOffset=CGPointMake(0, 0);
}

-(void)clearAllTextFieldsData
{
    guardianTextField.text=@"";
    commentsTextView.text=@"";
}

#pragma mark UIButton Actions
-(IBAction)clearButtonClicked:(id)sender
{
    [self resignKeyboard];
    
    // clearing textfield and textview
    [self clearAllTextFieldsData];
    
    //clearing radio button...
    [radioButtonsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        UIButton *btn=obj;
        [btn setImage:[UIImage imageNamed:@"radio_unselected.png"] forState:UIControlStateNormal];
        [btn setTitleColor:appLightGrayColor forState:UIControlStateNormal];
        [btn setSelected:NO];
        chooseRelationString=@"";
        guardianView.hidden=YES;
        
    }];

    // clearing check box buttons...
    [checkButtonsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         UIButton *lButton=obj;
         
         [visitReasonDict setObject:@"0" forKey:[NSString stringWithFormat:@"%ld",(long)idx]];
         NSDictionary *dict =[visitReasonArray objectAtIndex:lButton.tag];
         if([[dict valueForKey:@"reason"] isEqualToString:@"Others"])
         {
             commentsTextView.text=@"";
             commentsTextView.hidden=YES;
             commentsLabel.hidden=YES;
         }
         
         [self getUnselectedColorUIButtonTitleWithButton:lButton];
     }];

     [self setFrameToSubmitAndClearButtonWhenRemainingVisitReasonClicked];
}

-(IBAction)homeButtonClicked:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)submitButtonClicked:(id)sender
{
    [self resignKeyboard];
    
    if(chooseRelationString.length==0)
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please choose your relationship" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    else if([chooseRelationString isEqualToString:@"Others"])
    {
        if(guardianTextField.text.length==0)
        {
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please enter your name" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            alertView.tag=19;
          
            objc_setAssociatedObject(alertView, &visitConstantKey, guardianTextField, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

            [alertView show];
            return;
        }
        else if(guardianTextField.text.length<3)
        {
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please enter your name with minimum 3 letters" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            alertView.tag=19;
            
            objc_setAssociatedObject(alertView, &visitConstantKey, guardianTextField, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            
            [alertView show];
            return;
        }
    }
    
    NSMutableArray *idArray=[[NSMutableArray alloc]init];
    NSMutableArray *reasonArray=[[NSMutableArray alloc]init];
    
    for(int i=0;i<visitReasonDict.count;i++)
    {
        NSString *string =[visitReasonDict valueForKey:[NSString stringWithFormat:@"%d",i]];
        if([string isEqualToString:@"1"])
        {
            NSDictionary *dict =[visitReasonArray objectAtIndex:i];
            [idArray addObject:[self checkForNumberOrString:[dict valueForKey:@"id"]]];
            [reasonArray addObject:[dict valueForKey:@"reason"]];
        }
    }
    
    if(idArray.count==0)
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please select reason for visit" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
        __block NSString *finalIdString=@"";
        [idArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
        {
            if([finalIdString isEqualToString:@""])
            {
                finalIdString=obj;
            }
            else
            {
                finalIdString=[NSString stringWithFormat:@"%@,%@",finalIdString,obj];
            }
        }];
        
        __block BOOL isValidationCompleted=NO;
        [reasonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
              NSString *reasonString=obj;
             
             if([reasonString isEqualToString:@"Others"])
             {
                 if(commentsTextView.text.length==0)
                 {
                     UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please enter comments" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     alertView.tag=19;
                     [alertView show];
                     isValidationCompleted=NO;
                     
                     objc_setAssociatedObject(alertView, &visitConstantKey, commentsTextView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                     
                     return;
                 }
                 else if(commentsTextView.text.length<6)
                 {
                     UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please enter comments with minimum 6 letters" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     alertView.tag=19;
                     [alertView show];
                     isValidationCompleted=NO;
                     
                     objc_setAssociatedObject(alertView, &visitConstantKey, commentsTextView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                     
                     return;
                 }
                 else // submit form here... for 'others' visit reason also
                 {
                     isValidationCompleted=YES;
                 }
             }
             else  // submit form here...for all visit reasons except 'Others'
             {
                 isValidationCompleted=YES;
             }
         }];
        
        if(isValidationCompleted==YES)
        {
            [myappDelegate startSpinner];
            [self submitAppointmentFormDataToServerWithVisitReason:finalIdString];
        }
    }
}

-(IBAction)onRadioButtonValueChanged:(id)sender
{
    [self resignKeyboard];
    
    UIButton *btn=(UIButton *)sender;
    
    if([btn.titleLabel.text isEqualToString:@"Others"])
    {
       guardianView.hidden=NO;
    }
    else
    {
        guardianView.hidden=YES;
        guardianTextField.text=@"";
    }
    chooseRelationString=[chooseRelationArray objectAtIndex:btn.tag];
}

-(IBAction)checkBoxButtonClicked:(id)sender
{
    [self resignKeyboard];
    
    UIButton *globalButton=(UIButton *)sender;
    
    if([[visitReasonDict valueForKey:[NSString stringWithFormat:@"%ld",(long)globalButton.tag]] isEqualToString:@"1"]) // unselect
    {
        [visitReasonDict setObject:@"0" forKey:[NSString stringWithFormat:@"%ld",(long)globalButton.tag]];
     //   [globalButton setBackgroundImage:[UIImage imageNamed:@"check_unselected.png"] forState:UIControlStateNormal];
        
        NSDictionary *dict =[visitReasonArray objectAtIndex:globalButton.tag];
        if([[dict valueForKey:@"reason"] isEqualToString:@"Others"])
        {
            commentsTextView.text=@"";
            commentsTextView.hidden=YES;
            commentsLabel.hidden=YES;
        }
        
        [self getUnselectedColorUIButtonTitleWithButton:globalButton];
    }
    else //select
    {
        [visitReasonDict setObject:@"1" forKey:[NSString stringWithFormat:@"%ld",(long)globalButton.tag]];
      //  [globalButton setBackgroundImage:[UIImage imageNamed:@"check_selected.png"] forState:UIControlStateNormal];
        
        NSDictionary *dict =[visitReasonArray objectAtIndex:globalButton.tag];
        if([[dict valueForKey:@"reason"] isEqualToString:@"Others"])
        {
            commentsTextView.hidden=NO;
            commentsLabel.hidden=NO;
        }
        
        [self getSelectedColorUIButtonTitleWithButton:globalButton];
    }
    
    [self checkForOthersVisitReason];
}

#pragma mark - UITextField Attributes
-(UITextField *)getTextFieldAttributes:(UITextField *)cTextField
{
    cTextField.layer.cornerRadius=5.0;
    cTextField.layer.borderColor=appBlackColor.CGColor;
    [cTextField setBorderStyle:UITextBorderStyleNone];
    cTextField.font=CustomRegular(17);
    cTextField.textColor=appBlackColor;
    cTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    
    CGRect tfFrame=cTextField.frame;
    tfFrame.size.height=30;
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

#pragma mark - UITextView Attributes
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

#pragma mark - Api Call
-(void)getReasonForVisitList
{
    NSMutableDictionary * postvalues = [[NSMutableDictionary alloc]init];
    [apiCall callApisWithParameters:postvalues postmethod:@"GET" withUrl:@"appointment/reason" AndRequestType:@"appointment/reason"];
}

-(void)submitAppointmentFormDataToServerWithVisitReason:(NSString *)visitReason
{
    NSMutableDictionary * postvalues = [[NSMutableDictionary alloc]init];

    /*
     {
     "StudentId" : "150001",
     "VisitingPerson" : "Father"
     “GuardianName” : “Mahesh”
    "VisitReason" : "academic, transport (senign corresponding id’s only)
    "Comments" : "purpose description",
     }
     */
    
    [postvalues setValue:[self checkForNumberOrString:[childDetailsDict objectForKey:@"student_id"]] forKey:@"StudentId"];
    [postvalues setValue:chooseRelationString forKey:@"VisitingPerson"];
    
    if([chooseRelationString isEqualToString:@"Others"])
    {
        [postvalues setValue:guardianTextField.text forKey:@"GuardianName"];
    }
    else
    {
        [postvalues setValue:@"" forKey:@"GuardianName"];
    }
    
    [postvalues setValue:visitReason forKey:@"VisitReason"];
    [postvalues setValue:commentsTextView.text forKey:@"Comments"];

    [apiCall callApisWithParameters:postvalues postmethod:@"POST" withUrl:@"appointment/create" AndRequestType:@"appointment/create"];
}

#pragma mark - API Delegates
-(void)successWithResponse :(id)response andRequestType :(NSString *)requestType
{
    if ([requestType isEqualToString:@"appointment/reason"])
    {
        visitReasonArray = [NSMutableArray arrayWithArray:[response objectForKey:@"Reason"]];
        [self sortArrayWithName:visitReasonArray];
        
        [self createScrollViewForReasonForVisit];
    }
    else if ([requestType isEqualToString:@"appointment/create"])
    {
      //  NSLog(@"response/successWithResponse is %@",response);
        NSDictionary *resultDict=(NSDictionary *)response;
        if([[resultDict objectForKey:@"Status"] isEqualToString:@"SUCCESS"])
        {
            [self loadSuccuessApptViewController];
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
        [self showAlertMessage:@"Alert!" WithMessage:[error description] Delegate:nil CancelButtonTitle:@"Ok" OtherButtonTitle:nil AndTag:0];
    }
}

-(void)sortArrayWithName:(NSMutableArray *)filteredArray
{
    NSSortDescriptor *sortDescriptor1;//, *sortDescriptor2;
    sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
    //   sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"timeOnly" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor1];
    //  NSArray *sortDescriptors=[NSArray arrayWithObjects:sortDescriptor1,sortDescriptor2, nil];
    [filteredArray sortUsingDescriptors:sortDescriptors];
}

#pragma mark - Alert Message
-(void)showAlertMessage:(NSString *)titleString WithMessage:(NSString *)messageString Delegate:(id)delegate CancelButtonTitle:(NSString *)cancelTitle OtherButtonTitle:(NSString *)otherTitle AndTag:(int)tag
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:titleString message:messageString delegate:delegate cancelButtonTitle:cancelTitle otherButtonTitles:otherTitle, nil];
    alertView.tag=tag;
    [alertView show];
}

#pragma mark - UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==19) // required fields validation alert
    {
        UITextField *bTextField = objc_getAssociatedObject(alertView, &visitConstantKey);
        [bTextField becomeFirstResponder];
    }
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
    
    return YES;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    guardianTextField.text=textField.text;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *invalidCharSet;
    
    invalidCharSet  = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz. "] invertedSet];

    NSString *filteredString = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
    
    if (range.location == 0 && [string isEqualToString:@" "])
    {
        return NO;
    }
    
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextView Delegates
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
 //   currentTextView=textView;
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
    commentsTextView.text=textView.text;
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    UITextPosition* pos = textView.endOfDocument;
    CGRect currentRect = [textView caretRectForPosition:pos];
    
    if (currentRect.origin.y > previousRect.origin.y)
    {
        //new line reached, write your code
        NSLog(@"new line reached.");
    }
    previousRect = currentRect;

}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSCharacterSet *invalidCharSet;
    
    invalidCharSet  = [[NSCharacterSet characterSetWithCharactersInString:@" ,'/-.0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"] invertedSet];
    
    if (range.location == 0 && [text isEqualToString:@" "])
    {
        return NO;
    }
    
    NSString *filtered = [[text componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
    
    if([text isEqualToString:@"\n"])
    {
        return YES;
    }
    
    return [text isEqualToString:filtered];
    
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
            [temscrlv setContentOffset:CGPointMake(0, scrollfrm.origin.y-40) animated:YES];
        }
    }
}

@end
