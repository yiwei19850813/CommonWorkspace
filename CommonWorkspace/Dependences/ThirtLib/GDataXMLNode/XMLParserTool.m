//
//  XMLParserTool.m
//  nextSing
//
//  Created by chester.lee on 14-3-13.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import "XMLParserTool.h"

@implementation XMLParserTool

@end


// ****************************************************

@implementation GDataXMLElement(Expand)

- (NSString *)valueOfFirstElement:(NSString *)elemName
{
    if (!elemName)
    {
        return nil;
    }
    NSArray *array = [self elementsForName:elemName];
    if ([array count] < 1)
    {
        return nil;
    }
    return [[array objectAtIndex:0] stringValue];
}

- (GDataXMLElement *)firstSubElement:(NSString *)elemName
{
    NSArray *subElems = [self elementsForName:elemName];
    if (subElems.count == 0)
    {
        return nil;
    }
    return [subElems objectAtIndex:0];
}

@end

// ****************************************************

@implementation GDataXMLDocument (Expand)

- (GDataXMLElement *)firstElement:(NSString *)elemName
{
    if (!elemName)
    {
        return nil;
    }
    NSArray *array = [self nodesForXPath:elemName error:nil];
    if (array.count == 0)
    {
        return nil;
    }
    return [array objectAtIndex:0];
}

- (NSString *)valueOfFirstElement:(NSString *)elemName
{
    if (!elemName)
    {
        return nil;
    }
    NSArray *array = [self nodesForXPath:elemName error:nil];
    if ([array count] < 1)
    {
        return nil;
    }
    return [(GDataXMLElement *)[array objectAtIndex:0] stringValue];
}
@end