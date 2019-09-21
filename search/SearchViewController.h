//
//  SearchViewController.h
//  NewTown
//
//  Created by cy on 2019/6/29.
//  Copyright © 2019 cy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeader.h"
#import "SelectAddressViewController.h"
#import "HotelCalendarViewController.h"
#import "SearchResultViewController.h"
#import "SearchNameViewController.h"
#import "SFLabel/SFLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchViewController : UIViewController<UITextFieldDelegate>
{
    SFLabel *mAddressLocationLabel;
    SFLabel *mDateLabel;
    SFLabel *mHomeNameLabel;
    
    UIButton *mFindBtn;
    NSDictionary *coordinate;
}
//页面标题
@property (nonatomic,strong) UILabel *navTitleLabel;
@property(nonatomic,strong) CLLocationManager *locationManager;
//左侧返回按钮
@property (nonatomic,strong) UIButton *backButton;


@end

NS_ASSUME_NONNULL_END
