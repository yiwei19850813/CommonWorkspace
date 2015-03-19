//
//  UIImage+CS_Extensions.m
//  ISingV3
//
//  Created by xdyang on 14-11-12.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import "UIImage+CS_Extensions.h"

CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};


@implementation UIImage (CS_Extensions)

-(UIImage *)imageAtRect:(CGRect)rect
{
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage* subImage = [UIImage imageWithCGImage: imageRef];
    CGImageRelease(imageRef);
    
    return subImage;
    
}
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize {
    
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize {
    
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}
- (UIImage *)imageByScalingToSize:(CGSize)targetSize {
    
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    //   CGSize imageSize = sourceImage.size;
    //   CGFloat width = imageSize.width;
    //   CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    //   CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}
- (UIImage *)imageRotatedByRadians:(CGFloat)radians
{
    return [self imageRotatedByDegrees:RadiansToDegrees(radians)];
}
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    rotatedViewBox = nil;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

//获取图片的居中裁剪rect
- (CGRect)getCropRectWithImageSize:(CGSize)size withWidthHeightRate:(CGFloat)rate
{
    if(rate <= 0){
        return CGRectZero;
    }
    //按照宽度裁剪
    BOOL cropByHeight = YES;
    
    CGFloat imageWidth = self.size.width;
    CGFloat imageHeight = self.size.height;
    
    CGFloat needWidth = imageHeight * rate;
    CGFloat needHeight = imageWidth / rate;
    
    if(rate >= 1){
        
        if(imageWidth >= needWidth){
            cropByHeight = YES;
        }else{
            cropByHeight = NO;
        }
    }else{
        
        if(imageHeight >= needHeight){
            
            cropByHeight = NO;
        }else{
            cropByHeight = YES;
        }
    }
    
    CGRect rect = CGRectZero;
    if(cropByHeight){
        rect = CGRectMake((imageWidth - needWidth)/2, 0, needWidth, imageHeight);
    }else{
        rect = CGRectMake(0, (imageHeight - needHeight)/2, imageWidth, needHeight);
    }
    
    return rect;
}

//居中按比例裁剪
- (UIImage *)cropCenterWithWidthHeightRate:(CGFloat)rate
{
    UIImage *cropedImage = [self imageAtRect:[self getCropRectWithImageSize:self.size withWidthHeightRate:rate]];
    return cropedImage;
}

//获取尽量已centerPoint为中心的裁剪rect
- (CGRect)getCropRectWithImageSize:(CGSize)size withCenterPoint:(CGPoint)centerPoint withWidthHeightRate:(CGFloat)rate
{
    if(rate <= 0){
        return CGRectZero;
    }
    //按照宽度裁剪
    BOOL cropByHeight = YES;
    
    CGFloat imageWidth = self.size.width;
    CGFloat imageHeight = self.size.height;
    
    CGFloat needWidth = imageHeight * rate;
    CGFloat needHeight = imageWidth / rate;
    
    if(rate >= 1){
        
        if(imageWidth >= needWidth){
            cropByHeight = YES;
        }else{
            cropByHeight = NO;
        }
    }else{
        
        if(imageHeight >= needHeight){
            
            cropByHeight = NO;
        }else{
            cropByHeight = YES;
        }
    }
    
    CGRect rect = CGRectZero;
    if(cropByHeight){
        
        CGFloat x = (centerPoint.x - needWidth/2);
        if(x < 0){
            x = 0;
        }else if((x + needWidth) > imageWidth){
            x = imageWidth - needWidth;
        }
        rect = CGRectMake(x, 0, needWidth, imageHeight);
        
    }else{
        CGFloat y = (centerPoint.y - needHeight/2);
        if(y < 0){
            y = 0;
        }else if((y + needHeight) > imageHeight){
            y = imageHeight - needHeight;
        }
        rect = CGRectMake(0, y, imageWidth, needHeight);
    }
    
    return rect;
}


//人脸识别，并按长宽比例裁剪，计算的时候以短的一边为准，如果人脸检测失败，则居中裁剪
- (UIImage *)faceDetectAndCropToWidthHeightRate:(CGFloat)rate
{
    //Create a CIImage version of your photo
    CIImage* image = [CIImage imageWithCGImage:self.CGImage];
    
    //create a face detector
    //此处是CIDetectorAccuracyHigh，若用于real-time的人脸检测，则用CIDetectorAccuracyLow，更快
    NSDictionary  *opts = [NSDictionary dictionaryWithObject:CIDetectorAccuracyLow
                                                      forKey:CIDetectorAccuracy];
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil
                                              options:opts];
    
    //Pull out the features of the face and loop through them
    NSArray* features = [detector featuresInImage:image];
    
    UIImage *cropedImage = nil;
    if(features.count <= 0){
        
        //检测失败，居中裁剪
        cropedImage = [self imageAtRect:[self getCropRectWithImageSize:self.size withWidthHeightRate:rate]];
    }else{
        
        CGRect faceDetRect = CGRectZero;
        for (CIFaceFeature *f in features)
        {
            //旋转180，仅y
            faceDetRect = f.bounds;
            faceDetRect.origin.y = self.size.height - faceDetRect.size.height - faceDetRect.origin.y;
            
            DLOG(@"%@",NSStringFromCGRect(f.bounds));
            if (f.hasLeftEyePosition){
                DLOG(@"Left eye %f %f\n", f.leftEyePosition.x, f.leftEyePosition.y);
            }
            if (f.hasRightEyePosition)
            {
                DLOG(@"Right eye %f %f\n", f.rightEyePosition.x, f.rightEyePosition.y);

            }
            if (f.hasMouthPosition)
            {
                DLOG(@"Mouth %f %f\n", f.mouthPosition.x, f.mouthPosition.y);
            }
        }

        if(CGRectEqualToRect(faceDetRect, CGRectZero)){
            
            //检测失败，居中裁剪
            cropedImage = [self imageAtRect:[self getCropRectWithImageSize:self.size withWidthHeightRate:rate]];
        }else{
            
            CGPoint centerPoint =CGPointMake(0, 0);
            centerPoint.x = faceDetRect.origin.x + faceDetRect.size.width/2.0;
            centerPoint.y = faceDetRect.origin.y + faceDetRect.size.height/2.0;
            
            cropedImage = [self imageAtRect:[self getCropRectWithImageSize:self.size withCenterPoint:centerPoint withWidthHeightRate:rate]];
        }
    }
    
    return cropedImage;
}


-(UIImage*)scaleToSize:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (UIImage *)cropCenterAndResizeToFitWidth:(CGFloat)width;
{
    
    //裁剪
    CGSize oringinSize = self.size;
    CGFloat minLength = MIN(oringinSize.width, oringinSize.height);
    CGRect centerSqure = CGRectMake((oringinSize.width - minLength) / 2, (oringinSize.height - minLength)/2, minLength, minLength);
    UIImage *cropedImage = [self croppedImage:centerSqure];
    
    //缩放
    UIImage *image = [cropedImage scaleToSize:CGSizeMake(width, width)];
    return image;
}

- (UIImage *)croppedImage:(CGRect)bounds {
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], bounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}

@end
