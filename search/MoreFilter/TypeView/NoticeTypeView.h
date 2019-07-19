//
//  NoticeTypeView.h
//  NewTown
//
//  Created by macbookpro on 2019/7/19.
//  Copyright © 2019 macbookpro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeTypeView : UIView
@property (nonatomic,strong) UILabel *descriptionLabel;
@property int code;
@property (nonatomic, strong) UIButton *checkBoxBtn;
@end

NS_ASSUME_NONNULL_END
