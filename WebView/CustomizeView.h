//
//  CustomizeView.h
//  NewTown
//
//  Created by cy on 2019/9/2.
//  Copyright © 2019 cy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomizeView : UIView
//+ (UIButton *)createButtonWithFrame:(CGRect)frame :(NSString *)title :(SEL)event;
+ (UILabel *)createLabelWithFrame:(CGRect)frame :(CGFloat)fontSize :(NSString *)fontName :(UIColor *)fontColor :(NSTextAlignment)alignment;
+ (CustomLabel *)createLabelWithFrameCustom:(CGRect)frame :(CGFloat)fontSize :(NSString *)fontName :(UIColor *)fontColor :(NSTextAlignment)alignment;
+ (UIButton *)createButtonWithFrame:(CGRect)frame :(NSString *)title :(id)target :(SEL)event;
+ (UIButton *)createButtonWithImage:(CGRect)frame :(NSString *)imageName :(id)target :(SEL)pressEvent;
//+ (UIButton *)createButtonWithImage:(CGRect)frame :(NSString *)imageName :(SEL)pressEvent;
//+ (UIButton *)createButtonWithTitleAndImage:(NSString *)title :(CGRect)frame :(int)edgeInsetLeft :(SEL)btnPress;
+ (UIButton *)createButtonWithTitleAndImage:(NSString *)title :(CGRect)frame :(int)edgeInsetLeft :(id)target :(SEL)btnPress;
@end

NS_ASSUME_NONNULL_END
