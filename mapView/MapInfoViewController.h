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

NS_ASSUME_NONNULL_BEGIN

@interface MapInfoViewController : UIViewController<MKMapViewDelegate>{
    CLLocationManager* _locationManager;
}
//页面标题
@property (nonatomic,strong) UILabel *navTitleLabel;
//左侧返回按钮
@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,strong) MKMapView *mapView;
- (id)initWithTitle:(NSString *)strTitle;
@end

NS_ASSUME_NONNULL_END
