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
#import "HotelCell/HotelTableViewCell.h"
#import "UIImageView+WebCache.h"
#import <Parse/Parse.h>
#import "WebViewController.h"
#import "MoreFilter/MoreFilterViewController.h"

//NS_ASSUME_NONNULL_BEGIN

@interface SearchResultViewController : UIViewController<YZNavigationMenuViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSString *mStrAddress;
    NSString *mStrDate;
    NSString *mStrHomeName;
    UIView *mSearchShowView;
    UIView *mDateView;
    UILabel *mAddressLabel;
    UILabel *mSearchNameView;
    
    UIView *mShowPeopleNumberView;
    NSString *mStrSelectPeopleNumber; // 选择人数的值
    
    UIView *mShowPriceView;
    YZNavigationMenuView *mShowSortView;
    NSString *mStrSort;       //选择排序的值
    
    UIButton *peopleNumberButton;//选择人数
    UIButton *priceButton;//选择价格
    UIButton *sortButton;//选择排序
    UIButton *mMoreButton ;//更多筛选
    
    
    
    UITableView *mAllHotelTableview;
    NSArray *mAllHotelList;
    NSDictionary *mCoordinate;
    NSMutableDictionary *mDicFilter;
    
    UILabel *mNoResultLabel;
}
//左侧返回按钮
@property (nonatomic,strong) UIButton *backButton;

- (id)initWithAddress:(NSString *)address AndDate:(NSString *)strDate AndName:(NSString *)strName AndLoction:(NSDictionary *)coordinate;
@end

//NS_ASSUME_NONNULL_END
