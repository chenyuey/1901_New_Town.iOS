//
//  AppDelegate.h
//  NewTown
//
//  Created by macbookpro on 2019/3/4.
//  Copyright © 2019年 macbookpro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <YZBaseSDK/YZBaseSDK.h>
#import "YZDUICService.h"
#import <Parse/Parse.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,YZSDKDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

