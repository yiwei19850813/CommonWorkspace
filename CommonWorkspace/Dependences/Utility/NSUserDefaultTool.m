//
//  NSUserDefaultTool.m
//  nextSing
//
//  Created by chester.lee on 14-3-12.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import "NSUserDefaultTool.h"


@implementation NSUserDefaultTool

+ (BOOL)updateObject:(id)object forKey:(NSString *)keyString
{
    if (!object || !keyString)
    {
        DLOG(@"error operation on %s，PLZ Check!",__FUNCTION__);
        return NO;
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:object forKey:keyString];
    [userDefault synchronize];
    return YES;
}

+ (id)ObjectForKey:(NSString *)keyString
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:keyString];
}
+ (BOOL)updateBool:(BOOL)value  forKey:(NSString *)keyString
{
    if (!keyString)
    {
        DLOG(@"error operation on %s，PLZ Check!",__FUNCTION__);
        return NO;
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:value forKey:keyString];
    [userDefault synchronize];
    return YES;

}
+ (BOOL)boolForKey:(NSString *)keyString
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault boolForKey:keyString];
}

@end
