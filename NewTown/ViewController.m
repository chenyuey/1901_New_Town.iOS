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
//    YZWebView *webView = [[YZWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    [self.view addSubview:webView];
//    NSURL *url = [NSURL URLWithString:@"https://h5.youzan.com/v2/showcase/homepage?alias=lUWblj8NNI"];
//    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//    [webView loadRequest:urlRequest];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 50)];
    btn.backgroundColor = [UIColor redColor];
    btn.titleLabel.text = @"跳转";
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(jump:) forControlEvents:UIControlEventTouchUpInside];
    
    
}
- (void)jump:(id)sender{
    WebViewController *vc = [[WebViewController alloc]init];
    vc.loginTime = 0;
    //目前支持有赞的店铺主页链接、商品详情链接、商品列表链接、订单列表、会员中心等
    vc.loadUrl = @"https://j.youzan.com/_Xu9n9";
    [self.navigationController pushViewController:vc animated:YES];
}


@end
