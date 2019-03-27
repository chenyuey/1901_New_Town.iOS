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
- (void)createLoginViewWithFrame:(CGRect)frame :(UIColor *)lineColor{
    UIView *loginView = [[UIView alloc]initWithFrame:frame];
    [self.view addSubview:loginView];
    self.phoneNumberTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, frame.size.width - 72, 39)];
    [loginView addSubview:self.phoneNumberTextField];
    [self.phoneNumberTextField setPlaceholder:@"请输入手机号"];
    UIView *phoneNumberDownLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, frame.size.width, 1)];
    phoneNumberDownLineView.backgroundColor = lineColor;
    [loginView addSubview:phoneNumberDownLineView];
    self.passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 40+16, frame.size.width, 39)];
    [self.passwordTextField setPlaceholder:@"请输入验证码"];
    self.passwordTextField.secureTextEntry = YES;
    [loginView addSubview:self.passwordTextField];
    UIView *passwordDownLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 40+16+39, frame.size.width, 1)];
    passwordDownLineView.backgroundColor = lineColor;
    [loginView addSubview:passwordDownLineView];
    
    UIButton *getValidCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width - 72, 0, 72, 20)];
    [getValidCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getValidCodeBtn setTitleColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [getValidCodeBtn addTarget:self action:@selector(getValidCodePressd:) forControlEvents:UIControlEventTouchUpInside];
    [getValidCodeBtn setFont:[UIFont systemFontOfSize:14]];
    [loginView addSubview:getValidCodeBtn];
    
//    UILabel *loginBtn = [[UILabel alloc]initWithFrame:CGRectMake(0, 40+16+39+19, frame.size.width, 50)];
//    loginBtn.backgroundColor = [UIColor colorWithRed:99.0/255.0 green:190.0/255.0 blue:114.0/255.0 alpha:1.0];
//    loginBtn.text = @"登录";
//    loginBtn.textColor = [UIColor whiteColor] ;
//    loginBtn.layer.cornerRadius = 5;
//    loginBtn.textAlignment = NSTextAlignmentCenter;
//    UITapGestureRecognizer *tapLogin = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(login:)];
//    [loginBtn setUserInteractionEnabled:YES];
//    [loginBtn addGestureRecognizer:tapLogin];
//    [loginView addSubview:loginBtn];
//
//    [loginView setUserInteractionEnabled:YES];
//    [loginView bringSubviewToFront:loginBtn];
    
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 40+16+39+19, frame.size.width, 50)];
    loginBtn.backgroundColor = [UIColor colorWithRed:99.0/255.0 green:190.0/255.0 blue:114.0/255.0 alpha:1.0];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.layer.cornerRadius = 5;
    [loginView addSubview:loginBtn];
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
    self.navTitleLabel.text = @"登录";
    [self.view addSubview:self.navTitleLabel];
    UIColor *splitLineColor = [UIColor colorWithRed:213.0/255.0 green:214.0/255.0 blue:224.0/255.0 alpha:1.0];
    UIView *spitLineView = [[UIView alloc]initWithFrame:CGRectMake(0, SafeStatusBarHeight + 44, SCREEN_WIDTH, 1)];
    spitLineView.backgroundColor = splitLineColor;
    [self.view addSubview:spitLineView];
    
    UIButton *closeButton = [self createButtonWithImage:CGRectMake(20, SafeStatusBarHeight+10, 20, 20) :@"back_btn" :@selector(close:)];
    [self.view addSubview:closeButton];
    
    [self createLoginViewWithFrame:CGRectMake(17, SafeStatusBarHeight + 44 + 96, SCREEN_WIDTH - 17 - 15, 130) :splitLineColor];
    [self.view setUserInteractionEnabled:YES];
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
    if (self.phoneNumberTextField.text != nil && self.phoneNumberTextField.text.length > 0 && self.passwordTextField.text != nil && self.passwordTextField.text.length > 0) {
        NSDictionary *dicLoginInfo = @{@"mobile":self.phoneNumberTextField.text,
                                       @"smsCode":self.passwordTextField.text
                                       };//chenyue 123456
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
    
}
- (void)getValidCodePressd:(id)sender{
    NSLog(@"请求验证码");
    if (self.phoneNumberTextField.text != nil && self.phoneNumberTextField.text.length > 0) {
        NSDictionary *dicLoginInfo = @{@"mobile":self.phoneNumberTextField.text};
        [PFCloud callFunctionInBackground:@"requireSmsCode" withParameters:dicLoginInfo block:^(id  _Nullable resultInfo, NSError * _Nullable error) {
            if (error == nil) {
                NSLog(@"验证码获取成功");
            }
        }];
    }
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self dismissViewControllerAnimated:YES completion:^{
        if (buttonIndex == 0) {
            [self callBlockWithResult:NO];
            return;
        }
        //
//        [self login:nil];
    }];
}

@end

