//
//  AppDelegate.m
//  NewTown
//
//  Created by macbookpro on 2019/3/4.
//  Copyright © 2019年 macbookpro. All rights reserved.
//

#import "AppDelegate.h"
#import "WebViewController.h"
#import "CollectionViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    YZConfig *config = [[YZConfig alloc] initWithClientId:CLIENT_ID];
    NSString* scheme = [[[NSBundle mainBundle].infoDictionary[@"CFBundleURLTypes"] firstObject][@"CFBundleURLSchemes"] firstObject];
    config.scheme = scheme;
    config.enableLog = NO; // 关闭 sdk 的 log 输出
    [YZSDK.shared initializeSDKWithConfig:config];
    YZSDK.shared.delegate = self; // 必须设置代理方法，保证 SDK 在需要 token 的时候可以正常运行
    WebViewController *indexWebVC = [[WebViewController alloc]initWithURLString:@"https://j.youzan.com/Go44-9"];
    UINavigationController *indexNavigationController = [[UINavigationController alloc]initWithRootViewController:indexWebVC];
    indexNavigationController.tabBarItem.title = @"首页";
    indexNavigationController.tabBarItem.image = [UIImage imageNamed:@"indexBarIcon"];
//    self.window.rootViewController = rootNavigationController;
    WebViewController *newTownWebVC = [[WebViewController alloc]initWithURLString:@"https://h5.youzan.com/v2/feature/XgA5YjWnWO"];
    UINavigationController *newTownNavigationController = [[UINavigationController alloc]initWithRootViewController:newTownWebVC];
    newTownNavigationController.tabBarItem.title =@"全部民宿";
    newTownNavigationController.tabBarItem.image = [UIImage imageNamed:@"hotelBarIcon"];
    
    CollectionViewController *collectWebVC = [[CollectionViewController alloc]init];
    UINavigationController *collectNavigationController = [[UINavigationController alloc]initWithRootViewController:collectWebVC];
    collectNavigationController.tabBarItem.title =@"收藏";
    collectNavigationController.tabBarItem.image = [UIImage imageNamed:@"collection_default"];
    
    WebViewController *userCenterWebVC = [[WebViewController alloc]initWithURLString:@"https://h5.youzan.com/v2/showcase/usercenter?alias=3hgmk8rs"];
    UINavigationController *userCenterNavigationController = [[UINavigationController alloc]initWithRootViewController:userCenterWebVC];
    userCenterNavigationController.tabBarItem.title =@"个人中心";
    userCenterNavigationController.tabBarItem.image = [UIImage imageNamed:@"userCenterBarIcon"];
    
    
    
    NSArray *items = [NSArray arrayWithObjects:indexNavigationController,newTownNavigationController,collectNavigationController,userCenterNavigationController, nil];
    UITabBarController *tabBarC = [[UITabBarController alloc]init];
    [tabBarC setViewControllers:items];
    tabBarC.tabBar.backgroundColor = [UIColor whiteColor];
    tabBarC.tabBar.tintColor = [UIColor colorWithRed:122.0/255.0 green:187.0/255.0 blue:121.0/255.0 alpha:1];
    self.window.rootViewController = tabBarC;
    
    //创建Parse服务链接
    ParseClientConfiguration *parseConfig = [ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.server = @"http://47.95.200.31:1340/api/1";
//        configuration.server = @"http://10.135.8.93:1340/api/1";
        configuration.applicationId = @"myAppId";
        configuration.clientKey = @"myMasterKey";
    }];
    [Parse initializeWithConfiguration:parseConfig];
    //加入微信分享sdk
    [WXApi registerApp:@"wxba64cb9bbbbea771"];
    //加入腾讯分享sdk
    self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:@"101562763" andDelegate:self];
    
    
    return YES;
}
- (void)yzsdk:(YZSDK *)sdk needInitToken:(void (^)(NSString * _Nullable))callback
{
    // 调用有赞云的 init Token 接口并返回 token. 见：https://www.youzanyun.com/docs/guide/3400/3466
    // 最好由你的服务端来调用有赞的接口，客户端通过你的服务端间接调用有赞的接口获取 initToken 以保证安全性。
    [YZDUICService fetchInitTokenWithCompletionBlock:^(NSDictionary *info) {
        callback(info[@"access_token"]);
    }];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"NewTown"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([url.scheme isEqualToString:@"101562763"]) {
        return [QQApiInterface handleOpenURL:url delegate:self];
    }else {
        return YES;
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.scheme isEqualToString:@"tencent101562763"]) {
        return [TencentOAuth HandleOpenURL:url];
    }else{
        return [WXApi handleOpenURL:url delegate:self];
    }
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString *,id> *)options {
    if ([url.scheme isEqualToString:@"tencent101562763"]) {
        return [QQApiInterface handleOpenURL:url delegate:self];
    }else {
        return YES;
    }
}

@end
