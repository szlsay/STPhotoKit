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
#import "UIImagePickerController+ST.h"
#import "STConfig.h"

typedef NS_ENUM(NSInteger, PhotoType)
{
    PhotoTypeIcon,
    PhotoTypeRectangle,
    PhotoTypeRectangle1
};

@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, STPhotoKitDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;
@property (weak, nonatomic) IBOutlet UIImageView *imageRectangle;
@property (weak, nonatomic) IBOutlet UIImageView *imageRectangle1;

@property (nonatomic, assign) PhotoType type;


@end

@implementation ViewController

#pragma mark - --- lift cycle 生命周期 ---
- (void)viewDidLoad {

    [super viewDidLoad];

    UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectedIcon)];
    [self.imageIcon addGestureRecognizer:tap0];

    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectedRectangle)];
    [self.imageRectangle addGestureRecognizer:tap1];

    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectedRectangle1)];
    [self.imageRectangle1 addGestureRecognizer:tap2];
}

- (void)selectedIcon
{
    self.type = PhotoTypeIcon;
    [self editImageSelected];
}

- (void)selectedRectangle{
    self.type = PhotoTypeRectangle;
    [self editImageSelected];
}

- (void)selectedRectangle1{
    self.type = PhotoTypeRectangle1;
    [self editImageSelected];
}
#pragma mark - --- delegate 视图委托 ---

#pragma mark - 1.STPhotoKitDelegate的委托

- (void)photoKitController:(STPhotoKitController *)photoKitController resultImage:(UIImage *)resultImage
{
    switch (self.type) {
        case PhotoTypeIcon:
            self.imageIcon.image = resultImage;
            break;
        case PhotoTypeRectangle:
            self.imageRectangle.image = resultImage;
            break;
        case PhotoTypeRectangle1:
            self.imageRectangle1.image = resultImage;
            break;
        default:
            break;
    }
}

#pragma mark - 2.UIImagePickerController的委托

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *imageOriginal = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        STPhotoKitController *photoVC = [STPhotoKitController new];
        [photoVC setDelegate:self];
        [photoVC setImageOriginal:imageOriginal];
        switch (self.type) {
            case PhotoTypeIcon:
//                [photoVC setRectClip:CGRectMake(100, 200, 50, 50)];
                break;
            case PhotoTypeRectangle:
//                 [photoVC setRectClip:CGRectMake(100, 200, 100, 50)];
                break;
            case PhotoTypeRectangle1:
//                 [photoVC setRectClip:CGRectMake(100, 200, 50, 100)];
                break;
            default:
                break;
        }


        [self presentViewController:photoVC animated:YES completion:nil];
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
        UIImagePickerController *controller = [UIImagePickerController imagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];

        if ([controller isAvailableCamera] && [controller isSupportTakingPhotos]) {
            [controller setDelegate:self];
            [self presentViewController:controller animated:YES completion:nil];
        }else {
            NSLog(@"%s %@", __FUNCTION__, @"相机权限受限");
        }
    }];

    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"从相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *controller = [UIImagePickerController imagePickerControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [controller setDelegate:self];
        if ([controller isAvailablePhotoLibrary]) {
            [self presentViewController:controller animated:YES completion:nil];
        }    }];

    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    }];

    [alertController addAction:action0];
    [alertController addAction:action1];
    [alertController addAction:action2];

    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - --- private methods 私有方法 ---

#pragma mark - --- getters and setters 属性 ---
@end
