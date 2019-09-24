//
//  SearchNameViewController.m
//  NewTown
//
//  Created by cy on 2019/7/6.
//  Copyright © 2019 cy. All rights reserved.
//

#import "SearchNameViewController.h"
#import "CustomizeView.h"

@interface SearchNameViewController ()

@end

@implementation SearchNameViewController
- (CLGeocoder *)geocoder {
    if (_geocoder == nil) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}
- (id)initWithCityName:(NSString *)strCityName{
    self = [super init];
    if (self) {
        if (strCityName==nil || strCityName.length == 0) {
            mStrCity = @"中国";
        }
        mStrCity = strCityName;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES; // 隐藏navigationbar
    self.tabBarController.tabBar.hidden=YES;
    self.view.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0];
    
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, SafeStatusBarHeight, SCREEN_WIDTH, 60)];
    navView.backgroundColor = THEMECOLOR;
    [self.view addSubview:navView];
    
    self.backButton = [CustomizeView createButtonWithImage:CGRectMake(10, 10+8, 24, 24) :@"back_btn" :self :@selector(backToSearch)];
//    [self.view addSubview:self.backButton];
    [navView addSubview:self.backButton];
    
    mSearchBarView = [[UISearchBar alloc]initWithFrame:CGRectMake(35, 10, SCREEN_WIDTH - 35 - 11, 40)];
    mSearchBarView.placeholder = @"位置/地标/房源名称";
    mSearchBarView.tintColor = [UIColor whiteColor];
    UITextField * searchField = [mSearchBarView valueForKey:@"_searchField"];
//    [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [searchField setTextColor:[UIColor whiteColor]];
    
//    [self.view addSubview:mSearchBarView];
    [navView addSubview:mSearchBarView];
    mSearchBarView.layer.borderColor = [UIColor whiteColor].CGColor;
    mSearchBarView.layer.borderWidth = 1.0;
    mSearchBarView.layer.cornerRadius = 20.0;
    mSearchBarView.delegate = self;
    
    UIImage* searchBarBg = [SearchNameViewController GetImageWithColor:[UIColor clearColor] andHeight:32.0f];
    //设置背景图片
    [mSearchBarView setBackgroundImage:searchBarBg];
    //设置背景色
    [mSearchBarView setBackgroundColor:[UIColor clearColor]];
    //设置文本框背景
    [mSearchBarView setSearchFieldBackgroundImage:searchBarBg forState:UIControlStateNormal];
    
    mShowAddressTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, mSearchBarView.frame.origin.x+mSearchBarView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - mSearchBarView.frame.origin.y - mSearchBarView.frame.size.height) style:UITableViewStyleGrouped];
    mShowAddressTableview.delegate = self;
    mShowAddressTableview.dataSource = self;
    [self.view addSubview:mShowAddressTableview];
    mAddressList = [[NSArray alloc]init];
    
    
}
- (void)backToSearch{
    [self.navigationController popViewControllerAnimated:YES];
}

+ (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}
#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length > 0) {
        [self.geocoder geocodeAddressString:mStrCity completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            
            MKCoordinateRegion region = MKCoordinateRegionMake(placemark.location.coordinate,MKCoordinateSpanMake(0.1,0.1));
            MKLocalSearchRequest *localSearchRequest = [[MKLocalSearchRequest alloc] init] ;
            localSearchRequest.region = region;
            localSearchRequest.naturalLanguageQuery = searchText;//搜索关键词
            MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:localSearchRequest];
            [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
                NSLog(@"the response's count is:%ld",response.mapItems.count);
                if (error){
                    NSLog(@"error info：%@",error);
                }
                else{
                    self->mAddressList = response.mapItems;
                    [self->mShowAddressTableview reloadData];
                }
            }];
        }];
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    if (self->mAddressList.count == 0) {
        self.selectValueBlock(searchBar.text);
        [self backToSelectVC];
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mAddressList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *strIndentify = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strIndentify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIndentify];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    MKMapItem *mark = [mAddressList objectAtIndex:indexPath.row];
    cell.textLabel.text = mark.name;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MKMapItem *mark = [mAddressList objectAtIndex:indexPath.row];
    self.selectValueBlock(mark.placemark);
    //获取定位数据
    [self backToSelectVC];
}
#pragma mark - 页面事件
- (void)backToSelectVC{
    [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden=NO;
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
