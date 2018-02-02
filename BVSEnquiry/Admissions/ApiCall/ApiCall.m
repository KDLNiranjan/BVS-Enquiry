//
//  ApiCall.m
//  SchoolApp
//
//  Created by Kutung iMac 01 on 13/08/15.
//  Copyright (c) 2015 Kutung iMac 01. All rights reserved.
//

#import "ApiCall.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "AppDelegate.h"

@implementation ApiCall

@synthesize delegate;


-(void)callApisWithParameters :(id )postParameter postmethod:(NSString *)postMethod withUrl:(NSString *)url AndRequestType :(NSString *)requestType
{
    
    NSURL *myurl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",mainUrl,url]];
    
    NSDictionary *parameters = (NSDictionary *)postParameter;

    // API_KEY :  bvsamsws
    // Content-Type: application/json
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [serializer setValue:@"bvsamsws" forHTTPHeaderField:@"API-KEY"];
    // [serializer setValue:self.misfitAccessToken forHTTPHeaderField:@"access_token" ];
    manager.requestSerializer = serializer;
    NSLog(@"myurl is %@",myurl);
    NSLog(@"parameters is %@",parameters);
    
    if([postMethod isEqualToString:@"POST"])
    {
        [manager POST:[NSString stringWithFormat:@"%@",myurl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
             NSLog(@"JSON: %@", responseObject);
             NSDictionary *responseDic = (NSDictionary *)responseObject;
             if (responseDic.allKeys.count >0){
                 [delegate successWithResponse:responseDic andRequestType:requestType];
             }else{
                 [delegate failedWithError:@""];
             }
         }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"Error: %@", error);
// UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Could not connect to server check you r internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
// [alert show];
// [delegate failedWithError:@"Could not connect to server.check your internet connection"];
             [delegate failedWithError:[error localizedDescription]];

         }];
    }
    
    else
    {
        [manager GET:[NSString stringWithFormat:@"%@",myurl] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
            NSLog(@"JSON: %@", responseObject);
            NSDictionary *responseDic = (NSDictionary *)responseObject;
            if (responseDic.allKeys.count >0){
                [delegate successWithResponse:responseDic andRequestType:requestType];
            }else
            {
                [delegate failedWithError:@""];
            }

        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
            NSLog(@"Error: %@", error);
            [delegate failedWithError:[NSString stringWithFormat:@"%@",[[error userInfo]objectForKey:@"NSLocalizedDescription"]]];
            
        }];
    }
}


@end
