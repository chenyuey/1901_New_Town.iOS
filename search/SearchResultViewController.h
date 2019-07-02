//
//  SearchResultViewController.h
//  NewTown
//
//  Created by macbookpro on 2019/7/2.
//  Copyright © 2019 macbookpro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeader.h"

//NS_ASSUME_NONNULL_BEGIN

@interface SearchResultViewController : UIViewController{
    NSString *mStrAddress;
    NSString *mStrDate;
    NSString *mStrHomeName;
    UIView *mSearchShowView;
}
//左侧返回按钮
@property (nonatomic,strong) UIButton *backButton;
- (id)initWithAddress:(NSString *)address AndDate:(NSString *)strDate AndName:(NSString *)strName;
@end

//NS_ASSUME_NONNULL_END
