//
//  BottomTownItemView.m
//  NewTown
//
//  Created by cy on 2019/3/26.
//  Copyright © 2019年 cy. All rights reserved.
//

#import "BottomTownItemView.h"
#import "CommonHeader.h"
#import "CustomizeView.h"

@implementation BottomTownItemView
- (id)initTownInfoWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        float scale = SCREEN_WIDTH/375;
        self.coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 83, 83)];
        self.coverImageView.layer.cornerRadius = 6;
        [self addSubview:self.coverImageView];
        float titleOriginX = self.coverImageView.frame.size.width + 20 + 16;
        self.titleLabel = [CustomizeView createLabelWithFrame:CGRectMake(titleOriginX, 20+18, frame.size.width - titleOriginX - 20, 22) :16 :@"PingFangSC-bold" :[UIColor colorWithRed:17.0/255.0 green:17.0/255.0 blue:17.0/255.0 alpha:1.0] :NSTextAlignmentLeft];
        [self addSubview:self.titleLabel];
        
        self.descLabel = [CustomizeView createLabelWithFrame:CGRectMake(titleOriginX, 20+18 + 24, frame.size.width - titleOriginX - 20, 22) :14 :@"PingFangSC-regular" :[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0] :NSTextAlignmentLeft];
        [self addSubview:self.descLabel];
    }
    return self;
}
- (UILabel *)getSizeToFitFrameWithLabel:(UILabel *)label :(float)maxWidth{
    CGSize size = [label.text sizeWithFont:label.font
                         constrainedToSize:CGSizeMake(maxWidth, MAXFLOAT)
                             lineBreakMode:NSLineBreakByWordWrapping];
    CGRect labelFrame = label.frame;
    CGFloat height = size.height > 60 ? 60 : size.height;
    labelFrame.size.height = height;
    label.frame = labelFrame;
    return label;
}
- (void)setTitleFrameAndDescFrame:(NSString *)title :(NSString *)desc{
    self.titleLabel.text = title;
    self.descLabel.text = desc;
    self.titleLabel = [self getSizeToFitFrameWithLabel:self.titleLabel :self.titleLabel.bounds.size.width];
    self.descLabel = [self getSizeToFitFrameWithLabel:self.descLabel :self.descLabel.bounds.size.width];
    self.titleLabel.numberOfLines = 0;
    self.descLabel.numberOfLines = 0;
    float totalHeight = self.titleLabel.frame.size.height + 2 + self.descLabel.frame.size.height;
    self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, (self.coverImageView.frame.size.height - totalHeight)/2 + 20, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
    self.descLabel.frame = CGRectMake(self.descLabel.frame.origin.x, self.titleLabel.frame.size.height + self.titleLabel.frame.origin.y + 2, self.descLabel.frame.size.width, self.descLabel.frame.size.height);
}
@end
