//
//  UIImageView+Factory.m
//  MiguMV
//
//  Created by xdyang on 14-8-15.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import "UIImageView+Factory.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (Factory)

+ (UIImageView *)getImageViewWithFrame:(CGRect)frame image:(NSString *)imageName
                     isUserInteraction:(BOOL)isEnabled{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    [imageView setBackgroundColor:[UIColor clearColor]];
    [imageView setImage:[UIImage imageNamed:imageName]];
    [imageView setUserInteractionEnabled:(isEnabled ? YES : NO)];
    
    return imageView;
    
}

- (void)setImageWithUrlStr:(NSString *)urlStr placholderImage:(UIImage *)placeholder
{
    if (!urlStr) {
        return;
    }
    NSString *imgUrl = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlStr, nil, nil, kCFStringEncodingUTF8);
    [self sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:placeholder];
    CFRelease((__bridge CFTypeRef)(imgUrl));
}

- (void)setImageWithUrlStr:(NSString *)urlStr
{
    if (!urlStr) {
        return;
    }
    NSString *imgUrl = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlStr, nil, nil, kCFStringEncodingUTF8);
    [self sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
    CFRelease((__bridge CFTypeRef)(imgUrl));
}

@end
