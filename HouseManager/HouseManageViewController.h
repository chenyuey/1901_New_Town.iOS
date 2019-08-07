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

NS_ASSUME_NONNULL_BEGIN

@interface HouseManageViewController : UIViewController<WKUIDelegate,WKNavigationDelegate>
{
    WKWebView *mWebView;
}
@end

NS_ASSUME_NONNULL_END
