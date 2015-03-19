//
//  UILabel+Factory.m
//  MiguMV
//
//  Created by xdyang on 14-8-15.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import "UILabel+Factory.h"
#import "UIColor+Hex.h"


@implementation UILabel (Factory)

+ (UILabel *)createLabelWithFrame:(CGRect)frame withText:(NSString *)text  textColorHex:(long)textColor textFont:(CGFloat)font textAlignment:(NSTextAlignment)textAlignment backgroundColorHex:(long)backgroundColor target:(id)target selector:(SEL)selector;
{
    return [UILabel createLabelWithFrame:frame withText:text textColor:[UIColor colorWithHex:textColor] textFont:font textAlignment:textAlignment backgroundColor:[UIColor colorWithHex:backgroundColor] target:target selector:selector];
}

+ (UILabel *)createLabelWithFrame:(CGRect)frame withText:(NSString *)text  textColorHex:(long)textColor textFont:(CGFloat)font textAlignment:(NSTextAlignment)textAlignment backgroundColor:(UIColor *)backgroundColor target:(id)target selector:(SEL)selector
{
    return [UILabel createLabelWithFrame:frame withText:text textColor:[UIColor colorWithHex:textColor] textFont:font textAlignment:textAlignment backgroundColor:backgroundColor target:target selector:selector];
}

+ (UILabel *)createLabelWithFrame:(CGRect)frame withText:(NSString *)text  textColor:(UIColor *)textColor textFont:(CGFloat)font textAlignment:(NSTextAlignment)textAlignment backgroundColor:(UIColor *)backgroundColor target:(id)target selector:(SEL)selector
{
    UILabel *label = [[UILabel alloc] init];
    label.frame = frame;
    label.text = text;
    label.textAlignment = textAlignment;
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = textColor;
    label.backgroundColor = backgroundColor;
    if(target)
    {
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
        [label addGestureRecognizer:ges];        label.userInteractionEnabled = YES;
    }
    
    return label;
}

+ (UILabel *)getLabelWithFrame:(CGRect)frame textColor:(UIColor *)textColor
                          size:(CGFloat)size{
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    
    [label setTextColor:textColor];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setFont:[UIFont systemFontOfSize:size]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setLineBreakMode:NSLineBreakByTruncatingTail];
    
    return label;
    
}

@end
