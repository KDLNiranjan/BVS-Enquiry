//
//  ApiCall.h
//  SchoolApp
//
//  Created by Kutung iMac 01 on 13/08/15.
//  Copyright (c) 2015 Kutung iMac 01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@protocol ApiCallDelegate

-(void)successWithResponse :(id)response andRequestType :(NSString *)requestType;
-(void)failedWithError :(NSString *)error;

@end

@interface ApiCall : NSObject
{
    id <ApiCallDelegate>delegate;
}

@property (nonatomic, strong) id <ApiCallDelegate>delegate;
-(void)callApisWithParameters :(id )postParameter postmethod:(NSString *)postMethod withUrl:(NSString *)url AndRequestType :(NSString *)requestType;

@end
