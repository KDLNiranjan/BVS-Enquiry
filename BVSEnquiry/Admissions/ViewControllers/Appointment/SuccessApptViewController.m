//
//  SuccessApptViewController.m
//  BVSEnquiry
//
//  Created by Kutung PC 35 on 24/06/16.
//  Copyright © 2016 Kutung. All rights reserved.
//

#import "SuccessApptViewController.h"

@interface SuccessApptViewController ()
{
    NSTimer *_timer;
    CFTimeInterval _ticks;
    
    double currMinute;
    double currSeconds;
}
@end

@implementation SuccessApptViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    currMinute=1;
    currSeconds=0;
    
    gotoHomeButtonView.layer.cornerRadius=22.0f;
    gotoHomeButtonView.layer.borderColor=appGrayColor.CGColor;
    gotoHomeButtonView.layer.borderWidth=1.0f;
    
    [self createHeaderViewForNavigationBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startTimer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)createHeaderViewForNavigationBar
{
    int headerHeight;
    int fontSize;
    
    fontSize=30;
    headerHeight=70;
    
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, screensize.size.width, headerHeight)];
    
    headerView.backgroundColor=appWhiteColor;
    
    // image view...
    UIImageView *logoImgView=[[UIImageView alloc]initWithFrame:CGRectMake(30, 0, 160, 50)];
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
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init]; paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGRect rect = [text boundingRectWithSize:constraintSize1
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName: paragraphStyle.copy}
                                     context:nil];
    
    return rect.size;
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
          //  currSeconds=59;
            currSeconds=30;
        }
        else if(currSeconds>0)
        {
            currSeconds-=1;
        }
      //  if(currMinute>-1)
       //     redirectLabel.text = [NSString stringWithFormat:@"You will be redirected to new form in %02.0f seconds", currSeconds];
    }
    else
    {
        [_timer invalidate];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
