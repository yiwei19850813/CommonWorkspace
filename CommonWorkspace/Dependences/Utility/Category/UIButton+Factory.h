//
//  UIButton+Factory.h
//  MiguMV
//
//  Created by xdyang on 14-8-15.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Factory)

//创建button
+ (UIButton *)createButtonWithFrame:(CGRect)frame withNormalBGImage:(UIImage *)normalImage withHighlightedBGImage:(UIImage *)highlightedImage selectedBGImage:(UIImage *)selectedImage withTitle:(NSString *)title withTarget:(id)target withSel:(SEL)selector forEvent:(UIControlEvents)event;

+ (UIButton *)getBtnWithFrame:(CGRect)frame foregroundImage:(NSString *)imageName
                       target:(id)target action:(SEL)actionMethod;


- (void)setImageWithUrlStr:(NSString *)urlStr placholderImage:(UIImage *)placeholder;

- (void)setImageWithUrlStr:(NSString *)urlStr;

@end
