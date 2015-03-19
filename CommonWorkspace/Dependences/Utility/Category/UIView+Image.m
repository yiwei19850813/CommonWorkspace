//
//  UIView+Image.m
//  MiguMV
//
//  Created by sbfu on 14-8-25.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import "UIView+Image.h"

@implementation UIView (Image)

- (UIImage *)getImage
{
    //支持retina高分的关键
    if(UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(self.frame.size);
    }
    
    //获取图像
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();  
    UIGraphicsEndImageContext();
    return image;
}

@end
