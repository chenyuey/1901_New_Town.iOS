//
//  BottomTownItemView.h
//  NewTown
//
//  Created by macbookpro on 2019/3/26.
//  Copyright © 2019年 macbookpro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BottomTownItemView : UIView
@property (nonatomic, strong)UIImageView *coverImageView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *descLabel;
@property (nonatomic, strong)MKPointAnnotation *annotation;
- (id)initTownInfoWithFrame:(CGRect)frame;
- (void)setTitleFrameAndDescFrame:(NSString *)title :(NSString *)desc;
@end

NS_ASSUME_NONNULL_END
