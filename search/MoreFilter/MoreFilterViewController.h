//
//  MoreFilterViewController.h
//  NewTown
//
//  Created by cy on 2019/7/18.
//  Copyright © 2019 cy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeader.h"
#import "LeaseTypeView.h"
#import "EquipmentButton.h"
#import "NoticeTypeView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MoreFilterViewController : UIViewController
{
    UIScrollView *mShowAllFilterView;
    UIView *mLeaseTypeView;
    UIView *mHouseTypeView;
    UIView *mEquipmentTypeView;
    UIView *mNoticeView;
    NSMutableDictionary *mDicFilterInfo;
}
//页面标题
@property (nonatomic,strong) UILabel *navTitleLabel;
@property (nonatomic, copy) void(^selectValueBlock)(NSDictionary * allFilterDic);
- (id)initWithDicFilterInfo:(NSDictionary *)dicInfo;
@end

NS_ASSUME_NONNULL_END
