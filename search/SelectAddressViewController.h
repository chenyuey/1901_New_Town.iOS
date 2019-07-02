//
//  SelectAddressViewController.h
//  NewTown
//
//  Created by macbookpro on 2019/7/1.
//  Copyright © 2019 macbookpro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeader.h"
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectAddressViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
    UIScrollView *mScrollView;
    UIButton *mCurrentLocCity;
}
//左侧返回按钮
@property (nonatomic,strong) UIButton *backButton;

@property (nonatomic, strong) NSMutableDictionary *cities;

@property (nonatomic, strong) NSMutableArray *keys; //城市首字母
@property (nonatomic, strong) NSMutableArray *arrayCitys;   //城市数据

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong) CLLocationManager *locationManager;

@property (nonatomic, copy) void(^selectValueBlock)(NSString * valueStr);
@end

NS_ASSUME_NONNULL_END
