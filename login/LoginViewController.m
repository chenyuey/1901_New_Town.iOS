//
//  LoginViewController.m
//  YouzaniOSDemo
//
//  Created by 可乐 on 16/10/13.
//  Copyright © 2016年 Youzan. All rights reserved.
//

#import "LoginViewController.h"
#import <YZBaseSDK/YZBaseSDK.h>
#import "YZDUICService.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
#pragma mark - UI控件创建
- (UILabel *)createLabelWithFrame:(CGRect)frame :(CGFloat)fontSize :(NSString *)fontName :(UIColor *)fontColor :(NSTextAlignment)alignment{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.font = [UIFont fontWithName:fontName size:fontSize];
    label.textColor = fontColor;
    label.textAlignment = alignment;
    return label;
}
- (UIButton *)createButtonWithImage:(CGRect)frame :(NSString *)imageName :(SEL)pressEvent{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    UIImage *image = [UIImage imageNamed:imageName];
    [image setAccessibilityIdentifier:@"uncollect"];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:pressEvent forControlEvents:UIControlEventTouchUpInside];
    return button;
}
#pragma mark - 系统声明周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录界面";
    
    //导航栏
    self.navigationController.navigationBar.hidden = YES; // 隐藏navigationbar
    self.view.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0];
    //修改导航栏样式
    self.navTitleLabel = [self createLabelWithFrame:CGRectMake(0, SafeStatusBarHeight, SCREEN_WIDTH, 44) :20 :@"Arial-BoldM" :[UIColor blackColor] :NSTextAlignmentCenter];
    self.navTitleLabel.text = @"我的收藏";
    [self.view addSubview:self.navTitleLabel];
    
    UIButton *closeButton = [self createButtonWithImage:CGRectMake(20, SafeStatusBarHeight+10, 20, 20) :@"closePageIcon" :@selector(close:)];
    [self.view addSubview:closeButton];
    
    UIButton *loginButton = [self createButtonWithImage:CGRectMake(100, 200, 55.5, 24) :@"loginIcon" :@selector(login:)];
    [self.view addSubview:loginButton];
    
}

#pragma mark - Private Method

- (void)callBlockWithResult:(BOOL)success {
    if (self.loginBlock) {
        self.loginBlock(success);
    }
}

#pragma mark - Action

- (void)close:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不登录不能打开商品详情" delegate:self cancelButtonTitle:@"不登录" otherButtonTitles:@"登录",nil];
    [alertView show];
}

- (void)login:(id)sender {
    /**
     登录方法(在你使用时，应该换成自己服务器给的接口来获取access_token，cookie)
     */
    NSDictionary *dicLoginInfo = @{@"username":@"chenyue",
                                   @"password":@"123456"
                                   };
    [PFCloud callFunctionInBackground:@"login" withParameters:dicLoginInfo block:^(id  _Nullable resultInfo, NSError * _Nullable error) {
        if (resultInfo) {
            [YZSDK.shared synchronizeAccessToken:resultInfo[@"yz_user"][@"data"][@"access_token"]
                                       cookieKey:resultInfo[@"yz_user"][@"data"][@"cookie_key"]
                                     cookieValue:resultInfo[@"yz_user"][@"data"][@"cookie_value"]];
            [self dismissViewControllerAnimated:YES completion:^{
                [self callBlockWithResult:YES];
            }];
        }
    }];
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self dismissViewControllerAnimated:YES completion:^{
        if (buttonIndex == 0) {
            [self callBlockWithResult:NO];
            return;
        }
        //
        [self login:nil];
    }];
}

@end

