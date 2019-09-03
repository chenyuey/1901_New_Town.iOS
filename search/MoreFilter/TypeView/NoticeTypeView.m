//
//  NoticeTypeView.m
//  NewTown
//
//  Created by cy on 2019/7/19.
//  Copyright © 2019 cy. All rights reserved.
//

#import "NoticeTypeView.h"
#import "CustomizeView.h"

@implementation NoticeTypeView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame: frame];
    if (self) {
        self.descriptionLabel = [CustomizeView createLabelWithFrame:CGRectMake(17, 4, SCREEN_WIDTH - 45 - 17, 20) :14 :@"PingFangSC-regular" :[UIColor colorWithRed:16.0/255.0 green:16.0/255.0 blue:16.0/255.0 alpha:1.0] :NSTextAlignmentLeft];
        [self addSubview:self.descriptionLabel];
        self.checkBoxBtn = [self createButtonWithImage:CGRectMake(SCREEN_WIDTH - 45, 0, 20, 20) :@"check_box_off" :@"check_box_on" :@selector(selectLeaseTypePress)];
        [self addSubview:self.checkBoxBtn];
    }
    return self;
}
- (void)selectLeaseTypePress{
    self.checkBoxBtn.selected = !self.checkBoxBtn.selected;
}
#pragma mark - UI控件创建
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
