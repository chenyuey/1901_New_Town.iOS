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
- (void)enterNavgation:(id)sender{
    NSLog(@"开始导航");
    
    //当前的位置
    
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    
    //起点
    
    //MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coords1 addressDictionary:nil]];
    
    //目的地的位置
    
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:mCoordinateDestination addressDictionary:nil]];
    
    toLocation.name = mHotelLabel.text;
    
//    NSString *myname=[dataSource objectForKey:@"name"];
//
//    if (![XtomFunction xfunc_check_strEmpty:myname])
//
//    {
//
//        toLocation.name =myname;
//
//    }
    
    
    
    NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];
    
    NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
    
    //打开苹果自身地图应用，并呈现特定的item
    
    [MKMapItem openMapsWithItems:items launchOptions:options];
    
}
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
    
    UIButton *navigationImageBtn = [self createButtonWithImage:CGRectMake(SCREEN_WIDTH - 40 - 20 , self.mapView.frame.origin.y + self.mapView.frame.size.height + 20, 40, 40) :@"navigation" :@selector(enterNavgation:)];
    [self.view addSubview:navigationImageBtn];
    
    
    self.geocoder = [[CLGeocoder alloc]init];
    [self.geocoder geocodeAddressString:strHomeName completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        NSLog(@"%@",placemarks);
        if (placemarks.count == 0 || error != nil) {
            return ;
        }
        self->mPlacemarks = placemarks;
        // placemarks地标数组, 地标数组中存放着地标, 每一个地标包含了该位置的经纬度以及城市/区域/国家代码/邮编等等...
        // 获取数组中的第一个地标
        for (int i = 0; i < placemarks.count; i ++) {
            CLPlacemark *placemark = [placemarks objectAtIndex:i];
            MKPointAnnotation *annotation = [self locateToLatitude:placemark.location.coordinate.latitude longitude:placemark.location.coordinate.longitude :placemark.name];
            if (i == 0) {
                [self moveCenterLocationToLatitude:annotation];
            }
        }
        
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
    return annotation;
}
- (void)moveCenterLocationToTapPosition:(UITapGestureRecognizer *)gesture{
    MKAnnotationView *annotationView = (MKAnnotationView *)gesture.view;
    annotationView.image = [UIImage imageNamed:@"locationIconHighLight"];
    MKPointAnnotation *annotation = annotationView.annotation;
    [self moveCenterLocationToLatitude:annotation];
}
- (void)moveCenterLocationToLatitude:(MKPointAnnotation *)annotation{
    for (int i = 0; i < mPlacemarks.count; i ++) {
        CLPlacemark *mark = [mPlacemarks objectAtIndex:i];
        if (mark.location.coordinate.latitude == annotation.coordinate.latitude && mark.location.coordinate.longitude == annotation.coordinate.longitude) {
            mHotelLabel.text = [mark.addressDictionary objectForKey:@"Name"];
            mAddressDetailLabel.text = [NSString stringWithFormat:@"%@ %@",[[mark.addressDictionary objectForKey:@"FormattedAddressLines"]objectAtIndex:0],[mark.addressDictionary objectForKey:@"Name"]];
        }
    }
    
    // 设置地图中心的经度、纬度
    CLLocationCoordinate2D center = {annotation.coordinate.latitude,annotation.coordinate.longitude};
    mCoordinateDestination = center;
    // 设置地图显示的范围，地图显示范围越小，细节越清楚
    float zoom = 0.1;
    MKCoordinateSpan span = MKCoordinateSpanMake(zoom,zoom);
    // 创建MKCoordinateRegion对象，该对象代表地图的显示中心和显示范围
    MKCoordinateRegion region =MKCoordinateRegionMake(center, span);
    // 设置当前地图的显示中心和显示范围
    [self.mapView setRegion:region animated:YES];
    [self.mapView selectAnnotation:annotation animated:YES];
    
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
        annoView.image = [UIImage imageNamed:@"locationIcon"];
        UITapGestureRecognizer *tapAnnoview = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moveCenterLocationToTapPosition:)];
        [annoView addGestureRecognizer:tapAnnoview];
    }
    return annoView;
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    view.image = [UIImage imageNamed:@"locationIcon"];
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
