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
#import "CustomLabel.h"
#import "CustomizeView.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
- (id)initWithTag:(int)type{
    self = [super init];
    if (self) {
        currentType = type;
    }
    return self;
}
- (void)createLoginViewWithFrame:(CGRect)frame :(UIColor *)lineColor{
    UIView *loginView = [[UIView alloc]initWithFrame:frame];
    [self.view addSubview:loginView];
    UIView *phoneNumberView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
    phoneNumberView.layer.borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor;
    phoneNumberView.layer.borderWidth = 1;
    phoneNumberView.layer.cornerRadius = 20;
    [loginView addSubview:phoneNumberView];
    
    UIImageView *mobileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 11, 15, 18)];
    mobileImageView.image = [UIImage imageNamed:@"mobile_icon"];
    [phoneNumberView addSubview:mobileImageView];
    
    self.phoneNumberTextField = [[UITextField alloc]initWithFrame:CGRectMake(50, 0, frame.size.width - 50, 39)];
    [phoneNumberView addSubview:self.phoneNumberTextField];
    [self.phoneNumberTextField setPlaceholder:@"请输入手机号"];
    UIView *passwordView = [[UIView alloc]initWithFrame:CGRectMake(0, 45, frame.size.width, 40)];
    passwordView.layer.borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor;
    passwordView.layer.borderWidth = 1;
    passwordView.layer.cornerRadius = 20;
    passwordView.clipsToBounds = YES;
    [loginView addSubview:passwordView];
    self.passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(50, 0, frame.size.width-50-80, 39)];
    [self.passwordTextField setPlaceholder:@"请输入验证码"];
    self.passwordTextField.secureTextEntry = YES;
    [passwordView addSubview:self.passwordTextField];
    UIImageView *passwordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 11, 15, 18)];
    passwordImageView.image = [UIImage imageNamed:@"password_icon"];
    [passwordView addSubview:passwordImageView];
    
    _getValidCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width - 80, 0, 80, 40)];
    [_getValidCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _getValidCodeBtn.backgroundColor = THEMECOLOR;
    [_getValidCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_getValidCodeBtn addTarget:self action:@selector(getValidCodePressd:) forControlEvents:UIControlEventTouchUpInside];
    [_getValidCodeBtn setFont:[UIFont systemFontOfSize:14]];
    [passwordView addSubview:_getValidCodeBtn];
    
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, passwordView.frame.origin.y+passwordView.frame.size.height+55 ,frame.size.width, 40)];
    loginBtn.backgroundColor = THEMECOLOR;
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.layer.cornerRadius = 20;
    [loginView addSubview:loginBtn];
    
    UILabel *tintLabel = [CustomizeView createLabelWithFrame:CGRectMake(0, loginBtn.frame.origin.y+loginBtn.frame.size.height + 10, loginView.frame.size.width, 40) :16 :@"Arial" :[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0] :NSTextAlignmentCenter];
    tintLabel.text = @"新用户登录将直接创建账号";
    [loginView addSubview:tintLabel];
    
    closeButton = [CustomizeView createButtonWithImage:CGRectMake((loginView.frame.size.width-29)/2, tintLabel.frame.origin.y+tintLabel.frame.size.height+42, 29, 29) :@"close_login_icon" :self :@selector(closeLoginView)];
    [loginView addSubview:closeButton];
    if (currentType == 0) {
        closeButton.hidden = YES;
    }else{
        closeButton.hidden = NO;
    }
}
#pragma mark - 系统声明周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录界面";
    
    //导航栏
    self.navigationController.navigationBar.hidden = YES; // 隐藏navigationbar
    self.view.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0];
    UIColor *splitLineColor = [UIColor colorWithRed:213.0/255.0 green:214.0/255.0 blue:224.0/255.0 alpha:1.0];
    UIImageView *logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-80)/2, SafeStatusBarHeight + 44 + 20 , 80, 80)];
    logoImageView.image = [UIImage imageNamed:@"logo192"];
    logoImageView.layer.cornerRadius = 18;
    logoImageView.layer.masksToBounds = YES;
    [self.view addSubview:logoImageView];
    
    
    UIImage *loginBGImage = [UIImage imageNamed:@"loginTopBGImage"];
    UIImage *scaleLoginBGImage = [UIImage scaleImage:loginBGImage toScale:SCREEN_WIDTH/375.0];
    UIImageView *loginBGImageView= [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, scaleLoginBGImage.size.width, scaleLoginBGImage.size.height)];
    loginBGImageView.image = scaleLoginBGImage;
    [self.view addSubview:loginBGImageView];
    
    [self createLoginViewWithFrame:CGRectMake(30, scaleLoginBGImage.size.height+45, SCREEN_WIDTH - 60, SCREEN_HEIGHT - (scaleLoginBGImage.size.height+45)) :splitLineColor];
    [self.view setUserInteractionEnabled:YES];
    
    errLabel = [self createErrorToastViewWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, SafeStatusBarHeight + 44 + 96 + 180, 150, 60)];
}
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
}

-(void)viewWillAppear:(BOOL)animated{
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self setStatusBarBackgroundColor:THEMECOLOR];
}
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

#pragma mark - Private Method

- (void)callBlockWithResult:(BOOL)success {
    if (self.loginBlock) {
        self.loginBlock(success);
        if (timer != nil) {
            [timer invalidate];
            timer = nil;
        }
    }
}

#pragma mark - Action

- (void)closeLoginView {
    [self dismissViewControllerAnimated:YES completion:^{
        [self callBlockWithResult:NO];
        if (self->timer != nil) {
            [self->timer invalidate];
            self->timer = nil;
        }
    }];
}

- (void)login:(id)sender {
    /**
     登录方法(在你使用时，应该换成自己服务器给的接口来获取access_token，cookie)
     */
    if (self.phoneNumberTextField.text != nil && self.phoneNumberTextField.text.length > 0 && self.passwordTextField.text != nil && self.passwordTextField.text.length > 0) {
        NSDictionary *dicLoginInfo = @{@"mobile":self.phoneNumberTextField.text,
                                       @"smsCode":self.passwordTextField.text
                                       };//chenyue 123456
        [self loginInWithParseServerWithLoginInfo:dicLoginInfo];
    }
}
- (void)loginInWithParseServerWithLoginInfo:(NSDictionary *)dicLoginInfo{
    [PFCloud callFunctionInBackground:@"login" withParameters:dicLoginInfo block:^(id  _Nullable resultInfo, NSError * _Nullable err) {
        if (resultInfo) {
            NSString *strSessionToken = resultInfo[@"sessionToken"];
            NSDictionary *dicSessionToken = @{@"token":strSessionToken};
            [self writeToPlist:dicSessionToken];
            [self loginWithSessionToken:strSessionToken];
            if (resultInfo[@"yz_user"][@"data"] != [NSNull null]) {
                [YZSDK.shared synchronizeAccessToken:resultInfo[@"yz_user"][@"data"][@"access_token"]
                                           cookieKey:resultInfo[@"yz_user"][@"data"][@"cookie_key"]
                                         cookieValue:resultInfo[@"yz_user"][@"data"][@"cookie_value"]];
            }
            
        }else{
            if (err.code == 141) {
                self->errLabel.text = @"验证码错误/超时";
                self->errLabel.hidden = NO;
                [self performSelector:@selector(hideErrorLabel) withObject:nil afterDelay:2.0];
            }
        }
    }];
}
- (void)loginWithSessionToken:(NSString *)strSessionToken{
    [PFUser becomeInBackground:strSessionToken block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        if (!error) {
            if (self->currentType == 0) {
                [self willMoveToParentViewController:nil];
                [self.view removeFromSuperview];
                [self removeFromParentViewController];
                [self callBlockWithResult:YES];
            }else{
                [self dismissViewControllerAnimated:YES completion:^{
                    [self callBlockWithResult:YES];
                }];
            }
        }
    }];
}
- (void)getValidCodePressd:(id)sender{
    if (self.phoneNumberTextField.text != nil && self.phoneNumberTextField.text.length > 0) {
        NSDictionary *dicLoginInfo = @{@"mobile":self.phoneNumberTextField.text};
        [PFCloud callFunctionInBackground:@"requireSmsCode" withParameters:dicLoginInfo block:^(id  _Nullable resultInfo, NSError * _Nullable error) {
            if (error == nil) {
                NSLog(@"验证码获取成功");
                //添加倒计时功能
                int waitFor = [[resultInfo objectForKey:@"waitFor"]intValue];
                [self.getValidCodeBtn setTitle:[NSString stringWithFormat:@"倒计时%dS",waitFor/1000] forState:UIControlStateNormal];
                self->timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeCountDownTime) userInfo:nil repeats:YES];
            }else{
                if (error.userInfo != nil) {
                    if ([[error.userInfo objectForKey:@"error"] isKindOfClass:[NSString class]]) {
                        self->errLabel.text = [error.userInfo objectForKey:@"error"];
                    }else if([[[error.userInfo objectForKey:@"error"] allKeys]containsObject:@"waitFor"]){
                        self->errLabel.text = @"验证码请求过于频繁，请2分钟后重试";
                    }
                    self->errLabel.hidden = NO;
                    [self performSelector:@selector(hideErrorLabel) withObject:nil afterDelay:2.0];
                }
            }
        }];
    }
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self dismissViewControllerAnimated:YES completion:^{
        if (buttonIndex == 0) {
            [self callBlockWithResult:NO];
            if (self->timer != nil) {
                [self->timer invalidate];
                self->timer = nil;
            }
            return;
        }
        //
        [self login:nil];
    }];
}
- (void)changeCountDownTime{
    int waitFor = [[self.getValidCodeBtn.titleLabel.text stringByReplacingOccurrencesOfString:@"倒计时" withString:@""]intValue];
    if (waitFor > 0) {
        waitFor --;
        [self.getValidCodeBtn setTitle:[NSString stringWithFormat:@"倒计时%dS",waitFor] forState:UIControlStateNormal];
    }else{
        if (timer != nil) {
            [timer invalidate];
            timer = nil;
        }
        [self.getValidCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    
}

#pragma mark - 创建登录失败弹框
-(UILabel *)createErrorToastViewWithFrame:(CGRect)frame{
    CustomLabel *subscribeSuccessView = [CustomizeView createLabelWithFrame:frame :14 :@"Arial" :[UIColor whiteColor] :NSTextAlignmentCenter];
    subscribeSuccessView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
    subscribeSuccessView.layer.borderWidth = 1;
    subscribeSuccessView.layer.borderColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8].CGColor;
    subscribeSuccessView.clipsToBounds = YES;
    subscribeSuccessView.layer.cornerRadius = 12;
    subscribeSuccessView.numberOfLines = 0;
//    subscribeSuccessView.textInsets = UIEdgeInsetsMake(10, 0, 10, 0);
    
    subscribeSuccessView.hidden = YES;
    [self.view addSubview:subscribeSuccessView];
    return subscribeSuccessView;
}
- (void)hideErrorLabel{
    errLabel.hidden = YES;
}

/**
 写入数据到plist
 */
- (void)writeToPlist:(NSDictionary *)dicInfo{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject;
    NSLog(@"写入数据地址%@",path);
    NSString *fileName = [path stringByAppendingPathComponent:@"token.plist"];
    //序列化，把数组存入plist文件
    [dicInfo writeToFile:fileName atomically:YES];
    NSLog(@"写入成功");
}

@end

