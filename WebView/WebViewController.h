//
//  WebViewController.h
//  YouzaniOSDemo
//
//  Created by 陈月 on 19/03/05.
//  Copyright © 2016年 Youzan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeader.h"
#import "LoginViewController.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
//#import "WBMessageObject.h"
#import "WeiboSDK.h"
#import "MJRefresh.h"
#import <WebKit/WebKit.h>
#import "MapNavgationViewController.h"
#import "HotelDetailView.h"
#import "NewMapNavgationViewController.h"
#import "HouseManageViewController.h"
#import "TestViewController.h"

typedef NS_ENUM(NSUInteger, loginTime) {
    kLoginTimeNever = 0,     //演示不登录
    kLoginTimePrior = 1,     //演示先登录
    kLoginTimeWhenNeed = 2,  //演示后登录
};

@interface WebViewController : UIViewController<NSURLConnectionDelegate>{
    BOOL isCollecting;
    NSDictionary *shareInfo;
    UIView *shareView;
    UIView *loadingShadowView;
    NSMutableArray *mArrTitles;
    UILabel *mErrorLabel;
    HotelDetailView *mShowHotelDetailView;
    NSMutableData *arrHotelDetailData;
}
/**
 登录时机
 */
@property (assign, nonatomic) loginTime loginTime;
/**
 首次加载链接
 */
@property (copy, nonatomic) NSString *loadUrl;
//页面标题
@property (nonatomic,strong) UILabel *navTitleLabel;
//左侧返回按钮
@property (nonatomic,strong) UIButton *backButton;
//收藏按钮
@property (nonatomic,strong) UIButton *collectButton;
//地图按钮
//@property (nonatomic,strong) UIButton *mapButton;
//分享按钮
@property (nonatomic,strong) UIButton *shareButton;

//切换为房东按钮
@property (nonatomic,strong) UIButton *switchButton;

@property BOOL isLoginYouZan;

@property (nonatomic,strong) UIImageView *infoImageView;

- (id)initWithURLString:(NSString *)strURL;
@end

