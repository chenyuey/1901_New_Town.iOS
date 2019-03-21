//
//  CollectTableViewCell.m
//  NewTown
//
//  Created by macbookpro on 2019/3/21.
//  Copyright © 2019年 macbookpro. All rights reserved.
//

#import "CollectTableViewCell.h"
#import "CommonHeader.h"

@implementation CollectTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        self.coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 184, 92)];
        self.coverImageView.layer.cornerRadius = 6;
        [self addSubview:self.coverImageView];
        
        self.titleLabel = [self createLabelWithFrame:CGRectMake(220, 32, SCREEN_WIDTH - 220 - 20, 22) :16 :@"PingFangSC-bold" :[UIColor colorWithRed:17.0/255.0 green:17.0/255.0 blue:17.0/255.0 alpha:1.0] :NSTextAlignmentLeft];
        [self addSubview:self.titleLabel];
        
        self.descLabel = [self createLabelWithFrame:CGRectMake(220, 32 + 22 + 2, SCREEN_WIDTH - 220 - 20, 22) :14 :@"PingFangSC-regular" :[UIColor colorWithRed:17.0/255.0 green:17.0/255.0 blue:17.0/255.0 alpha:1.0] :NSTextAlignmentLeft];
        [self addSubview:self.descLabel];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - UI控件创建
- (UILabel *)createLabelWithFrame:(CGRect)frame :(CGFloat)fontSize :(NSString *)fontName :(UIColor *)fontColor :(NSTextAlignment)alignment{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.font = [UIFont fontWithName:fontName size:fontSize];
    label.textColor = fontColor;
    label.textAlignment = alignment;
    return label;
}
- (UIButton *)createButtonWithImage:(CGRect)frame :(NSString *)imageName :(SEL)pressEvent{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    UIImage *image = [UIImage imageNamed:imageName];
    [image setAccessibilityIdentifier:@"uncollect"];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:pressEvent forControlEvents:UIControlEventTouchUpInside];
    return button;
}
@end
