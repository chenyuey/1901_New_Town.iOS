//
//  EquipmentButton.h
//  NewTown
//
//  Created by cy on 2019/7/18.
//  Copyright © 2019 cy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EquipmentButton : UIButton
@property(nonatomic,strong) NSString *keyType;
@property int code;
@property (nonatomic,strong) NSString *descriptionValue;
-(id)initWithFrame:(CGRect)frame :(NSString *)title :(int)eqCode :(id)target :(SEL)event;
@end

NS_ASSUME_NONNULL_END
