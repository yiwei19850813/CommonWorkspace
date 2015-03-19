//
//  NSArray+help.m
//  ISingV3
//
//  Created by xdyang on 14-10-27.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import "NSArray+help.h"

@implementation NSArray (help)

- (NSString *)getStringWithSepStr:(NSString *)sep
{
    if(self.count <= 0){
        return nil;
    }
    
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@", [self objectAtIndex:0]];
    if(self.count == 1){
        return str;
    }
    
    for (int i = 1; i < self.count; ++i){
        [str appendString:[NSString stringWithFormat:@"%@%@", sep, [self objectAtIndex:i]]];
    }
    return str;
}

@end
