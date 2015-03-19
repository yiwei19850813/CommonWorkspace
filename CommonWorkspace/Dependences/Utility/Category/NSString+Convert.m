//
//  NSString+Convert.m
//  MiguMV
//
//  Created by xdyang on 14-8-22.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import "NSString+Convert.h"
#import "NSStringFromAnyObject.h"

@implementation NSString (Convert)

NSString *__NSStringFromOtherObject(const char *type, const void *object) {
    
    NSString *result = __NSStringFromAnyObject(type, object);
    NSArray *array = [result  componentsSeparatedByString:@")"];
    NSRange range = [result rangeOfString:@")"];
    BOOL contains = (range.location != NSNotFound);
    
    if(array.count >= 2){
        return [array objectAtIndex:1];
    }else if(!contains){
        return result;
    }
    return nil;
}

@end
