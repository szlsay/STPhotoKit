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
/** 2.修剪的尺寸,默认是 CGSizeMake(ScreenWidth, ScreenWidth) */
@property (nonatomic, assign) CGSize sizeCrop;

@property (nullable, nonatomic, weak)id <STPhotoKitDelegate>delegate ;


@property (nonatomic, assign) CGRect cropFrame;

@property (nonatomic, retain) UIImage *editedImage;


@property (nonatomic, retain) UIView *ratioView;

@property (nonatomic, assign) CGRect oldFrame;
@property (nonatomic, assign) CGRect largeFrame;
@property (nonatomic, assign) CGFloat limitRatio;

@property (nonatomic, assign) CGRect latestFrame;

@end

NS_ASSUME_NONNULL_END