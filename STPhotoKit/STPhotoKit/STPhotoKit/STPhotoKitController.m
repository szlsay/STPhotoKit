//
//  STPhotoKitController.m
//  STPhotoKit
//
//  Created by 沈兆良 on 16/2/26.
//  Copyright © 2016年 沈兆良. All rights reserved.
//

#import "STPhotoKitController.h"
#import "STConfig.h"

NS_ASSUME_NONNULL_BEGIN
@interface STPhotoKitController ()<UIGestureRecognizerDelegate>

/** 1.图片 */
@property (nonatomic, strong) UIImageView *imageView;
/** 2.取消按钮 */
@property (nonatomic, strong) UIButton *buttonCancel;
/** 3.确认按钮 */
@property (nonatomic, strong) UIButton *buttonConfirm;
/** 4.覆盖图 */
@property (nonatomic, strong) UIView *viewOverlay;
/** 5.中间比例视图 */
@property (nonatomic, strong) UIView *viewRatio;
/** 6.图片返回初始状态 */
@property (nonatomic, strong) UIButton *buttonBack;
@end

NS_ASSUME_NONNULL_END

@implementation STPhotoKitController

#pragma mark - --- lift cycle 生命周期 ---

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sizeCrop  = CGSizeMake(ScreenWidth - STMarginBig, ScreenWidth - STMarginBig);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.viewOverlay];
    [self.view addSubview:self.viewRatio];
    [self.view addSubview:self.buttonCancel];
    [self.view addSubview:self.buttonConfirm];
    [self.view addSubview:self.buttonBack];

    [self addGestureRecognizerToView:self.view];
}
#pragma mark - --- delegate 视图委托 ---

#pragma mark - --- event response 事件相应 ---
/**
 *  1.取消操作
 */
- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  2.确认操作
 */
- (void)confirm
{
//    if ([self.delegate respondsToSelector:@selector(photoKitController:resultImage:)]) {
//        [self.delegate photoKitController:self resultImage:[self getSubImage]];
//    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  3.返回原来位置
 */
- (void)recover
{
    [self.buttonBack setHidden:YES];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.imageView setTransform:CGAffineTransformMakeRotation(0)];
        [self.imageView setFrame:self.view.bounds];
    } completion:^(BOOL finished) {
    }];

}
/**
 *  4.处理旋转手势
 */
- (void)rotateView:(UIRotationGestureRecognizer *)rotationGestureRecognizer
{
    [self.buttonBack setHidden:NO];
    UIView *view = self.imageView;
    if (rotationGestureRecognizer.state == UIGestureRecognizerStateBegan || rotationGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformRotate(view.transform, rotationGestureRecognizer.rotation);
        [rotationGestureRecognizer setRotation:0];
    }
}
/**
 *  5.处理缩放手势
 */
- (void)pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
     [self.buttonBack setHidden:NO];
    UIView *view = self.imageView;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
}
/**
 *  6.处理拖拉手势
 */
- (void)panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
     [self.buttonBack setHidden:NO];
    UIView *view = self.imageView;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
}
#pragma mark - --- private methods 私有方法 ---
/**
 *  1.镂空中间的视图
 */
- (void)setupHollowUI
{
    NSLog(@"%s %@", __FUNCTION__, NSStringFromCGRect(self.viewRatio.frame));
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path appendPath:[UIBezierPath bezierPathWithRect:self.view.frame]];
    [path appendPath:[UIBezierPath bezierPathWithRect:self.viewRatio.frame].bezierPathByReversingPath];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    self.viewOverlay.layer.mask = maskLayer;
}

/**
 *  2.添加所有的手势
 */
- (void) addGestureRecognizerToView:(UIView *)view
{
    // 旋转手势
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateView:)];
    [view addGestureRecognizer:rotationGestureRecognizer];

    // 缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [view addGestureRecognizer:pinchGestureRecognizer];

    // 移动手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [view addGestureRecognizer:panGestureRecognizer];
}

//-(UIImage *)getSubImage{
//    CGRect squareFrame = self.cropFrame;
//    CGFloat scaleRatio = self.latestFrame.size.width / self.imageOriginal.size.width;
//    CGFloat x = (squareFrame.origin.x - self.latestFrame.origin.x) / scaleRatio;
//    CGFloat y = (squareFrame.origin.y - self.latestFrame.origin.y) / scaleRatio;
//    CGFloat w = squareFrame.size.width / scaleRatio;
//    CGFloat h = squareFrame.size.width / scaleRatio;
//    if (self.latestFrame.size.width < self.cropFrame.size.width) {
//        CGFloat newW = self.imageOriginal.size.width;
//        CGFloat newH = newW * (self.cropFrame.size.height / self.cropFrame.size.width);
//        x = 0; y = y + (h - newH) / 2;
//        w = newH; h = newH;
//    }
//    if (self.latestFrame.size.height < self.cropFrame.size.height) {
//        CGFloat newH = self.imageOriginal.size.height;
//        CGFloat newW = newH * (self.cropFrame.size.width / self.cropFrame.size.height);
//        x = x + (w - newW) / 2; y = 0;
//        w = newH; h = newH;
//    }
//    CGRect myImageRect = CGRectMake(x, y, w, h);
//    CGImageRef imageRef = self.imageOriginal.CGImage;
//    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
//    CGSize size;
//    size.width = myImageRect.size.width;
//    size.height = myImageRect.size.height;
//    UIGraphicsBeginImageContext(size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextDrawImage(context, myImageRect, subImageRef);
//    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
//    UIGraphicsEndImageContext();
//    return smallImage;
//}



#pragma mark - --- getters and setters 属性 ---

- (void)setImageOriginal:(UIImage *)imageOriginal
{
    _imageOriginal = imageOriginal;
    self.imageView.image = imageOriginal;
}

- (void)setSizeCrop:(CGSize)sizeCrop
{
    _sizeCrop = sizeCrop;

    self.viewRatio.bounds = CGRectMake(0, 0, sizeCrop.width, sizeCrop.height);
    self.viewRatio.center = self.view.center;
    [self.viewOverlay setHollowWithCenterFrame:self.viewRatio.frame];
}

/** 1.图片 */
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_imageView setUserInteractionEnabled:YES];
        [_imageView setMultipleTouchEnabled:YES];
    }
    return _imageView;
}
/** 2.取消按钮 */
- (UIButton *)buttonCancel
{
    if (!_buttonCancel) {
        CGFloat buttonW = 40;
        CGFloat buttonH = 28;
        CGFloat buttonX = STMarginBig;
        CGFloat buttonY = ScreenHeight - buttonH - STMarginBig;
        _buttonCancel = [[UIButton alloc]initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
        [_buttonCancel setBackgroundColor:RGBA(0, 0, 0, 50.0/255)];
        [_buttonCancel setTitle:@"取消" forState:UIControlStateNormal];
        [_buttonCancel setTitleColor:[UIColor whiteColor]
                            forState:UIControlStateNormal];
        [_buttonCancel.titleLabel setFont:[UIFont systemFontOfSize:14]];

        [_buttonCancel setClipsToBounds:YES];
        [_buttonCancel.layer setCornerRadius:2];
        [_buttonCancel.layer setBorderWidth:0.5];
        [_buttonCancel.layer setBorderColor:RGBA(255, 255, 255, 60.0/255).CGColor];
        [_buttonCancel addTarget:self
                          action:@selector(cancel)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonCancel;
}
/** 3.确认按钮 */
- (UIButton *)buttonConfirm
{
    if (!_buttonConfirm) {
        CGFloat buttonW = 40;
        CGFloat buttonH = 28;
        CGFloat buttonX = ScreenWidth - buttonW - STMarginBig;
        CGFloat buttonY = ScreenHeight - buttonH - STMarginBig;
        _buttonConfirm = [[UIButton alloc]initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
        [_buttonConfirm setBackgroundColor:RGBA(0, 0, 0, 50.0/255)];
        [_buttonConfirm setTitle:@"确定" forState:UIControlStateNormal];
        [_buttonConfirm setTitleColor:[UIColor whiteColor]
                             forState:UIControlStateNormal];
        [_buttonConfirm.titleLabel setFont:[UIFont systemFontOfSize:14]];

        [_buttonConfirm setClipsToBounds:YES];
        [_buttonConfirm.layer setCornerRadius:2];
        [_buttonConfirm.layer setBorderWidth:0.5];
        [_buttonConfirm.layer setBorderColor:RGBA(255, 255, 255, 60.0/255).CGColor];
        [_buttonConfirm addTarget:self
                           action:@selector(confirm)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonConfirm;
}
/** 4.覆盖图 */
- (UIView *)viewOverlay
{
    if (!_viewOverlay) {
        _viewOverlay = [[UIView alloc]initWithFrame:self.view.bounds];
        [_viewOverlay setBackgroundColor:[UIColor blackColor]];
        [_viewOverlay setAlpha:102.0/255];
    }
    return _viewOverlay;
}
/** 5.中间比例视图 */
- (UIView *)viewRatio
{
    if (!_viewRatio) {
        _viewRatio = [[UIView alloc]init];
        [_viewRatio.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [_viewRatio.layer setBorderWidth:0.5];
        [_viewRatio.layer setBorderColor:RGBA(255, 255, 255, 60.0/255).CGColor];
    }
    return _viewRatio;
}
/** 6.图片返回初始状态 */
- (UIButton *)buttonBack
{
    if (!_buttonBack) {
        CGFloat buttonW = 40;
        CGFloat buttonH = 28;
        CGFloat buttonX = ScreenWidth - buttonW - STMarginBig;
        CGFloat buttonY = ScreenHeight - buttonH - STMarginBig;
        _buttonBack = [[UIButton alloc]initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
        [_buttonBack setCenterX:ScreenWidth/2];
        [_buttonBack setBackgroundColor:RGBA(0, 0, 0, 50.0/255)];
        [_buttonBack setTitle:@"复原" forState:UIControlStateNormal];
        [_buttonBack setTitleColor:[UIColor whiteColor]
                             forState:UIControlStateNormal];
        [_buttonBack.titleLabel setFont:[UIFont systemFontOfSize:14]];

        [_buttonBack setClipsToBounds:YES];
        [_buttonBack.layer setCornerRadius:2];
        [_buttonBack.layer setBorderWidth:0.5];
        [_buttonBack.layer setBorderColor:RGBA(255, 255, 255, 60.0/255).CGColor];
        [_buttonBack setHidden:YES];
        [_buttonBack addTarget:self
                           action:@selector(recover)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonBack;
}
@end
