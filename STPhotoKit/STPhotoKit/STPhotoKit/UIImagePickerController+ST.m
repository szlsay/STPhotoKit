//
//  UIImagePickerController+ST.m
//  STPhotoKit
//
//  Created by 沈兆良 on 16/2/26.
//  Copyright © 2016年 沈兆良. All rights reserved.
//

#import "UIImagePickerController+ST.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
@implementation UIImagePickerController (ST)
/**
 *  1.是否相册可用
 *
 *  @return <#return value description#>
 */
- (BOOL) isAvailablePhotoLibrary{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}

/**
 *  2.是否相机可用
 *
 *  @return <#return value description#>
 */
- (BOOL) isAvailableCamera{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

/**
 *  3.是否可以保存相册可用
 *
 *  @return <#return value description#>
 */
- (BOOL) isAvailableSavedPhotosAlbum{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
}

/**
 *  4.是否后置摄像头可用
 *
 *  @return <#return value description#>
 */
- (BOOL) isAvailableCameraDeviceRear{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}
/**
 *  5.是否前置摄像头可用
 *
 *  @return <#return value description#>
 */
- (BOOL)isAvailableCameraDeviceFront{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

/**
 *  6.是否支持拍照权限
 *
 *  @return <#return value description#>
 */
- (BOOL) isSupportTakingPhotos{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        return NO;
    }else {
        return YES;
    }
}
/**
 *  7.是否支持获取相册视频权限
 *
 *  @return <#return value description#>
 */
- (BOOL)isSupportPickVideosFromPhotoLibrary{
    return [self isSupportsMedia:(__bridge NSString *)kUTTypeMovie
                      sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
/**
 *  8.是否支持获取相册图片权限
 *
 *  @return <#return value description#>
 */
- (BOOL) isSupportPickPhotosFromPhotoLibrary{
    return [self isSupportsMedia:(__bridge NSString *)kUTTypeImage
                      sourceType:UIImagePickerControllerSourceTypePhotoLibrary];

}

- (BOOL)isSupportsMedia:(NSString *)mediaType sourceType:(UIImagePickerControllerSourceType)sourceType
{
    __block BOOL result = NO;
    if ([mediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:mediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;

}

+ (UIImagePickerController *)imagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController *controller = [[UIImagePickerController alloc]init];
    [controller setSourceType:sourceType];
    [controller setMediaTypes:@[(NSString *)kUTTypeImage]];
    return controller;
}


@end
