//
//  CustomizeView.m
//  NewTown
//
//  Created by cy on 2019/9/2.
//  Copyright © 2019 cy. All rights reserved.
//

#import "CustomizeView.h"

@implementation CustomizeView
+ (UILabel *)createLabelWithFrame:(CGRect)frame :(CGFloat)fontSize :(NSString *)fontName :(UIColor *)fontColor :(NSTextAlignment)alignment{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
//    label.font = [UIFont fontWithName:fontName size:fontSize];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = fontColor;
    label.textAlignment = alignment;
    return label;
}
+ (CustomLabel *)createLabelWithFrameCustom:(CGRect)frame :(CGFloat)fontSize :(NSString *)fontName :(UIColor *)fontColor :(NSTextAlignment)alignment{
    CustomLabel *label = [[CustomLabel alloc]initWithFrame:frame];
    label.font = [UIFont fontWithName:fontName size:fontSize];
    label.textColor = fontColor;
    label.textAlignment = alignment;
    return label;
}
+ (UIButton *)createButtonWithImage:(CGRect)frame :(NSString *)imageName :(id)target :(SEL)pressEvent{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    UIImage *image = [UIImage imageNamed:imageName];
    [image setAccessibilityIdentifier:@"uncollect"];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:target action:pressEvent forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton *)createButtonWithFrame:(CGRect)frame :(NSString *)title :(id)target :(SEL)event{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:target action:event forControlEvents:UIControlEventTouchUpInside];
    //添加文字颜色
    [button setFont:[UIFont systemFontOfSize:14.0f]];
    return button;
}
+ (UIButton *)createButtonWithTitleAndImage:(NSString *)title :(CGRect)frame :(int)edgeInsetLeft :(id)target :(SEL)btnPress{
    UIButton *peopleNumberButton = [[UIButton alloc]initWithFrame:frame];
    [peopleNumberButton setTitle:title forState:UIControlStateNormal];
    [peopleNumberButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [peopleNumberButton setImage:[UIImage imageNamed:@"switchIcon"] forState:UIControlStateNormal];
    peopleNumberButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [peopleNumberButton.titleLabel sizeToFit];
    peopleNumberButton.titleEdgeInsets = UIEdgeInsetsMake(0, edgeInsetLeft, 0, 0);
    peopleNumberButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [peopleNumberButton addTarget:target action:btnPress forControlEvents:UIControlEventTouchUpInside];
    return peopleNumberButton;
}

@end
