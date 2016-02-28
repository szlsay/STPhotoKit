//
//  STPhotoKitController.h
//  STPhotoKit
//
//  Created by 沈兆良 on 16/2/26.
//  Copyright © 2016年 沈兆良. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class STPhotoKitController;

@protocol STPhotoKitDelegate <NSObject>
- (void)photoKitController:(STPhotoKitController *)photoKitController
               resultImage:(UIImage *)resultImage;

@end

@interface STPhotoKitController : UIViewController


/** 1.原始图片, 必须设置*/
@property (nonatomic, strong) UIImage *imageOriginal;


@property (nullable, nonatomic, weak)id <STPhotoKitDelegate>delegate ;

/** 剪切的范围 */
@property (nonatomic, assign) CGRect rectClip;


@end

NS_ASSUME_NONNULL_END