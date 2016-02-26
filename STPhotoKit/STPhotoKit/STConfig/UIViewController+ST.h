//
//  UIViewController+ST.h
//  STPhotoKit
//
//  Created by 沈兆良 on 16/2/26.
//  Copyright © 2016年 沈兆良. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ST)
/**
 *  1.是否获取相册
 *
 *  @return <#return value description#>
 */
- (BOOL) isAvailablePhotoLibrary;
/**
 *  2.是否获取相机
 *
 *  @return <#return value description#>
 */
- (BOOL) isAvailableCamera;
/**
 *  3.是否获取后置摄像头
 *
 *  @return <#return value description#>
 */
- (BOOL) isAvailableRearCamera;
/**
 *  4.是否获取前置摄像头
 *
 *  @return <#return value description#>
 */
- (BOOL) isAvailableFrontCamera;
/**
 *  5.是否支持拍照
 *
 *  @return <#return value description#>
 */
- (BOOL) canCameraSupportTakingPhotos;
/**
 *  6.是否支持获取相册视频
 *
 *  @return <#return value description#>
 */
- (BOOL) canUserPickVideosFromPhotoLibrary;
/**
 *  7.是否支持获取相册图片
 *
 *  @return <#return value description#>
 */
- (BOOL) canUserPickPhotosFromPhotoLibrary;
@end
