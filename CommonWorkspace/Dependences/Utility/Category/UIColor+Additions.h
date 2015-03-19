//
//  UIFont+Additions.h
//  MiguMV
//
//  Created by sbfu on 14-8-18.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Additions)

+ (instancetype)colorWithR:(int)R G:(int)G B:(int)B;

+ (instancetype)colorWithR:(int)R G:(int)G B:(int)B alpha:(float)A;

+ (UIColor*) colorWithHex: (NSUInteger)hex alpha:(CGFloat)alpha;

@end
