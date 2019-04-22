//
//  MapInfoViewController.h
//  NewTown
//
//  Created by macbookpro on 2019/3/20.
//  Copyright © 2019年 macbookpro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeader.h"
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "BottomTownItemView.h"
#import "UIImageView+WebCache.h"
#import "WebViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MapInfoViewController : UIViewController<MKMapViewDelegate,UIScrollViewDelegate>{
    CLLocationManager* _locationManager;
    UIScrollView *bottomScrollView;
    NSString *strMapTitle;
    BOOL isHomeType;
    BOOL isJoinInFirst;
}
//页面标题
@property (nonatomic,strong) UILabel *navTitleLabel;
//左侧返回按钮
@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,strong) MKMapView *mapView;
- (id)initWithTitle:(NSString *)strTitle;
- (id)initWithTitle:(NSString *)strTitle andType:(BOOL)isHome;
@end

NS_ASSUME_NONNULL_END
