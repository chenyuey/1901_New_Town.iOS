//
//  SearchViewController.m
//  NewTown
//
//  Created by cy on 2019/6/29.
//  Copyright © 2019 cy. All rights reserved.
//

#import "SearchViewController.h"
#import "CustomizeView.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //导航栏
    self.navigationController.navigationBar.hidden = YES; // 隐藏navigationbar
    self.view.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0];
    mAddressLocationLabel = [self createLabelWithFrame:CGRectMake(16, SafeStatusBarHeight+19, SCREEN_WIDTH - 16*2, 44) :14 :@"Arial" :[UIColor colorWithRed:58/255.0 green:60/255.0 blue:64/255.0 alpha:1.0] :NSTextAlignmentLeft];
    mAddressLocationLabel.layer.borderColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0].CGColor;
    mAddressLocationLabel.layer.cornerRadius = 4;
    mAddressLocationLabel.layer.borderWidth = 1.0;
    mAddressLocationLabel.textColor = [UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1.0];
    mAddressLocationLabel.text = @"请选择地址";
    mAddressLocationLabel.userInteractionEnabled = YES;
    [self.view addSubview:mAddressLocationLabel];
    //添加选择地址点击事件
    UITapGestureRecognizer *tapAddress = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectAddress:)];
    [mAddressLocationLabel addGestureRecognizer:tapAddress];
    
    mDateLabel = [self createLabelWithFrame:CGRectMake(16, mAddressLocationLabel.frame.origin.y + mAddressLocationLabel.frame.size.height + 8, SCREEN_WIDTH - 16*2, 44) :14 :@"Arial" :[UIColor colorWithRed:58/255.0 green:60/255.0 blue:64/255.0 alpha:1.0] :NSTextAlignmentLeft];
    mDateLabel.layer.borderColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0].CGColor;
    mDateLabel.layer.cornerRadius = 4;
    mDateLabel.layer.borderWidth = 1.0;
    mDateLabel.textColor = [UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1.0];
    mDateLabel.text = @"请选择入住时间";
    [self.view addSubview:mDateLabel];
    //添加选择地址点击事件
    mDateLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapDate = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDate:)];
    [mDateLabel addGestureRecognizer:tapDate];
    
    mHomeNameLabel = [self createLabelWithFrame:CGRectMake(16, mDateLabel.frame.origin.y + mDateLabel.frame.size.height + 8, SCREEN_WIDTH - 16*2, 44) :14 :@"Arial" :[UIColor colorWithRed:58/255.0 green:60/255.0 blue:64/255.0 alpha:1.0] :NSTextAlignmentLeft];
    mHomeNameLabel.layer.borderColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0].CGColor;
    mHomeNameLabel.layer.cornerRadius = 4;
    mHomeNameLabel.layer.borderWidth = 1.0;
    mHomeNameLabel.textColor = [UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1.0];
    mHomeNameLabel.text = @"位置/地标/房源名称";
    mHomeNameLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapHomeName = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectHomeName:)];
    [mHomeNameLabel addGestureRecognizer:tapHomeName];
    
    //设置显示模式为永远显示(默认不显示 必须设置 否则没有效果)
    [self.view addSubview:mHomeNameLabel];
    
    mFindBtn = [CustomizeView createButtonWithFrame:CGRectMake(16, mHomeNameLabel.frame.origin.y + mHomeNameLabel.frame.size.height + 11, SCREEN_WIDTH - 16*2, 44) :@"查找" :self :@selector(findButtonClick:)];
    mFindBtn.backgroundColor = [UIColor colorWithRed:90.0/255.0 green:169.0/255.0 blue:135.0/255.0 alpha:1.0];
    [mFindBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    mFindBtn.layer.cornerRadius = 4;
    [self.view addSubview:mFindBtn];
    
    [self startLocate];
    mDateLabel.text = [self converseDateToStringWithCurrent];
}
- (NSString *)converseDateToStringWithCurrent{
    //获取系统当前时间
    NSDate *currentDate = [NSDate date];
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
    //输出currentDateString
    NSDate *nextDay = [NSDate dateWithTimeInterval:24*60*60 sinceDate:currentDate];
    NSString *nextDateString = [dateFormatter stringFromDate:nextDay];
    return [NSString stringWithFormat:@"%@ ~ %@ 1晚",currentDateString,nextDateString];
}
#pragma mark - UI控件创建
- (SFLabel *)createLabelWithFrame:(CGRect)frame :(CGFloat)fontSize :(NSString *)fontName :(UIColor *)fontColor :(NSTextAlignment)alignment{
    SFLabel *label = [[SFLabel alloc]initWithFrame:frame];
    label.font = [UIFont fontWithName:fontName size:fontSize];
    label.textColor = fontColor;
    label.textAlignment = alignment;
    return label;
}
#pragma mark - 动态事件
- (void)findButtonClick:(id)sender{
    if ([mAddressLocationLabel.text isEqualToString:@"请选择地址"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择填入地址" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([mDateLabel.text isEqualToString:@"请选择入住时间"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择填入入住时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
//    mHomeNameLabel.text
    NSString *strHomeAddressName = mHomeNameLabel.text;
    if ([strHomeAddressName isEqualToString:@"位置/地标/房源名称"]) {
        strHomeAddressName = @"";
    }
    SearchResultViewController *searchVC = [[SearchResultViewController alloc]initWithAddress:mAddressLocationLabel.text AndDate:mDateLabel.text AndName:strHomeAddressName AndLoction:coordinate];
    [self.navigationController pushViewController:searchVC animated:YES];
    
}
- (void)viewDidAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=NO;
    [UIView animateWithDuration:0.2 animations:^{
        for (int i = 0; i < self.tabBarController.view.subviews.count; i ++) {
            UIView *tmpView = [self.tabBarController.view.subviews objectAtIndex:i];
            if ([tmpView isKindOfClass:[UITabBar class]]) {
                CGRect frame = tmpView.frame;
                frame.origin.y = SCREEN_HEIGHT - SafeAreaBottomHeight - 49;
                tmpView.frame = frame;
                [self.tabBarController.view bringSubviewToFront:tmpView];
                break;
            }
        }
    }];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [mHomeNameLabel resignFirstResponder]; // 空白处收起
}
- (void)selectAddress:(id)sender{
    SelectAddressViewController *selectAddressVC = [[SelectAddressViewController alloc]init];
    selectAddressVC.selectValueBlock = ^(NSString *addressName){
        self->mAddressLocationLabel.text = [NSString stringWithFormat:@"%@",addressName];
        self->mAddressLocationLabel.textColor = [UIColor colorWithRed:58.0/255.0 green:60.0/255.0 blue:64.0/255.0 alpha:1.0];
    };
    [self.navigationController pushViewController:selectAddressVC animated:YES];
}
- (void)selectDate:(id)sender{
    HotelCalendarViewController *vc = [[HotelCalendarViewController alloc] init];
    [vc setSelectCheckDateBlock:^(NSString *startDateStr, NSString *endDateStr, NSString *daysStr) {
        self->mDateLabel.text = [NSString stringWithFormat:@"%@ ~ %@ %@晚",startDateStr,endDateStr,daysStr];
        self->mDateLabel.textColor = [UIColor colorWithRed:58.0/255.0 green:60.0/255.0 blue:64.0/255.0 alpha:1.0];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)selectHomeName:(id)sender{
    SearchNameViewController *vc = [[SearchNameViewController alloc] initWithCityName:self->mAddressLocationLabel.text];
    [vc setSelectValueBlock:^(CLPlacemark *placemark) {
        if ([placemark isKindOfClass:[NSString class]]) {
            self->mHomeNameLabel.text = placemark;
            self->coordinate = nil;
            self->coordinate = @{@"latitude": @(38.016437),
                                 @"longitude": @(114.491728)};
        }else{
            self->mHomeNameLabel.text = placemark.name;
            self->mHomeNameLabel.textColor = [UIColor colorWithRed:58.0/255.0 green:60.0/255.0 blue:64.0/255.0 alpha:1.0];
            double latitude = placemark.location.coordinate.latitude;
            double longitude = placemark.location.coordinate.longitude;
            self->coordinate = @{@"latitude": @(latitude),
                                 @"longitude": @(longitude)};
        }
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 开始定位
- (void)startLocate{
    // 判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init] ;
        self.locationManager.delegate = self;
        // 开始定位
        [self.locationManager startUpdatingLocation];
    }else {
        //提示用户无法进行定位操作
    }
    //3.请求用户授权
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        //请求用户授权
        [_locationManager requestWhenInUseAuthorization];
    }
}
#pragma mark - CoreLocation Delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
    [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *mark = [placemarks objectAtIndex:0];
        self->mAddressLocationLabel.text = mark.locality;
//        [mAddressLocationLabel setTitle:mark.locality forState:UIControlStateNormal];
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}

@end
