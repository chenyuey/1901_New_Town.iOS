//
//  DropdownMenuView.h
//  NewTown
//
//  Created by macbookpro on 2019/7/4.
//  Copyright © 2019 macbookpro. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class DropdownMenuView;

@protocol DropdownMenuDelegate <NSObject>
@optional
- (void)dropdownMenuDidDismiss:(DropdownMenuView *)menu;
- (void)dropdownMenuDidShow:(DropdownMenuView *)menu;
@end

@interface DropdownMenuView : UIView
@property (nonatomic, weak) id<DropdownMenuDelegate> delegate;

#pragma mark 在指定UIView下方显示菜单
- (void)showFrom:(UIView *)from;

#pragma mark 销毁下拉菜单
- (void)dismiss;

// 要显示的内容控制器
@property (nonatomic, strong) UIViewController *contentController;
@end

NS_ASSUME_NONNULL_END
