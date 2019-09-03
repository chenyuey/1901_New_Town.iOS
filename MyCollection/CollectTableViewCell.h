//
//  CollectTableViewCell.h
//  NewTown
//
//  Created by cy on 2019/3/21.
//  Copyright © 2019年 cy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectTableViewCell : UITableViewCell
@property (nonatomic, strong)UIImageView *coverImageView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *descLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setTitleFrameAndDescFrame:(NSString *)title :(NSString *)desc;
@end

NS_ASSUME_NONNULL_END
