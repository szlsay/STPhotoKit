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

/** 4.单击手势 */
@property (nonatomic, strong)UITapGestureRecognizer  *tapSingle;
/** 5.双击手势 */
@property (nonatomic, strong)UITapGestureRecognizer  *tapDouble;


/** 拖动手势 */
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@end

NS_ASSUME_NONNULL_END

@implementation STPhotoKitController

#pragma mark - --- lift cycle 生命周期 ---


- (void)viewDidLoad {
    [super viewDidLoad];


    // scale to fit the screen
    CGFloat oriWidth = self.cropFrame.size.width;
    CGFloat oriHeight = self.imageOriginal.size.height * (oriWidth / self.imageOriginal.size.width);
    CGFloat oriX = self.cropFrame.origin.x + (self.cropFrame.size.width - oriWidth) / 2;
    CGFloat oriY = self.cropFrame.origin.y + (self.cropFrame.size.height - oriHeight) / 2;
    self.oldFrame = CGRectMake(oriX, oriY, oriWidth, oriHeight);
    self.latestFrame = self.oldFrame;
    self.imageView.frame = self.oldFrame;

    self.largeFrame = CGRectMake(0, 0, self.limitRatio * self.oldFrame.size.width, self.limitRatio * self.oldFrame.size.height);

    [self addGestureRecognizers];

    //    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)] ;
    //    [pinchRecognizer setDelegate:self];
    //    [self.imageView addGestureRecognizer:pinchRecognizer];
    //
    //    UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)] ;
    //    [rotationRecognizer setDelegate:self];
    //    [self.imageView addGestureRecognizer:rotationRecognizer];
    //
    //    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)] ;
    //    [panRecognizer setMinimumNumberOfTouches:1];
    //    [panRecognizer setMaximumNumberOfTouches:1];
    //    [panRecognizer setDelegate:self];
    //    [self.imageView addGestureRecognizer:panRecognizer];
    //
    //    UITapGestureRecognizer *tapProfileImageRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)] ;
    //    [tapProfileImageRecognizer setNumberOfTapsRequired:1];
    //    [tapProfileImageRecognizer setDelegate:self];
    //    [self.imageView addGestureRecognizer:tapProfileImageRecognizer];


    [self.view addSubview:self.imageView];
    [self.view addSubview:self.viewOverlay];
    [self.view addSubview:self.viewRatio];
    [self.view addSubview:self.buttonCancel];
    [self.view addSubview:self.buttonConfirm];

    [self setupHollowUI];

    [self.view addGestureRecognizer:self.panGesture];

}
#pragma mark - --- delegate 视图委托 ---
//// 缩放
//-(void)scale:(id)sender {
//
//    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
//        _lastScale = 1.0;
//    }
//
//    CGFloat scale = 1.0 - (_lastScale - [(UIPinchGestureRecognizer*)sender scale]);
//
//    CGAffineTransform currentTransform = photoImage.transform;
//    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
//
//    [photoImage setTransform:newTransform];
//
//    _lastScale = [(UIPinchGestureRecognizer*)sender scale];
//    [self showOverlayWithFrame:photoImage.frame];
//}
//
//// 旋转
//-(void)rotate:(id)sender {
//
//    if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
//
//        _lastRotation = 0.0;
//        return;
//    }
//
//    CGFloat rotation = 0.0 - (_lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
//
//    CGAffineTransform currentTransform = photoImage.transform;
//    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
//
//    [photoImage setTransform:newTransform];
//
//    _lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
//    [self showOverlayWithFrame:photoImage.frame];
//}
//
//// 移动
//-(void)move:(id)sender {
//
//    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:canvas];
//
//    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
//        _firstX = [photoImage center].x;
//        _firstY = [photoImage center].y;
//    }
//
//    translatedPoint = CGPointMake(_firstX+translatedPoint.x, _firstY+translatedPoint.y);
//
//    [photoImage setCenter:translatedPoint];
//    [self showOverlayWithFrame:photoImage.frame];
//}



#pragma mark - --- event response 事件相应 ---
- (void)cancel{

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)confirm{
    if ([self.delegate respondsToSelector:@selector(photoKitController:resultImage:)]) {
        [self.delegate photoKitController:self resultImage:[self getSubImage]];
    }
//    if ([self.delegate respondsToSelector:@selector(imageCropperController:resultImage:)]) {
//        [self.delegate imageCropperController:self resultImage:[self getSubImage]];
//    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = self.imageView;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat absCenterX = self.cropFrame.origin.x + self.cropFrame.size.width / 2;
        CGFloat absCenterY = self.cropFrame.origin.y + self.cropFrame.size.height / 2;
        CGFloat scaleRatio = self.imageView.frame.size.width / self.cropFrame.size.width;
        CGFloat acceleratorX = 1 - ABS(absCenterX - view.center.x) / (scaleRatio * absCenterX);
        CGFloat acceleratorY = 1 - ABS(absCenterY - view.center.y) / (scaleRatio * absCenterY);
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x * acceleratorX, view.center.y + translation.y * acceleratorY}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGRect newFrame = self.imageView.frame;
        newFrame = [self handleBorderOverflow:newFrame];
        [UIView animateWithDuration:0.3 animations:^{
            self.imageView.frame = newFrame;
            self.latestFrame = newFrame;
        }];
    }
}

#pragma mark - --- private methods 私有方法 ---
/**
 *  1.镂空中间的视图
 */
- (void)setupHollowUI
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path appendPath:[UIBezierPath bezierPathWithRect:self.view.frame]];
    [path appendPath:[UIBezierPath bezierPathWithRect:self.viewRatio.frame].bezierPathByReversingPath];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    self.viewOverlay.layer.mask = maskLayer;
}
// register all gestures
- (void) addGestureRecognizers
{

    // add pinch gesture
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [self.view addGestureRecognizer:pinchGestureRecognizer];

    //    // add pan gesture
    //    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    //    [self.view addGestureRecognizer:panGestureRecognizer];
}

- (UIPanGestureRecognizer *)panGesture
{
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panView:)];
    }
    return _panGesture;
}

// pinch gesture handler
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = self.imageView;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
    else if (pinchGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGRect newFrame = self.imageView.frame;
        newFrame = [self handleScaleOverflow:newFrame];
        newFrame = [self handleBorderOverflow:newFrame];
        [UIView animateWithDuration:0.3 animations:^{
            self.imageView.frame = newFrame;
            self.latestFrame = newFrame;
        }];
    }
}




- (CGRect)handleScaleOverflow:(CGRect)newFrame {
    // bounce to original frame
    CGPoint oriCenter = CGPointMake(newFrame.origin.x + newFrame.size.width/2, newFrame.origin.y + newFrame.size.height/2);
    if (newFrame.size.width < self.oldFrame.size.width) {
        newFrame = self.oldFrame;
    }
    if (newFrame.size.width > self.largeFrame.size.width) {
        newFrame = self.largeFrame;
    }
    newFrame.origin.x = oriCenter.x - newFrame.size.width/2;
    newFrame.origin.y = oriCenter.y - newFrame.size.height/2;
    return newFrame;
}

- (CGRect)handleBorderOverflow:(CGRect)newFrame {
    // horizontally
    if (newFrame.origin.x > self.cropFrame.origin.x) newFrame.origin.x = self.cropFrame.origin.x;
    if (CGRectGetMaxX(newFrame) < self.cropFrame.size.width) newFrame.origin.x = self.cropFrame.size.width - newFrame.size.width;
    // vertically
    if (newFrame.origin.y > self.cropFrame.origin.y) newFrame.origin.y = self.cropFrame.origin.y;
    if (CGRectGetMaxY(newFrame) < self.cropFrame.origin.y + self.cropFrame.size.height) {
        newFrame.origin.y = self.cropFrame.origin.y + self.cropFrame.size.height - newFrame.size.height;
    }
    // adapt horizontally rectangle
    if (self.imageView.frame.size.width > self.imageView.frame.size.height && newFrame.size.height <= self.cropFrame.size.height) {
        newFrame.origin.y = self.cropFrame.origin.y + (self.cropFrame.size.height - newFrame.size.height) / 2;
    }
    return newFrame;
}

-(UIImage *)getSubImage{
    CGRect squareFrame = self.cropFrame;
    CGFloat scaleRatio = self.latestFrame.size.width / self.imageOriginal.size.width;
    CGFloat x = (squareFrame.origin.x - self.latestFrame.origin.x) / scaleRatio;
    CGFloat y = (squareFrame.origin.y - self.latestFrame.origin.y) / scaleRatio;
    CGFloat w = squareFrame.size.width / scaleRatio;
    CGFloat h = squareFrame.size.width / scaleRatio;
    if (self.latestFrame.size.width < self.cropFrame.size.width) {
        CGFloat newW = self.imageOriginal.size.width;
        CGFloat newH = newW * (self.cropFrame.size.height / self.cropFrame.size.width);
        x = 0; y = y + (h - newH) / 2;
        w = newH; h = newH;
    }
    if (self.latestFrame.size.height < self.cropFrame.size.height) {
        CGFloat newH = self.imageOriginal.size.height;
        CGFloat newW = newH * (self.cropFrame.size.width / self.cropFrame.size.height);
        x = x + (w - newW) / 2; y = 0;
        w = newH; h = newH;
    }
    CGRect myImageRect = CGRectMake(x, y, w, h);
    CGImageRef imageRef = self.imageOriginal.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    CGSize size;
    size.width = myImageRect.size.width;
    size.height = myImageRect.size.height;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    return smallImage;
}
#pragma mark - --- getters and setters 属性 ---
/** 1.图片 */
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [_imageView setMultipleTouchEnabled:YES];
        [_imageView setUserInteractionEnabled:YES];
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

- (UIView *)viewRatio
{
    if (!_viewRatio) {
        _viewRatio = [[UIView alloc] initWithFrame:self.cropFrame];
        [_viewRatio.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [_viewRatio.layer setBorderWidth:0.5];
        [_viewRatio setBackgroundColor:[UIColor clearColor]];
    }
    return _viewRatio;
}

- (void)setImageOriginal:(UIImage *)imageOriginal
{
    _imageOriginal = imageOriginal;
    self.imageView.image = imageOriginal;
}



@end
