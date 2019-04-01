//
//  CommonHeader.h
//  
//
//  Created by Mac on 2017/5/31.
//  Copyright © 2017年 Mac. All rights reserved.
//
typedef enum{
    SUCCESSHUDTYPE = 0,// 操作成功
    ERRORINPUTHUDTYPE,//请输入正确的金额
    NONETWORKHUDTYPE,//网络不给力
    LOADINGDATAHUDTYPE//数据加载中
}SHOWHUDTYPE;
//#import "UIColor+HexColor.h"
//#import "UIViewController+HUD.h"

//#import <Masonry.h>
//#import <UIImageView+WebCache.h>
//#import <Mantle.h>

//界面适配
//#import "CodeAdaptation.h"
//#import "LXUserDefaults.h"

//#import "BaseModel.h"
//#import "PatientUtils.h"
//#import "NSString+Size.h"
//#import "UIView+Frame.h"

#pragma --mark 统一播放按钮
#define playBtnImg @"播放按钮"
#define pauseBtnImg @"暂停按钮"
#define playFullScreenBtnImg @"全屏按钮"

//#pragma --mark 用户信息
//用户手机号
#define USERPHONE @"USERPHONE"
//微信登录信息
#define WECHATINFO @"WECHATINFO"
#define TOKEN @"TOKEN"
#define OPENID @"OPENID"
//评测文件路径
#define EVALUATION @"EVALUATION"

//系统课课程路径数组
#define SYSTEMPATH @"SYSTEMPATH"
//系统课基路径
#define BASEPATH @"BASEPATH"

//动画缓存
//开始动画
#define STARTAN @"STARTAN"
#define AN @"AN"
//结束动画
#define ENDAN @"ENDAN"

//good序列
#define GOODAN @"GOODAN"
//middle
#define MIDDLE @"MIDDLE"
//down
#define DOWN @"DOWN"

//角色交换通知
#define CHANGESTOP @"CHANGESTOP"

//断开socket链接
#define DISCONNENTSOCKET @"DISCONNENTSOCKET"
////socket连接成功
//#define SOCKETLINKSUCCESS @"SOCKETLINKSUCCESS"


#pragma --mark 认证header头

#define AUTHHEADER @"Bearer"

#define USER_DEFAULT_KEY_SESSION_ID @"USER_DEFAULT_KEY_SESSION_ID"


#pragma --mark 颜色

#define RGBACOLOR(r,g,b,a)  [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
//
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define A100XFFFFFF [UIColor colorWithRed:((float)((0xFFFFFF & 0xFF0000) >> 16))/255.0 green:((float)((0xFFFFFF & 0xFF00) >> 8))/255.0 blue:((float)(0xFFFFFF & 0xFF))/255.0 alpha:1.0]

#define A110XF1F1F1 [UIColor colorWithRed:((float)((0xF1F1F1 & 0xFF0000) >> 16))/255.0 green:((float)((0xF1F1F1 & 0xFF00) >> 8))/255.0 blue:((float)(0xF1F1F1 & 0xFF))/255.0 alpha:1.0]

#define A120X1FC29B [UIColor colorWithRed:((float)((0x1FC29B & 0xFF0000) >> 16))/255.0 green:((float)((0x1FC29B & 0xFF00) >> 8))/255.0 blue:((float)(0x1FC29B & 0xFF))/255.0 alpha:1.0]

#define A130X60CEBB [UIColor colorWithRed:((float)((0x60CEBB & 0xFF0000) >> 16))/255.0 green:((float)((0x60CEBB & 0xFF00) >> 8))/255.0 blue:((float)(0x60CEBB & 0xFF))/255.0 alpha:1.0]

#define A140X333333 [UIColor colorWithRed:((float)((0x333333 & 0xFF0000) >> 16))/255.0 green:((float)((0x333333 & 0xFF00) >> 8))/255.0 blue:((float)(0x333333 & 0xFF))/255.0 alpha:1.0]

#define A150X999999 [UIColor colorWithRed:((float)((0x999999 & 0xFF0000) >> 16))/255.0 green:((float)((0x999999 & 0xFF00) >> 8))/255.0 blue:((float)(0x999999 & 0xFF))/255.0 alpha:1.0]

#define A160XD4D4D4 [UIColor colorWithRed:((float)((0xD4D4D4 & 0xFF0000) >> 16))/255.0 green:((float)((0xD4D4D4 & 0xFF00) >> 8))/255.0 blue:((float)(0xD4D4D4 & 0xFF))/255.0 alpha:1.0]

#define A170XFF3B5E [UIColor colorWithRed:((float)((0xFF3B5E & 0xFF0000) >> 16))/255.0 green:((float)((0xFF3B5E & 0xFF00) >> 8))/255.0 blue:((float)(0xFF3B5E & 0xFF))/255.0 alpha:1.0]

#define A180X1B9BFF [UIColor colorWithRed:((float)((0x1B9BFF & 0xFF0000) >> 16))/255.0 green:((float)((0x1B9BFF & 0xFF00) >> 8))/255.0 blue:((float)(0x1B9BFF & 0xFF))/255.0 alpha:1.0]

#define A190XEBF8F5 [UIColor colorWithRed:((float)((0xEBF8F5 & 0xFF0000) >> 16))/255.0 green:((float)((0xEBF8F5 & 0xFF00) >> 8))/255.0 blue:((float)(0xEBF8F5 & 0xFF))/255.0 alpha:1.0]

#define A200X4B5A7A [UIColor colorWithRed:((float)((0x4B5A7A & 0xFF0000) >> 16))/255.0 green:((float)((0x4B5A7A & 0xFF00) >> 8))/255.0 blue:((float)(0x4B5A7A & 0xFF))/255.0 alpha:1.0]

#define A210XF5F5F5 [UIColor colorWithRed:((float)((0xF5F7FA & 0xFF0000) >> 16))/255.0 green:((float)((0xF5F7FA & 0xFF00) >> 8))/255.0 blue:((float)(0xF5F7FA & 0xFF))/255.0 alpha:1.0]

#define A220XF9F9F9 [UIColor colorWithRed:((float)((0xF9F9F9 & 0xFF0000) >> 16))/255.0 green:((float)((0xF9F9F9 & 0xFF00) >> 8))/255.0 blue:((float)(0xF9F9F9 & 0xFF00))/255.0 alpha:1.0]

#define A230XD4ECFA [UIColor colorWithRed:((float)((0xD4ECFA & 0xFF0000) >> 16))/255.0 green:((float)((0xD4ECFA & 0xFF00) >> 8))/255.0 blue:((float)(0xD4ECFA & 0xFF00))/255.0 alpha:1.0]

#define A250X43C1FF [UIColor colorWithRed:((float)((0x43C1FF & 0xFF0000) >> 16))/255.0 green:((float)((0x43C1FF & 0xFF00) >> 8))/255.0 blue:((float)(0x43C1FF & 0xFF00))/255.0 alpha:1.0]

#define A260X067AF5 [UIColor colorWithRed:((float)((0x067AF5 & 0xFF0000) >> 16))/255.0 green:((float)((0x067AF5 & 0xFF00) >> 8))/255.0 blue:((float)(0x067AF5 & 0xFF00))/255.0 alpha:1.0]

#define A270XB6B6B6 [UIColor colorWithRed:((float)((0xB6B6B6 & 0xFF0000) >> 16))/255.0 green:((float)((0xB6B6B6 & 0xFF00) >> 8))/255.0 blue:((float)(0xB6B6B6 & 0xFF))/255.0 alpha:1.0]

#define A280XEA6516 [UIColor colorWithRed:((float)((0xEA6516 & 0xFF0000) >> 16))/255.0 green:((float)((0xEA6516 & 0xFF00) >> 8))/255.0 blue:((float)(0xEA6516 & 0xFF))/255.0 alpha:1.0]

#define A290X067AF5 [UIColor colorWithRed:((float)((0x067AF5 & 0xFF0000) >> 16))/255.0 green:((float)((0x067AF5 & 0xFF00) >> 8))/255.0 blue:((float)(0x067AF5 & 0xFF))/255.0 alpha:1.0]

#define A300X666666 [UIColor colorWithRed:((float)((0x666666 & 0xFF0000) >> 16))/255.0 green:((float)((0x666666 & 0xFF00) >> 8))/255.0 blue:((float)(0x666666 & 0xFF))/255.0 alpha:1.0]

#define A300XCCCCCC [UIColor colorWithRed:((float)((0xCCCCCC & 0xFF0000) >> 16))/255.0 green:((float)((0xCCCCCC & 0xFF00) >> 8))/255.0 blue:((float)(0xCCCCCC & 0xFF))/255.0 alpha:1.0]

#define A310XCBCBCB [UIColor colorWithRed:((float)((0xCBCBCB & 0xFF0000) >> 16))/255.0 green:((float)((0xCBCBCB & 0xFF00) >> 8))/255.0 blue:((float)(0xCBCBCB & 0xFF))/255.0 alpha:1.0]

#define A320X1A1A1A [UIColor colorWithRed:((float)((0x1A1A1A & 0xFF0000) >> 16))/255.0 green:((float)((0x1A1A1A & 0xFF00) >> 8))/255.0 blue:((float)(0x1A1A1A & 0xFF))/255.0 alpha:1.0]

#define A330X515151 [UIColor colorWithRed:((float)((0x515151 & 0xFF0000) >> 16))/255.0 green:((float)((0x515151 & 0xFF00) >> 8))/255.0 blue:((float)(0x515151 & 0xFF))/255.0 alpha:1.0]

#pragma --mark通知
#define NOPASS @"NOPASS"
//
//#define WILLDRAG @"WILLDRAG"
//#define DidEndDecelerat @"DidEndDecelerat"
//登录成功
#define LOGINSUCCESSDISMISS @"LOGINSUCCESSDISMISS"
//微信登录成功
#define WECHATLOGINSUCCESS @"WECHATLOGINSUCCESS"

//退出登录
#define LOGOUTSUCCESS @"LOGOUTSUCCESS"

//推出新页面
#define PUSHNEWPAGE @"PUSHNEWPAGE"

//支付成功
#define PAYSUCCESS @"PAYSUCCESS"
//支付失败
#define PAYFAIL @"PAYFAIL"
//支付取消
#define PAYCANCLE @"PAYCANCLE"

//评测中断
#define evaluatSuspend @"evaluatSuspend"
//评测正常退出
#define evaluatQuit @"evaluatQuit"

//刷新首页
#define REFRSH @"REFRSH"
//是否在评测
#define isEvaluation @"isEvaluation"
//在评测时上下滑
#define stopTime @"stopTime"
//在评测时按home键退出
#define Homequit @"Homequit"
//开始倒计时
#define startTime @"startTime"
//刷新登录页
#define REFRESHLOGIN @"REFRESHLOGIN"

#define disConnectNotification @"disConnectNotification"

//主动连接socket
#define CONNECTSOCKET @"CONNECTSOCKET"

//从后台进入（角色交换）
#define EnterHome @"EnterHome"

//网络断开点击重新连接
#define CLICKRECONNECTSOCKET @"CLICKRECONNECTSOCKET"

//连接socket成功
#define CONNECTSOCKETSUCCESS @"CONNECTSOCKETSUCCESS"

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#define HUDFONTSIZE 12
//
//#define USER_DEFAULT_KEY_SESSION_ID @"USER_DEFAULT_KEY_SESSION_ID"
#define ISFIRST @"ISFIRST"
//
#define OVERIOS9 ([[[UIDevice currentDevice] systemVersion] floatValue]>=9.0)

//获取屏幕宽高
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define Screen_Bounds [UIScreen mainScreen].bounds
#define SCROLLVIEW_WIDTH ([[UIScreen mainScreen] bounds].size.width - 44)

////适配iphone X
#define ISIPHONEX  (SCREEN_HEIGHT == 812.0 ? YES : NO)

#define isIPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isIPad : NO)
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isIPad : NO)
//判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isIPad : NO)
//判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isIPad : NO)

#define SafeStatusBarHeight ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 44.0 : 20.0)
//(SCREEN_HEIGHT == 812.0 ? 44 : 20)
#define SafeAreaTopHeight ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 88.0 : 64.0)
//(SCREEN_HEIGHT == 812.0 ? 88 : 64)
//#define SafeAreaBottomHeight ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 83.0 : 49.0)
//#define SafeAreaBottomHeight (SCREEN_HEIGHT == 812.0 ? 34 : 0)
#define SafeAreaBottomHeight ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 34 : 0)

///适配ipad
#define isIPAD [[UIDevice currentDevice].model isEqualToString:@"iPad"]

////强弱引用
#define kWeakSelf(type)  __weak typeof(type) weak##type = type;
#define kStrongSelf(type) __strong typeof(type) type = weak##type;
//
/////IOS 版本判断
#define IOSAVAILABLEVERSION(version) ([[UIDevice currentDevice] availableVersion:version] < 0)
//// 当前系统版本
#define CurrentSystemVersion [[UIDevice currentDevice].systemVersion doubleValue]
//
#define vCFBundleShortVersionStr [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
//
////拼接字符串
#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]
//
////数据验证
#define StrValid(f) (f!=nil && [f isKindOfClass:[NSString class]] && ![f isEqualToString:@""])
#define SafeStr(f) (StrValid(f) ? f:@"")
#define HasString(str,eky) ([str rangeOfString:key].location!=NSNotFound)

#define ValidStr(f) StrValid(f)
#define ValidDict(f) (f!=nil && [f isKindOfClass:[NSDictionary class]])
#define ValidArray(f) (f!=nil && [f isKindOfClass:[NSArray class]] && [f count]>0)
#define ValidNum(f) (f!=nil && [f isKindOfClass:[NSNumber class]])
#define ValidClass(f,cls) (f!=nil && [f isKindOfClass:[cls class]])
#define ValidData(f) (f!=nil && [f isKindOfClass:[NSData class]])
//
////获取系统对象
#define kApplication        [UIApplication sharedApplication]
#define kAppWindow          [UIApplication sharedApplication].delegate.window
#define kAppDelegate        [AppDelegate shareAppDelegate]
#define kRootViewController [UIApplication sharedApplication].delegate.window.rootViewController
#define kUserDefaults       [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]
#define kApplicationDelagate [[UIApplication sharedApplication]delegate]

/**************************************************/
// 移除iOS7之后，cell默认左侧的分割线边距(table代理方法删除)
#define kRemoveCellSeparatorDelegate \
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{\
cell.separatorInset = UIEdgeInsetsZero;\
cell.layoutMargins = UIEdgeInsetsZero; \
cell.preservesSuperviewLayoutMargins = NO; \
}
/**************************************************/

///**颜色 --色值**/
//
#define HexCOLOR(hex) ([UIColor colorWithHexString:hex])
//
//-------------------打印日志-------------------------
//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif
