//
//  MapInfoViewController.m
//  NewTown
//
//  Created by macbookpro on 2019/3/20.
//  Copyright © 2019年 macbookpro. All rights reserved.
//

#import "MapInfoViewController.h"

@interface MapInfoViewController ()

@end

@implementation MapInfoViewController
- (id)initWithTitle:(NSString *)strTitle{
    self = [super init];
    if (self) {
        self.navigationController.navigationBar.hidden = YES; // 隐藏navigationbar
        self.view.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0];
        //修改导航栏样式
        self.navTitleLabel = [self createLabelWithFrame:CGRectMake(50, SafeStatusBarHeight, SCREEN_WIDTH - 100, 44) :20 :@"Arial-BoldM" :[UIColor blackColor] :NSTextAlignmentCenter];
        self.navTitleLabel.text = strTitle;
        [self.view addSubview:self.navTitleLabel];
        self.backButton = [self createButtonWithImage:CGRectMake(20, SafeStatusBarHeight+10, 24, 24) :@"back_btn" :@selector(backToRegion:)];
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
    PFQuery *query = [PFQuery queryWithClassName:@"TownMap"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        PFObject *townInfo = [objects objectAtIndex:0];
        CGFloat latitude = [[townInfo objectForKey:@"coordinate"]latitude];
        CGFloat longitude = [[townInfo objectForKey:@"coordinate"]longitude];
        NSString *townName = [townInfo objectForKey:@"name"];
        NSString *townDesc = [townInfo objectForKey:@"description"];
        [self locateToLatitude:latitude longitude:longitude :townName :townDesc];
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
#pragma mark - 页面事件
- (void)backToRegion:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)locateToLatitude:(CGFloat)latitude longitude:(CGFloat)longitude :(NSString *)townName :(NSString*)townDesc{
    // 设置地图中心的经度、纬度
    CLLocationCoordinate2D center = {latitude,longitude};
    // 设置地图显示的范围，地图显示范围越小，细节越清楚
    MKCoordinateSpan span = MKCoordinateSpanMake(0.005,0.005);
    // 创建MKCoordinateRegion对象，该对象代表地图的显示中心和显示范围
    MKCoordinateRegion region =MKCoordinateRegionMake(center, span);
    // 设置当前地图的显示中心和显示范围
    [self.mapView setRegion:region animated:YES];
    // 创建MKPointAnnotation对象——代表一个锚点
    MKPointAnnotation* annotation = [[MKPointAnnotation alloc] init];
    annotation.title = townName;
    annotation.subtitle = townDesc;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(
                                                                   latitude , longitude);
    annotation.coordinate = coordinate;
    // 添加锚点
    [self.mapView addAnnotation:annotation];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
