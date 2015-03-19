//
//  NetworkUtility.h
//  woMusic
//
//  Created by iflytek on 12-1-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkUtility : NSObject {
    
}

+ (BOOL)is3gWapApn;
+ (BOOL)isWifi;
+ (NSString *)getApnName;
//+ (BOOL)checkNetWork;

// 是否为联通网络 add by bwzhu
+ (BOOL)isUninet;

// 判断是否联网， add by zhengchen2
+(BOOL) isConnectedToNet;

@end
