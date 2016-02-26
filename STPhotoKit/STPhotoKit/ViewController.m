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
@property (nonatomic, strong) UIImageView *imageHead;
/** 2.获取的原图 */
@property (nonatomic, strong) UIImageView *imageSource;
/** 3.修剪后的图 */
@property (nonatomic, strong) UIImageView *imageCrop;
@end

@implementation ViewController

#pragma mark - --- lift cycle 生命周期 ---
- (void)viewDidLoad {

    [super viewDidLoad];
    [self.view addSubview:self.imageHead];
    [self.view addSubview:self.imageSource];
    [self.view addSubview:self.imageCrop];
}
#pragma mark - --- delegate 视图委托 ---

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self editImageSelected];
}

#pragma mark - 1.STPhotoKitDelegate的委托

- (void)photoKitController:(STPhotoKitController *)photoKitController resultImage:(UIImage *)resultImage
{
    [self.imageCrop setImage:resultImage];
    self.imageHead.image = resultImage;
}

#pragma mark - 2.UIImagePickerController的委托

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *imageOriginal = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [self.imageSource setImage:imageOriginal];
        imageOriginal = [UIImage imageByScalingToMaxSize:imageOriginal];
        STPhotoKitController *imageCropperVC = [[STPhotoKitController alloc]init];
        imageCropperVC.imageOriginal = imageOriginal;
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
        CGFloat imageW = 50;
        CGFloat imageH = imageW;
        CGFloat imageX = 0;
        CGFloat imageY = 260;
        _imageHead = [[UIImageView alloc]initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
        [_imageHead setCenterX:ScreenWidth/2];
        [_imageHead.layer setCornerRadius:imageW/2];
        [_imageHead.layer setMasksToBounds:YES];
        [_imageHead.layer setBorderColor:[UIColor orangeColor].CGColor];
        [_imageHead.layer setBorderWidth:0.5];

        [_imageHead setContentMode:UIViewContentModeScaleAspectFill];
        [_imageHead setBackgroundColor:[UIColor whiteColor]];
        [_imageHead setUserInteractionEnabled:YES];
        
    }
    return _imageHead;
}

- (UIImageView *)imageSource
{
    if (!_imageSource) {
        CGFloat imageW = 100;
        CGFloat imageH = imageW;
        CGFloat imageX = 0;
        CGFloat imageY = 20;
        _imageSource = [[UIImageView alloc]initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
        [_imageSource setCenterX:ScreenWidth/2];
        [_imageSource.layer setBorderColor:[UIColor blueColor].CGColor];
        [_imageSource.layer setBorderWidth:0.5];
        [_imageSource setContentMode:UIViewContentModeScaleAspectFit];

    }
    return _imageSource;

}

- (UIImageView *)imageCrop
{
    if (!_imageCrop) {
        CGFloat imageW = 100;
        CGFloat imageH = imageW;
        CGFloat imageX = 0;
        CGFloat imageY = 140;
        _imageCrop = [[UIImageView alloc]initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
         [_imageCrop setCenterX:ScreenWidth/2];
        [_imageCrop.layer setBorderColor:[UIColor blueColor].CGColor];
        [_imageCrop.layer setBorderWidth:0.5];
        [_imageCrop setContentMode:UIViewContentModeScaleAspectFit];


    }
    return _imageCrop;
    
}



@end
