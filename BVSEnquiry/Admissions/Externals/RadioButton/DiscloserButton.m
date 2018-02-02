//
//  DiscloserButton.m
//  BVSEnquiry
//
//  Created by Kutung-PC43 on 03/10/16.
//  Copyright © 2016 Kutung. All rights reserved.
//

#import "DiscloserButton.h"

@interface DiscloserButton ()

@end

@implementation DiscloserButton
@synthesize lblTitle;

- (void)viewDidLoad {
    [super viewDidLoad];
    lblTitle.clipsToBounds=YES;
    lblTitle.layer.cornerRadius=8.0f;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
