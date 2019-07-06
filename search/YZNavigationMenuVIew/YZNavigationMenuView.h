//
//  YZNavigationMenuView.h
//  YZNavigationMenuView
//
//  Created by holden on 2016/12/25.
//  Copyright © 2016年 holden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeader.h"

@protocol YZNavigationMenuViewDelegate;

@interface YZNavigationMenuView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) id<YZNavigationMenuViewDelegate>delegate;

/**
 点击每一栏时通过block回调,索引从0开始,
 */
@property (nonatomic, copy) void (^clickedBlock)(NSInteger index);

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray;

@end

@protocol YZNavigationMenuViewDelegate <NSObject>

@optional

/**
 点击每一栏时通过代理回调

 @param menuView self
 @param index 每一栏的索引,从0开始,
 */
- (void)navigationMenuView:(YZNavigationMenuView *)menuView clickedAtIndex:(NSInteger)index;

@end
