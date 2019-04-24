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

#import <WXApi.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>

#import "LYWNewfeatureViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,YZSDKDelegate,WXApiDelegate,TencentSessionDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property(nonatomic,strong) TencentOAuth *tencentOAuth;
@property(nonatomic,strong)UITabBarController *tabBarC;

- (void)saveContext;


@end

