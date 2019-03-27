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
        strMapTitle = strTitle;
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
    
    bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.mapView.frame.origin.y+self.mapView.frame.size.height, SCREEN_WIDTH, 136)];
    bottomScrollView.pagingEnabled = YES;
    bottomScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:bottomScrollView];
    
    NSString *region = [strMapTitle stringByReplacingOccurrencesOfString:@"发现" withString:@""];
    PFQuery *query = [PFQuery queryWithClassName:@"TownMap"];
    [query whereKey:@"region" equalTo:region];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects.count>0) {
            self->bottomScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * objects.count, self->bottomScrollView.bounds.size.height);
            [self showAllTownInfoWithTowns:objects];
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
#pragma mark - 页面事件
- (void)showAllTownInfoWithTowns:(NSArray *)towns{
    for (int i = 0; i < towns.count; i ++) {
        BottomTownItemView *townItemView = [[BottomTownItemView alloc]initTownInfoWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, bottomScrollView.bounds.size.height)];
        PFObject *townInfo = [towns objectAtIndex:i];
        [townItemView.coverImageView sd_setImageWithURL:[NSURL URLWithString:[townInfo objectForKey:@"cover_link"]]];
        [townItemView.coverImageView layoutIfNeeded];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:townItemView.coverImageView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(6, 6)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.frame = townItemView.coverImageView.bounds;
        maskLayer.path = maskPath.CGPath;
        townItemView.coverImageView.layer.mask = maskLayer;
        [townItemView setTitleFrameAndDescFrame:[townInfo objectForKey:@"name"] :[townInfo objectForKey:@"description"]];
        
        townItemView.latitude = [[townInfo objectForKey:@"coordinate"]latitude];
        townItemView.longitude = [[townInfo objectForKey:@"coordinate"]longitude];
        [townItemView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapTownView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showCurrentTownInfoInMapView:)];
        [townItemView addGestureRecognizer:tapTownView];
        
        [bottomScrollView addSubview:townItemView];
        if (i == 0) {
            [self locateToLatitude:townItemView.latitude longitude:townItemView.longitude :townItemView.titleLabel.text :townItemView.descLabel.text];
        }
    }
}
- (void)showCurrentTownInfoInMapView:(UIGestureRecognizer *)gesture{
    BottomTownItemView *townView = (BottomTownItemView*)gesture.view;
     [self locateToLatitude:townView.latitude longitude:townView.longitude :townView.titleLabel.text :townView.descLabel.text];
}
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
