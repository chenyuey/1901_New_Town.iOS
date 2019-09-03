//
//  MapNavgationViewController.h
//  NewTown
//
//  Created by cy on 2019/6/10.
//  Copyright © 2019 cy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CommonHeader.h"
#import <Parse/Parse.h>
#import "CustomLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MapNavgationViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>
{
    CLLocationManager* _locationManager;
    NSString *strHomeName;
    NSArray *mPlacemarks;
    UILabel *mHotelLabel;
    UILabel *mAddressDetailLabel;
    
    
    CLLocationCoordinate2D mCoordinateDestination;
    CLLocationCoordinate2D mCoordinateStart;
    
    MKPolyline *mCurrentOverLay;
    
    PFObject *mHomeItemInfo;
}
@property (nonatomic,strong) MKMapView *mapView;
@property (strong,nonatomic) CLGeocoder *geocoder;
//左侧返回按钮
@property (nonatomic,strong) UIButton *backButton;
- (id)initWithHomeName:(NSString *)strName :(PFObject *)homeItemInfo;
@end

NS_ASSUME_NONNULL_END
