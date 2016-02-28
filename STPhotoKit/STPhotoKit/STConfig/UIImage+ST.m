//
//  UIImage+ST.m
//  STImageHead
//
//  Created by 沈兆良 on 16/2/25.
//  Copyright © 2016年 沈兆良. All rights reserved.
//

#import "UIImage+ST.h"
#import "STConst.h"

@implementation UIImage (ST)
+ (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {

    CGFloat maxWidth = ScreenWidth * 2;
    if (sourceImage.size.width < maxWidth) return sourceImage;

    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = maxWidth;
        btWidth = sourceImage.size.width * (maxWidth / sourceImage.size.height);
    } else {
        btWidth = maxWidth;
        btHeight = sourceImage.size.height * (maxWidth / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return  [self imageWithSourceImage:sourceImage scaleSize:targetSize];
//    return [self imageCroppingForSourceImage:sourceImage targetSize:targetSize];
}


//
//+ (UIImage *)imageCroppingForSourceImage:(UIImage *)sourceImage  targetSize:(CGSize)targetSize
//{
//
//    UIImage *newImage;
//
//    CGSize imageSize = sourceImage.size;
//    CGFloat width = imageSize.width;
//    CGFloat height = imageSize.height;
//    CGFloat targetWidth = targetSize.width;
//    CGFloat targetHeight = targetSize.height;
//
//    CGFloat scaleFactor = 0.0;
//    CGFloat scaledWidth = targetWidth;
//    CGFloat scaledHeight = targetHeight;
//    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
//
//    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
//    {
//        CGFloat widthFactor = targetWidth / width;
//        CGFloat heightFactor = targetHeight / height;
//
//        if (widthFactor > heightFactor)
//            scaleFactor = widthFactor; // scale to fit height
//        else
//            scaleFactor = heightFactor; // scale to fit width
//
//        scaledWidth  = width * scaleFactor;
//        scaledHeight = height * scaleFactor;
//
//        // center the image
//        if (widthFactor > heightFactor)
//        {
//            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
//        }
//        else
//            if (widthFactor < heightFactor)
//            {
//                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
//            }
//    }
//    UIGraphicsBeginImageContext(targetSize); // this will crop
//    CGRect thumbnailRect = CGRectZero;
//    thumbnailRect.origin = thumbnailPoint;
//    thumbnailRect.size.width  = scaledWidth;
//    thumbnailRect.size.height = scaledHeight;
//
//    [sourceImage drawInRect:thumbnailRect];
//
//    newImage = UIGraphicsGetImageFromCurrentImageContext();
//    if(newImage == nil) NSLog(@"could not scale image");
//
//    //pop the context to get back to the default
//    UIGraphicsEndImageContext();
//    return newImage;
//}



/**
 *  绘制图片圆角
 *
 *  @param image       <#image description#>
 *  @param borderWidth <#borderWidth description#>
 *  @param color       <#color description#>
 *
 *  @return <#return value description#>
 */


+ (UIImage *)imageWithClipImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)color
{
    // 图片的宽度和高度
    CGFloat imageWH = image.size.width;

    // 设置圆环的宽度
    CGFloat border = borderWidth;

    // 圆形的宽度和高度
    CGFloat ovalWH = imageWH + 2 * border;

    // 1.开启上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(ovalWH, ovalWH), NO, 0);

    // 2.画大圆
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, ovalWH, ovalWH)];

    [color set];

    [path fill];

    // 3.设置裁剪区域
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(border, border, imageWH, imageWH)];
    [clipPath addClip];

    // 4.绘制图片
    [image drawAtPoint:CGPointMake(border, border)];

    // 5.获取图片
    UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();

    // 6.关闭上下文
    UIGraphicsEndImageContext();

    return clipImage;
}

/**
 *  指定区域图片的截图
 *
 *  @param sourceImage 原始图片
 *  @param clipRect    截取范围
 *
 *  @return 截图图片
 */
+ (UIImage *)imageWithSourceImage:(UIImage *)sourceImage
                          clipRect:(CGRect)clipRect
{
    CGImageRef imageRef = sourceImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, clipRect);
    CGSize imageSize = clipRect.size;
    UIGraphicsBeginImageContext(imageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, clipRect, subImageRef);
    UIImage *clipImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    return clipImage;
}

/**
 *  指定图片的比例
 *
 *  @param sourceImage <#sourceImage description#>
 *  @param scaleSize   <#scaleSize description#>
 *
 *  @return <#return value description#>
 */
+ (UIImage *)imageWithSourceImage:(UIImage *)sourceImage
                        scaleSize:(CGSize)scaleSize
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(scaleSize);

    // 绘制改变大小的图片
    [sourceImage drawInRect:CGRectMake(0, 0, scaleSize.width, scaleSize.height)];

    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();

    // 使当前的context出堆栈
    UIGraphicsEndImageContext();

    // 返回新的改变大小后的图片
    return scaledImage;
}

@end
