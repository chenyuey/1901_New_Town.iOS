//
//  HotelDetailView.m
//  NewTown
//
//  Created by cy on 2019/7/9.
//  Copyright © 2019 cy. All rights reserved.
//

#import "HotelDetailView.h"

@implementation HotelDetailView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIView *firstView = [[UIView alloc]initWithFrame:CGRectMake(16, 19, 298, 49)];
        firstView.layer.cornerRadius = 6;
        firstView.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
        [self addSubview:firstView];
        self.leaseTypeLabel = [CustomizeView createLabelWithFrame:CGRectMake(13, 13, 56, 20) :13 :@"PingFangSC-regular" :[UIColor colorWithRed:16.0/255.0 green:16.0/255.0 blue:16.0/255.0 alpha:1.0] :NSTextAlignmentLeft];
        [firstView addSubview:self.leaseTypeLabel];
        self.bedLabel = [CustomizeView createLabelWithFrame:CGRectMake(80, 13, 140, 20) :13 :@"PingFangSC-regular" :[UIColor colorWithRed:16.0/255.0 green:16.0/255.0 blue:16.0/255.0 alpha:1.0] :NSTextAlignmentCenter];
        [firstView addSubview:self.bedLabel];
        self.toiletLabel = [CustomizeView createLabelWithFrame:CGRectMake(220, 13, 70, 20) :13 :@"PingFangSC-regular" :[UIColor colorWithRed:16.0/255.0 green:16.0/255.0 blue:16.0/255.0 alpha:1.0] :NSTextAlignmentLeft];
        [firstView addSubview:self.toiletLabel];
        
        UILabel *equipTextLabel = [CustomizeView createLabelWithFrame:CGRectMake(16, 92, 28, 20) :13 :@"PingFangSC-regular" :[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0] :NSTextAlignmentLeft];
        equipTextLabel.text = @"设备";
        [self addSubview:equipTextLabel];
        
        self.equipmengListView = [[UIView alloc]initWithFrame:CGRectMake(16, equipTextLabel.frame.origin.y + equipTextLabel.frame.size.height + 6, 322, 145)];
        [self addSubview:self.equipmengListView];
        
        UILabel *noticeTextLabel = [CustomizeView createLabelWithFrame:CGRectMake(16, 282, 28, 20) :13 :@"PingFangSC-regular" :[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0] :NSTextAlignmentLeft];
        noticeTextLabel.text = @"须知";
        [self addSubview:noticeTextLabel];
        
        self.noticeLabel = [CustomizeView createLabelWithFrame:CGRectMake(16, 308, 306, 65) :13 :@"PingFangSC-regular" :[UIColor colorWithRed:16.0/255.0 green:16.0/255.0 blue:16.0/255.0 alpha:1.0] :NSTextAlignmentLeft];
        self.noticeLabel.numberOfLines = 0;
        [self addSubview:self.noticeLabel];
        
        UILabel *posTextLabel = [CustomizeView createLabelWithFrame:CGRectMake(16, 382, 28, 20) :13 :@"PingFangSC-regular" :[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0] :NSTextAlignmentLeft];
        posTextLabel.text = @"位置";
        [self addSubview:posTextLabel];
        
        self.positionLabel = [CustomizeView createLabelWithFrame:CGRectMake(16, 401, 306, 20) :13 :@"PingFangSC-regular" :[UIColor colorWithRed:16.0/255.0 green:16.0/255.0 blue:16.0/255.0 alpha:1.0] :NSTextAlignmentLeft];
        [self addSubview:self.positionLabel];
        
        self.mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 423, self.frame.size.width, 170)];
        [self addSubview:self.mapView];
        self.mapView.mapType = MKMapTypeStandard;
        self.mapView.zoomEnabled = YES;
        self.mapView.scrollEnabled = YES;
        self.mapView.delegate = self;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(MKPointAnnotation*)locateToLatitude:(CGFloat)latitude longitude:(CGFloat)longitude{
    self.latitude = latitude;
    self.longitude = longitude;
    // 创建MKPointAnnotation对象——代表一个锚点
    MKPointAnnotation* annotation = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude , longitude);
    annotation.coordinate = coordinate;
    // 添加锚点
    [self.mapView addAnnotation:annotation];
    [self moveCenterLocationToLatitude:annotation];
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
    annoView.image = [UIImage imageNamed:@"locationIconHighLight"];
    annoView.canShowCallout = YES;
    return annoView;
}
- (void)moveCenterLocationToLatitude:(MKPointAnnotation*) annotation{
    // 设置地图中心的经度、纬度
    CLLocationCoordinate2D center = {annotation.coordinate.latitude,annotation.coordinate.longitude};
    // 设置地图显示的范围，地图显示范围越小，细节越清楚
    float zoom = 0.1;
    MKCoordinateSpan span = MKCoordinateSpanMake(zoom,zoom);

    // 创建MKCoordinateRegion对象，该对象代表地图的显示中心和显示范围
    MKCoordinateRegion region =MKCoordinateRegionMake(center, span);
    // 设置当前地图的显示中心和显示范围
    [self.mapView setRegion:region animated:YES];
    [self.mapView selectAnnotation:annotation animated:YES];
}

@end
