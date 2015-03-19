//
//  UIImage+WriteToFile.m
//  ISingV3
//
//  Created by xdyang on 14-11-11.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import "UIImage+WriteToFile.h"

@implementation UIImage (WriteToFile)

- (void)writeToFileWithPath:(NSString *)path
{
    if(!path || path.length <= 0){
        return;
    }
    NSData *data = UIImageJPEGRepresentation(self, 1.0f);
    [data writeToFile:path atomically:YES];
}

@end
