//
//  UIFont+Additions.m
//  MiguMV
//
//  Created by sbfu on 14-8-18.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import "UIColor+Additions.h"

@implementation UIColor(Additions)

+ (instancetype)colorWithR:(int)R G:(int)G B:(int)B
{
    return [UIColor colorWithR:R G:G B:B alpha:1];
}

+ (instancetype)colorWithR:(int)R G:(int)G B:(int)B alpha:(float)A
{
    return [UIColor colorWithRed:R / 255.0 green:G / 255.0 blue:B / 255.0 alpha:A];
}

+ (UIColor*) colorWithHex: (NSUInteger)hex alpha:(CGFloat)alpha
{
	CGFloat red, green, blue;
    
	red = ((CGFloat)((hex >> 16) & 0xFF)) / ((CGFloat)0xFF);
	green = ((CGFloat)((hex >> 8) & 0xFF)) / ((CGFloat)0xFF);
	blue = ((CGFloat)((hex >> 0) & 0xFF)) / ((CGFloat)0xFF);
    
	return [UIColor colorWithRed: red green:green blue:blue alpha:alpha];
}

@end
