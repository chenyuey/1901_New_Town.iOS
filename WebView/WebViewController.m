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
#define BASE_URL @"http://yzyj.1000q1000z.com/landlord/api/1/"


@interface WebViewController () <YZWebViewDelegate, YZWebViewNoticeDelegate>
@property (strong, nonatomic) YZWebView *webView;
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
- (CustomLabel *)createLabelWithFrameCustom:(CGRect)frame :(CGFloat)fontSize :(NSString *)fontName :(UIColor *)fontColor :(NSTextAlignment)alignment{
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
-(UIButton *)createButtonWithFrame:(CGRect)frame :(NSString *)title :(SEL)event{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:event forControlEvents:UIControlEventTouchUpInside];
    //添加文字颜色
    [button setFont:[UIFont systemFontOfSize:14.0f]];
    return button;
}
- (UIButton *)createButtonWithTitleAndImage:(NSString *)title :(CGRect)frame :(int)edgeInsetLeft :(SEL)btnPress{
    UIButton *peopleNumberButton = [[UIButton alloc]initWithFrame:frame];
    [peopleNumberButton setTitle:title forState:UIControlStateNormal];
    [peopleNumberButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [peopleNumberButton setImage:[UIImage imageNamed:@"switchIcon"] forState:UIControlStateNormal];
    peopleNumberButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [peopleNumberButton.titleLabel sizeToFit];
    peopleNumberButton.titleEdgeInsets = UIEdgeInsetsMake(0, edgeInsetLeft, 0, 0);
    peopleNumberButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [peopleNumberButton addTarget:self action:btnPress forControlEvents:UIControlEventTouchUpInside];
    return peopleNumberButton;
}
#pragma mark - 页面事件
- (BOOL)navigationShouldPopOnBackButton {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        mShowHotelDetailView.superview.hidden = YES;
        return NO;
    } else if (self.navigationController.childViewControllers.count > 1){
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    else{
        self.tabBarController.tabBar.hidden=NO;
        return YES;
    }
}
- (void)switchToHouseManager{
    HouseManageViewController *houseManageVC = [[HouseManageViewController alloc]init];
    [self presentViewController:houseManageVC animated:YES completion:nil];
//    TestViewController *a = [[TestViewController alloc]init];
//    [self presentViewController:a animated:YES completion:nil];
//    [self.navigationController pushViewController:houseManageVC animated:YES];
}
//收藏按钮点击事件
- (void)addItemToMyCollections:(id)sender{
    isCollecting = YES;
    if ([PFUser currentUser]) {
        [self.webView share];
    }else{
        [self showLoginViewControllerIfNeeded];
    }
}
- (void)shareToYourFriend:(id)sender{
    isCollecting = NO;
    [self.webView share];
}
- (void)enterMapInfo:(id)sender{
    MapInfoViewController *mapInfoVC = [[MapInfoViewController alloc]initWithTitle:self.navTitleLabel.text];
    [self.navigationController pushViewController:mapInfoVC animated:YES];
}
#pragma mark - 视图加载
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES; // 隐藏navigationbar
    self.view.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0];
    
    //修改导航栏样式
    self.navTitleLabel = [self createLabelWithFrame:CGRectMake(50, SafeStatusBarHeight, SCREEN_WIDTH - 100, 44) :20 :@"Arial-BoldM" :[UIColor blackColor] :NSTextAlignmentCenter];
    self.infoImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2+45, 12, 20, 20)];
    self.infoImageView.image = [UIImage imageNamed:@"info_icon"];
    self.infoImageView.hidden = YES;
    [self.navTitleLabel addSubview:self.infoImageView];
    
    [self.view addSubview:self.navTitleLabel];
    self.backButton = [self createButtonWithImage:CGRectMake(10, SafeStatusBarHeight+10, 24, 24) :@"back_btn" :@selector(navigationShouldPopOnBackButton)];
    self.backButton.hidden = YES;
    [self.view addSubview:self.backButton];
    
    self.switchButton = [self createButtonWithTitleAndImage:@"切换为房东" :CGRectMake(10, SafeStatusBarHeight+10, 100, 20) :4 :@selector(switchToHouseManager)];
    self.switchButton.hidden = YES;
    [self.view addSubview:self.switchButton];
    //创建收藏按钮
    self.collectButton = [self createButtonWithImage:CGRectMake(SCREEN_WIDTH - 8 - 10 - 24 -24, SafeStatusBarHeight+10, 24, 24) :@"collection_default" :@selector(addItemToMyCollections:)];
    self.collectButton.hidden = YES;
    [self.view addSubview:self.collectButton];
    self.shareButton = [self createButtonWithImage:CGRectMake(SCREEN_WIDTH - 24 - 10, SafeStatusBarHeight+8, 24, 24) :@"shareIcon" :@selector(shareToYourFriend:)];
    self.shareButton.hidden = YES;
    [self.view addSubview:self.shareButton];
    //创建地图按钮
    self.mapButton = [self createButtonWithImage:CGRectMake(SCREEN_WIDTH - 24 - 10, SafeStatusBarHeight+10, 24, 24) :@"mapIcon" :@selector(enterMapInfo:)];
    self.mapButton.hidden = YES;
    [self.view addSubview:self.mapButton];
    
    self.webView = [[YZWebView alloc]initWithWebViewType:YZWebViewTypeWKWebView];
    self.webView.frame = CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - SafeAreaTopHeight  - SafeAreaBottomHeight);
    self.webView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.webView];
    self.webView.delegate = self;
    self.webView.noticeDelegate = self;
    [self.webView setNeedsLayout];
    [self.webView layoutIfNeeded];
    self.navigationItem.rightBarButtonItem.enabled = NO;//默认分享按钮不可用
    // 加载链接
    [self loginAndloadUrl:self.loadUrl];
    
    //添加分享弹框
    shareView = [self createShareViewWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 166)];
    
    mArrTitles = [[NSMutableArray alloc]initWithCapacity:0];
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
            self.isLoginYouZan = YES;
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
- (void) addWebKitTransform:(YZWebView *)webView{
    NSString *const INJECT_CSS = @"var head = document.getElementsByTagName('head');var tagStyle=document.createElement(\"style\"); tagStyle.setAttribute(\"type\", \"text/css\");tagStyle.appendChild(document.createTextNode(\"iframe{-webkit-transform:translateZ(0px)}\"));head[0].appendChild(tagStyle);";
    [webView stringByEvaluatingJavaScriptFromString:INJECT_CSS];
    
}
- (BOOL)webView:(YZWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    self.infoImageView.hidden = YES;
    if ([request.URL.absoluteString containsString:@"www.bing.com"]) {
        if (![self.navTitleLabel.text isEqualToString:@"加载中..."]) {
            MapInfoViewController *mapInfoVC = [[MapInfoViewController alloc]initWithTitle:self.navTitleLabel.text andType:YES];
            [self.navigationController pushViewController:mapInfoVC animated:YES];
        }
        return NO;
    }
    if ([request.URL.absoluteString containsString:@"http://hostlocation.com/"]) {
        self->mErrorLabel = [self createErrorToastViewWithFrame:CGRectMake((SCREEN_WIDTH - 200)/2, (SCREEN_HEIGHT - SafeAreaBottomHeight - 40 - SafeAreaTopHeight)/2, 200, 40)];
        self->mErrorLabel.text = @"未找到位置信息";
        self->mErrorLabel.hidden = YES;
        [self.view addSubview:self->mErrorLabel];
        
        PFQuery *query = [PFQuery queryWithClassName:@"HomeMap"];
        [query whereKey:@"name" equalTo:self.navTitleLabel.text];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable results, NSError * _Nullable error) {
            if (results.count > 0) {
                PFObject *homeItemInfo = [results objectAtIndex:0];
                MapNavgationViewController *mapInfoVC = [[MapNavgationViewController alloc]initWithHomeName:self.navTitleLabel.text :homeItemInfo];
                [self.navigationController pushViewController:mapInfoVC animated:YES];
            }else{
                self->mErrorLabel.hidden = NO;
                [self performSelector:@selector(hideErrorLabel) withObject:nil afterDelay:2.0];
            }
        }];
        
        return NO;
    }
    if (loadingShadowView == nil) {
        loadingShadowView = [self createLoadingShadowView];
        [self.view bringSubviewToFront:loadingShadowView];
    }
    NSString *strPathURL = request.URL.path;
    if (navigationType != UIWebViewNavigationTypeBackForward) {
        loadingShadowView.hidden = NO;
        self.navTitleLabel.text = @"加载中...";
    }
    else{
        [mArrTitles removeLastObject];
        self.navTitleLabel.text = [mArrTitles objectAtIndex:(mArrTitles.count - 1)];
        [self updateWebviewFrameAndTabbarHidden];
        [self updateCollectBtnAndShareBtnHidden:strPathURL];
    }
    
    //地图按钮的显示和隐藏
    if ([strPathURL isEqualToString:@"/v2/showcase/category"]) {
        //显示地图按钮
        self.mapButton.hidden = NO;
    }else{
        self.mapButton.hidden = YES;
    }
    
    return YES;
}
- (void)webViewDidFinishLoad:(id<YZWebView>)webView{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"]; 
    loadingShadowView.hidden = YES;
    [self updateWebviewFrameAndTabbarHidden];

    [webView evaluateJavaScript:@"document.title"
              completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
                  if (![self.navTitleLabel.text isEqualToString:response]) {
                      NSString *strPathURL = self.webView.URL.path;
                      [self updateCollectBtnAndShareBtnHidden:strPathURL];
                  }
                  //加载新链接时，分享按钮先置为不可用
                  [self addWebKitTransform:self.webView];
                  self.navTitleLabel.text = response;
                  if ([self.webView.URL.path containsString:@"goods"]) {
                      self.navTitleLabel.text = @"房源详情";
                      self.infoImageView.hidden = NO;
                      self.navTitleLabel.userInteractionEnabled = YES;
                      UITapGestureRecognizer *tapDate = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showHotelInfo)];
                      [self.navTitleLabel addGestureRecognizer:tapDate];
                      [self showHotelInfo];
                  }
                  [self->mArrTitles addObject:response];
                  //全部民宿不添加 收藏按钮 功能
                  if ([response isEqualToString:@"全部民宿"]) {
                      self.collectButton.hidden = YES;
                      self.shareButton.hidden = YES;
                  }
                  [self showCollectionButtonStatus:response];
                  if ([response isEqualToString:@"全部攻略"]) {
                      self.mapButton.hidden = YES;
                  }
                  if ([response isEqualToString:@"首页"] && self.webView.scrollView.mj_header == nil) {
                      self.webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshWebView)];
                  }
                  if (self.webView.scrollView.mj_header != nil) {
                      [self.webView.scrollView.mj_header endRefreshing];
                  }
                  if ([self.webView.URL.path containsString:@"membercenter"]) {
                      self.switchButton.hidden = NO;
                  }else{
                      self.switchButton.hidden = YES;
                  }
                  
              }];
}
- (void)webView:(id<YZWebView>)webView didFailLoadWithError:(NSError *)error{
    
}
- (void)updateWebviewFrameAndTabbarHidden{
    if ([self.webView canGoBack] || self.navigationController.childViewControllers.count>1) {
        self.backButton.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            for (int i = 0; i < self.tabBarController.view.subviews.count; i ++) {
                UIView *tmpView = [self.tabBarController.view.subviews objectAtIndex:i];
                if ([tmpView isKindOfClass:[UITabBar class]]) {
                    CGRect frame = tmpView.frame;
                    frame.origin.y = SCREEN_HEIGHT;
                    tmpView.frame = frame;
                }else{
                    [self.tabBarController.view bringSubviewToFront:tmpView];
                }
            }
        }];
        self.webView.frame = CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - SafeAreaTopHeight - SafeAreaBottomHeight);
        [self.view bringSubviewToFront:self.webView];
    }else{
        self.backButton.hidden = YES;
        self.tabBarController.tabBar.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            for (int i = 0; i < self.tabBarController.view.subviews.count; i ++) {
                UIView *tmpView = [self.tabBarController.view.subviews objectAtIndex:i];
                if ([tmpView isKindOfClass:[UITabBar class]]) {
                    CGRect frame = tmpView.frame;
                    frame.origin.y = SCREEN_HEIGHT - SafeAreaBottomHeight - 49;
                    tmpView.frame = frame;
                    [self.tabBarController.view bringSubviewToFront:tmpView];
                    break;
                }
            }
        }];
        self.webView.frame = CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - SafeAreaTopHeight - SafeAreaBottomHeight - 49);
    }
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}
- (void)updateCollectBtnAndShareBtnHidden:(NSString *)strPathURL{
    //收藏按钮
    if ([strPathURL containsString:@"feature"] && ![strPathURL containsString:@"search"]) {
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
    //分享按钮显示和隐藏
    if (([strPathURL containsString:@"feature"] || [strPathURL containsString:@"goods"]) && ![strPathURL containsString:@"search"]) {
        self.shareButton.hidden = NO;
    }else{
        self.shareButton.hidden = YES;
    }
}
- (void)refreshWebView{
    [self reloadButtonAction];
}

#pragma mark - Action

- (void)showLoginViewControllerIfNeeded
{
    if (self.loginTime == kLoginTimeNever) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    if ([PFUser currentUser]) {
        //自动登录
        [PFCloud callFunctionInBackground:@"YZLogin" withParameters:nil block:^(id  _Nullable resultInfo, NSError * _Nullable error) {
            if (error == nil && [[resultInfo objectForKey:@"msg"] isEqualToString:@"登录成功"]) {
                [YZSDK.shared synchronizeAccessToken:resultInfo[@"data"][@"access_token"]
                                           cookieKey:resultInfo[@"data"][@"cookie_key"]
                                         cookieValue:resultInfo[@"data"][@"cookie_value"]];
                [self.webView reload];
            }
        }];
    }else{
        [self presentNativeLoginViewWithBlock:^(BOOL success){
            if (success) {
                self.isLoginYouZan = YES;
                [weakSelf.webView reload];
            } else {
                if ([weakSelf.webView canGoBack]) {
                    [weakSelf.webView goBack];
                }
            };
        }];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    if (self.navTitleLabel.text != nil && ![self.navTitleLabel.text isEqualToString: @"首页"]) {
        [self reloadButtonAction];//首页不刷 别的页面刷
    }
    self.isLoginYouZan = YES;
    if (self.childViewControllers.count > 0) {
        [self removeLoginViewController];
    }
}
- (void)removeLoginViewController{
    LoginViewController *loginVC = self.childViewControllers[0];
    [loginVC willMoveToParentViewController:nil];
    [loginVC.view removeFromSuperview];
    [loginVC removeFromParentViewController];
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
    if ([[self.webView.URL absoluteString] containsString:@"usercenter"]) {
        if (self.childViewControllers.count == 0) {
            LoginViewController *loginVC = [[LoginViewController alloc]initWithTag:0];
            loginVC.loginBlock = ^(BOOL success){
                if (success) {
                    [self.webView reload];
                }
            };
            loginVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - SafeAreaBottomHeight - 44);
            [self addChildViewController:loginVC];
            [self.view addSubview:loginVC.view];
            [loginVC didMoveToParentViewController:self];
        }
    }else{
        LoginViewController *loginVC = [[LoginViewController alloc]initWithTag:1];
        loginVC.loginBlock = block; //买家登录结果
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

/**
 *  显示分享数据
 *
 *  @param data
 */
- (void)alertShareData:(id)data {
    
    shareInfo = (NSDictionary *)data;
    if (isCollecting == YES) {
        [self collectItemInfoToServer:shareInfo];
    }else{
        //弹框
        [self shareWithFriend];
    }
}
- (void)collectItemInfoToServer:(NSDictionary *)shareDic{
    NSString *title = [shareDic objectForKey:@"title"];
    NSNumber *type = [NSNumber numberWithInt:1];
    //收藏接口调用的数据
    if ([title containsString:@"🏠"]){
        type = [NSNumber numberWithInt:0];
    }
    PFQuery *collectQuery = [PFQuery queryWithClassName:@"Collection"];
    [collectQuery whereKey:@"name" equalTo:title];
    [collectQuery whereKey:@"user" equalTo:[PFUser currentUser]];
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
            [collectionObject setObject:[PFUser currentUser] forKey:@"user"];
            [collectionObject setObject:[shareDic objectForKey:@"imgUrl"] forKey:@"cover_link"];
            [collectionObject setObject:[shareDic objectForKey:@"link"] forKey:@"link"];
            if ([shareDic objectForKey:@"desc"] != nil) {
                [collectionObject setObject:[shareDic objectForKey:@"desc"] forKey:@"description"];
            }
            
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
    if (self.collectButton.hidden == NO && [PFUser currentUser]) {
        PFQuery *collectQuery = [PFQuery queryWithClassName:@"Collection"];
        [collectQuery whereKey:@"name" equalTo:title];
        [collectQuery whereKey:@"user" equalTo:[PFUser currentUser]];
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
#pragma mark - 显示隐藏分享框
- (void)shareWithFriend{
    //显示分享的页面
    self->shareView.superview.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        CGPoint point = self->shareView.center;
        point.y -= 166+SafeAreaBottomHeight;
        self->shareView.center = point;
    }];
}
- (void)cancleShare{
    self->shareView.superview.hidden = YES;
    [UIView animateWithDuration:0.5 animations:^{
        CGPoint point = self->shareView.center;
        point.y += 166+SafeAreaBottomHeight;
        self->shareView.center = point;
    }];
}

- (UIView *)createLoadingShadowView{
    UIView *tmpView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 120)/2, SafeStatusBarHeight + 44 + 120, 120, 120)];
    tmpView.hidden = YES;
    tmpView.backgroundColor = [UIColor whiteColor];
    tmpView.layer.cornerRadius = 16;
    [self.view addSubview:tmpView];
    
    //添加阴影
    tmpView.layer.shadowColor = [UIColor blackColor].CGColor;
    tmpView.layer.shadowOffset = CGSizeMake(0,0);
    tmpView.layer.shadowOpacity = 0.5;
    tmpView.layer.shadowRadius = 5;
    
    
    UIWebView *webViewTmp = [[UIWebView alloc] initWithFrame:CGRectMake((tmpView.frame.size.width - 48)/2,(tmpView.frame.size.height - 48)/2 ,48,48)];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"];
    NSURL *url = [NSURL URLWithString:path];
    [webViewTmp loadRequest:[NSURLRequest requestWithURL:url]];
    [tmpView addSubview:webViewTmp];
    return tmpView;
}
#pragma mark - 分享到好友，朋友圈，qq，新浪
- (UIView *)createShareViewWithFrame:(CGRect)frame{
    UIView *shadowView = [[UIView alloc]initWithFrame:Screen_Bounds];
    shadowView.hidden = YES;
    shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [self.view addSubview:shadowView];
    UIView *shareView = [[UIView alloc]initWithFrame:frame];
    [shadowView addSubview:shareView];
    shareView.backgroundColor = [UIColor whiteColor];
    UILabel *titleTabel = [self createLabelWithFrame:CGRectMake(0, 16, SCREEN_WIDTH, 21) :15 :@"PingFangSC-Regular" :[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] :NSTextAlignmentCenter];
    titleTabel.text = @"分享给好友";
    [shareView addSubview:titleTabel];
    UIButton *wechat = [self createButtonWithImage:CGRectMake(SCREEN_WIDTH/4+(SCREEN_WIDTH/4 - 55)/2, 53, 55, 55) :@"wechatRound" :@selector(shareToWechat:)];
    wechat.tag = 1;
    [shareView addSubview:wechat];
    UIButton *friends = [self createButtonWithImage:CGRectMake((SCREEN_WIDTH/4 - 55)/2, 53, 55, 55) :@"wechatFriends" :@selector(shareToWechat:)];
    friends.tag = 2;
    [shareView addSubview:friends];
    UIButton *qq = [self createButtonWithImage:CGRectMake(SCREEN_WIDTH/2+(SCREEN_WIDTH/4 - 55)/2, 53, 55, 55) :@"qq" :@selector(shareToQQ:)];
    [shareView addSubview:qq];
    UIButton *sina = [self createButtonWithImage:CGRectMake(SCREEN_WIDTH*0.75+(SCREEN_WIDTH/4 - 55)/2, 53, 55, 55) :@"sinaIcon" :@selector(shareToSina:)];
    [shareView addSubview:sina];
    
    UIView *splitLine = [[UIView alloc]initWithFrame:CGRectMake(0, 126, SCREEN_WIDTH, 1)];
    splitLine.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    [shareView addSubview:splitLine];
    UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 122, SCREEN_WIDTH, 44)];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancleShare) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:cancleBtn];
    return shareView;
}
- (SendMessageToWXReq *)shareToWechatWithLink:(NSString *)link :(NSString *)msgTitle :(NSString *)name :(NSString*)imageUrl{
    WXMediaMessage * message = [WXMediaMessage message];
    message.title = msgTitle;
    message.description = name;
    [message setThumbImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]]];
    WXWebpageObject * webPageObject = [WXWebpageObject object];
    webPageObject.webpageUrl = link;
    message.mediaObject = webPageObject;
    SendMessageToWXReq * req1 = [[SendMessageToWXReq alloc]init];
    req1.bText = NO;
    req1.message = message;
    return req1;
}
- (void)shareToWechat:(id)sender{
    NSString *strMsgTitle = @"";
    NSString *imageUrl = [shareInfo objectForKey:@"imgUrl"];
    NSString *title = [shareInfo objectForKey:@"title"];
    NSString *link = [shareInfo objectForKey:@"link"];
    if ([link containsString:@"goods"]) {
        strMsgTitle = @"我发现了一间特色小镇里的民宿，一起去看看吧";
    }else if ([title containsString:@"🏠"]){
        strMsgTitle = @"我发现了一个特色小镇，一起去看看吧";
    }else{
        strMsgTitle = @"我发现了一个特色小镇的玩法体验，一起去看看吧";
    }
    SendMessageToWXReq * req1 = [self shareToWechatWithLink:link :strMsgTitle :title :imageUrl];
    //设置分享到朋友圈(WXSceneTimeline)、好友回话(WXSceneSession)、收藏(WXSceneFavorite)
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 2) {
        req1.scene = WXSceneSession;
    }else{
        req1.scene = WXSceneTimeline;
    }
    [WXApi sendReq:req1];
    [self cancleShare];
}
- (void)shareToQQ:(id)sender{
    NSString *strMsgTitle = @"";
    NSString *imageUrl = [shareInfo objectForKey:@"imgUrl"];
    NSString *title = [shareInfo objectForKey:@"title"];
    NSString *link = [shareInfo objectForKey:@"link"];
    if ([link containsString:@"goods"]) {
        strMsgTitle = @"我发现了一间特色小镇里的民宿，一起去看看吧";
    }else if ([title containsString:@"🏠"]){
        strMsgTitle = @"我发现了一个特色小镇，一起去看看吧";
    }else{
        strMsgTitle = @"我发现了一个特色小镇的玩法体验，一起去看看吧";
    }
    
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:link]
                                title:strMsgTitle
                                description:title
                                previewImageData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    //将内容分享到qq
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self cancleShare];
}
- (void)shareToSina:(id)sender{
    [self cancleShare];
    
    WBMessageObject *wbmsg = [WBMessageObject message];
    
    NSString *strMsgTitle = @"";
    NSString *imageUrl = [shareInfo objectForKey:@"imgUrl"];
    NSString *title = [shareInfo objectForKey:@"title"];
    NSString *link = [shareInfo objectForKey:@"link"];
    if ([link containsString:@"goods"]) {
        strMsgTitle = @"我发现了一间特色小镇里的民宿，一起去看看吧";
    }else if ([title containsString:@"🏠"]){
        strMsgTitle = @"我发现了一个特色小镇，一起去看看吧";
    }else{
        strMsgTitle = @"我发现了一个特色小镇的玩法体验，一起去看看吧";
    }
    
    wbmsg.text = [NSString stringWithFormat:@"%@%@",strMsgTitle,link];
    WBImageObject *wbImg = [[WBImageObject alloc] init];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    
    wbImg.imageData = imageData;
    wbmsg.imageObject = wbImg;
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = link;
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:wbmsg authInfo:authRequest access_token:nil];
    [WeiboSDK sendRequest:request];
}
-(UILabel *)createErrorToastViewWithFrame:(CGRect)frame{
    CustomLabel *subscribeSuccessView = [self createLabelWithFrameCustom:frame :14 :@"Arial" :[UIColor whiteColor] :NSTextAlignmentCenter];
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
    mErrorLabel.hidden = YES;
}

- (NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    
    if (!jsonData) {
        NSLog(@"%@",error);
    } else {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}
#pragma mark - 显示房源详情
- (void)showHotelInfo{
    if ([self.navTitleLabel.text isEqualToString:@"房源详情"]) {
        if (mShowHotelDetailView == nil) {
            mShowHotelDetailView = [self createHotelDetailView];
        }
        Boolean isHidden = !mShowHotelDetailView.superview.hidden;
        mShowHotelDetailView.superview.hidden = isHidden;
        
        NSString *strGoodId =[[self.webView.URL.path componentsSeparatedByString:@"/"]lastObject];// @"367rrfcmr4ucp";//
        NSDictionary *dicValue = @{@"alias_id":strGoodId};
        NSString *strFilterValue = [self convertToJsonData:dicValue];
        
        if (isHidden == NO) {
            [self getRequestListWithUrlGet:[NSString stringWithFormat:@"classes/Item?where=%@",strFilterValue] :^(NSDictionary *dictData) {
                if ([[dictData objectForKey:@"results"]count] == 0) {
                    return ;
                }
                NSDictionary *itemInfo = [[dictData objectForKey:@"results"] objectAtIndex:0];
                int houseTypeMapCode = [[itemInfo objectForKey:@"houseTypeMap"]intValue];
                int leaseTypeCode = [[itemInfo objectForKey:@"leaseType"]intValue];
                NSDictionary *bedList = [itemInfo objectForKey:@"bedList"];
                int maxPeopleCnt = [[itemInfo objectForKey:@"maxPeopleCnt"]intValue];
                int toiletTypeCode = [[itemInfo objectForKey:@"toiletType"]intValue];
                NSDictionary *equipmentList1 = [itemInfo objectForKey:@"equipmentList"];
                NSArray *noticeCodeArray = [itemInfo objectForKey:@"notice"];
                NSDictionary *coordinate = [itemInfo objectForKey:@"coordinate"];
                
                CLGeocoder *myGeocoder = [CLGeocoder new];
                
                // 坐标转地名
                double latitude = [[coordinate objectForKey:@"latitude"]doubleValue];
                double longitude = [[coordinate objectForKey:@"longitude"]doubleValue];
                [myGeocoder reverseGeocodeLocation:[[CLLocation alloc]initWithLatitude:latitude longitude:longitude] completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                    CLPlacemark *placeMark=[placemarks firstObject];
                    self->mShowHotelDetailView.positionLabel.text = placeMark.name;
                    [self->mShowHotelDetailView locateToLatitude:latitude longitude:longitude];
                    UITapGestureRecognizer *mTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterMapInfoWithNewNavgaiton)];
                    [self->mShowHotelDetailView.mapView addGestureRecognizer:mTap];
                }];
                
                
                [self getRequestListWithUrl:@"/equipmentList" :^(NSDictionary *dictData) {
                    for (int i = 0; i < self->mShowHotelDetailView.equipmengListView.subviews.count; i ++) {
                        UIView *subviewTmp = [self->mShowHotelDetailView.equipmengListView.subviews objectAtIndex:i];
                        [subviewTmp removeFromSuperview];
                    }
                    NSDictionary *allEqList = [dictData objectForKey:@"result"];
                    NSMutableArray* allEquipmentList = [NSMutableArray new]; //存储所有属性
                    for (int i = 0; i < allEqList.allKeys.count; i ++) {
                        NSString *strKey = [allEqList.allKeys objectAtIndex:i];
                        NSArray *eqListItems = [[allEqList objectForKey:strKey] objectForKey:@"equipmentList"];
                        [allEquipmentList addObjectsFromArray:eqListItems];
                    }
                    NSMutableArray* allExistEquipmentList = [NSMutableArray new];//存储房屋信息中存在的属性
                    for (int i = 0; i < equipmentList1.allKeys.count; i ++) {
                        NSString *strKey = [[equipmentList1 allKeys] objectAtIndex:i];//key
                        NSArray *arrCodes = [equipmentList1 objectForKey:strKey];//code 数组
                        NSArray *allEQTypeList = [[allEqList objectForKey:strKey] objectForKey:@"equipmentList"];
                        for (int m = 0; m < arrCodes.count; m ++) {
                            for (int n = 0; n < allEQTypeList.count; n ++) {
                                if ([[[allEQTypeList objectAtIndex:n] objectForKey:@"code"]intValue] == [[arrCodes objectAtIndex:m]intValue] ) {
                                    [allExistEquipmentList addObject:[allEQTypeList objectAtIndex:n]];
                                    break;
                                }
                            }
                        }
                    }
                    for (int i = 0; i < allEquipmentList.count; i ++) {
                        Boolean isExist = false;
                        for (int j = 0; j < allExistEquipmentList.count; j ++) {
                            if ([[allEquipmentList objectAtIndex:i] isEqual:[allExistEquipmentList objectAtIndex:j]]) {
                                isExist = true;
                                break;
                            }
                        }
                        UILabel *tmpLabel = [self createLabelWithFrame:CGRectMake(76.5*(i%4), 29*floor(i/4.0), 76.5, 29) :14 :@"PingFangSC-regular" :[UIColor colorWithRed:16.0/255.0 green:16.0/255.0 blue:16.0/255.0 alpha:1.0]  :NSTextAlignmentLeft];
                        tmpLabel.text = [[allEquipmentList objectAtIndex:i]objectForKey:@"description"];
                        [self->mShowHotelDetailView.equipmengListView addSubview:tmpLabel];
                        if (!isExist) {
                            tmpLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
                        }
                    }
                }];
                [self getRequestListWithUrl:@"/leaseType" :^(NSDictionary *dictData) {
                    NSArray *allLeaseList = [dictData objectForKey:@"result"];
                    for (int i = 0; i < allLeaseList.count; i ++) {
                        if ([[[allLeaseList objectAtIndex:i]objectForKey:@"code"]intValue] == leaseTypeCode) {
                            self->mShowHotelDetailView.leaseTypeLabel.text = [[allLeaseList objectAtIndex:i]objectForKey:@"description"];
                            break;
                        }
                    }
                }];
                [self getRequestListWithUrl:@"/bedList" :^(NSDictionary *dictData) {
                    NSArray *arrBedList = [dictData objectForKey:@"result"];
                    NSMutableString* arrExistBed = [NSMutableString new];
                    for (int i = 0; i < bedList.allKeys.count; i ++) {
                        NSString *strBedKey = [bedList.allKeys objectAtIndex:i];
                        if ([[bedList objectForKey:strBedKey]intValue] > 0) {
                            for (int j = 0; j < arrBedList.count; j ++) {
                                NSDictionary *bedInfo = [arrBedList objectAtIndex:j];
                                if ([[bedInfo objectForKey:@"key"] isEqualToString:strBedKey]) {
                                    if (arrExistBed.length == 0) {
                                        [arrExistBed appendString:[NSString stringWithFormat:@"%@*%d",[bedInfo objectForKey:@"description"],[[bedList objectForKey:strBedKey]intValue]]];
                                    }else{
                                        [arrExistBed appendString:[NSString stringWithFormat:@"/%@*%d",[bedInfo objectForKey:@"description"],[[bedList objectForKey:strBedKey]intValue]]];
                                    }
                                    break;
                                }
                            }
                        }
                    }
                    self->mShowHotelDetailView.bedLabel.text = arrExistBed;
                    
                }];
                [self getRequestListWithUrl:@"/notice" :^(NSDictionary *dictData) {
                    NSArray *arrNoticeList = [dictData objectForKey:@"result"];
                    NSMutableString *allNoticeDesc = [NSMutableString new];
                    for (int i = 0; i < noticeCodeArray.count; i ++) {
                        for (int j = 0; j < arrNoticeList.count; j ++) {
                            if ([[noticeCodeArray objectAtIndex:i]intValue] == [[[arrNoticeList objectAtIndex:j]objectForKey:@"code"]intValue]) {
                                [allNoticeDesc appendString:[NSString stringWithFormat:@"%@; ",[[arrNoticeList objectAtIndex:j]objectForKey:@"description"]]];
                                break;
                            }
                        }
                    }
                    self->mShowHotelDetailView.noticeLabel.text = allNoticeDesc;
                }];
                [self getRequestListWithUrl:@"/toiletType" :^(NSDictionary *dictData) {
                    NSArray *allToiletList = [dictData objectForKey:@"result"];
                    for (int i = 0; i < allToiletList.count; i ++) {
                        if ([[[allToiletList objectAtIndex:i]objectForKey:@"code"]intValue] == toiletTypeCode) {
                            self->mShowHotelDetailView.toiletLabel.text = [[allToiletList objectAtIndex:i]objectForKey:@"description"];
                            break;
                        }
                    }
                }];
            }];
            //添加动画 CGRectMake(SCREEN_WIDTH - 338, 0, 338, SCREEN_HEIGHT - SafeAreaTopHeight)
            [UIView animateWithDuration:0.3 animations:^{
                self->mShowHotelDetailView.center = CGPointMake(SCREEN_WIDTH - 338+338/2, (SCREEN_HEIGHT - SafeAreaTopHeight)/2);
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                self->mShowHotelDetailView.center = CGPointMake(SCREEN_WIDTH+338/2, (SCREEN_HEIGHT - SafeAreaTopHeight)/2);
            }];
        }
    }
}
- (HotelDetailView *)createHotelDetailView{
    UIView *hotelDetailView = [[UIView alloc]initWithFrame:self.webView.frame];
    hotelDetailView.backgroundColor = [UIColor colorWithRed:57.0/255.0 green:37.0/255.0 blue:37.0/255.0 alpha:0.6];
    hotelDetailView.hidden = YES;
    [self.view addSubview:hotelDetailView];
    [self.view bringSubviewToFront:hotelDetailView];
    HotelDetailView *hotelDetailViewTmp = [[HotelDetailView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, 338, SCREEN_HEIGHT - SafeAreaTopHeight)];
    [hotelDetailView addSubview:hotelDetailViewTmp];
    UIView *clearView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 338, SCREEN_HEIGHT - SafeAreaTopHeight)];
    clearView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapLeftView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideInfoView)];
    [clearView addGestureRecognizer:tapLeftView];
    [hotelDetailView addSubview:clearView];
    return hotelDetailViewTmp;
}
- (void)hideInfoView{
    mShowHotelDetailView.superview.hidden = YES;
}
- (void)enterMapInfoWithNewNavgaiton{
    NewMapNavgationViewController *mapInfoVC =[[NewMapNavgationViewController alloc]initWithHomeName:mShowHotelDetailView.positionLabel.text :mShowHotelDetailView.latitude :mShowHotelDetailView.longitude];
    [self.navigationController pushViewController:mapInfoVC animated:YES];
}

- (void)getRequestListWithUrl:(NSString *)strUrl :(void(^)(NSDictionary *dictData))showDataInView{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@functions%@",BASE_URL,[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"khYEI0xFyAnVCUpO" forHTTPHeaderField:@"X-Parse-Application-Id"];
    NSURLSession *session =[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        //回到主线程 刷新数据 要是刷新就在这里面
        dispatch_async(dispatch_get_main_queue(), ^{
            showDataInView(dic);
        });
    }];
    //启动任务
    [dataTask resume];
}
- (void)getRequestListWithUrlGet:(NSString *)strUrl :(void(^)(NSDictionary *dictData))showDataInView{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"khYEI0xFyAnVCUpO" forHTTPHeaderField:@"X-Parse-Application-Id"];
    NSURLSession *session =[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        //回到主线程 刷新数据 要是刷新就在这里面
        dispatch_async(dispatch_get_main_queue(), ^{
            showDataInView(dic);
        });
    }];
    //启动任务
    [dataTask resume];
}
@end

