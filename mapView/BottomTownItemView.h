//
//  BottomTownItemView.h
//  NewTown
//
//  Created by cy on 2019/3/26.
//  Copyright © 2019年 cy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BottomTownItemView : UIView
@property (nonatomic, strong)UIImageView *coverImageView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *descLabel;
@property (nonatomic, strong)MKPointAnnotation *annotation;
@property (nonatomic, strong)NSString *webLinkURL;
- (id)initTownInfoWithFrame:(CGRect)frame;
- (void)setTitleFrameAndDescFrame:(NSString *)title :(NSString *)desc;
@end

NS_ASSUME_NONNULL_END
