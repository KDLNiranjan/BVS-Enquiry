//
//  HomeViewController.m
//  BVSEnquiry
//
//  Created by Kutung PC 35 on 14/06/16.
//  Copyright © 2016 Kutung. All rights reserved.
//

#import "HomeViewController.h"
#import "SubmitFormViewControllerIpad.h"
#import "ParentVisitingFormViewController.h"
#import "StudentIDViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationItem setHidesBackButton:YES];
    
    [self initializeView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initializeView
{
    self.view.backgroundColor=appWhiteColor;
    
    // creating header view navigation bar
    [self createHeaderViewForNavigationBar];
}

-(UIView *)createHeaderViewForNavigationBar
{
    int headerHeight;
    int leftButtonYaxis;
    int fontSize;
    fontSize=30;
    headerHeight=50;
    leftButtonYaxis=headerHeight/2-20;
    
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, screensize.size.width, headerHeight)];
    
    headerView.backgroundColor=appWhiteColor;
    
    // image view...
    UIImageView *logoImgView=[[UIImageView alloc]initWithFrame:CGRectMake(30, 0, 160, 50)];//Height:50
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

-(IBAction)enquiryFormButtonClicked:(id)sender
{
    SubmitFormViewControllerIpad *submitFormVC=[[SubmitFormViewControllerIpad alloc]initWithNibName:@"SubmitFormViewControllerIpad" bundle:nil];
    [self.navigationController pushViewController:submitFormVC animated:YES];
}

-(IBAction)principalAppointmentButtonClicked:(id)sender
{
    StudentIDViewController *studentIDEnterToProceedVC=[[StudentIDViewController alloc]initWithNibName:@"StudentIDViewController" bundle:nil];
    [self.navigationController pushViewController:studentIDEnterToProceedVC animated:YES];
    
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

@end
