//
//  BaseEntity.m
//  MiguMV
//
//  Created by xdyang on 14-8-22.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import "BaseEntity.h"

@implementation StatusEntity

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end

@implementation BaseEntity

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end

@implementation OptionalJSONModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end
