//
//  EquipmentButton.m
//  NewTown
//
//  Created by macbookpro on 2019/7/18.
//  Copyright © 2019 macbookpro. All rights reserved.
//

#import "EquipmentButton.h"

@implementation EquipmentButton
-(id)initWithFrame:(CGRect)frame :(NSString *)title :(int)eqCode :(id)target :(SEL)event{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:16.0/255.0 green:16.0/255.0 blue:16.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self addTarget:target action:event forControlEvents:UIControlEventTouchUpInside];
        self.layer.borderColor = [UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0].CGColor;
        self.layer.borderWidth = 1.0;
        //添加文字颜色
        [self setFont:[UIFont systemFontOfSize:12.0f]];
        self.code = eqCode;
        self.descriptionValue = title;
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
