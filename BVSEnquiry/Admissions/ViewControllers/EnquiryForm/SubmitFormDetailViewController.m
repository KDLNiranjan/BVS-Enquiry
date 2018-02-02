//
//  SubmitFormDetailViewController.m
//  BVSEnquiry
//
//  Created by Kutung iMac 01 on 28/09/15.
//  Copyright (c) 2015 Kutung iMac 01. All rights reserved.
//

#import "SubmitFormDetailViewController.h"
#import <CoreText/CoreText.h>

@interface SubmitFormDetailViewController ()
{
    NSTimer *_timer;
    CFTimeInterval _ticks;
    
    double currMinute;
    double currSeconds;

}
@end

@implementation SubmitFormDetailViewController

@synthesize enquiryNumberString;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   // startNewButton.layer.sublayerTransform = CATransform3DMakeTranslation(10.0f, 0.0f, 0.0f);
    
    startNewButtonView.layer.cornerRadius=18.0f;
    startNewButtonView.layer.borderColor=[UIColor colorWithRed:165.0f/255.0f green:23.0f/255.0f blue:35.0f/255.0f alpha:1.0].CGColor;
    startNewButtonView.layer.borderWidth=2.0f;
    
    currMinute=1;
    currSeconds=0;
    
    [self createHeaderViewForNavigationBar];
    
    [self getAttributedStringForThankYouMessage];
  
    [self getAttributedStringForCounterLabel];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startTimer];
}
-(void)getAttributedStringForThankYouMessage
{
    NSMutableAttributedString *mutableString = nil;
    NSString *detailLabelTextString = [NSString stringWithFormat:@"Your Reference Enquiry number is %@.",self.enquiryNumberString];
    mutableString = [[NSMutableAttributedString alloc] initWithString:detailLabelTextString];
    
    NSRegularExpression *regExpression = [NSRegularExpression regularExpressionWithPattern:self.enquiryNumberString options:0 error:nil];
    
    //  enumerate matches
    NSRange range = NSMakeRange(0,[detailLabelTextString length]);
    [regExpression enumerateMatchesInString:detailLabelTextString options:0 range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop)
    {
        NSRange enquiryNumberRange = [result rangeAtIndex:0];
        [mutableString addAttribute:NSForegroundColorAttributeName value:appButtonColor range:enquiryNumberRange];
        [detailLabel setAttributedText:mutableString];
    }];
}

-(void)getAttributedStringForCounterLabel
{
    counterNumberLabel.text = [NSString stringWithFormat:@"Please proceed to Counter Number 2."];
    
    NSRange range1 = [counterNumberLabel.text rangeOfString:@"Please proceed to"];
    NSRange range2 = [counterNumberLabel.text rangeOfString:@"Counter Number 2."];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:counterNumberLabel.text];
    
    //  [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:boldTextFontSize]} range:range1];
    [attributedText setAttributes:@{NSFontAttributeName:CustomRegular(18)}
                            range:range1];
    [attributedText setAttributes:@{NSFontAttributeName:CustomSemiBold(22)}
                            range:range2];
    
    counterNumberLabel.attributedText = attributedText;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)createHeaderViewForNavigationBar
{
    int headerHeight;
    int leftButtonWidth;
    int leftButtonHeight;
    int leftButtonYaxis;
    int fontSize;
    
    fontSize=30;
    headerHeight=70;
    leftButtonWidth=40;
    leftButtonHeight=40;
    leftButtonYaxis=headerHeight/2-20;
    
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, screensize.size.width, headerHeight)];
    
    headerView.backgroundColor=appWhiteColor;
    
    // image view...
    UIImageView *logoImgView=[[UIImageView alloc]initWithFrame:CGRectMake(30, 5, 160, 50)];
    logoImgView.image=[UIImage imageNamed:@"nav_logo.png"];
    logoImgView.tintColor=appGrayColor;
    [headerView addSubview:logoImgView];
    
    [self.view addSubview:headerView];
    
    
    UILabel *lblSubTitle=[[UILabel alloc]initWithFrame:CGRectMake(logoImgView.frame.origin.x+30,logoImgView.frame.size.height, logoImgView.frame.size.width,20)];
    lblSubTitle.font=[UIFont fontWithName:@"Arial" size:8];
    lblSubTitle.textColor=[UIColor blackColor];
    lblSubTitle.text=@"Affiliated to CBSE (No.1930692)";
    [headerView addSubview:lblSubTitle];

    return headerView;
}

#pragma mark - Get Size Based on Text

-(CGSize)getSizebasedOnText :(NSString *)text FontName :(UIFont *)font AndWidth : (int)width
{
    CGSize constraintSize1 = CGSizeMake(width, 1000.f);
    
    return [text sizeWithFont:font
            constrainedToSize:constraintSize1
                lineBreakMode:NSLineBreakByWordWrapping];
}

- (IBAction)startNewButtonClicked:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - NSTimer Methods Stop Watch
- (void)startTimer
{
    if (_timer == nil)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(timerFired)
                                                userInfo:nil
                                                 repeats:YES];
    }
}

- (void)stopTimer
{
    [_timer invalidate];
    _timer = nil;
}


-(void)timerFired
{
    if((currMinute>0 || currSeconds>=0) && currMinute>=0)
    {
        if(currSeconds==0)
        {
            currMinute-=1;
            currSeconds=59;
        }
        else if(currSeconds>0)
        {
            currSeconds-=1;
        }
        if(currMinute>-1)
            redirectLabel.text = [NSString stringWithFormat:@"You will be redirected to new form in %02.0f seconds", currSeconds];
    }
    else
    {
        [_timer invalidate];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
@end
