//
//  HotelDetailView.h
//  NewTown
//
//  Created by macbookpro on 2019/7/9.
//  Copyright © 2019 macbookpro. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CommonHeader.h"
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HotelDetailView : UIView<MKMapViewDelegate>
@property (nonatomic,strong) UILabel *leaseTypeLabel;
@property (nonatomic,strong) UILabel *bedLabel;
@property (nonatomic,strong) UILabel *toiletLabel;
@property (nonatomic,strong) UIView *equipmengListView;
@property (nonatomic,strong) UILabel *noticeLabel;
@property (nonatomic,strong) UILabel *positionLabel;
@property (nonatomic,strong) MKMapView *mapView;

- (id)initWithFrame:(CGRect)frame;
-(MKPointAnnotation*)locateToLatitude:(CGFloat)latitude longitude:(CGFloat)longitude;
@end

NS_ASSUME_NONNULL_END
