//
//  UIImage+CS_Extensions.h
//  ISingV3
//
//  Created by xdyang on 14-11-12.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CS_Extensions)

- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

//人脸识别，并按长宽比例裁剪，计算的时候以短的一边为准，如果人脸检测失败，则居中裁剪
- (UIImage *)faceDetectAndCropToWidthHeightRate:(CGFloat)rate;


- (UIImage *)cropCenterAndResizeToFitWidth:(CGFloat)width;
- (CGRect)getCropRectWithImageSize:(CGSize)size withWidthHeightRate:(CGFloat)rate;
//居中按比例裁剪
- (UIImage *)cropCenterWithWidthHeightRate:(CGFloat)rate;

@end
