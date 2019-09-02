//
//  HouseManageViewController.h
//  NewTown
//
//  Created by cy on 2019/8/9.
//  Copyright © 2019 cy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "CommonHeader.h"
#import "SaveImage_Util.h"

NS_ASSUME_NONNULL_BEGIN

@interface HouseManageViewController : UIViewController<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    WKWebView *mWebView;
    
    int indextNumb;// 交替图片名字
    UIImage *getImage;//获取的图片
    HouseManageViewController *target;

}
@end

NS_ASSUME_NONNULL_END
