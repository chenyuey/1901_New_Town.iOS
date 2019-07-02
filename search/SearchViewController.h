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

NS_ASSUME_NONNULL_BEGIN

@interface SearchViewController : UIViewController<UITextFieldDelegate>
{
    UILabel *mAddressLocationLabel;
    UILabel *mDateLabel;
    UITextField *mHomeNameLabel;
    
    UIButton *mFindBtn;
}
//页面标题
//@property (nonatomic,strong) UILabel *navTitleLabel;
@end

NS_ASSUME_NONNULL_END
