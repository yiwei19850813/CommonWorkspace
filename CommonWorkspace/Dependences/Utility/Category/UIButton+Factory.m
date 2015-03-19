//
//  UIButton+Factory.m
//  MiguMV
//
//  Created by xdyang on 14-8-15.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import "UIButton+Factory.h"
#import "UIButton+WebCache.h"

@implementation UIButton (Factory)

//创建button
+ (UIButton *)createButtonWithFrame:(CGRect)frame withNormalBGImage:(UIImage *)normalImage withHighlightedBGImage:(UIImage *)highlightedImage selectedBGImage:(UIImage *)selectedImage withTitle:(NSString *)title withTarget:(id)target withSel:(SEL)selector forEvent:(UIControlEvents)event;
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.backgroundColor = [UIColor clearColor];
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:selectedImage  forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateNormal];
    if(target)
    {
        [button addTarget:target  action:selector forControlEvents:event];
    }
    
    return button;
}

+ (UIButton *)getBtnWithFrame:(CGRect)frame foregroundImage:(NSString *)imageName
                       target:(id)target action:(SEL)actionMethod{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setFrame:frame];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setBackgroundImage:[UIImage imageNamed:imageName]
                   forState:UIControlStateNormal];
    
    [btn addTarget:target
            action:actionMethod
  forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
    
}

- (void)setImageWithUrlStr:(NSString *)urlStr placholderImage:(UIImage *)placeholder
{
    if (!urlStr) {
        return;
    }
    [self setImage:placeholder forState:UIControlStateNormal];
    NSString *imgUrl = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlStr, nil, nil, kCFStringEncodingUTF8);
//    NSString *imgUrl = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self sd_setImageWithURL:[NSURL URLWithString:imgUrl] forState:UIControlStateNormal placeholderImage:placeholder];
    CFRelease((__bridge CFTypeRef)(imgUrl));
}

- (void)setImageWithUrlStr:(NSString *)urlStr
{
    if (!urlStr) {
        return;
    }
    NSString *imgUrl = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlStr, nil, nil, kCFStringEncodingUTF8);
    [self sd_setImageWithURL:[NSURL URLWithString:imgUrl] forState:UIControlStateNormal];
    CFRelease((__bridge CFTypeRef)(imgUrl));
}

@end
