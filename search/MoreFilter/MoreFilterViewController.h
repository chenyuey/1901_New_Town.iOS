//
//  MoreFilterViewController.h
//  NewTown
//
//  Created by macbookpro on 2019/7/18.
//  Copyright © 2019 macbookpro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeader.h"
#import "LeaseTypeView.h"
#import "EquipmentButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface MoreFilterViewController : UIViewController
{
    UIScrollView *mShowAllFilterView;
    UIView *mLeaseTypeView;
    UIView *mHouseTypeView;
    UIView *mEquipmentTypeView;
}
//页面标题
@property (nonatomic,strong) UILabel *navTitleLabel;
@end

NS_ASSUME_NONNULL_END
