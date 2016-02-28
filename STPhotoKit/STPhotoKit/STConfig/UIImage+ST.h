//
//  UIImage+ST.h
//  STImageHead
//
//  Created by 沈兆良 on 16/2/25.
//  Copyright © 2016年 沈兆良. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ST)

+ (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage;
+ (UIImage *)imageWithClipImage:(UIImage *)image
                          frame:(CGRect)frame;

+ (UIImage *)imageWithClipImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)color;

/**
 *  指定区域图片的截图
 *
 *  @param sourceImage 原始图片
 *  @param clipRect    截取范围
 *
 *  @return 截图图片
 */
+ (UIImage *)imageWithSourceImage:(UIImage *)sourceImage
                         clipRect:(CGRect)clipRect;
@end
