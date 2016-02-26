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

//+ (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage;

//+ (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize;
@end
