//
//  SVProgressHUD+Migu.m
//  ISingV3
//
//  Created by sbfu on 14/10/24.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import "SVProgressHUD+Migu.h"

@implementation SVProgressHUD (Migu)

+ (void)showLoadFailedMessage
{
    [SVProgressHUD showWithTitle:@"加载失败" withTime:1.0];
}

@end
