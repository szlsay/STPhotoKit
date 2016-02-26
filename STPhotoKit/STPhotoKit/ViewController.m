//
//  ViewController.m
//  STPhotoKit
//
//  Created by 沈兆良 on 16/2/26.
//  Copyright © 2016年 沈兆良. All rights reserved.
//

#import "ViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import "STPhotoKitController.h"
#import "STConfig.h"

@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, STPhotoKitDelegate>

/** 1.头像图片 */
@property (nullable, nonatomic, strong) UIImageView *imageHead;
@end

@implementation ViewController

#pragma mark - --- lift cycle 生命周期 ---
- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.imageHead];


}
#pragma mark - --- delegate 视图委托 ---


#pragma mark - 1.STPhotoKitDelegate的委托

- (void)photoKitController:(STPhotoKitController *)photoKitController resultImage:(UIImage *)resultImage
{
    self.imageHead.image = resultImage;
}

#pragma mark - 2.UIImagePickerController的委托

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *imageOriginal = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        imageOriginal = [UIImage imageByScalingToMaxSize:imageOriginal];
        STPhotoKitController *imageCropperVC = [[STPhotoKitController alloc]init];
        imageCropperVC.imageOriginal = imageOriginal;
        imageCropperVC.cropFrame = CGRectMake(0, 100, ScreenWidth, ScreenWidth);
        imageCropperVC.limitRatio = 3.0;
        imageCropperVC.delegate = self;
        [self presentViewController:imageCropperVC animated:YES completion:nil];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}


#pragma mark - --- event response 事件相应 ---
- (void)editImageSelected
{
    UIAlertController *alertController = [[UIAlertController alloc]init];

    UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePicture];
    }];

    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"从相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"%s %@", __FUNCTION__, action.title);
        [self photoAlbum];
    }];

    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"%s %@", __FUNCTION__, action.title);
    }];

    [alertController addAction:action0];
    [alertController addAction:action1];
    [alertController addAction:action2];

    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)takePicture
{
    // 拍照
    if ([self isAvailableCamera] && [self canCameraSupportTakingPhotos]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([self isAvailableFrontCamera]) {
            controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        [self presentViewController:controller
                           animated:YES
                         completion:^(void){
                         }];
    }

}

- (void)photoAlbum{
    // 从相册中选取
    if ([self isAvailablePhotoLibrary]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        [self presentViewController:controller
                           animated:YES
                         completion:^(void){
                         }];
    }

}
#pragma mark - --- private methods 私有方法 ---

#pragma mark - --- getters and setters 属性 ---

- (UIImageView *)imageHead
{
    if (!_imageHead) {
        CGFloat imageW = 100;
        CGFloat imageH =imageW;
        CGFloat imageX = 100;
        CGFloat imageY = 300;
        _imageHead = [[UIImageView alloc]initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];

        [_imageHead.layer setCornerRadius:imageW/2];
        [_imageHead.layer setMasksToBounds:YES];
        [_imageHead.layer setBorderColor:[UIColor orangeColor].CGColor];
        [_imageHead.layer setBorderWidth:0.5];

        [_imageHead setContentMode:UIViewContentModeScaleAspectFill];
        [_imageHead setBackgroundColor:[UIColor whiteColor]];
        [_imageHead setUserInteractionEnabled:YES];

        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editImageSelected)];
        [_imageHead addGestureRecognizer:imageTap];
        
    }
    return _imageHead;
}

@end
