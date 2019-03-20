//
//  ViewController.m
//  NewTown
//
//  Created by macbookpro on 2019/3/4.
//  Copyright © 2019年 macbookpro. All rights reserved.
//

#import "ViewController.h"
#import <YZBaseSDK/YZBaseSDK.h>
#import "WebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 50)];
    btn.backgroundColor = [UIColor redColor];
    btn.titleLabel.text = @"跳转";
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(jump:) forControlEvents:UIControlEventTouchUpInside];
    
    
}
- (void)jump:(id)sender{
    WebViewController *vc = [[WebViewController alloc]initWithURLString:@"https://j.youzan.com/Go44-9"];
    vc.loginTime = 0;
    //目前支持有赞的店铺主页链接、商品详情链接、商品列表链接、订单列表、会员中心等
    [self.navigationController pushViewController:vc animated:YES];
}


@end
