//
//  SearchNameViewController.h
//  NewTown
//
//  Created by macbookpro on 2019/7/6.
//  Copyright © 2019 macbookpro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeader.h"
NS_ASSUME_NONNULL_BEGIN

@interface SearchNameViewController : UIViewController{
    UISearchBar *mSearchBarView;
}
@property(nonatomic,copy) void(^selectCheckDateBlock)(NSString *homeName);
//左侧返回按钮
@property (nonatomic,strong) UIButton *backButton;
@end

NS_ASSUME_NONNULL_END
