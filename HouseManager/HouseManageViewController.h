//
//  HouseManageViewController.h
//  NewTown
//
//  Created by macbookpro on 2019/8/7.
//  Copyright © 2019 macbookpro. All rights reserved.
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

}
@end

NS_ASSUME_NONNULL_END
