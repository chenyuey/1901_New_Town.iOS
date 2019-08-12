//
//  SaveImage_Util.h
//  NewTown
//
//  Created by macbookpro on 2019/8/12.
//  Copyright © 2019 macbookpro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SaveImage_Util : NSObject

#pragma mark  保存图片到document
+ (BOOL)saveImage:(UIImage *)saveImage ImageName:(NSString *)imageName back:(void(^)(NSString *imagePath))back;
@end

NS_ASSUME_NONNULL_END
