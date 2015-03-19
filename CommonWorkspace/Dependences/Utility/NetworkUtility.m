//
//  NetworkUtility.m
//  woMusic
//
//  Created by iflytek on 12-1-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NetworkUtility.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>
#import "OSSPCarrierInfo.h"

@implementation NetworkUtility

+ (BOOL)is3gWapApn
{
    CFDictionaryRef systemProxyDict = CFNetworkCopySystemProxySettings();
    CFStringRef httpProxy = CFDictionaryGetValue(systemProxyDict, (CFStringRef)@"HTTPProxy");
    Boolean isHttpProxyMatch = NO;
    if (httpProxy != NULL)
    {
        isHttpProxyMatch = CFEqual(httpProxy, (CFStringRef)@"10.0.0.172");
    }
    if (isHttpProxyMatch)
    {
        CFNumberRef httpPort = CFDictionaryGetValue(systemProxyDict, (CFStringRef)@"HTTPPort");
        if (httpPort != NULL)
        {
            int port;
            if (CFNumberGetValue(httpPort, kCFNumberIntType, &port))
            {
                CFRelease(systemProxyDict);
                return (port == 80);
            }
        }
    }
    CFRelease(systemProxyDict);
    return NO;
}

+ (BOOL)isWifi
{
    struct sockaddr_in localWifiAddress;
	bzero(&localWifiAddress, sizeof(localWifiAddress));
	localWifiAddress.sin_len = sizeof(localWifiAddress);
	localWifiAddress.sin_family = AF_INET;
	// IN_LINKLOCALNETNUM is defined in <netinet/in.h> as 169.254.0.0
	localWifiAddress.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&localWifiAddress);
    if (NULL == reachability) 
    {
        return NO;
    }
    SCNetworkReachabilityFlags flags;
    BOOL reachable = SCNetworkReachabilityGetFlags(reachability, &flags);
    if (reachable == NO) 
    {
        return NO;
    }
    CFRelease(reachability);
    reachability = NULL;
    BOOL isWifi = NO;
    if((flags & kSCNetworkReachabilityFlagsReachable) && (flags & kSCNetworkReachabilityFlagsIsDirect))
    {
        isWifi = YES;
    }
    return isWifi;
}

+ (NSString *)getApnName
{
    NSString *carrierName;
    carrierName = [OSSPCarrierInfo getCarrierEnName];
    
    if ([self isWifi])
    {
//        NSLog(@"WIFI用户");
        return @"wifi";
    }
    else if ([carrierName isEqualToString:@"uninet"]) 
    {
//        NSLog(@"联通用户");
        return [self is3gWapApn] ? @"3gwap":@"3gnet";
    }
    else if ([carrierName isEqualToString:@"cmnet"]) 
    {
//        NSLog(@"移动用户");
        return [self is3gWapApn] ? @"cmwap":@"cmnet";
    }
    else if ([carrierName isEqualToString:@"ctnet"]) 
    {
//        NSLog(@"电信用户");
        return [self is3gWapApn] ? @"ctwap":@"ctnet";
    }
    else
    {
//        NSLog(@"WIFI用户");
        return @"wifi";
    }
}


//+ (BOOL)checkNetWork
//{
//    // 3gwap接入点
//    if ([NetworkUtility is3gWapApn]) 
//    {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:CHANGE_3G_NET_TIP delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alertView show];
//        [alertView release];
//        return NO;
//    }
//    return YES;
//}

+ (BOOL)isUninet
{
    return [[self getApnName] hasPrefix:@"3g"];
}

// 判断是否联网，不知道什么意思，网上抄的，抄的，抄的
+(BOOL) isConnectedToNet{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}

@end
