//
//  ColorDefined.h
//  StrategyObserve
//
//  Created by bwzhu on 14-3-18.
//  Copyright (c) 2014年 bwzhu. All rights reserved.
//
#import <Foundation/Foundation.h>

#define COLOR_RGB_16(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define COLOR_RGB_10(r, g, b) [UIColor colorWithRed: r/255.0 green: g/255.0 blue: b/255.0 alpha:1.0]

#define COLOR_White         [UIColor whiteColor]
#define COLOR_Black         [UIColor blackColor]
#define COLOR_Red           [UIColor redColor]
#define COLOR_clear         [UIColor clearColor]
#define COLOR_Gray          [UIColor grayColor]
#define COLOR_LightGray     [UIColor lightGrayColor]
#define COLOR_DarkGray      [UIColor darkGrayColor]


#define COLOR_CustomGray    COLOR_RGB_16(0xc8c8c8)
#define COLOR_CustomBlue    COLOR_RGB_16(0x0097dd)
#define COLOR_Pink          COLOR_RGB_10(224, 40, 150)
//#define COLOR_Pink          COLOR_RGB_10(226, 20, 150)//COLOR_RGB_10(217, 68, 166)