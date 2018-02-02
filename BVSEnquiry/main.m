//
//  main.m
//  BVSEnquiry
//
//  Created by Kutung iMac 01 on 30/09/15.
//  Copyright (c) 2015 Kutung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[])
{
    @autoreleasepool
    {
         NSLog(@"%d    %s",argc,argv[0]);
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
