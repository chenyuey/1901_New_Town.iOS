//
//  WebViewController.m
//  YouzaniOSDemo
//
//  Created by 陈月 on 19/03/05.
//  Copyright © 2016年 Youzan. All rights reserved.
//

#import "WebViewController.h"
#import "LoginViewController.h"
#import <YZBaseSDK/YZBaseSDK.h>
#import "YZDUICService.h"
#import "CommonHeader.h"

@interface WebViewController () <YZWebViewDelegate, YZWebViewNoticeDelegate>
@property (strong, nonatomic) YZWebView *webView;
//@property (strong, nonatomic) UIBarButtonItem *closeBarButtonItem; /**< 关闭按钮 */
@end

@implementation WebViewController
- (id)initWithURLString:(NSString *)strURL{
    self = [super init];
    if (self) {
        self.loadUrl = strURL;
    }
    return self;
}
- (UILabel *)createLabelWithFrame:(CGRect)frame :(CGFloat)fontSize :(NSString *)fontName :(UIColor *)fontColor :(NSTextAlignment)alignment{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.font = [UIFont fontWithName:fontName size:fontSize];
    label.textColor = fontColor;
    label.textAlignment = alignment;
    return label;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES; // 隐藏navigationbar
    self.view.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0];
    
    //修改导航栏样式
    self.navTitleLabel = [self createLabelWithFrame:CGRectMake(100, SafeStatusBarHeight, SCREEN_WIDTH - 200, 44) :20 :@"Arial-BoldM" :[UIColor blackColor] :NSTextAlignmentCenter];
    [self.view addSubview:self.navTitleLabel];
    
    
    self.webView = [[YZWebView alloc]initWithFrame:CGRectMake(0, SafeStatusBarHeight+44, SCREEN_WIDTH, SCREEN_HEIGHT - SafeStatusBarHeight-44)];
    [self.view addSubview:self.webView];
    self.webView.delegate = self;
    self.webView.noticeDelegate = self;
    [self initBarButtonItem];
    self.navigationItem.rightBarButtonItem.enabled = NO;//默认分享按钮不可用
    
    // 加载链接
    [self loginAndloadUrl:self.loadUrl];
}

- (BOOL)navigationShouldPopOnBackButton {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        self.navigationItem.leftItemsSupplementBackButton = YES;
//        self.navigationItem.leftBarButtonItem = self.closeBarButtonItem;
        return NO;
    } else {
        return YES;
    }
}

- (void)dealloc {
    //Demo中 退出当前controller就清除用户登录信息
    [YZSDK.shared logout];
    _webView.delegate = nil;
    _webView.noticeDelegate = nil;
    _webView = nil;
}

#pragma mark - YZWebViewDelegate

- (void)webView:(YZWebView *)webView didReceiveNotice:(YZNotice *)notice
{
    NSLog(@"类型：%lu",(unsigned long)notice.type);
    switch (notice.type) {
        case YZNoticeTypeLogin: // 收到登陆请求
        {
            [self showLoginViewControllerIfNeeded];
            break;
        }
        case YZNoticeTypeShare: // 收到分享的回调数据
        {
            [self alertShareData:notice.response];
            break;
        }
        case YZNoticeTypeReady: // Web页面已准备好
        {
            // 此时可以分享，但注意此事件并不作为是否可分享的标志事件
            self.navigationItem.rightBarButtonItem.enabled = YES;
            break;
        }
        case YZNoticeTypeAddToCart: // 加入购物车的时候调用
        {
            NSLog(@"购物车 --- %@", notice.response);
            break;
        }
        case YZNoticeTypeBuyNow:    // 立即购买
        {
            NSLog(@"立即购买 -- %@", notice.response);
            break;
        }
        case YZNoticeTypeAddUp:     // 购物车结算时调用
        {
            NSLog(@"购物车结算 --- %@", notice.response);
            break;
        }
        case YZNoticeTypePaymentFinished:   // 支付成功回调结果页
        {
            NSLog(@"支付成功回调结果页 --- %@", notice.response);
            break;
        }
        default:
            break;
    }
}

- (BOOL)webView:(YZWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //加载新链接时，分享按钮先置为不可用
    self.navigationItem.rightBarButtonItem.enabled = NO;
    // 不做任何筛选
    return YES;
}
- (void)webViewDidFinishLoad:(id<YZWebView>)webView{
    [webView evaluateJavaScript:@"document.title"
              completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
//                  self.navigationItem.title = response;
                  NSLog(@"TITLELLL: %@",response);
                  self.navTitleLabel.text = response;
//                  self.title = response;
              }];
}

#pragma mark - Action

- (void)showLoginViewControllerIfNeeded
{
    if (self.loginTime == kLoginTimeNever) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self presentNativeLoginViewWithBlock:^(BOOL success){
        if (success) {
            [weakSelf.webView reload];
        } else {
            if ([weakSelf.webView canGoBack]) {
                [weakSelf.webView goBack];
            }
        };
    }];
}

- (void)shareButtonAction {
    [self.webView share];
}
- (void)reloadButtonAction {
    [self.webView reload];
}

- (void)closeItemBarButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private

- (void)initBarButtonItem {
    //初始化关闭按钮
//    self.closeBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeItemBarButtonAction)];
//    UIBarButtonItem *reloadBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(reloadButtonAction)];
    //初始化分享按钮
//    UIBarButtonItem *shareButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonAction)];
//    self.navigationItem.rightBarButtonItems = @[shareButtonItem,reloadBarButtonItem];
}

/**
 *  加载链接。
 *
 *  @remark 这里强制先登录再加载链接，你的工程里由你控制。
 *  @param urlString 链接
 */
- (void)loginAndloadUrl:(NSString*)urlString {
    if (self.loginTime != kLoginTimePrior) {
        [self loadWithString:urlString];
        return;
    }
    
    /**
     登录方法(在你使用时，应该换成自己服务器给的接口来获取access_token，cookie)
     */
    [YZDUICService loginWithOpenUid:[UserModel sharedManage].userId completionBlock:^(NSDictionary *resultInfo) {
        if (resultInfo) {
            //用户登录成功
            [YZSDK.shared synchronizeAccessToken:resultInfo[@"data"][@"access_token"]
                                       cookieKey:resultInfo[@"data"][@"cookie_key"]
                                     cookieValue:resultInfo[@"data"][@"cookie_value"]];
            [self loadWithString:urlString];
        }
    }];
}

- (void)loadWithString:(NSString *)urlStr {
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    if ([NSThread isMainThread]) {
        [self.webView loadRequest:urlRequest];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.webView loadRequest:urlRequest];
        });
    }
}

/**
 唤起原生登录界面
 
 @param block 登录事件回调
 */
- (void)presentNativeLoginViewWithBlock:(LoginResultBlock)block {
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navigation = [board instantiateViewControllerWithIdentifier:@"login"];
    LoginViewController *loginVC = [navigation.viewControllers objectAtIndex:0];
    loginVC.loginBlock = block; //买家登录结果
    [self presentViewController:navigation animated:YES completion:nil];
}

/**
 *  显示分享数据
 *
 *  @param data
 */
- (void)alertShareData:(id)data {
    NSDictionary *shareDic = (NSDictionary *)data;
    NSString *message = [NSString stringWithFormat:@"%@\r%@" , shareDic[@"title"],shareDic[@"link"]];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"数据已经复制到黏贴版" message:message delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alertView show];
    //复制到粘贴板
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = message;
}

@end

