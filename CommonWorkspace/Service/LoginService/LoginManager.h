//
//  LoginManager.h
//  CommonWorkspace
//  description:登录相关
//  Created by xdyang on 15/3/29.
//  Copyright (c) 2015年 myself. All rights reserved.
//

#import <Foundation/Foundation.h>

//自动登录开关存储key值
#define AutoLoginSwitch @"isAutoLoginSwitch"

@interface LoginManager : NSObject

@property (nonatomic)BOOL logined;

@property (nonatomic, copy)NSString *userName;

@end
