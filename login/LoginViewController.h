//
//  LoginViewController.h
//  YouzaniOSDemo
//
//  Created by 可乐 on 16/10/13.
//  Copyright © 2016年 Youzan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
#import "CommonHeader.h"
#import <Parse/Parse.h>
#import "WebViewController.h"
#import "UIImage+LXExtension.h"

typedef void (^LoginResultBlock)(BOOL success);

@interface LoginViewController : UIViewController{
    NSTimer *timer;
    UIButton *closeButton;
    int currentType;
    UILabel *errLabel;
}

@property (copy, nonatomic) LoginResultBlock loginBlock;
//页面标题
@property (nonatomic,strong) UILabel *navTitleLabel;
@property (nonatomic,strong) UIButton *getValidCodeBtn;

@property (nonatomic, strong)UITextField *phoneNumberTextField;
@property (nonatomic, strong)UITextField *passwordTextField;
- (id)initWithTag:(int)type;
@end

