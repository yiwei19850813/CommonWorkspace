//
//  UIImageView+Factory.h
//  MiguMV
//
//  Created by xdyang on 14-8-15.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Factory)

+ (UIImageView *)getImageViewWithFrame:(CGRect)frame image:(NSString *)imageName
                     isUserInteraction:(BOOL)isEnabled;

- (void)setImageWithUrlStr:(NSString *)urlStr placholderImage:(UIImage *)placeholder;

- (void)setImageWithUrlStr:(NSString *)urlStr;

@end
