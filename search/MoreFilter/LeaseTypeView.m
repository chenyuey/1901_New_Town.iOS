//
//  LeaseTypeView.m
//  NewTown
//
//  Created by macbookpro on 2019/7/18.
//  Copyright © 2019 macbookpro. All rights reserved.
//

#import "LeaseTypeView.h"

@implementation LeaseTypeView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame: frame];
    if (self) {
        self.descriptionLabel = [self createLabelWithFrame:CGRectMake(17, 4, SCREEN_WIDTH - 45 - 17, 20) :14 :@"PingFangSC-regular" :[UIColor colorWithRed:16.0/255.0 green:16.0/255.0 blue:16.0/255.0 alpha:1.0] :NSTextAlignmentLeft];
        [self addSubview:self.descriptionLabel];
        self.extendLabel = [self createLabelWithFrame:CGRectMake(17, self.descriptionLabel.frame.origin.y+self.descriptionLabel.frame.size.height, SCREEN_WIDTH - 45 - 17, 16) :12 :@"PingFangSC-regular" :[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0] :NSTextAlignmentLeft];
        [self addSubview:self.extendLabel];
        self.checkBoxBtn = [self createButtonWithImage:CGRectMake(SCREEN_WIDTH - 45, 12, 20, 20) :@"check_box_off" :@"check_box_on" :@selector(selectLeaseTypePress)];
        [self addSubview:self.checkBoxBtn];
    }
    return self;
}
- (void)selectLeaseTypePress{
    self.checkBoxBtn.selected = !self.checkBoxBtn.selected;
}
#pragma mark - UI控件创建
- (UILabel *)createLabelWithFrame:(CGRect)frame :(CGFloat)fontSize :(NSString *)fontName :(UIColor *)fontColor :(NSTextAlignment)alignment{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.font = [UIFont fontWithName:fontName size:fontSize];
    label.textColor = fontColor;
    label.textAlignment = alignment;
    return label;
}
- (UIButton *)createButtonWithImage:(CGRect)frame :(NSString *)imageNameNormal :(NSString *)imageNameSelected :(SEL)pressEvent{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    [button setImage:[UIImage imageNamed:imageNameNormal] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageNameSelected] forState:UIControlStateSelected];
    [button addTarget:self action:pressEvent forControlEvents:UIControlEventTouchUpInside];
    return button;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
