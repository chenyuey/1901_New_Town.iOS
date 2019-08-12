//
//  HouseManageViewController.m
//  NewTown
//
//  Created by macbookpro on 2019/8/7.
//  Copyright © 2019 macbookpro. All rights reserved.
//

#import "HouseManageViewController.h"

@interface HouseManageViewController ()

@end

@implementation HouseManageViewController
#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden=YES;
    WKWebViewConfiguration *config = [self createConfig];
    
    mWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, SafeStatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - SafeStatusBarHeight - SafeAreaBottomHeight) configuration:config];
    // UI代理
    mWebView.UIDelegate = self;
    // 导航代理
    mWebView.navigationDelegate = self;
    // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
    mWebView.allowsBackForwardNavigationGestures = YES;
    //可返回的页面列表, 存储已打开过的网页
    WKBackForwardList * backForwardList = [mWebView backForwardList];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://m.house.xnngs.cn/"]];
    
    NSString *strSessionToken = [self readFromPlist];
    strSessionToken = [strSessionToken stringByReplacingOccurrencesOfString:@":" withString:@"&"];
    NSString *strUrl = [NSString stringWithFormat:@"http://192.168.124.237:9001?session_token=%@",strSessionToken];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    [mWebView loadRequest:request];
    [self.view addSubview:mWebView];
    
}
- (WKWebViewConfiguration*)createConfig{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    // 创建设置对象
    WKPreferences *preference = [[WKPreferences alloc]init];
    //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
    preference.minimumFontSize = 0;
    //设置是否支持javaScript 默认是支持的
    preference.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
    preference.javaScriptCanOpenWindowsAutomatically = YES;
    config.preferences = preference;
    
    // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
    config.allowsInlineMediaPlayback = YES;
    //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
    config.mediaTypesRequiringUserActionForPlayback = YES;
    //设置是否允许画中画技术 在特定设备上有效
    config.allowsPictureInPictureMediaPlayback = YES;
    //设置请求的User-Agent信息中应用程序名称 iOS9后可用
    config.applicationNameForUserAgent = @"ChinaDailyForiPad";
    // 我们可以在WKScriptMessageHandler代理中接收到
    
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    
    [userContentController addScriptMessageHandler:self name:@"iosModel"];
    [userContentController addScriptMessageHandler:self name:@"Camera"];
    config.userContentController = userContentController;
    
    return config;
}

/**
 从plist读取数据
 
 @return 读出数据
 */
- (NSString *)readFromPlist{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject;
    NSLog(@"读取数据地址%@",path);
    NSString *fileName = [path stringByAppendingPathComponent:@"token.plist"];
    //反序列化，把plist文件数据读取出来，转为数组
    NSDictionary *result = [NSDictionary dictionaryWithContentsOfFile:fileName];
    if (result == nil) {
        return @"";
    }
    NSLog(@"%@", result);
    return [result objectForKey:@"token"];
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    //    Decides whether to allow or cancel a navigation after its response is known.
    
    NSLog(@"知道返回内容之后，是否允许加载，允许加载");
    if ([webView.URL.absoluteString isEqualToString:@"https://m.baidu.com/"]) {
        decisionHandler(WKNavigationResponsePolicyCancel);
        [self dismissViewControllerAnimated:YES completion:^{

        }];
//        [self.navigationController popViewControllerAnimated:YES];

    }else{
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden=YES;
    //禁用屏幕左滑返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.tabBarController.tabBar.hidden=NO;
    //开启
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    if (self.presentedViewController)
    {
        [super dismissViewControllerAnimated:flag completion:completion];
    }
}

@end
