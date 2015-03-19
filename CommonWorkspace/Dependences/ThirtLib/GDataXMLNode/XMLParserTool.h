//
//  XMLParserTool.h
//  nextSing
//
//  Created by chester.lee on 14-3-13.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"


@interface XMLParserTool : NSObject

@end


// ****************************************************
// 封装一层，外面调用的太频繁，代码有点乱
// ****************************************************
@interface GDataXMLElement(Expand)

// 获取值
- (NSString *)valueOfFirstElement:(NSString *)elemName;

// 获取标签
- (GDataXMLElement *)firstSubElement:(NSString *)elemName;
@end



// ****************************************************
// 封装一层，外面调用的太频繁，代码有点乱
// ****************************************************

@interface GDataXMLDocument (Expand)

- (GDataXMLElement *)firstElement:(NSString *)elemName;

- (NSString *)valueOfFirstElement:(NSString *)elemName;

@end