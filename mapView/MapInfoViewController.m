//
//  MapInfoViewController.m
//  NewTown
//
//  Created by cy on 2019/3/20.
//  Copyright © 2019年 cy. All rights reserved.
//

#import "MapInfoViewController.h"
#import "CustomizeView.h"
@interface MapInfoViewController ()

@end

@implementation MapInfoViewController
- (id)initWithTitle:(NSString *)strTitle{
    self = [super init];
    if (self) {
        strMapTitle = strTitle;
        self.navigationController.navigationBar.hidden = YES; // 隐藏navigationbar
        self.view.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0];
        //修改导航栏样式
        self.navTitleLabel = [CustomizeView createLabelWithFrame:CGRectMake(50, SafeStatusBarHeight, SCREEN_WIDTH - 100, 44) :20 :@"Arial-BoldM" :[UIColor blackColor] :NSTextAlignmentCenter];
        self.navTitleLabel.text = strTitle;
        [self.view addSubview:self.navTitleLabel];
        self.backButton = [CustomizeView createButtonWithImage:CGRectMake(10, SafeStatusBarHeight+10, 24, 24) :@"back_btn" :self :@selector(backToRegion:)];
        [self.view addSubview:self.backButton];
    }
    return self;
}
- (id)initWithTitle:(NSString *)strTitle andType:(BOOL)isHome{
    self = [super init];
    if (self) {
        isHomeType = isHome;
        strMapTitle = strTitle;
        self.navigationController.navigationBar.hidden = YES; // 隐藏navigationbar
        self.view.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0];
        //修改导航栏样式
        self.navTitleLabel = [CustomizeView createLabelWithFrame:CGRectMake(50, SafeStatusBarHeight, SCREEN_WIDTH - 100, 44) :20 :@"Arial-BoldM" :[UIColor blackColor] :NSTextAlignmentCenter];
        self.navTitleLabel.text = strTitle;
        [self.view addSubview:self.navTitleLabel];
        self.backButton = [CustomizeView createButtonWithImage:CGRectMake(20, SafeStatusBarHeight+10, 24, 24) :@"back_btn" :self :@selector(backToRegion:)];
        [self.view addSubview:self.backButton];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0];

    self.mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 136 - SafeAreaBottomHeight)];
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.zoomEnabled = YES;
    self.mapView.scrollEnabled = YES;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.mapView.frame.origin.y+self.mapView.frame.size.height, SCROLLVIEW_WIDTH, 136)];
    bottomScrollView.pagingEnabled = YES;
    bottomScrollView.clipsToBounds = NO;
    bottomScrollView.showsHorizontalScrollIndicator = NO;
    bottomScrollView.delegate = self;
    [self.view addSubview:bottomScrollView];
    [self updateMapDataInfo];
    isJoinInFirst = true;
}
- (void)updateMapDataInfo{
    if (isHomeType == NO) {
        NSString *region = strMapTitle;
        PFQuery *query = [PFQuery queryWithClassName:@"TownMap"];
        if (![region isEqualToString:@"全部小镇"]) {
            [query whereKey:@"region" equalTo:region];
        }
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if (objects.count>0) {
                self->bottomScrollView.contentSize = CGSizeMake(SCROLLVIEW_WIDTH * objects.count, self->bottomScrollView.bounds.size.height);
                [self showAllTownInfoWithTowns:objects];
            }
        }];
    }else{
        PFQuery *query = [PFQuery queryWithClassName:@"HomeMap"];
        PFQuery *currentTownQuery = [PFQuery queryWithClassName:@"TownMap"];
        [currentTownQuery whereKey:@"name" equalTo:strMapTitle];
        [currentTownQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable results, NSError * _Nullable error) {
            if (results.count > 0) {
                PFObject *currentTownItem = [results objectAtIndex:0];
                NSString *objectId = currentTownItem.objectId;
                [query whereKey:@"nearby_towns" containedIn:@[objectId]];
                [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                    if (objects.count>0) {
                        self->bottomScrollView.contentSize = CGSizeMake(SCROLLVIEW_WIDTH * objects.count, self->bottomScrollView.bounds.size.height);
                        [self showAllTownInfoWithTowns:objects];
                    }
                }];
            }
            
        }];
    }
}
#pragma mark - 页面事件
- (void)showAllTownInfoWithTowns:(NSArray *)towns{
    for (int i = 0; i < towns.count; i ++) {
        BottomTownItemView *townItemView = [[BottomTownItemView alloc]initTownInfoWithFrame:CGRectMake(SCROLLVIEW_WIDTH * i, 0, SCROLLVIEW_WIDTH, bottomScrollView.bounds.size.height)];
        PFObject *townInfo = [towns objectAtIndex:i];
        townItemView.webLinkURL = [townInfo objectForKey:@"link"];
        [townItemView.coverImageView sd_setImageWithURL:[NSURL URLWithString:[townInfo objectForKey:@"cover_link"]] placeholderImage:[UIImage imageNamed:@"image_placeholder"]];
        [townItemView.coverImageView layoutIfNeeded];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:townItemView.coverImageView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(6, 6)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.frame = townItemView.coverImageView.bounds;
        maskLayer.path = maskPath.CGPath;
        townItemView.coverImageView.layer.mask = maskLayer;
        [townItemView setTitleFrameAndDescFrame:[townInfo objectForKey:@"name"] :[townInfo objectForKey:@"description"]];
        [townItemView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapTownView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showCurrentTownInfoInMapView:)];
        [townItemView addGestureRecognizer:tapTownView];
        [bottomScrollView addSubview:townItemView];
        MKPointAnnotation *annotation = [self locateToLatitude:[[townInfo objectForKey:@"coordinate"]latitude] longitude:[[townInfo objectForKey:@"coordinate"]longitude] :townItemView.titleLabel.text :townItemView.descLabel.text];
        townItemView.annotation = annotation;
        if (i == 0) {
            [self moveCenterLocationToLatitude:[self.mapView.annotations objectAtIndex:0]];
        }
        
    }
}
- (void)showCurrentTownInfoInMapView:(UIGestureRecognizer *)gesture{
    BottomTownItemView *townView = (BottomTownItemView*)gesture.view;
    //跳转到详情页
    WebViewController *webVC = [[WebViewController alloc]initWithURLString:townView.webLinkURL];
    [self.navigationController pushViewController:webVC animated:YES];
}
- (void)backToRegion:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(MKPointAnnotation*)locateToLatitude:(CGFloat)latitude longitude:(CGFloat)longitude :(NSString *)townName :(NSString*)townDesc{
    // 创建MKPointAnnotation对象——代表一个锚点
    MKPointAnnotation* annotation = [[MKPointAnnotation alloc] init];
    annotation.title = townName;
    annotation.subtitle = townDesc;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude , longitude);
    annotation.coordinate = coordinate;
    // 添加锚点
    [self.mapView addAnnotation:annotation];
    return annotation;
}
- (void)moveCenterLocationToLatitude:(MKPointAnnotation*) annotation{
    // 设置地图中心的经度、纬度
    CLLocationCoordinate2D center = {annotation.coordinate.latitude,annotation.coordinate.longitude};
    // 设置地图显示的范围，地图显示范围越小，细节越清楚
    float zoom = 0.1;
    if (isHomeType) {
        zoom = 0.01;
    }
    MKCoordinateSpan span = MKCoordinateSpanMake(zoom,zoom);
    if (!isJoinInFirst) {
        span = self.mapView.region.span;
    }
    // 创建MKCoordinateRegion对象，该对象代表地图的显示中心和显示范围
    MKCoordinateRegion region =MKCoordinateRegionMake(center, span);
    // 设置当前地图的显示中心和显示范围
    [self.mapView setRegion:region animated:YES];
    [self.mapView selectAnnotation:annotation animated:YES];
    isJoinInFirst = false;
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
    annoView.image = [UIImage imageNamed:@"locationIcon"];
    annoView.canShowCallout = YES;
    return annoView;
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    view.image = [UIImage imageNamed:@"locationIconHighLight"];
    //更新底部的视图
    for (int i = 0; i < bottomScrollView.subviews.count; i ++) {
        BottomTownItemView *townItemView = [bottomScrollView.subviews objectAtIndex:i];
        if ([townItemView isKindOfClass:[BottomTownItemView class]]) {
            if ([townItemView.annotation isEqual:view.annotation]) {
                int n = townItemView.center.x/SCROLLVIEW_WIDTH;
                bottomScrollView.contentOffset = CGPointMake(n*SCROLLVIEW_WIDTH, 0);
                return;
            }
        }
    }
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    view.image = [UIImage imageNamed:@"locationIcon"];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    for (int i = 0; i < bottomScrollView.subviews.count; i ++) {
        BottomTownItemView *townItemView = [bottomScrollView.subviews objectAtIndex:i];
        if ([townItemView isKindOfClass:[BottomTownItemView class]] && townItemView.frame.origin.x == scrollView.contentOffset.x) {
            [self moveCenterLocationToLatitude:townItemView.annotation];
            return;
        }
    }
}


@end
