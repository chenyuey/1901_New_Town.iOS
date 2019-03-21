//
//  CollectionViewController.h
//  NewTown
//
//  Created by macbookpro on 2019/3/21.
//  Copyright © 2019年 macbookpro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeader.h"
#import "CollectTableViewCell.h"
#import "UIImageView+WebCache.h"

NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    UITableView *mCollectTableView;
    NSArray *collectionDataSource;
}
//页面标题
@property (nonatomic,strong) UILabel *navTitleLabel;
@property (nonatomic,strong) UIView *slideBarView;
@end

NS_ASSUME_NONNULL_END
