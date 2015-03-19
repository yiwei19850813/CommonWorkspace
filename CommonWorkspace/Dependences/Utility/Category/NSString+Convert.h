//
//  NSString+Convert.h
//  MiguMV
//
//  Created by xdyang on 14-8-22.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Convert)

FOUNDATION_EXPORT NSString *__NSStringFromOtherObject(const char *type, const void *object);

#define NSStringFromOtherObject(anyobject) \
__NSStringFromOtherObject(@encode(__typeof__(anyobject)), (__typeof__(anyobject) []){ anyobject })


@end
