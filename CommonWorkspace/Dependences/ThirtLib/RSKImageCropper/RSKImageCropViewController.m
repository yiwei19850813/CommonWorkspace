//
// RSKImageCropViewController.m
//
// Copyright (c) 2014 Ruslan Skorb, http://lnkd.in/gsBbvb
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "RSKImageCropViewController.h"
#import "RSKTouchView.h"
#import "RSKImageScrollView.h"
#import "UIImage+FixOrientation.h"
#import "UIImage+CS_Extensions.h"

static const CGFloat kPortraitCircleMaskRectInnerEdgeInset = 15.0f;
static const CGFloat kPortraitSquareMaskRectInnerEdgeInset = 20.0f;
static const CGFloat kPortraitCancelAndChooseButtonsHorizontalMargin = 13.0f;
static const CGFloat kPortraitCancelAndChooseButtonsVerticalMargin = 21.0f;

static const CGFloat kLandscapeCircleMaskRectInnerEdgeInset = 45.0f;
static const CGFloat kLandscapeSquareMaskRectInnerEdgeInset = 45.0f;
static const CGFloat kLandscapeCancelAndChooseButtonsVerticalMargin = 12.0f;

@interface RSKImageCropViewController ()

@property (strong, nonatomic) UIColor *originalNavigationControllerViewBackgroundColor;
@property (assign, nonatomic) BOOL originalNavigationControllerNavigationBarHidden;
@property (assign, nonatomic) BOOL originalStatusBarHidden;

@property (strong, nonatomic) RSKImageScrollView *imageScrollView;
@property (strong, nonatomic) RSKTouchView *overlayView;
@property (strong, nonatomic) CAShapeLayer *maskLayer;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *chooseButton;

@property (strong, nonatomic) UITapGestureRecognizer *doubleTapGestureRecognizer;

@property (assign, nonatomic) BOOL didSetupConstraints;
@property (strong, nonatomic) NSLayoutConstraint *cancelButtonBottomConstraint;
@property (strong, nonatomic) NSLayoutConstraint *chooseButtonBottomConstraint;

@end

@implementation RSKImageCropViewController

#pragma mark - Lifecycle

- (instancetype)initWithImage:(UIImage *)originalImage
{
    self = [super init];
    if (self) {
        _originalImage = originalImage;
        _cropMode = RSKImageCropModeCircle;
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)originalImage cropMode:(RSKImageCropMode)cropMode
{
    self = [super init];
    if (self) {
        _originalImage = originalImage;
        _cropMode = cropMode;
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)originalImage cropMode:(RSKImageCropMode)cropMode cropSize:(CGSize)cropSize
{
    self = [super init];
    if (self) {
        _originalImage = originalImage;
        _cropMode = cropMode;
        _cropSize = cropSize;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.view.backgroundColor = [UIColor blackColor];
    self.view.clipsToBounds = YES;
    
    self.title = @"剪切图片";
    
    [self.navigationController setNavigationBarToDefaultStyle];
    UIBarButtonItem *dis = [UIBarButtonItem dismissButtonWithTarget:self Action:@selector(cancelCrop)];
    self.navigationItem.leftBarButtonItem = dis;
    
    UIBarButtonItem *finish = [UIBarButtonItem titleButtonWithTarget:self Action:@selector(cropImage) andTitle:@"完成"];
    self.navigationItem.rightBarButtonItem = finish;
    
//    self.originalStatusBarHidden = [UIApplication sharedApplication].statusBarHidden;
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
//    
//    self.originalNavigationControllerNavigationBarHidden = self.navigationController.navigationBarHidden;
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self.view addSubview:self.imageScrollView];
    [self.view addSubview:self.overlayView];
    [self.view addSubview:self.cancelButton];
    [self.view addSubview:self.chooseButton];
    
    [self.view addGestureRecognizer:self.doubleTapGestureRecognizer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.originalNavigationControllerViewBackgroundColor = self.navigationController.view.backgroundColor;
    self.navigationController.view.backgroundColor = [UIColor blackColor];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:self.originalStatusBarHidden];
    [self.navigationController setNavigationBarHidden:self.originalNavigationControllerNavigationBarHidden animated:animated];
    self.navigationController.view.backgroundColor = self.originalNavigationControllerViewBackgroundColor;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self layoutImageScrollView];
    [self layoutOverlayView];
    [self updateMaskPath];
    [self.view setNeedsUpdateConstraints];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (!self.imageScrollView.zoomView) {
        [self displayImage];
    }
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    if (!self.didSetupConstraints) {
        [self.cancelButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:28];
        CGFloat left = kDeviceWidth/2 - 44 - 32;
        [self.cancelButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:left];
        [self.chooseButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:28];
        [self.chooseButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:left];
        
        self.didSetupConstraints = YES;
    } else {
        if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
            self.cancelButtonBottomConstraint.constant = -kPortraitCancelAndChooseButtonsVerticalMargin;
            self.chooseButtonBottomConstraint.constant = -kPortraitCancelAndChooseButtonsVerticalMargin;
        } else {
            self.cancelButtonBottomConstraint.constant = -kLandscapeCancelAndChooseButtonsVerticalMargin;
            self.chooseButtonBottomConstraint.constant = -kLandscapeCancelAndChooseButtonsVerticalMargin;
        }
    }
}

#pragma mark - Custom Accessors

- (RSKImageScrollView *)imageScrollView
{
    if (!_imageScrollView) {
        _imageScrollView = [[RSKImageScrollView alloc] init];
        _imageScrollView.clipsToBounds = NO;
    }
    return _imageScrollView;
}

- (RSKTouchView *)overlayView
{
    if (!_overlayView) {
        _overlayView = [[RSKTouchView alloc] init];
        _overlayView.receiver = self.imageScrollView;
        [_overlayView.layer addSublayer:self.maskLayer];
    }
    return _overlayView;
}

- (CAShapeLayer *)maskLayer
{
    if (!_maskLayer) {
        _maskLayer = [CAShapeLayer layer];
        _maskLayer.fillRule = kCAFillRuleEvenOdd;
        _maskLayer.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3].CGColor;
    }
    return _maskLayer;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_cancelButton setImage:[UIImage imageNamed:@"but_r_sel"] forState:UIControlStateNormal];
        [_cancelButton setImage:[UIImage imageNamed:@"but_r_nor"] forState:UIControlStateHighlighted];
        [_cancelButton addTarget:self action:@selector(onLeftTrasition) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.opaque = NO;
    }
    return _cancelButton;
}

- (UIButton *)chooseButton
{
    if (!_chooseButton) {
        _chooseButton = [[UIButton alloc] init];
        _chooseButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_chooseButton setImage:[UIImage imageNamed:@"but_l_sel"] forState:UIControlStateNormal];
        [_chooseButton setImage:[UIImage imageNamed:@"but_r_nor"] forState:UIControlStateHighlighted];
        [_chooseButton addTarget:self action:@selector(onRightTrasition) forControlEvents:UIControlEventTouchUpInside];
        _chooseButton.opaque = NO;
    }
    return _chooseButton;
}

- (UITapGestureRecognizer *)doubleTapGestureRecognizer
{
    if (!_doubleTapGestureRecognizer) {
        _doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        _doubleTapGestureRecognizer.delaysTouchesEnded = NO;
        _doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    }
    return _doubleTapGestureRecognizer;
}

- (CGSize)cropSize
{
    CGFloat viewWidth = CGRectGetWidth(self.view.bounds);
    CGFloat viewHeight = CGRectGetHeight(self.view.bounds);
    
    CGSize cropSize;
    switch (self.cropMode) {
        case RSKImageCropModeCircle: {
            CGFloat diameter;
            if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
                diameter = MIN(viewWidth, viewHeight) - kPortraitCircleMaskRectInnerEdgeInset * 2;
            } else {
                diameter = MIN(viewWidth, viewHeight) - kLandscapeCircleMaskRectInnerEdgeInset * 2;
            }
            cropSize = CGSizeMake(diameter, diameter);
            break;
        }
        case RSKImageCropModeSquare: {
            CGFloat length;
            if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
                length = MIN(viewWidth, viewHeight) - kPortraitSquareMaskRectInnerEdgeInset * 2;
            } else {
                length = MIN(viewWidth, viewHeight) - kLandscapeSquareMaskRectInnerEdgeInset * 2;
            }
            cropSize = CGSizeMake(length, length);
            break;
        }
        case RSKImageCropModeCustom: {
            cropSize = _cropSize;
            break;
        }
    }
    return cropSize;
}

#pragma mark - Action handling
- (void)onLeftTrasition
{
    LogFuctionName;
    self.originalImage = [self.originalImage imageRotatedByDegrees:90];
    [self displayImage];
}

- (void)onRightTrasition
{
    LogFuctionName;
    self.originalImage = [self.originalImage imageRotatedByDegrees:(-90)];
    [self displayImage];
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    [self resetZoomScale:YES];
    [self resetContentOffset:YES];
}

#pragma mark - Private

- (void)resetZoomScale:(BOOL)animated
{
    CGFloat zoomScale;
    if (CGRectGetWidth(self.view.bounds) > CGRectGetHeight(self.view.bounds)) {
        zoomScale = CGRectGetHeight(self.view.bounds) / self.originalImage.size.height;
    } else {
        zoomScale = CGRectGetWidth(self.view.bounds) / self.originalImage.size.width;
    }
    [self.imageScrollView setZoomScale:zoomScale animated:animated];
}

- (void)resetContentOffset:(BOOL)animated
{
    CGSize boundsSize = self.imageScrollView.bounds.size;
    CGRect frameToCenter = self.imageScrollView.zoomView.frame;
    
    CGPoint contentOffset;
    if (CGRectGetWidth(frameToCenter) > boundsSize.width) {
        contentOffset.x = (CGRectGetWidth(frameToCenter) - boundsSize.width) * 0.5f;
    } else {
        contentOffset.x = 0;
    }
    if (CGRectGetHeight(frameToCenter) > boundsSize.height) {
        contentOffset.y = (CGRectGetHeight(frameToCenter) - boundsSize.height) * 0.5f;
    } else {
        contentOffset.y = 0;
    }
    
    [self.imageScrollView setContentOffset:contentOffset animated:animated];
}

- (void)displayImage
{
    if (self.originalImage) {
        [self.imageScrollView displayImage:self.originalImage];
        [self resetZoomScale:NO];
    }
}

- (void)layoutImageScrollView
{
    self.imageScrollView.frame = [self maskRect];
}

- (void)layoutOverlayView
{
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) * 2, CGRectGetHeight(self.view.bounds) * 2);
    self.overlayView.frame = frame;
}

- (void)updateMaskPath
{
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithRect:self.overlayView.frame];
    
    UIBezierPath *maskPath = nil;
    switch (self.cropMode) {
        case RSKImageCropModeCircle: {
            maskPath = [UIBezierPath bezierPathWithOvalInRect:[self maskRect]];
            break;
        }
        case RSKImageCropModeSquare:
        case RSKImageCropModeCustom: {
            maskPath = [UIBezierPath bezierPathWithRect:[self maskRect]];
            break;
        }
    }
    
    [clipPath appendPath:maskPath];
    clipPath.usesEvenOddFillRule = YES;
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.duration = [CATransaction animationDuration];
    pathAnimation.timingFunction = [CATransaction animationTimingFunction];
    [self.maskLayer addAnimation:pathAnimation forKey:@"path"];
    
    //添加指示线
    CGRect rect = [self maskRect];
    UIView *leftLine = [[UIView alloc] init];
    leftLine.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:leftLine];
    [leftLine autoSetDimension:ALDimensionWidth toSize:1];
    [leftLine autoSetDimension:ALDimensionHeight toSize:rect.size.height];
    [leftLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [leftLine autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:rect.origin.y];
    
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topLine];
    [topLine autoSetDimension:ALDimensionHeight toSize:1];
    [topLine autoSetDimension:ALDimensionWidth toSize:rect.size.width];
    [topLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [topLine autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:rect.origin.y];
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomLine];
    [bottomLine autoSetDimension:ALDimensionHeight toSize:1];
    [bottomLine autoSetDimension:ALDimensionWidth toSize:rect.size.width];
    [bottomLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [bottomLine autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:(rect.origin.y + rect.size.height)];
    
    UIView *rightLine = [[UIView alloc] init];
    rightLine.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:rightLine];
    [rightLine autoSetDimension:ALDimensionWidth toSize:1];
    [rightLine autoSetDimension:ALDimensionHeight toSize:rect.size.height];
    [rightLine autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [rightLine autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:rect.origin.y];
    
    
    self.maskLayer.path = [clipPath CGPath];
}

- (CGRect)maskRect
{
    CGRect maskRect = CGRectMake((CGRectGetWidth(self.view.frame) - self.cropSize.width) * 0.5f,
                                 (CGRectGetHeight(self.view.frame) - self.cropSize.height) * 0.5f,
                                 self.cropSize.width,
                                 self.cropSize.height);
    
    return maskRect;
}

- (CGRect)cropRect
{
    CGRect cropRect = CGRectZero;
    float zoomScale = 1.0 / self.imageScrollView.zoomScale;
    
    cropRect.origin.x = self.imageScrollView.contentOffset.x * zoomScale;
    cropRect.origin.y = self.imageScrollView.contentOffset.y * zoomScale;
    cropRect.size.width = CGRectGetWidth(self.imageScrollView.bounds) * zoomScale;
    cropRect.size.height = CGRectGetHeight(self.imageScrollView.bounds) * zoomScale;
    
    CGSize imageSize = self.originalImage.size;
    CGFloat x = CGRectGetMinX(cropRect);
    CGFloat y = CGRectGetMinY(cropRect);
    CGFloat width = CGRectGetWidth(cropRect);
    CGFloat height = CGRectGetHeight(cropRect);
    
    UIImageOrientation imageOrientation = self.originalImage.imageOrientation;
    if (imageOrientation == UIImageOrientationRight || imageOrientation == UIImageOrientationRightMirrored) {
        cropRect.origin.x = y;
        cropRect.origin.y = imageSize.width - CGRectGetWidth(cropRect) - x;
        cropRect.size.width = height;
        cropRect.size.height = width;
    } else if (imageOrientation == UIImageOrientationLeft || imageOrientation == UIImageOrientationLeftMirrored) {
        cropRect.origin.x = imageSize.height - CGRectGetHeight(cropRect) - y;
        cropRect.origin.y = x;
        cropRect.size.width = height;
        cropRect.size.height = width;
    } else if (imageOrientation == UIImageOrientationDown || imageOrientation == UIImageOrientationDownMirrored) {
        cropRect.origin.x = imageSize.width - CGRectGetWidth(cropRect) - x;;
        cropRect.origin.y = imageSize.height - CGRectGetHeight(cropRect) - y;
    }
    
    return cropRect;
}

- (UIImage *)croppedImage:(UIImage *)image cropRect:(CGRect)cropRect
{
    CGImageRef croppedCGImage = CGImageCreateWithImageInRect(image.CGImage, cropRect);
    UIImage *croppedImage = [UIImage imageWithCGImage:croppedCGImage scale:1.0f orientation:image.imageOrientation];
    CGImageRelease(croppedCGImage);
    return [croppedImage fixOrientation];
}

- (void)cropImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *croppedImage = [self croppedImage:self.originalImage cropRect:[self cropRect]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(imageCropViewController:didCropImage:)]) {
                [self.delegate imageCropViewController:self didCropImage:croppedImage];
            }
            
            if(self.cropImageCallBack){
                _cropImageCallBack(croppedImage);
            }
            
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        });
    });
}

- (void)cancelCrop
{
    if ([self.delegate respondsToSelector:@selector(imageCropViewControllerDidCancelCrop:)]) {
        [self.delegate imageCropViewControllerDidCancelCrop:self];
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
