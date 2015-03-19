//
//  NSObject+AssociatedObject.m
//  Unity-iPhone
//
//  Created by xdyang on 14-4-28.
//
//

#import "NSObject+AssociatedObject.h"
#import <objc/runtime.h>

@implementation NSObject (AssociatedObject)
@dynamic associatedUserInfo;

- (void)setAssociatedUserInfo:(id)object
{
    //去除原来的关联
    objc_setAssociatedObject(self, @selector(associatedUserInfo), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, @selector(associatedUserInfo), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)associatedUserInfo
{
    return objc_getAssociatedObject(self, @selector(associatedUserInfo));
}

@end
