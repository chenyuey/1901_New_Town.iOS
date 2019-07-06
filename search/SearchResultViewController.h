//
//  SearchResultViewController.h
//  NewTown
//
//  Created by macbookpro on 2019/7/2.
//  Copyright © 2019 macbookpro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeader.h"
#import "DoubleSliderView.h"
#import "UIView+Extension.h"
#import "YZNavigationMenuView.h"

//NS_ASSUME_NONNULL_BEGIN

@interface SearchResultViewController : UIViewController<YZNavigationMenuViewDelegate>{
    NSString *mStrAddress;
    NSString *mStrDate;
    NSString *mStrHomeName;
    UIView *mSearchShowView;
    UIView *mDateView;
    UILabel *mAddressLabel;
    UILabel *mSearchNameView;
    
    UIView *mShowPeopleNumberView;
    NSString *mStrSelectPeopleNumber;
    
    UIView *mShowPriceView;
    YZNavigationMenuView *mShowSortView;
}
//左侧返回按钮
@property (nonatomic,strong) UIButton *backButton;

- (id)initWithAddress:(NSString *)address AndDate:(NSString *)strDate AndName:(NSString *)strName;
@end

//NS_ASSUME_NONNULL_END
