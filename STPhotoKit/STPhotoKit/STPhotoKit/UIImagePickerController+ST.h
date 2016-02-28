//
//  UIImagePickerController+ST.h
//  STPhotoKit
//
//  Created by 沈兆良 on 16/2/26.
//  Copyright © 2016年 沈兆良. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImagePickerController (ST)
/**
 *  1.是否相册可用
 *
 *  @return <#return value description#>
 */
- (BOOL) isAvailablePhotoLibrary;
/**
 *  2.是否相机可用
 *
 *  @return <#return value description#>
 */
- (BOOL) isAvailableCamera;
/**
 *  3.是否可以保存相册可用
 *
 *  @return <#return value description#>
 */
- (BOOL) isAvailableSavedPhotosAlbum;
/**
 *  4.是否后置摄像头可用
 *
 *  @return <#return value description#>
 */
- (BOOL) isAvailableCameraDeviceRear;
/**
 *  5.是否前置摄像头可用
 *
 *  @return <#return value description#>
 */
- (BOOL) isAvailableCameraDeviceFront;

/**
 *  6.是否支持拍照权限
 *
 *  @return <#return value description#>
 */
- (BOOL) isSupportTakingPhotos;

/**
 *  7.是否支持获取相册视频权限
 *
 *  @return <#return value description#>
 */
- (BOOL)isSupportPickVideosFromPhotoLibrary;

/**
 *  8.是否支持获取相册图片权限
 *
 *  @return <#return value description#>
 */
- (BOOL) isSupportPickPhotosFromPhotoLibrary;

+ (UIImagePickerController *)imagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType;
@end
