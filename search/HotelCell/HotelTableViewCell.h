//
//  HotelTableViewCell.h
//  NewTown
//
//  Created by macbookpro on 2019/7/8.
//  Copyright © 2019 macbookpro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface HotelTableViewCell : UITableViewCell
@property (nonatomic,strong) UIImageView *coverImageView;
@property (nonatomic,strong) UILabel *profileLabel;
@property (nonatomic,strong) UILabel *hotelNameLabel;
@property (nonatomic,strong) UILabel *remarksLabel;
@property (nonatomic,strong) UILabel *priceLabel;
@end

NS_ASSUME_NONNULL_END
