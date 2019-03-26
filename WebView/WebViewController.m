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
#import "MapInfoViewController.h"

@interface WebViewController () <YZWebViewDelegate, YZWebViewNoticeDelegate>
@property (strong, nonatomic) YZWebView *webView;
//@property (strong, nonatomic) UIBarButtonItem *closeBarButtonItem; /**< 关闭按钮 */
@end

@implementation WebViewController
- (id)initWithURLString:(NSString *)strURL{
    self = [super init];
    if (self) {
        self.loadUrl = strURL;
        self.loginTime = 2;
    }
    return self;
}
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
#pragma mark - 页面事件
- (BOOL)navigationShouldPopOnBackButton {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        return NO;
    } else if (self.navigationController.childViewControllers.count > 1){
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    else{
        return YES;
    }
}
//收藏按钮点击事件
- (void)addItemToMyCollections:(id)sender{
    UIImage *currentImage = [self.collectButton imageForState:UIControlStateNormal];
//    if ([currentImage.accessibilityIdentifier isEqualToString:@"uncollect"]) {//收藏
        [self.webView share];
        
//    }else{//取消收藏
//
//    }
}
- (void)enterMapInfo:(id)sender{
    MapInfoViewController *mapInfoVC = [[MapInfoViewController alloc]initWithTitle:self.navTitleLabel.text];
//    mapInfoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mapInfoVC animated:YES];
}
#pragma mark - 视图加载
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES; // 隐藏navigationbar
    self.view.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0];
    
    //修改导航栏样式
    self.navTitleLabel = [self createLabelWithFrame:CGRectMake(50, SafeStatusBarHeight, SCREEN_WIDTH - 100, 44) :20 :@"Arial-BoldM" :[UIColor blackColor] :NSTextAlignmentCenter];
    [self.view addSubview:self.navTitleLabel];
    self.backButton = [self createButtonWithImage:CGRectMake(20, SafeStatusBarHeight+10, 24, 24) :@"back_btn" :@selector(navigationShouldPopOnBackButton)];
    self.backButton.hidden = YES;
    [self.view addSubview:self.backButton];
    //创建收藏按钮
    self.collectButton = [self createButtonWithImage:CGRectMake(SCREEN_WIDTH - 24 - 20, SafeStatusBarHeight+10, 24, 24) :@"collection_default" :@selector(addItemToMyCollections:)];
    self.collectButton.hidden = YES;
    [self.view addSubview:self.collectButton];
    //创建地图按钮
    self.mapButton = [self createButtonWithImage:CGRectMake(SCREEN_WIDTH - 24 - 20, SafeStatusBarHeight+10, 24, 24) :@"mapIcon" :@selector(enterMapInfo:)];
    self.mapButton.hidden = YES;
    [self.view addSubview:self.mapButton];
    
    
    self.webView = [[YZWebView alloc]initWithFrame:CGRectMake(0, SafeStatusBarHeight+44, SCREEN_WIDTH, SCREEN_HEIGHT - SafeStatusBarHeight-44 - 44 - SafeAreaBottomHeight)];
    [self.view addSubview:self.webView];
    self.webView.delegate = self;
    self.webView.noticeDelegate = self;
    self.navigationItem.rightBarButtonItem.enabled = NO;//默认分享按钮不可用
    
    // 加载链接
    [self loginAndloadUrl:self.loadUrl];
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
    NSString *strPathURL = request.URL.path;
    if ([strPathURL containsString:@"feature"]) {
        //显示收藏
        self.collectButton.hidden = NO;
        UIImage *imageTmp = [UIImage imageNamed:@"collection_default"];
        [imageTmp setAccessibilityIdentifier:@"uncollect"];
        [self.collectButton setImage:imageTmp forState:UIControlStateNormal];
    }
    else{
        //隐藏收藏
        self.collectButton.hidden = YES;
    }
    if ([request.URL.path isEqualToString:@"/v2/showcase/category"]) {
        //显示地图按钮
        self.mapButton.hidden = NO;
    }else{
        self.mapButton.hidden = YES;
    }
    return YES;
}
- (void)webViewDidFinishLoad:(id<YZWebView>)webView{
    [webView evaluateJavaScript:@"document.title"
              completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
                  NSLog(@"TITLELLL: %@",response);
                  self.navTitleLabel.text = response;
                  NSLog(@"=============%d",self.navigationController.childViewControllers.count);
                  //加载新链接时，分享按钮先置为不可用
                  if ([self.webView canGoBack] || self.navigationController.childViewControllers.count>1) {
                      self.backButton.hidden = NO;
                      self.tabBarController.tabBar.hidden=YES;
                      self.webView.frame = CGRectMake(0, SafeStatusBarHeight+44, SCREEN_WIDTH, SCREEN_HEIGHT - SafeStatusBarHeight-44 - SafeAreaBottomHeight);
                  }else{
                      self.backButton.hidden = YES;
                      self.tabBarController.tabBar.hidden=NO;
                      self.webView.frame = CGRectMake(0, SafeStatusBarHeight+44, SCREEN_WIDTH, SCREEN_HEIGHT - SafeStatusBarHeight-44 - 44 - SafeAreaBottomHeight);
                  }
                  //全部民宿不添加 收藏按钮 功能
                  if ([response isEqualToString:@"全部民宿"]) {
                      self.collectButton.hidden = YES;
                  }
                  if ([response isEqualToString:@"全部小镇"]) {
                      //不显示地图
                      self.mapButton.hidden = YES;
                  }
                  [self showCollectionButtonStatus:response];
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
- (NSString *)formatTitleWithString :(NSString *)strTitle{
    if ([strTitle containsString:@"🏠"]) {
        strTitle = [strTitle stringByReplacingOccurrencesOfString:@"🏠" withString:@""];
    }
    return strTitle;
}

#pragma mark - Private

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
//    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    loginVC.loginBlock = block; //买家登录结果
    [self presentViewController:loginVC animated:YES completion:nil];
}

/**
 *  显示分享数据
 *
 *  @param data
 */
- (void)alertShareData:(id)data {
    NSDictionary *shareDic = (NSDictionary *)data;
    NSString *title = [shareDic objectForKey:@"title"];
    NSNumber *type = [NSNumber numberWithInt:1];
    //收藏接口调用的数据
    if ([title containsString:@"🏠"]){
        type = [NSNumber numberWithInt:0];
    }
    PFQuery *collectQuery = [PFQuery queryWithClassName:@"Collection"];
    [collectQuery whereKey:@"name" equalTo:title];
    [collectQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects.count > 0) {
            //取消收藏
            [PFObject deleteAllInBackground:objects block:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    UIImage *imageTmp = [UIImage imageNamed:@"collection_default"];
                    [imageTmp setAccessibilityIdentifier:@"uncollect"];
                    [self.collectButton setImage:imageTmp forState:UIControlStateNormal];
                }
            }];
        }else{
            //添加收藏
            PFObject *collectionObject = [PFObject objectWithClassName:@"Collection"];
            [collectionObject setObject:title forKey:@"name"];
            [collectionObject setObject:[shareDic objectForKey:@"imgUrl"] forKey:@"cover_link"];
            [collectionObject setObject:[shareDic objectForKey:@"link"] forKey:@"link"];
            [collectionObject setObject:[shareDic objectForKey:@"desc"] forKey:@"description"];
            [collectionObject setObject:type forKey:@"type"];
            [collectionObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    UIImage *imageTmp = [UIImage imageNamed:@"collection_high_light"];
                    [imageTmp setAccessibilityIdentifier:@"collected"];
                    [self.collectButton setImage:imageTmp forState:UIControlStateNormal];
                }
            }];
        }
    }];
    
}
- (void)showCollectionButtonStatus:(NSString *)title{
    if (self.collectButton.hidden == NO) {
        PFQuery *collectQuery = [PFQuery queryWithClassName:@"Collection"];
        [collectQuery whereKey:@"name" equalTo:title];
        [collectQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if (objects.count > 0) {
                UIImage *imageTmp = [UIImage imageNamed:@"collection_high_light"];
                [imageTmp setAccessibilityIdentifier:@"collected"];
                [self.collectButton setImage:imageTmp forState:UIControlStateNormal];
            }else{
                UIImage *imageTmp = [UIImage imageNamed:@"collection_default"];
                [imageTmp setAccessibilityIdentifier:@"uncollect"];
                [self.collectButton setImage:imageTmp forState:UIControlStateNormal];
            }
        }];
    }
}

@end

