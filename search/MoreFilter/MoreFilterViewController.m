//
//  MoreFilterViewController.m
//  NewTown
//
//  Created by cy on 2019/7/18.
//  Copyright © 2019 cy. All rights reserved.
//

#import "MoreFilterViewController.h"
#import "CustomizeView.h"
#define BASE_URL @"http://yzyj.1000q1000z.com/landlord/api/1/"


@interface MoreFilterViewController ()

@end

@implementation MoreFilterViewController
#pragma mark - UI控件创建
//- (UILabel *)createLabelWithFrame:(CGRect)frame :(CGFloat)fontSize :(NSString *)fontName :(UIColor *)fontColor :(NSTextAlignment)alignment{
//    UILabel *label = [[UILabel alloc]initWithFrame:frame];
//    label.font = [UIFont fontWithName:fontName size:fontSize];
//    label.textColor = fontColor;
//    label.textAlignment = alignment;
//    return label;
//}
//- (UIButton *)createButtonWithImage:(CGRect)frame :(NSString *)imageName :(SEL)pressEvent{
//    UIButton *button = [[UIButton alloc]initWithFrame:frame];
//    UIImage *image = [UIImage imageNamed:imageName];
//    [button setImage:image forState:UIControlStateNormal];
//    [button addTarget:self action:pressEvent forControlEvents:UIControlEventTouchUpInside];
//    return button;
//}
//-(UIButton *)createButtonWithFrame:(CGRect)frame :(NSString *)title :(SEL)event{
//    UIButton *button = [[UIButton alloc]initWithFrame:frame];
//    [button setTitle:title forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [button addTarget:self action:event forControlEvents:UIControlEventTouchUpInside];
//    //添加文字颜色
//    [button setFont:[UIFont systemFontOfSize:14.0f]];
//    return button;
//}
-(UIButton *)createButtonWithFrame:(CGRect)frame :(NSString *)title :(UIColor *)textColor :(UIColor *)bgColor :(SEL)event{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    [button setBackgroundColor:bgColor];
    [button addTarget:self action:event forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 4;
    //添加文字颜色
    [button setFont:[UIFont systemFontOfSize:14.0f]];
    return button;
}
-(UIButton *)createButtonWithFrameAndBorder:(CGRect)frame :(NSString *)title :(int)code :(SEL)event{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:16.0/255.0 green:16.0/255.0 blue:16.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [button addTarget:self action:event forControlEvents:UIControlEventTouchUpInside];
    button.layer.borderColor = [UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0].CGColor;
    button.tag = code;
    button.layer.borderWidth = 1.0;
    //添加文字颜色
    [button setFont:[UIFont systemFontOfSize:12.0f]];
    return button;
}
#pragma mark - 系统生命周期
- (id)initWithDicFilterInfo:(NSDictionary *)dicInfo{
    self = [super init];
    if (self) {
        mDicFilterInfo = [NSMutableDictionary new];
        if ([dicInfo.allKeys containsObject:@"notice"]) {
            [mDicFilterInfo setObject:[dicInfo objectForKey:@"notice"] forKey:@"notice"];
        }
        if ([dicInfo.allKeys containsObject:@"equipmentList"]) {
            [mDicFilterInfo setObject:[dicInfo objectForKey:@"equipmentList"] forKey:@"equipmentList"];
        }
        if ([dicInfo.allKeys containsObject:@"houseType"]) {
            [mDicFilterInfo setObject:[dicInfo objectForKey:@"houseType"] forKey:@"houseType"];
        }
        if ([dicInfo.allKeys containsObject:@"leaseType"]) {
            [mDicFilterInfo setObject:[dicInfo objectForKey:@"leaseType"] forKey:@"leaseType"];
        }
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏
    self.navigationController.navigationBar.hidden = YES; // 隐藏navigationbar
    self.view.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0];
    //修改导航栏样式
    self.navTitleLabel = [CustomizeView createLabelWithFrame:CGRectMake(0, SafeStatusBarHeight+14, SCREEN_WIDTH, 20) :14 :@"Arial-BoldM" :[UIColor blackColor] :NSTextAlignmentCenter];
    self.navTitleLabel.text = @"更多筛选";
    [self.view addSubview:self.navTitleLabel];
    
    UIButton *closeButton = [CustomizeView createButtonWithImage:CGRectMake(14, SafeStatusBarHeight+12, 20, 20) :@"closePageIcon" :self :@selector(closeCurrentPage)];
    [self.view addSubview:closeButton];
    
    UIButton *clearButton = [CustomizeView createButtonWithFrame:CGRectMake(SCREEN_WIDTH - 68, SafeStatusBarHeight+16, 60, 20) :@"清空条件" :self :@selector(clearAllFilter)];
    [self.view addSubview:clearButton];
    mShowAllFilterView = [self createScrollViewWithFrame:CGRectMake(0, SafeStatusBarHeight + 44, SCREEN_WIDTH, SCREEN_HEIGHT - (SafeStatusBarHeight + 44) )];
    
    [self getAllData];
}

- (void)closeCurrentPage{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)clearAllFilter{
    //删除所有的筛选选项
    NSArray *allLeaseSubViews = mLeaseTypeView.subviews;
    for (int i = 0; i < allLeaseSubViews.count; i ++) {
        LeaseTypeView *tmp = [allLeaseSubViews objectAtIndex:i];
        tmp.checkBoxBtn.selected = NO;
    }
    NSArray *allHouseSubView = mHouseTypeView.subviews;
    for (int i = 0; i < allHouseSubView.count; i ++) {
        UIButton *tmp = [allHouseSubView objectAtIndex:i];
        tmp.selected = NO;
        [tmp setBackgroundColor:[UIColor whiteColor]];
        
    }
    NSArray *allEquipmentSubView = mEquipmentTypeView.subviews;
    for (int i = 0; i < allEquipmentSubView.count; i ++) {
        EquipmentButton *tmp = [allEquipmentSubView objectAtIndex:i];
        tmp.selected = NO;
        [tmp setBackgroundColor:[UIColor whiteColor]];
    }
    
    NSArray *allNoticeSubView = mNoticeView.subviews;
    for (int i = 0; i < allNoticeSubView.count; i ++) {
        NoticeTypeView *tmp = [allNoticeSubView objectAtIndex:i];
        tmp.checkBoxBtn.selected = NO;
    }
}
- (void)confirmButtonPress{
    NSMutableDictionary *allFilterDic = [NSMutableDictionary new];
    //统计 出租类型
    NSArray *allLeaseSubViews = mLeaseTypeView.subviews;
    NSMutableArray *allSelectLease = [NSMutableArray new];
    for (int i = 0; i < allLeaseSubViews.count; i ++) {
        LeaseTypeView *tmp = [allLeaseSubViews objectAtIndex:i];
        if (tmp.checkBoxBtn.selected == YES) {
            [allSelectLease addObject:@(tmp.code)];
        }
    }
    if (allSelectLease.count > 0) {
        [allFilterDic setObject:allSelectLease forKey:@"leaseType"];
    }
    
    //统计 房源类型
    NSMutableArray *allSelectHouse = [NSMutableArray new];
    NSArray *allHouseSubView = mHouseTypeView.subviews;
    for (int i = 0; i < allHouseSubView.count; i ++) {
        UIButton *tmp = [allHouseSubView objectAtIndex:i];
        if (tmp.selected == YES) {
            [allSelectHouse addObject:@(tmp.tag)];
        }
    }
    if (allSelectHouse.count > 0) {
        [allFilterDic setObject:allSelectHouse forKey:@"houseType"];
    }
    
    //统计 设施
    NSMutableDictionary *dicSelectEquipments = [NSMutableDictionary new];
    NSArray *allEquipmentSubView = mEquipmentTypeView.subviews;
    for (int i = 0; i < allEquipmentSubView.count; i ++) {
        EquipmentButton *tmp = [allEquipmentSubView objectAtIndex:i];
        if (tmp.selected == YES) {
            if (![dicSelectEquipments.allKeys containsObject:tmp.keyType]) {
                [dicSelectEquipments setObject:[NSMutableArray new] forKey:tmp.keyType];
            }
            NSMutableArray *currentKeyEquips = [dicSelectEquipments objectForKey:tmp.keyType];
            [currentKeyEquips addObject:@(tmp.code)];
            [dicSelectEquipments setObject:currentKeyEquips forKey:tmp.keyType];
        }
    }
    if (dicSelectEquipments.allKeys.count > 0) {
        [allFilterDic setObject:dicSelectEquipments forKey:@"equipmentList"];
    }
    
    //统计 守则
    NSMutableArray *allSelectNotice = [NSMutableArray new];
    NSArray *allNoticeSubView = mNoticeView.subviews;
    for (int i = 0; i < allNoticeSubView.count; i ++) {
        NoticeTypeView *tmp = [allNoticeSubView objectAtIndex:i];
        if (tmp.checkBoxBtn.selected == YES) {
            [allSelectNotice addObject:@(tmp.code)];
        }
    }
    if (allSelectNotice.count > 0) {
        [allFilterDic setObject:allSelectNotice forKey:@"notice"];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        self.selectValueBlock(allFilterDic);
    }];
}
- (void)houseTypeClick:(UIButton*)sender{
    UIButton *button = sender;
    button.selected = !button.selected;
    if (button.selected == YES) {
        [button setBackgroundColor:THEMECOLOR];
    }else{
        [button setBackgroundColor:[UIColor whiteColor]];
    }
}
- (void)equipmentTypeClick:(EquipmentButton *)sender{
    EquipmentButton *button = sender;
    button.selected = !button.selected;
    if (button.selected == YES) {
        [button setBackgroundColor:THEMECOLOR];
    }else{
        [button setBackgroundColor:[UIColor whiteColor]];
    }
}

- (void)getAllData{
    //出租类型
    [self getRequestListWithUrl:@"/leaseType" :^(NSDictionary *dictData) {
        NSArray *allLeaseList = [dictData objectForKey:@"result"];
        self->mLeaseTypeView = [[UIView alloc]initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH, 44*allLeaseList.count)];
        [self->mShowAllFilterView addSubview:self->mLeaseTypeView];
        for (int i = 0; i < allLeaseList.count; i ++) {
            LeaseTypeView *leaseTypeViewTmp = [[LeaseTypeView alloc]initWithFrame:CGRectMake(0, 44*i, SCREEN_WIDTH, 44)];
            leaseTypeViewTmp.descriptionLabel.text = [[allLeaseList objectAtIndex:i]objectForKey:@"description"];
            leaseTypeViewTmp.extendLabel.text = [[allLeaseList objectAtIndex:i]objectForKey:@"extend"];
            leaseTypeViewTmp.code = [[[allLeaseList objectAtIndex:i]objectForKey:@"code"]intValue];
            [self->mLeaseTypeView addSubview:leaseTypeViewTmp];
            if ([self->mDicFilterInfo.allKeys containsObject:@"leaseType"]&&[[self->mDicFilterInfo objectForKey:@"leaseType"]containsObject:@(leaseTypeViewTmp.code)]) {
                leaseTypeViewTmp.checkBoxBtn.selected = YES;
            }
        }
        [self getHouseTypeView];
        
    }];
    //守则
    
}
- (void)getNoticeListView{
    [self getRequestListWithUrl:@"/notice" :^(NSDictionary *dictData) {
        NSArray *arrNoticeList = [dictData objectForKey:@"result"];
        UILabel *noticeLabel = [CustomizeView createLabelWithFrame:CGRectMake(18, self->mEquipmentTypeView.frame.origin.y + self->mEquipmentTypeView.frame.size.height + 17, 60, 20) :14 :@"PingFangSC-regular" :[UIColor colorWithRed:16.0/255.0 green:16.0/255.0 blue:16.0/255.0 alpha:1.0] :NSTextAlignmentLeft];
        noticeLabel.text = @"守则";
        [self->mShowAllFilterView addSubview:noticeLabel];
        int rows = (int)arrNoticeList.count;
        self->mNoticeView = [[UIView alloc]initWithFrame:CGRectMake(0, noticeLabel.frame.origin.y+noticeLabel.frame.size.height+7, SCREEN_WIDTH, 20*rows+7*(rows-1))];
        [self->mShowAllFilterView addSubview:self->mNoticeView];
        for (int i = 0; i < rows; i ++) {
            NoticeTypeView *noticeTypeViewTmp = [[NoticeTypeView alloc]initWithFrame:CGRectMake(0, i*27, SCREEN_WIDTH, 27)];
            noticeTypeViewTmp.descriptionLabel.text = [[arrNoticeList objectAtIndex:i]objectForKey:@"description"];
            noticeTypeViewTmp.code = [[[arrNoticeList objectAtIndex:i]objectForKey:@"code"]intValue];
            [self->mNoticeView addSubview:noticeTypeViewTmp];
            if ([self->mDicFilterInfo.allKeys containsObject:@"notice"]&&[[self->mDicFilterInfo objectForKey:@"notice"]containsObject:@(noticeTypeViewTmp.code)]) {
                noticeTypeViewTmp.checkBoxBtn.selected = YES;
            }
        }
        UIButton *confirmButton = [self createButtonWithFrame:CGRectMake(12, self->mNoticeView.frame.origin.y+self->mNoticeView.frame.size.height+37, SCREEN_WIDTH - 24, 36) :@"确定" :[UIColor whiteColor] :THEMECOLOR :@selector(confirmButtonPress)];
        [self->mShowAllFilterView addSubview:confirmButton];
        self->mShowAllFilterView.contentSize = CGSizeMake(SCREEN_WIDTH, confirmButton.frame.origin.y+confirmButton.frame.size.height + 80);
    }];
}
- (void)getHouseTypeView{
    //房源类型
    [self getRequestListWithUrl:@"/houseTypeMap" :^(NSDictionary *dictData) {
        NSArray *allHouseType = [dictData objectForKey:@"result"];
        UILabel *houseTypeLabel = [CustomizeView createLabelWithFrame:CGRectMake(18, self->mLeaseTypeView.frame.origin.y + self->mLeaseTypeView.frame.size.height + 12, 60, 20) :14 :@"PingFangSC-regular" :[UIColor colorWithRed:16.0/255.0 green:16.0/255.0 blue:16.0/255.0 alpha:1.0] :NSTextAlignmentLeft];
        houseTypeLabel.text = @"房源类型";
        [self->mShowAllFilterView addSubview:houseTypeLabel];
        int rows = ceil(allHouseType.count*1.0/5.0);//
        self->mHouseTypeView = [[UIView alloc]initWithFrame:CGRectMake(0, houseTypeLabel.frame.origin.y+houseTypeLabel.frame.size.height+7, SCREEN_WIDTH, 7+30*rows+8*(rows-1))];
        [self->mShowAllFilterView addSubview:self->mHouseTypeView];
        double space = (SCREEN_WIDTH - 15 - 8 - 64*5)/4;
        for (int i = 0; i < allHouseType.count; i ++) {
            NSDictionary *houseTypeInfo = [allHouseType objectAtIndex:i];
            UIButton *houseTypeBtn = [self createButtonWithFrameAndBorder:CGRectMake(15+(64+space)*(i%5), (30+8)*floor(i/5), 64, 30) :[houseTypeInfo objectForKey:@"description"] :[[houseTypeInfo objectForKey:@"code"]intValue] :@selector(houseTypeClick:)];
            [self->mHouseTypeView addSubview:houseTypeBtn];
            if ([self->mDicFilterInfo.allKeys containsObject:@"houseType"]&&[[self->mDicFilterInfo objectForKey:@"houseType"]containsObject:@(houseTypeBtn.tag)]) {
                houseTypeBtn.selected = YES;
                houseTypeBtn.backgroundColor = THEMECOLOR;
            }
        }
        [self getEquipmentListView];
    }];
}
- (void)getEquipmentListView{
    //设备类型
    [self getRequestListWithUrl:@"/equipmentList" :^(NSDictionary *dictData) {
        NSDictionary *allEquipmentList = [dictData objectForKey:@"result"];
        int count = 0;
        for (int i = 0; i < allEquipmentList.allKeys.count; i ++) {
            NSDictionary *equipmentInfo = [allEquipmentList objectForKey:[allEquipmentList.allKeys objectAtIndex:i]];
            count += [[equipmentInfo objectForKey:@"equipmentList"] count];
        }
        
        UILabel *equipmentLabel = [CustomizeView createLabelWithFrame:CGRectMake(18, self->mHouseTypeView.frame.origin.y + self->mHouseTypeView.frame.size.height + 18, 60, 20) :14 :@"PingFangSC-regular" :[UIColor colorWithRed:16.0/255.0 green:16.0/255.0 blue:16.0/255.0 alpha:1.0] :NSTextAlignmentLeft];
        equipmentLabel.text = @"设施";
        [self->mShowAllFilterView addSubview:equipmentLabel];
        int rows = ceil(count*1.0/4.0);
        self->mEquipmentTypeView = [[UIView alloc]initWithFrame:CGRectMake(0, equipmentLabel.frame.origin.y+equipmentLabel.frame.size.height+7, SCREEN_WIDTH, 7+30*rows+8*(rows-1))];
        [self->mShowAllFilterView addSubview:self->mEquipmentTypeView];
        double space = (SCREEN_WIDTH - 21 - 19 - 73*4)/4;
        int m = 0;
        for (int i = 0; i < allEquipmentList.allKeys.count; i ++) {
            NSString *keyType = [allEquipmentList.allKeys objectAtIndex:i];
            NSDictionary *equipmentTypeInfo = [allEquipmentList objectForKey:keyType];
            NSArray *equipmentList = [equipmentTypeInfo objectForKey:@"equipmentList"] ;
            for (int j = 0; j < equipmentList.count; j ++) {
                EquipmentButton *houseTypeBtn = [[EquipmentButton alloc]initWithFrame:CGRectMake(21+(73+space)*(m%4), (30+8)*floor(m/4), 73, 30) :[[equipmentList objectAtIndex:j] objectForKey:@"description"] :[[[equipmentList objectAtIndex:j] objectForKey:@"code"]intValue] :self :@selector(equipmentTypeClick:)];
                houseTypeBtn.keyType = keyType;
                m++;
                [self->mEquipmentTypeView addSubview:houseTypeBtn];
                
                if ([self->mDicFilterInfo.allKeys containsObject:@"equipmentList"]&&[[[self->mDicFilterInfo objectForKey:@"equipmentList"]allKeys]containsObject:keyType] && [[[self->mDicFilterInfo objectForKey:@"equipmentList"]objectForKey:keyType] containsObject:@(houseTypeBtn.code)]) {
                    houseTypeBtn.selected = YES;
                    houseTypeBtn.backgroundColor = THEMECOLOR;
                }
            }
        }
        [self getNoticeListView];
    }];
}
- (UIScrollView *)createScrollViewWithFrame:(CGRect)frame{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:frame];
    [self.view addSubview:scrollView];
    UILabel *leaseTypeLabel = [CustomizeView createLabelWithFrame:CGRectMake(18, 5, 60, 20) :14 :@"PingFangSC-regular" :[UIColor colorWithRed:16.0/255.0 green:16.0/255.0 blue:16.0/255.0 alpha:1.0] :NSTextAlignmentLeft];
    leaseTypeLabel.text = @"出租类型";
    [scrollView addSubview:leaseTypeLabel];
    return scrollView;
}


- (void)getRequestListWithUrl:(NSString *)strUrl :(void(^)(NSDictionary *dictData))showDataInView{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@functions%@",BASE_URL,[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"khYEI0xFyAnVCUpO" forHTTPHeaderField:@"X-Parse-Application-Id"];
    NSURLSession *session =[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            //回到主线程 刷新数据 要是刷新就在这里面
            dispatch_async(dispatch_get_main_queue(), ^{
                showDataInView(dic);
            });
        }
        
    }];
    //启动任务
    [dataTask resume];
}

@end
