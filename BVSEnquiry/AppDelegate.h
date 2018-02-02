//
//  AppDelegate.h
//  BVSEnquiry
//
//  Created by Kutung iMac 01 on 14/09/15.
//  Copyright (c) 2015 Kutung iMac 01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSMutableArray *allStudentsArray;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


-(void)startSpinner;
-(void)stopSpinner;

@end

