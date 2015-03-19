//
//  UILabel+Factory.h
//  MiguMV
//
//  Created by xdyang on 14-8-15.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Factory)

//创建UILabel  使用16进制的颜色值
+ (UILabel *)createLabelWithFrame:(CGRect)frame withText:(NSString *)text  textColorHex:(long)textColor textFont:(CGFloat)font textAlignment:(NSTextAlignment)textAlignment backgroundColorHex:(long)backgroundColor target:(id)target selector:(SEL)selector;

//创建UILabel  使用16进制的颜色值,但背景色用UIColor,因为一般的UILabel的背景色为透明色
+ (UILabel *)createLabelWithFrame:(CGRect)frame withText:(NSString *)text  textColorHex:(long)textColor textFont:(CGFloat)font textAlignment:(NSTextAlignment)textAlignment backgroundColor:(UIColor *)backgroundColor target:(id)target selector:(SEL)selector;

//创建UILabel  使用UIColor的颜色值
+ (UILabel *)createLabelWithFrame:(CGRect)frame withText:(NSString *)text  textColor:(UIColor *)textColor textFont:(CGFloat)font textAlignment:(NSTextAlignment)textAlignment backgroundColor:(UIColor *)backgroundColor target:(id)target selector:(SEL)selector;

+ (UILabel *)getLabelWithFrame:(CGRect)frame textColor:(UIColor *)textColor
                          size:(CGFloat)size;

@end
