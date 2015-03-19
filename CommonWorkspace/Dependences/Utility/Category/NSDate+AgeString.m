//
//  NSDate+AgeString.m
//  nextSing
//
//  Created by BiaoRo on 14-5-6.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import "NSDate+AgeString.h"

@implementation NSDate (AgeString)

//获取年龄
- (NSInteger)getTheYearCount
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSYearCalendarUnit fromDate:self toDate:[NSDate date] options:0];
    return [comps year];
}

//获取星座
- (NSString *)getConstellation
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:self];
    
    int m = [dateComponent month];
    int d = [dateComponent day];
    
    NSString *astroString = @"魔羯座水瓶座双鱼座白羊座金牛座双子座巨蟹座狮子座处女座天秤座天蝎座射手座魔羯座";
    
    NSString *astroFormat = @"102123444543";
    
    NSString *result;
    
    if (m<1||m>12||d<1||d>31){
        
        return @"错误日期格式!";
        
    }
    
    if(m==2 && d>29)
    {

        return @"错误日期格式!!";
        
    }else if(m==4 || m==6 || m==9 || m==11) {
        
        if (d>30) {
            
            return @"错误日期格式!!!";
            
        }
        
    }
    
    result=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(m*3-(d < [[astroFormat substringWithRange:NSMakeRange((m-1), 1)] intValue] - (-19))*3,3)]];
    
    return result;
}

@end
