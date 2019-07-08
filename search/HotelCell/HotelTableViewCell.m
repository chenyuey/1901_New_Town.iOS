//
//  HotelTableViewCell.m
//  NewTown
//
//  Created by macbookpro on 2019/7/8.
//  Copyright © 2019 macbookpro. All rights reserved.
//

#import "HotelTableViewCell.h"

@implementation HotelTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(14, 0, SCREEN_WIDTH-28, 179)];
        [self addSubview:self.coverImageView];
        self.profileLabel = [self createLabelWithFrame:CGRectMake(14, self.coverImageView.frame.size.height+7, SCREEN_WIDTH-28, 17) :12 :@"Arial" :[UIColor colorWithRed:16.0/255.0 green:16.0/255.0 blue:16.0/255.0 alpha:1.0] :NSTextAlignmentLeft];
        [self addSubview:self.profileLabel];
        self.hotelNameLabel = [self createLabelWithFrame:CGRectMake(14, self.profileLabel.frame.size.height+self.profileLabel.frame.origin.y+2, SCREEN_WIDTH-28, 21) :15 :@"Arial" :[UIColor colorWithRed:16.0/255.0 green:16.0/255.0 blue:16.0/255.0 alpha:1.0] :NSTextAlignmentLeft];
        [self addSubview:self.hotelNameLabel];
        self.remarksLabel = [self createLabelWithFrame:CGRectMake(14, self.hotelNameLabel.frame.size.height+self.hotelNameLabel.frame.origin.y+2, SCREEN_WIDTH-28, 21) :12 :@"Arial" :[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0] :NSTextAlignmentLeft];
        [self addSubview:self.remarksLabel];
        self.priceLabel = [self createLabelWithFrame:CGRectMake(14, self.remarksLabel.frame.size.height+self.remarksLabel.frame.origin.y+3, SCREEN_WIDTH-28, 21) :15 :@"PingFangSC-bold" :[UIColor colorWithRed:90.0/255.0 green:169.0/255.0 blue:135.0/255.0 alpha:1.0] :NSTextAlignmentLeft];
        [self addSubview:self.priceLabel];
    }
    return self;
}
#pragma mark - UI控件创建
- (UILabel *)createLabelWithFrame:(CGRect)frame :(CGFloat)fontSize :(NSString *)fontName :(UIColor *)fontColor :(NSTextAlignment)alignment{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.font = [UIFont fontWithName:fontName size:fontSize];
    label.textColor = fontColor;
    label.textAlignment = alignment;
    return label;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
