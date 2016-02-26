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
    return [self imageCroppingForSourceImage:sourceImage targetSize:targetSize];
}



+ (UIImage *)imageCroppingForSourceImage:(UIImage *)sourceImage  targetSize:(CGSize)targetSize
{

    UIImage *newImage;

    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;

    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);

    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;

        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width

        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;

        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;

    [sourceImage drawInRect:thumbnailRect];

    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");

    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}


//获得屏幕图像
- (UIImage *)imageFromView: (UIView *) theView
{

    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return theImage;
}

//获得某个范围内的屏幕图像
- (UIImage *)imageFromView: (UIView *) theView   atFrame:(CGRect)r
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(r);
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return  theImage;//[self getImageAreaFromImage:theImage atFrame:r];
}

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
@end
