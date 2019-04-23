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
#pragma mark - UI控件创建
- (CustomLabel *)createLabelWithFrame:(CGRect)frame :(CGFloat)fontSize :(NSString *)fontName :(UIColor *)fontColor :(NSTextAlignment)alignment{
    CustomLabel *label = [[CustomLabel alloc]initWithFrame:frame];
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
//    self.passwordTextField.secureTextEntry = YES;
    [loginView addSubview:self.passwordTextField];
    UIView *passwordDownLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 40+16+39, frame.size.width, 1)];
    passwordDownLineView.backgroundColor = lineColor;
    [loginView addSubview:passwordDownLineView];
    
    _getValidCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width - 72, 10, 72, 20)];
    [_getValidCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getValidCodeBtn setTitleColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_getValidCodeBtn addTarget:self action:@selector(getValidCodePressd:) forControlEvents:UIControlEventTouchUpInside];
    [_getValidCodeBtn setFont:[UIFont systemFontOfSize:14]];
    [loginView addSubview:_getValidCodeBtn];
    
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 40+16+39+19, frame.size.width - 20, 50)];
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
    
    closeButton = [self createButtonWithImage:CGRectMake(10, SafeStatusBarHeight+10, 20, 20) :@"back_btn" :@selector(close:)];
    [self.view addSubview:closeButton];
    
    [self createLoginViewWithFrame:CGRectMake(17, SafeStatusBarHeight + 44 + 96, SCREEN_WIDTH - 17 - 15, 180) :splitLineColor];
    [self.view setUserInteractionEnabled:YES];
    
    if (currentType == 0) {
        closeButton.hidden = YES;
    }else{
        closeButton.hidden = NO;
    }
    
    errLabel = [self createErrorToastViewWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, SafeStatusBarHeight + 44 + 96 + 180, 150, 60)];
}
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
}

- (void)viewDidAppear:(BOOL)animated{
//    WebViewController *parent = (WebViewController *)self.parentViewController;
//   if ([PFUser currentUser]){
//       [self willMoveToParentViewController:nil];
//       [self.view removeFromSuperview];
//       [self removeFromParentViewController];
//       [self callBlockWithResult:YES];
//    }
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

- (void)close:(id)sender {
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
        [PFCloud callFunctionInBackground:@"login" withParameters:dicLoginInfo block:^(id  _Nullable resultInfo, NSError * _Nullable err) {
            if (resultInfo) {
                [PFUser becomeInBackground:resultInfo[@"sessionToken"] block:^(PFUser * _Nullable user, NSError * _Nullable error) {
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
                    self->errLabel.text = [error.userInfo objectForKey:@"error"];
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
    CustomLabel *subscribeSuccessView = [self createLabelWithFrame:frame :14 :@"Arial" :[UIColor whiteColor] :NSTextAlignmentCenter];
    subscribeSuccessView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
    subscribeSuccessView.layer.borderWidth = 1;
    subscribeSuccessView.layer.borderColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8].CGColor;
    subscribeSuccessView.clipsToBounds = YES;
    subscribeSuccessView.layer.cornerRadius = 12;
    subscribeSuccessView.numberOfLines = 0;
    subscribeSuccessView.textInsets = UIEdgeInsetsMake(10, 0, 10, 0);
    
    subscribeSuccessView.hidden = YES;
    [self.view addSubview:subscribeSuccessView];
    return subscribeSuccessView;
}
- (void)hideErrorLabel{
    errLabel.hidden = YES;
}

@end

