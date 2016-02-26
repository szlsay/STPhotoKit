//
//  UIViewController+ST.m
//  STPhotoKit
//
//  Created by 沈兆良 on 16/2/26.
//  Copyright © 2016年 沈兆良. All rights reserved.
//

#import "UIViewController+ST.h"
#import <MobileCoreServices/MobileCoreServices.h>
@implementation UIViewController (ST)
/**
 *  1.是否获取相册
 *
 *  @return <#return value description#>
 */
- (BOOL) isAvailablePhotoLibrary{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}
/**
 *  2.是否获取相机
 *
 *  @return <#return value description#>
 */
- (BOOL) isAvailableCamera{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}
/**
 *  3.是否获取后置摄像头
 *
 *  @return <#return value description#>
 */
- (BOOL) isAvailableRearCamera{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}
/**
 *  4.是否获取前置摄像头
 *
 *  @return <#return value description#>
 */
- (BOOL) isAvailableFrontCamera{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}
/**
 *  5.是否支持拍照
 *
 *  @return <#return value description#>
 */
- (BOOL) canCameraSupportTakingPhotos{
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}
/**
 *  6.是否支持获取相册视频
 *
 *  @return <#return value description#>
 */
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
/**
 *  7.是否支持获取相册图片
 *
 *  @return <#return value description#>
 */
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];

}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}
@end
