//
//  MapNavgationViewController.m
//  NewTown
//
//  Created by macbookpro on 2019/6/10.
//  Copyright © 2019 macbookpro. All rights reserved.
//

#import "MapNavgationViewController.h"

@interface MapNavgationViewController ()

@end

@implementation MapNavgationViewController
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
- (id)initWithHomeName:(NSString *)strName{
    self = [super init];
    if (self) {
        strHomeName = strName;
    }
    return self;
}
- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
//查看路线
- (void)showTheRoute{
    MKPlacemark *fromPlacemark = [[MKPlacemark alloc] initWithCoordinate:[[_locationManager location] coordinate] addressDictionary:nil];
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
    _locationManager.distanceFilter = 200;
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
    
    self.backButton = [self createButtonWithImage:CGRectMake(10, SafeStatusBarHeight+10, 24, 24) :@"back_btn" :@selector(back:)];
    [self.view addSubview:self.backButton];
    
    [self addUpdateLoactionManager];
    
    mHotelLabel = [self createLabelWithFrame:CGRectMake(20, self.mapView.frame.origin.y + self.mapView.frame.size.height + 5, SCREEN_WIDTH - 40 - 50, 30) :14 :@"Arial" :[UIColor blackColor] :NSTextAlignmentLeft];
    [self.view addSubview:mHotelLabel];
    mAddressDetailLabel = [self createLabelWithFrame:CGRectMake(20, mHotelLabel.frame.origin.y + mHotelLabel.frame.size.height + 5, SCREEN_WIDTH - 40 - 50, 30) :12 :@"Arial" :[UIColor blackColor] :NSTextAlignmentLeft];
    mAddressDetailLabel.numberOfLines = 0;
    [self.view addSubview:mAddressDetailLabel];
    
    UIButton *navigationImageBtn = [self createButtonWithImage:CGRectMake(SCREEN_WIDTH - 40 - 20 , self.mapView.frame.origin.y + self.mapView.frame.size.height + 20, 40, 40) :@"navigation" :@selector(creatActionSheet)];
    [self.view addSubview:navigationImageBtn];
    
    self.geocoder = [[CLGeocoder alloc]init];
    mHotelLabel.text = strHomeName;
    PFQuery *query = [PFQuery queryWithClassName:@"HomeMap"];
    [query whereKey:@"name" equalTo:strHomeName];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable results, NSError * _Nullable error) {
        PFObject *homeItemInfo = [results objectAtIndex:0];
        PFGeoPoint *coordinate = [homeItemInfo objectForKey:@"coordinate"];
        [self locateToLatitude:coordinate.latitude longitude:coordinate.longitude :self->strHomeName];
        self->mCoordinateDestination = CLLocationCoordinate2DMake(coordinate.latitude,coordinate.longitude);
        CLLocation *loc = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        [self.geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            CLPlacemark *mark = [placemarks objectAtIndex:0];
            self->mAddressDetailLabel.text = [NSString stringWithFormat:@"%@ %@",[[mark.addressDictionary objectForKey:@"FormattedAddressLines"]objectAtIndex:0],self->strHomeName];
        }];
    }];
}

#pragma mark - UI控件创建
- (UILabel *)createLabelWithFrame:(CGRect)frame :(CGFloat)fontSize :(NSString *)fontName :(UIColor *)fontColor :(NSTextAlignment)alignment{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.font = [UIFont fontWithName:fontName size:fontSize];
    label.textColor = fontColor;
    label.textAlignment = alignment;
    return label;
}
- (UIButton *)createButtonWithImage:(CGRect)frame :(NSString *)imageName :(SEL)pressEvent{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    UIImage *image = [UIImage imageNamed:imageName];
    [image setAccessibilityIdentifier:@"uncollect"];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:pressEvent forControlEvents:UIControlEventTouchUpInside];
    return button;
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
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1,0.1);
    MKCoordinateRegion region =MKCoordinateRegionMake(coordinate, span);
    [self.mapView setRegion:region animated:YES];
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
    [self.mapView setRegion:theRegion];
}

@end
