//
//  UIImage+LXExtension.m
//  linktrustEduTeacher
//
//  Created by chenliang on 16/12/13.
//  Copyright © 2016年 linktrust. All rights reserved.
//

#import "UIImage+LXExtension.h"

@implementation UIImage (LXExtension)


/**
 *  将一张UIImage scale 至 某个尺寸的UIImage
 *
 *  @param name    可拉升图片的图片名
 *  @param newSize 新尺寸
 *
 *  @return 加工之后的图片
 */
+ (UIImage *)resizedImageName:(NSString *)name scaledToSize:(CGSize)newSize{
    
    UIImage *image = [UIImage imageNamed:name];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.bounds = CGRectMake(0, 0, newSize.width, newSize.height);
    return [UIImage captureWithView:imageView];
}

/**
 *  将一张UIImage scale 至 某个尺寸的UIImage
 *
 *  @param img     可拉升图片
 *  @param newSize 新尺寸
 *
 *  @return 加工之后的图片
 */
+ (UIImage *)resizedImage:(UIImage *)img scaledToSize:(CGSize)newSize{
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
    imageView.bounds = CGRectMake(0, 0, newSize.width, newSize.height);
    return [UIImage captureWithView:imageView];
}

/**
 *  给指定的view截图
 *
 *  @param view 指定的View
 *
 *  @return 一张截图
 */
+ (UIImage* )captureWithView:(UIView *)view
{
    return [UIImage imageWithView:view scaledToSize:view.frame.size];
}

/**
 *  给指定的view截图
 *
 *  @param view 指定的View
 *  @param newSize 新的尺寸
 *  @return 一张截图
 */
+ (UIImage *)imageWithView:(UIView *)view scaledToSize:(CGSize)newSize
{
    // 1.开启上下文
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    //将当前的view的图层呈现在当前上下文，获取某个图层的图片 view的layer渲染到上下文
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    // 3.取出图片
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 4.结束上下文
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 *  根据制定的颜色绘制一张图片
 *  @param size  图片的尺寸
 *  @param color  图片的颜色
 *  @param alpha  图片的alpha
 */
+ (UIImage *)imageWithSize:(CGSize)size PureColor:(UIColor *)color alpha:(CGFloat )alpha{
    UIGraphicsBeginImageContextWithOptions(size, 0, 0.0);
    [[color colorWithAlphaComponent:alpha] set];
    UIRectFill((CGRect){{0,0},size});
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image resizableImageWithCapInsets:UIEdgeInsetsZero];
}

/**
 *  根据制定的颜色绘制一张图片
 *  @param size  图片的尺寸
 *  @param color  图片的颜色
 *  @param alpha  图片的alpha
 */
+ (UIImage *)circleImageWithPureColor:(UIColor *)color size:(CGSize)size alpha:(CGFloat )alpha{
    
    UIGraphicsBeginImageContextWithOptions(size, 0, 0.0);
    [[color colorWithAlphaComponent:alpha] set];
    [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size.width, size.height)] fill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 *  生成小红点 图片
 */
+ (UIImage *)redCircleImage
{
    return [self circleImageWithPureColor:[UIColor redColor] size:CGSizeMake(5, 5) alpha:0];
}


//根据文件名生成一张,图片的位置在[NSBundel mainBundle]中,就是俗称的沙盒
+ (UIImage *)imageWithFileName:(NSString *)name {
    NSString *imagePath = [[NSBundle mainBundle]pathForResource:name ofType:@"png"];
    return [UIImage imageWithContentsOfFile:imagePath];
    
}

// 因为你让backgroundImage根据文字的font进行拉伸....可能不会好看....  返回一张可以自由拉伸的图片......
+ (UIImage*)resizedImageWithName:(NSString*)imageName{
    
    return [self resizedImageWithName:imageName left:.5f height:.5f];;
}

//生成一张可以自由拉伸的图片
+ (UIImage *)resizedImageWithName:(NSString *)imageName left:(CGFloat)left height:(CGFloat)height
{
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image stretchableImageWithLeftCapWidth:left*image.size.width topCapHeight:height*image.size.height];
    return image;
}

//生成一张质量[compressionQuality／压缩/处理]的图片
+ (UIImage *) handleImageWithImage:(UIImage *)image{
    NSData *data = UIImageJPEGRepresentation(image, 0.0001);
    return [[UIImage alloc] initWithData:data];
}

//根据自定义中的.bundle中的图片名名生成一张图片
+ (UIImage *) imageWithBundleName:(NSString *)name imageName:(NSString *)imageName{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"bundle"
                          ];
    filePath = [filePath stringByAppendingPathComponent:imageName];
    return [UIImage imageWithContentsOfFile:filePath];
}


/**
 图片切割成圆形

 @param img 传入图片 UIImage
 @return    切割完的图片
 */
+ (UIImage *)circleImageWithImage:(UIImage *)img
{
    UIGraphicsBeginImageContextWithOptions(img.size, NO, 1.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    CGContextClip(ctx);
    [img drawInRect:rect];
    
    UIImage *circleImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return circleImg;
}
/**
 修正拍照旋转
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage
{
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width,0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width,0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height,0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx =CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                            CGImageGetBitsPerComponent(aImage.CGImage),0,
                                            CGImageGetColorSpace(aImage.CGImage),
                                            CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx,CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
        default:
            CGContextDrawImage(ctx,CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg =CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    
    return img;
}
/**
 等比例缩放图片
 
 @param image 传入图片 UIImage
 @param scaleSize 缩放大小
 @return 缩放后的图片
 */
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize

{
//    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize), NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
+ (UIImage *)scaleImage:(UIImage *)image toScaleWith:(float)scaleSize toScaleHeight:(float)scaleHeight{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize), YES, 0.0);
//    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleHeight));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleHeight)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
                                

- (UIImage *)drawRectWithRoundedCorner
{
    CGRect rect = CGRectMake(0.f, 0.f, 150.f, 150.f);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:rect.size.width * 0.5];
    UIGraphicsBeginImageContextWithOptions(rect.size, false, [UIScreen mainScreen].scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(), bezierPath.CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    [self drawInRect:rect];
    
    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return output;
}

- (UIImage *)circleImage {
    
    // 开始图形上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    // 获得图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 设置一个范围
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    // 根据一个rect创建一个椭圆
    CGContextAddEllipseInRect(ctx, rect);
    
    // 裁剪
    CGContextClip(ctx);
    
    // 将原照片画到图形上下文
    [self drawInRect:rect];
    
    // 从上下文上获取剪裁后的照片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}
/**
 截图
 
 @param image 传入图片 UIImage
 @param rect 截取位置
 @return 截取后的图片
 */
+ (UIImage *)ct_imageFromImage:(UIImage *)image inRect:(CGRect)rect{
    
    //把像 素rect 转化为 点rect（如无转化则按原图像素取部分图片）
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat x= rect.origin.x*scale,y=rect.origin.y*scale,w=rect.size.width*scale,h=rect.size.height*scale;
    CGRect dianRect = CGRectMake(x, y, w, h);
    
    //截取部分图片并生成新图片
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, dianRect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    return newImage;
}

@end
