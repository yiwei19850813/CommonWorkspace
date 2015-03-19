//
//  UINavigationController+setNavigationBarToDefaultStyle.m
//  ISingV3
//
//  Created by xdyang on 14-11-2.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import "UINavigationController+setNavigationBarToDefaultStyle.h"

@implementation UINavigationController (setNavigationBarToDefaultStyle)

//设置导航栏为默认样式-和该工程相关
- (void)setNavigationBarToDefaultStyle
{
    [self.navigationBar setBackgroundImage: [UIImage imageNamed:@"BG-NavBar"] forBarMetrics:UIBarMetricsDefault];
}

@end
