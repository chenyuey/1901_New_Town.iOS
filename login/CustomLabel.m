//
//  CustomLabel.m
//  NewTown
//
//  Created by cy on 2019/4/2.
//  Copyright © 2019年 cy. All rights reserved.
//

#import "CustomLabel.h"

@implementation CustomLabel
- (instancetype)init {
    if (self = [super init]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _textInsets)];
}

@end
