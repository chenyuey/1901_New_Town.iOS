//
//  NewMapNavgationViewController.h
//  NewTown
//
//  Created by macbookpro on 2019/7/13.
//  Copyright © 2019 macbookpro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CommonHeader.h"
#import <Parse/Parse.h>
#import "CustomLabel.h"


NS_ASSUME_NONNULL_BEGIN

@interface NewMapNavgationViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>
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
    double mLatitude;
    double mLongitude;
}
@property (nonatomic,strong) MKMapView *mapView;
@property (strong,nonatomic) CLGeocoder *geocoder;
//左侧返回按钮
@property (nonatomic,strong) UIButton *backButton;
- (id)initWithHomeName:(NSString *)strName :(PFObject *)homeItemInfo;
- (id)initWithHomeName:(NSString *)strName :(double )latitude :(double)longitude;

@end

NS_ASSUME_NONNULL_END
