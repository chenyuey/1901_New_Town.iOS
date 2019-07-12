//
//  SearchResultViewController.m
//  NewTown
//
//  Created by macbookpro on 2019/7/2.
//  Copyright © 2019 macbookpro. All rights reserved.
//

#import "SearchResultViewController.h"
#define BASE_URL @"http://192.168.124.104:1330/api/1/"
@interface SearchResultViewController ()
@property (nonatomic, assign) NSInteger minAge;
@property (nonatomic, assign) NSInteger maxAge;
@property (nonatomic, assign) NSInteger curMinPrice;
@property (nonatomic, assign) NSInteger curMaxPrice;

//@property (nonatomic, strong) UILabel *ageLabel;
@property (nonatomic, strong) UILabel *ageTipsLabel;
@property (nonatomic, strong) DoubleSliderView *doubleSliderView;
@end

@implementation SearchResultViewController
- (id)initWithAddress:(NSString *)address AndDate:(NSString *)strDate AndName:(NSString *)strName AndLoction:(NSDictionary *)coordinate{
    self = [super init];
    if (self) {
        mStrAddress = address;
        mStrDate = strDate;
        mStrHomeName = strName;
        mCoordinate = coordinate;
    }
    return self;
}
- (void)createDropDownList{
    UIView *dropDownView = [[UIView alloc]initWithFrame:CGRectMake(35, mSearchShowView.frame.origin.y+mSearchShowView.frame.size.height+13, SCREEN_WIDTH-70, 20)];
    [self.view addSubview:dropDownView];
    float distance = (dropDownView.frame.size.width - 46*3-84)/3;
    peopleNumberButton = [self createButtonWithTitleAndImage:@"人数" :CGRectMake(0, 0, 46, 20) :30];
    [dropDownView addSubview:peopleNumberButton];
    priceButton = [self createButtonWithTitleAndImage:@"价格" :CGRectMake(peopleNumberButton.frame.origin.x+peopleNumberButton.frame.size.width+distance, 0, 46, 20) :30];
    [dropDownView addSubview:priceButton];
    UIButton *moreButton = [self createButtonWithTitleAndImage:@"更多筛选" :CGRectMake(priceButton.frame.origin.x+priceButton.frame.size.width+distance, 0, 84, 20) :66];
    [dropDownView addSubview:moreButton];
    sortButton = [self createButtonWithTitleAndImage:@"排序" :CGRectMake(moreButton.frame.origin.x+moreButton.frame.size.width+distance, 0, 46, 20) :30];
    [dropDownView addSubview:sortButton];
    mShowPeopleNumberView = [self createSelectPeopleView];
    mShowPeopleNumberView.hidden = YES;
    mShowPriceView = [self createSelectPriceView];
    mShowPriceView.hidden = YES;
    mShowSortView = [[YZNavigationMenuView alloc]initWithFrame:CGRectMake(0, mSearchShowView.frame.origin.y+mSearchShowView.frame.size.height+13 + 20 + 5, SCREEN_WIDTH, 176) titleArray:@[@"默认",@"低价优先",@"高价优先",@"距离优先"]];
    mShowSortView.hidden = YES;
    mShowSortView.delegate = self;
    [self.view addSubview:mShowSortView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES; // 隐藏navigationbar
    self.tabBarController.tabBar.hidden=YES;
    self.view.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0];
    self.tabBarController.tabBar.hidden=YES;
    self.backButton = [self createButtonWithImage:CGRectMake(10, SafeStatusBarHeight+10+8, 24, 24) :@"back_btn" :@selector(backToSearch)];
    [self.view addSubview:self.backButton];
    mSearchShowView = [self createSearchShowViewWithFrame:CGRectMake(35, SafeStatusBarHeight + 10, SCREEN_WIDTH - 35 - 11, 40) :mStrDate :mStrAddress];
    mAllHotelTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeStatusBarHeight+109, SCREEN_HEIGHT, SCREEN_HEIGHT - SafeStatusBarHeight - 109) style:UITableViewStylePlain];//274
    mAllHotelTableview.delegate = self;
    mAllHotelTableview.dataSource = self;
    mAllHotelTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mAllHotelTableview];
    [self createDropDownList];
    
    mAllHotelList = @[];
    
    
    NSString *startDate = [mStrDate substringWithRange:NSMakeRange(0, 10)];
    NSString *endDate = [mStrDate substringWithRange:NSMakeRange(13,10)];
    
    mDicFilter = [NSMutableDictionary new];
    [mDicFilter setObject:startDate forKey:@"begin_date"];
    [mDicFilter setObject:endDate forKey:@"end_date"];
    [mDicFilter setObject:mStrAddress forKey:@"city"];
    [mDicFilter setObject:mCoordinate forKey:@"coordinate"];
//    PFQuery *query;
    
//    @"coordinate":coordinate,
//    @"limit":@(1) ,
//    @"skip": @(0),
//    @"order":@"-price",
//    @"maxPeopleCnt": @[@(0),@(3)],
//    @"price":@[@(0), @(1000)],
    
    
    [self getRequestListWithUrl:@"/findItem" :mDicFilter :^(NSDictionary *dictData) {
        NSLog(@"%@",dictData);
        self->mAllHotelList = [dictData objectForKey:@"result"];
        [self->mAllHotelTableview reloadData];
    }];
            
}
- (void)updateDataList{
    [self getRequestListWithUrl:@"/findItem" :mDicFilter :^(NSDictionary *dictData) {
        NSLog(@"%@",dictData);
        self->mAllHotelList = [dictData objectForKey:@"result"];
        [self->mAllHotelTableview reloadData];
    }];
}

- (void)getRequestListWithUrl:(NSString *)strUrl :(NSDictionary*)dicFilter :(void(^)(NSDictionary *dictData))showDataInView{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@functions%@",BASE_URL,[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"auFfj_6MTBRLoLnvDr0vDreK" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSData* data = [NSJSONSerialization dataWithJSONObject:dicFilter options:NSJSONWritingPrettyPrinted error:nil];
    NSString *bodyData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [request setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
    NSURLSession *session =[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        //回到主线程 刷新数据 要是刷新就在这里面
        dispatch_async(dispatch_get_main_queue(), ^{
            showDataInView(dic);
        });
    }];
    //启动任务
    [dataTask resume];
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
-(UIButton *)createButtonWithFrame:(CGRect)frame :(NSString *)title :(SEL)event{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:event forControlEvents:UIControlEventTouchUpInside];
    //添加文字颜色
    [button setFont:[UIFont systemFontOfSize:14.0f]];
    return button;
}
- (UIButton *)createButtonWithTitleAndImage:(NSString *)title :(CGRect)frame :(int)edgeInsetLeft{
    UIButton *peopleNumberButton = [[UIButton alloc]initWithFrame:frame];
    [peopleNumberButton setTitle:title forState:UIControlStateNormal];
    [peopleNumberButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [peopleNumberButton setImage:[UIImage imageNamed:@"pull_down"] forState:UIControlStateNormal];
    [peopleNumberButton setImage:[UIImage imageNamed:@"pull_up"] forState:UIControlStateSelected];
    peopleNumberButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [peopleNumberButton.titleLabel sizeToFit];
    peopleNumberButton.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    peopleNumberButton.imageEdgeInsets = UIEdgeInsetsMake(0, edgeInsetLeft, 0, 0);
    [peopleNumberButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    return peopleNumberButton;
}
- (void)buttonClick:(UIButton *)button {
    button.selected = !button.selected;
    NSString *title = button.titleLabel.text;
    UIView *view = [button superview];
    for (int i = 0; i < view.subviews.count; i ++) {
        UIButton *subview = [view.subviews objectAtIndex:i];
        if ([subview isKindOfClass:[UIButton class]] && ![subview isEqual:button]) {
            subview.selected = NO;
        }
    }
    if ([title isEqualToString:@"人数"]) {
        //显示人数筛选
        mShowPeopleNumberView.hidden = !button.selected;
        mShowPriceView.hidden = YES;
        mShowSortView.hidden = YES;
    }else if([title isEqualToString:@"价格"]){
        mShowPriceView.hidden = !button.selected;
        mShowPeopleNumberView.hidden = YES;
        mShowSortView.hidden = YES;
    }else if([title isEqualToString:@"排序"]){
        mShowPriceView.hidden = YES;
        mShowPeopleNumberView.hidden = YES;
        mShowSortView.hidden = !button.selected;
        
    }else {
        
    }
    
}
- (void)selectPeopleNumber:(UIButton *)sender{
    UIButton *selectBtn = sender;
    selectBtn.selected = !selectBtn.selected;
    if (selectBtn.selected) {
        mStrSelectPeopleNumber = selectBtn.titleLabel.text;
        NSArray *arrValues = [[mStrSelectPeopleNumber substringToIndex:mStrSelectPeopleNumber.length - 1] componentsSeparatedByString:@"～"];
        int min = [[arrValues objectAtIndex:0]intValue];
        int max = [[arrValues objectAtIndex:1]intValue];
        [mDicFilter setObject:@[@(min),@(max)] forKey:@"maxPeopleCnt"];
        [self updateDataList];
        UIView *superView = [selectBtn superview];
        for (int i = 0; i < superView.subviews.count; i ++) {
            UIButton *subview = [superView.subviews objectAtIndex:i];
            [selectBtn setBackgroundColor:[UIColor colorWithRed:90.0/255.0 green:169.0/255.0 blue:135.0/255.0 alpha:1.0]];
            if ([subview isKindOfClass:[UIButton class]] && ![selectBtn isEqual:subview]) {
                [subview setBackgroundColor:[UIColor whiteColor]];
                subview.selected = NO;
            }
        }
        
    }else{
        [selectBtn setBackgroundColor:[UIColor whiteColor]];
        mStrSelectPeopleNumber = @"";
        [mDicFilter removeObjectForKey:@"maxPeopleCnt"];
        [self updateDataList];
    }
}
//选择人数按钮设置
- (UIButton *)createSelectButtonWithFrame:(CGRect)frame :(NSString *)title{
    UIButton *btn1 = [[UIButton alloc]initWithFrame:frame];
    [btn1 setTitle:title forState:UIControlStateNormal];
    btn1.layer.borderWidth = 1.0;
    btn1.layer.borderColor = [UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0].CGColor;
    [btn1 setTitleColor:[UIColor colorWithRed:58.0/255.0 green:60.0/255.0 blue:64.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [btn1 addTarget:self action:@selector(selectPeopleNumber:) forControlEvents:UIControlEventTouchUpInside];
    return btn1;
}
- (UIView *)createSelectPeopleView{
    UIView *view  = [[UIView alloc]initWithFrame:CGRectMake(0, mSearchShowView.frame.origin.y+mSearchShowView.frame.size.height+13 + 20 + 5, SCREEN_WIDTH, 125)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    float dis = (SCREEN_WIDTH - 50 - 75*4)/3;
    UIButton *btn1 = [self createSelectButtonWithFrame:CGRectMake(25, 30, 75, 25) :@"1～2人"];
    [view addSubview:btn1];
    UIButton *btn2 = [self createSelectButtonWithFrame:CGRectMake(btn1.frame.origin.x+btn1.frame.size.width+dis, 30, 75, 25) :@"3～4人"];
    [view addSubview:btn2];
    UIButton *btn3 = [self createSelectButtonWithFrame:CGRectMake(btn2.frame.origin.x+btn2.frame.size.width+dis, 30, 75, 25) :@"5～7人"];
    [view addSubview:btn3];
    UIButton *btn4 = [self createSelectButtonWithFrame:CGRectMake(btn3.frame.origin.x+btn3.frame.size.width+dis, 30, 75, 25) :@"8～10人"];
    [view addSubview:btn4];
    UIButton *btn5 = [self createSelectButtonWithFrame:CGRectMake(25, 30+25+15, 75, 25) :@"10人以上"];
    [view addSubview:btn5];
    return view;
}
- (UIView *)createSearchShowViewWithFrame:(CGRect)frame :(NSString *)strDate :(NSString *)strAddress{
    UIView *showSearchItemView = [[UIView alloc]initWithFrame:frame];
    [self.view addSubview:showSearchItemView];
    showSearchItemView.layer.cornerRadius = 20.0;
    showSearchItemView.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    mDateView = [[UIView alloc]initWithFrame:CGRectMake(15, 5, 50, 30)];
    [showSearchItemView addSubview:mDateView];
    UILabel *startDateLabel = [self createLabelWithFrame:CGRectMake(0, 0, mDateView.frame.size.width, 15) :14 :@"Arial" :[UIColor colorWithRed:16.0/255.0 green:16.0/255.0 blue:16.0/255.0 alpha:1.0] :NSTextAlignmentCenter];
    
    [mDateView addSubview:startDateLabel];
    UILabel *endDateLabel = [self createLabelWithFrame:CGRectMake(0, 15, mDateView.frame.size.width, 15) :14 :@"Arial" :[UIColor colorWithRed:16.0/255.0 green:16.0/255.0 blue:16.0/255.0 alpha:1.0] :NSTextAlignmentCenter];
    [mDateView addSubview:endDateLabel];
    if (strDate.length > 10) {
        startDateLabel.text = [NSString stringWithFormat:@"入%@",[strDate substringWithRange:NSMakeRange(5, 5)]];
        endDateLabel.text = [NSString stringWithFormat:@"离%@",[strDate substringWithRange:NSMakeRange(18, 5)]];
    }
    mAddressLabel = [self createLabelWithFrame:CGRectMake(mDateView.frame.origin.x + mDateView.frame.size.width+10, 10, 40, 20) : 14:@"Arial" :[UIColor colorWithRed:16.0/255.0 green:16.0/255.0 blue:16.0/255.0 alpha:1.0] :NSTextAlignmentCenter];
    mAddressLabel.text = strAddress;
    [mAddressLabel sizeToFit];
    [showSearchItemView addSubview:mAddressLabel];
    mSearchNameView = [self createLabelWithFrame:CGRectMake(mAddressLabel.frame.origin.x + mAddressLabel.frame.size.width+10, 10, 40, 20) :14 :@"Arial" :[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0] :NSTextAlignmentLeft];
    mSearchNameView.text = @"房源/地标/房源名称";
    [showSearchItemView addSubview:mSearchNameView];
    if (![mStrHomeName isEqualToString:@""]) {
        mSearchNameView.text = mStrHomeName;
        mSearchNameView.textColor = [UIColor colorWithRed:16.0/255.0 green:16.0/255.0 blue:16.0/255.0 alpha:1.0];
    }
    [mSearchNameView sizeToFit];
    return showSearchItemView;
}
#pragma mark - 自定义事件
- (void)backToSearch{
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


#pragma mark - 创建价格选择筛选
- (UIView *)createSelectPriceView{
    UIView *view  = [[UIView alloc]initWithFrame:CGRectMake(0, mSearchShowView.frame.origin.y+mSearchShowView.frame.size.height+13 + 20 + 5, SCREEN_WIDTH, 160)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    self.ageTipsLabel = [self createLabelWithFrame:CGRectMake(18, 9, 63, 20) :14 :@"PingFangSC-regular" :[UIColor colorWithRed:16.0/255.0 green:16.0/255.0 blue:16.0/255.0 alpha:1.0] :NSTextAlignmentLeft];
    self.ageTipsLabel.text = @"¥0 - 不限";
    NSArray *arrPrice = @[@"¥0",@"¥100",@"¥200",@"¥300",@"¥400",@"¥500",@"¥600",@"不限"];
    float dis = (SCREEN_WIDTH - 18*2 - 30*8)/7;
    for (int i = 0; i < 8; i ++) {
        UILabel *priceLabelTmp = [self createLabelWithFrame:CGRectMake(18+30*i+dis*i, self.ageTipsLabel.frame.origin.y+self.ageTipsLabel.frame.size.height + 4, 30, 17) :12 :@"Arial" :[UIColor colorWithRed:16.0/255.0 green:16.0/255.0 blue:16.0/255.0 alpha:1.0] :NSTextAlignmentCenter];
        [view addSubview:priceLabelTmp];
        priceLabelTmp.text = [arrPrice objectAtIndex:i];
    }
    [view addSubview:self.ageTipsLabel];
    
    self.doubleSliderView = [self doubleSliderView];
    
    self.minAge = 0;
    self.maxAge = 700;
    self.curMinPrice = 0;
    self.curMaxPrice = 700;
    
    [view addSubview:self.doubleSliderView];
    self.doubleSliderView.x = 18;
    self.doubleSliderView.y = self.ageTipsLabel.frame.origin.y + self.ageTipsLabel.frame.size.height+17+12;
    
    UIButton *confirmBtn = [self createButtonWithFrame:CGRectMake(12, view.frame.size.height - 36 - 13, SCREEN_WIDTH - 24, 36) :@"确定" :@selector(confirmSelectPrice:)];
    [confirmBtn setBackgroundColor:[UIColor colorWithRed:90.0/255.0 green:169.0/255.0 blue:135.0/255.0 alpha:1.0]];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [view addSubview:confirmBtn];
    return view;
}
- (void)confirmSelectPrice:(id)sender{
    NSLog(@"%@",self.ageTipsLabel.text);
    mShowPriceView.hidden = YES;
    priceButton.selected = NO;
}
#pragma mark - 选择价格
#pragma mark - action
//根据值获取整数
- (CGFloat)fetchIntFromValue:(CGFloat)value {
    CGFloat newValue = floorf(value);
    CGFloat changeValue = value - newValue;
    if (changeValue >= 0.5) {
        newValue = newValue + 1;
    }
    return newValue;
}

- (void)sliderValueChangeActionIsLeft: (BOOL)isLeft finish: (BOOL)finish {
    if (isLeft) {
        CGFloat age = (self.maxAge - self.minAge) * self.doubleSliderView.curMinValue;
        CGFloat tmpAge = [self fetchIntFromValue:age];
        self.curMinPrice = (NSInteger)tmpAge + self.minAge;
        [self changeAgeTipsText];
    }else {
        CGFloat age = (self.maxAge - self.minAge) * self.doubleSliderView.curMaxValue;
        CGFloat tmpAge = [self fetchIntFromValue:age];
        self.curMaxPrice = (NSInteger)tmpAge + self.minAge;
        [self changeAgeTipsText];
    }
    if (finish) {
        [self changeSliderValue];
    }
}

//值取整后可能改变了原始的大小，所以需要重新改变滑块的位置
- (void)changeSliderValue {
    CGFloat finishMinValue = (CGFloat)(self.curMinPrice - self.minAge)/(CGFloat)(self.maxAge - self.minAge);
    CGFloat finishMaxValue = (CGFloat)(self.curMaxPrice - self.minAge)/(CGFloat)(self.maxAge - self.minAge);
    self.doubleSliderView.curMinValue = finishMinValue;
    self.doubleSliderView.curMaxValue = finishMaxValue;
    [self.doubleSliderView changeLocationFromValue];
}

- (void)changeAgeTipsText {
    if (self.curMinPrice == self.curMaxPrice) {
        self.ageTipsLabel.text = [NSString stringWithFormat:@"¥%li", self.curMinPrice];
        if (self.curMaxPrice == 700) {
            self.ageTipsLabel.text = @"不限";
        }
    }else {
        self.ageTipsLabel.text = [NSString stringWithFormat:@"¥%li~¥%li", self.curMinPrice, self.curMaxPrice];
        if (self.curMaxPrice == 700) {
            self.ageTipsLabel.text = [NSString stringWithFormat:@"¥%li~不限", self.curMinPrice];
        }
    }
    [self.ageTipsLabel sizeToFit];
}

#pragma mark - setter & getter

- (UILabel *)ageTipsLabel {
    if (!_ageTipsLabel) {
        _ageTipsLabel = [[UILabel alloc] init];
        _ageTipsLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        _ageTipsLabel.textColor = [UIColor blackColor];
        _ageTipsLabel.text = [NSString stringWithFormat:@"%li~%li岁",self.minAge, self.maxAge];
        [_ageTipsLabel sizeToFit];
    }
    return _ageTipsLabel;
}

- (DoubleSliderView *)doubleSliderView {
    if (!_doubleSliderView) {
        _doubleSliderView = [[DoubleSliderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width - 18 * 2, 35 + 20)];
        _doubleSliderView.needAnimation = true;
        __weak typeof(self) weakSelf = self;
        _doubleSliderView.sliderBtnLocationChangeBlock = ^(BOOL isLeft, BOOL finish) {
            [weakSelf sliderValueChangeActionIsLeft:isLeft finish:finish];
        };
    }
    return _doubleSliderView;
}
#pragma mark - YZNavigationMenuViewDelegate
- (void)navigationMenuView:(YZNavigationMenuView *)menuView clickedAtIndex:(NSInteger)index;
{
    NSLog(@"------我是第%ld栏",index + 1);
    mShowSortView.hidden = YES;
    mStrSort = [menuView.titleArray  objectAtIndex:index];
    sortButton.selected = NO;
}
#pragma mark -  UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mAllHotelList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *strIndentify = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    HotelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strIndentify];
    if (!cell) {
        cell = [[HotelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIndentify];
    }
    NSString *imageUrl = [[mAllHotelList objectAtIndex:indexPath.row]objectForKey:@"cover_link"];
    [cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"image_placeholder"]];
    [cell.coverImageView layoutIfNeeded];
    cell.profileLabel.text = @"整套出租 双人床 2人";
    cell.hotelNameLabel.text = [[mAllHotelList objectAtIndex:indexPath.row]objectForKey:@"title"];
    cell.remarksLabel.text = [[mAllHotelList objectAtIndex:indexPath.row]objectForKey:@"desc"];
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%@",[[mAllHotelList objectAtIndex:indexPath.row]objectForKey:@"price"]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 274;
}
@end
