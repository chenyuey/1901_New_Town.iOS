//
//  SearchViewController.h
//  NewTown
//
//  Created by macbookpro on 2019/6/29.
//  Copyright © 2019 macbookpro. All rights reserved.
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
    PFGeoPoint *coordinate;
}
//页面标题
//@property (nonatomic,strong) UILabel *navTitleLabel;
@end

NS_ASSUME_NONNULL_END
