//
//  NewMapNavgationViewController.m
//  NewTown
//
//  Created by cy on 2019/7/13.
//  Copyright © 2019 cy. All rights reserved.
//

#import "NewMapNavgationViewController.h"
#import "CustomizeView.h"

@interface NewMapNavgationViewController ()

@end

@implementation NewMapNavgationViewController

#pragma mark - 底部弹出框
-(void)creatActionSheet {
    UIAlertAction *action1;
    if ([self.mapView.overlays containsObject:mCurrentOverLay]) {
        action1 = [UIAlertAction actionWithTitle:@"隐藏路线" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self hideTheRoute];
        }];
    }else{
        action1 = [UIAlertAction actionWithTitle:@"显示路线" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showTheRoute];
        }];
    }
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [action1 setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"用Apple地图导航" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self enterAppleMapNavgation];
    }];
    [action2 setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    [action3 setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    
    //把action添加到actionSheet里
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    [actionSheet addAction:action3];
    //相当于之前的[actionSheet show];
    [self presentViewController:actionSheet animated:YES completion:nil];
}
#pragma mark - 系统初始化
- (id)initWithHomeName:(NSString *)strName :(PFObject *)homeItemInfo{
    self = [super init];
    if (self) {
        strHomeName = strName;
        mHomeItemInfo = homeItemInfo;
    }
    return self;
}
- (id)initWithHomeName:(NSString *)strName :(double )latitude :(double)longitude{
    self = [super init];
    if (self) {
        strHomeName = strName;
        mLatitude = latitude;
        mLongitude = longitude;
    }
    return self;
}
- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    [_locationManager stopUpdatingLocation];
    self.mapView = nil;
}
//查看路线
- (void)showTheRoute{
    MKPlacemark *fromPlacemark = [[MKPlacemark alloc] initWithCoordinate:mCoordinateStart addressDictionary:nil];
    MKPlacemark *toPlacemark = [[MKPlacemark alloc] initWithCoordinate:mCoordinateDestination addressDictionary:nil];
    MKMapItem *fromItem = [[MKMapItem alloc] initWithPlacemark:fromPlacemark];
    MKMapItem *toItem = [[MKMapItem alloc] initWithPlacemark:toPlacemark];
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = fromItem;
    request.destination = toItem;
    request.requestsAlternateRoutes = YES;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         if (error) {
             NSLog(@"error:%@", error);
         }
         else {
             MKRoute *route = response.routes[0];
             self->mCurrentOverLay = route.polyline;
             [self.mapView addOverlay:self->mCurrentOverLay];
         }
     }];
}
//进入apple地图导航
- (void)enterAppleMapNavgation{
    //当前的位置
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    //目的地的位置
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:mCoordinateDestination addressDictionary:nil]];
    toLocation.name = mHotelLabel.text;
    NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];
    NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
    //打开苹果自身地图应用，并呈现特定的item
    [MKMapItem openMapsWithItems:items launchOptions:options];
}
- (void)hideTheRoute{
    [self.mapView removeOverlay:mCurrentOverLay];
}


//打开定位服务
- (void)addUpdateLoactionManager{
    _locationManager = [[CLLocationManager alloc] init];
    
    //1.在info.plist中配置允许定位设置
    //NSLocationWhenInUseUsageDiscription
    
    //2.查看手机定位服务是否开启
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"请在设置中打开定位服务");
        return;
    }
    //3.请求用户授权
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        //请求用户授权
        [_locationManager requestWhenInUseAuthorization];
    }
    //4.重要,让地图显示当前用户的位置
    self.mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    self.mapView.showsUserLocation = YES;
    _locationManager.delegate = self;
    _locationManager.distanceFilter = 10;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.hidden = YES; // 隐藏navigationbar
    self.view.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0];
    self.mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, SafeStatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-SafeStatusBarHeight - SafeAreaBottomHeight - 80)];
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.zoomEnabled = YES;
    self.mapView.scrollEnabled = YES;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    mCoordinateStart = CLLocationCoordinate2DMake(0, 0);
    self.backButton = [CustomizeView createButtonWithImage:CGRectMake(10, SafeStatusBarHeight+10, 24, 24) :@"back_btn" :self :@selector(back:)];
    [self.view addSubview:self.backButton];
    
    [self addUpdateLoactionManager];
    
    mHotelLabel = [CustomizeView createLabelWithFrame:CGRectMake(20, self.mapView.frame.origin.y + self.mapView.frame.size.height + 5, SCREEN_WIDTH - 40 - 50, 30) :14 :@"Arial" :[UIColor blackColor] :NSTextAlignmentLeft];
    [self.view addSubview:mHotelLabel];
    mAddressDetailLabel = [CustomizeView createLabelWithFrame:CGRectMake(20, mHotelLabel.frame.origin.y + mHotelLabel.frame.size.height + 5, SCREEN_WIDTH - 40 - 50, 30) :12 :@"Arial" :[UIColor blackColor] :NSTextAlignmentLeft];
    mAddressDetailLabel.numberOfLines = 0;
    [self.view addSubview:mAddressDetailLabel];
    
    UIButton *navigationImageBtn = [CustomizeView createButtonWithImage:CGRectMake(SCREEN_WIDTH - 40 - 20 , self.mapView.frame.origin.y + self.mapView.frame.size.height + 20, 40, 40) :@"navigation" :self :@selector(creatActionSheet)];
    [self.view addSubview:navigationImageBtn];
    
    self.geocoder = [[CLGeocoder alloc]init];
    
    //解析房屋信息
    mHotelLabel.text = strHomeName;
    [self parseHomeInfo];
}
- (void)parseHomeInfo{
    [self locateToLatitude:mLatitude longitude:mLongitude :self->strHomeName];
    self->mCoordinateDestination = CLLocationCoordinate2DMake(mLatitude,mLongitude);
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:mLatitude longitude:mLongitude];
    [self.geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *mark = [placemarks objectAtIndex:0];
        self->mAddressDetailLabel.text = [NSString stringWithFormat:@"%@ %@",[[mark.addressDictionary objectForKey:@"FormattedAddressLines"]objectAtIndex:0],self->strHomeName];
    }];
}

//添加位置定位图标
-(MKPointAnnotation*)locateToLatitude:(CGFloat)latitude longitude:(CGFloat)longitude :(NSString *)markerTitle{
    // 创建MKPointAnnotation对象——代表一个锚点
    MKPointAnnotation* annotation = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude , longitude);
    annotation.coordinate = coordinate;
    annotation.title = markerTitle;
    // 添加锚点
    [self.mapView addAnnotation:annotation];
    CLLocationCoordinate2D center = {annotation.coordinate.latitude,annotation.coordinate.longitude};
    // 设置地图显示的范围，地图显示范围越小，细节越清楚】
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1,0.1);
    // 创建MKCoordinateRegion对象，该对象代表地图的显示中心和显示范围
    MKCoordinateRegion region =MKCoordinateRegionMake(center, span);
    // 设置当前地图的显示中心和显示范围
    [self.mapView setRegion:region animated:YES];
    [self.mapView selectAnnotation:annotation animated:YES];
    
    return annotation;
}

#pragma mark - MKMapViewDelegate
- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *pinId = @"pinID";
    MKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:pinId];
    if (annoView == nil) {
        annoView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinId];
    }
    annoView.annotation = annotation;
    annoView.canShowCallout = YES;
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        annoView.image = [UIImage imageNamed:@"location"];
        if(mCoordinateStart.latitude == 0 && mCoordinateStart.longitude == 0){
            MKCoordinateSpan span = MKCoordinateSpanMake(0.1,0.1);
            MKCoordinateRegion region =MKCoordinateRegionMake(mCoordinateDestination, span);
            [self.mapView setRegion:region animated:YES];
        }
        mCoordinateStart = annotation.coordinate;
    }else if([annotation isKindOfClass:[MKPointAnnotation class]]){
        annoView.image = [UIImage imageNamed:@"locationIconHighLight"];
    }
    return annoView;
}
//线路的绘制
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer;
    renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.lineWidth = 5.0;
    renderer.strokeColor = [UIColor colorWithRed:138.0/255.0 green:159.0/255.0 blue:244.0/255.0 alpha:1.0];
    return renderer;
}

#pragma mark - CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{
    //地图的范围 越小越精确
    MKCoordinateSpan theSpan;
    theSpan.latitudeDelta=0.05;
    theSpan.longitudeDelta=0.05;
    MKCoordinateRegion theRegion;
    theRegion.center=[[_locationManager location] coordinate];
    theRegion.span=theSpan;
    mCoordinateStart = [[_locationManager location] coordinate];
}

- (void)dealloc
{
    if (self.mapView != nil) {
        self.mapView = nil;
    }
}
@end
