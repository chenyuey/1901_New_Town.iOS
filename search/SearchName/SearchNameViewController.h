//
//  SearchNameViewController.h
//  NewTown
//
//  Created by cy on 2019/7/6.
//  Copyright © 2019 cy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeader.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface SearchNameViewController : UIViewController<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>{
    UISearchBar *mSearchBarView;
    UITableView *mShowAddressTableview;
    NSArray *mAddressList;
    NSString *mStrCity;
}
@property(nonatomic,copy) void(^selectCheckDateBlock)(NSString *homeName);
//左侧返回按钮
@property (nonatomic,strong) UIButton *backButton;
/**
 *  地理编码对象
 */
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, copy) void(^selectValueBlock)(CLPlacemark * valueStr);
- (id)initWithCityName:(NSString *)strCityName;
@end

NS_ASSUME_NONNULL_END
