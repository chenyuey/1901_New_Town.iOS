//
//  HotelTableViewCell.m
//  NewTown
//
//  Created by cy on 2019/7/8.
//  Copyright © 2019 cy. All rights reserved.
//

#import "HotelTableViewCell.h"
#import "CustomizeView.h"

@implementation HotelTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(14, 0, SCREEN_WIDTH-28, 179)];
        [self addSubview:self.coverImageView];
        self.profileLabel = [CustomizeView createLabelWithFrame:CGRectMake(14, self.coverImageView.frame.size.height+7, SCREEN_WIDTH-28, 17) :12 :@"Arial" :[UIColor colorWithRed:16.0/255.0 green:16.0/255.0 blue:16.0/255.0 alpha:1.0] :NSTextAlignmentLeft];
        [self addSubview:self.profileLabel];
        self.hotelNameLabel = [CustomizeView createLabelWithFrame:CGRectMake(14, self.profileLabel.frame.size.height+self.profileLabel.frame.origin.y+2, SCREEN_WIDTH-28, 21) :15 :@"Arial" :[UIColor colorWithRed:16.0/255.0 green:16.0/255.0 blue:16.0/255.0 alpha:1.0] :NSTextAlignmentLeft];
        [self addSubview:self.hotelNameLabel];
        self.remarksLabel = [CustomizeView createLabelWithFrame:CGRectMake(14, self.hotelNameLabel.frame.size.height+self.hotelNameLabel.frame.origin.y+2, SCREEN_WIDTH-28, 21) :12 :@"Arial" :[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0] :NSTextAlignmentLeft];
        [self addSubview:self.remarksLabel];
        self.priceLabel = [CustomizeView createLabelWithFrame:CGRectMake(14, self.remarksLabel.frame.size.height+self.remarksLabel.frame.origin.y+3, SCREEN_WIDTH-28, 21) :15 :@"PingFangSC-bold" :THEMECOLOR :NSTextAlignmentLeft];
        [self addSubview:self.priceLabel];
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

@end
