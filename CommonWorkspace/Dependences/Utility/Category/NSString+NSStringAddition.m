//
//  NSString+NSStringAddition.m
//  iSing
//
//  Created by cui xiaoqian on 13-4-21.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//

#import "NSString+NSStringAddition.h"
#import "NSData+NSDataAdditions.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

#define IS_CH_SYMBOL(chr) ((int)(chr)>127)

//空字符串
#define     LocalStr_None           @""

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

char pinyinFirstLetter(unsigned short hanzi);
@implementation NSString (Base64)

+ (NSString *)encodeBase64UrlWithBase64:(NSString *)strBase64
{
	// Switch a base64 encoded string into a "base 64 url" encoded string
	// all that really means is no "=" padding and switch "-" for "+" and "_" for "/"
    
	// This is not a "standard" per se, but it is a widely used variant.
	// See http://en.wikipedia.org/wiki/Base64#URL_applications for more information
    
	NSString * strStep1 = [strBase64 stringByReplacingOccurrencesOfString:@"=" withString:@""];
	NSString * strStep2 = [strStep1 stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
	NSString * strStep3 = [strStep2 stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
	return strStep3;
}

+ (NSString *)encodeBase64WithString:(NSString *)strData {
	return [NSData encodeBase64WithData:[strData dataUsingEncoding:NSUTF8StringEncoding]];
}


+ (NSString *)base64StringFromText:(NSString *)text
{
    if (text && ![text isEqualToString:LocalStr_None]) {
        //取项目的bundleIdentifier作为KEY  改动了此处
        //NSString *key = [[NSBundle mainBundle] bundleIdentifier];
        NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
        //IOS 自带DES加密 Begin  改动了此处
        //data = [self DESEncrypt:data WithKey:key];
        //IOS 自带DES加密 End
        return [self base64EncodedStringFrom:data];
    }
    else {
        return LocalStr_None;
    }
}

+ (NSString *)textFromBase64String:(NSString *)base64
{
    if (base64 && ![base64 isEqualToString:LocalStr_None]) {
        //取项目的bundleIdentifier作为KEY   改动了此处
        //NSString *key = [[NSBundle mainBundle] bundleIdentifier];
        NSData *data = [self dataWithBase64EncodedString:base64];
        //IOS 自带DES解密 Begin    改动了此处
        //data = [self DESDecrypt:data WithKey:key];
        //IOS 自带DES加密 End
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    else {
        return LocalStr_None;
    }
}

/******************************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES加密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 ******************************************************************************/
+ (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    return nil;
}

/******************************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES解密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 ******************************************************************************/
+ (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    return nil;
}

/******************************************************************************
 函数名称 : + (NSData *)dataWithBase64EncodedString:(NSString *)string
 函数描述 : base64格式字符串转换为文本数据
 输入参数 : (NSString *)string
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 :
 ******************************************************************************/
+ (NSData *)dataWithBase64EncodedString:(NSString *)string
{
    if (string == nil)
        [NSException raise:NSInvalidArgumentException format:nil];
    if ([string length] == 0)
        return [NSData data];
    
    static char *decodingTable = NULL;
    if (decodingTable == NULL)
    {
        decodingTable = malloc(256);
        if (decodingTable == NULL)
            return nil;
        memset(decodingTable, CHAR_MAX, 256);
        NSUInteger i;
        for (i = 0; i < 64; i++)
            decodingTable[(short)encodingTable[i]] = i;
    }
    
    const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
    if (characters == NULL)     //  Not an ASCII string!
        return nil;
    char *bytes = malloc((([string length] + 3) / 4) * 3);
    if (bytes == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (YES)
    {
        char buffer[4];
        short bufferLength;
        for (bufferLength = 0; bufferLength < 4; i++)
        {
            if (characters[i] == '\0')
                break;
            if (isspace(characters[i]) || characters[i] == '=')
                continue;
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
            {
                free(bytes);
                return nil;
            }
        }
        
        if (bufferLength == 0)
            break;
        if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
        {
            free(bytes);
            return nil;
        }
        
        //  Decode the characters in the buffer to bytes.
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        if (bufferLength > 2)
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        if (bufferLength > 3)
            bytes[length++] = (buffer[2] << 6) | buffer[3];
    }
    
    bytes = realloc(bytes, length);
    return [NSData dataWithBytesNoCopy:bytes length:length];
}

/******************************************************************************
 函数名称 : + (NSString *)base64EncodedStringFrom:(NSData *)data
 函数描述 : 文本数据转换为base64格式字符串
 输入参数 : (NSData *)data
 输出参数 : N/A
 返回参数 : (NSString *)
 备注信息 :
 ******************************************************************************/
+ (NSString *)base64EncodedStringFrom:(NSData *)data
{
    if ([data length] == 0)
        return @"";
    
    char *characters = malloc((([data length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [data length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [data length])
            buffer[bufferLength++] = ((char *)[data bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}

@end




@implementation NSString(MD5Addition)

- (NSString *) stringFromMD5{
    
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return [outputString autorelease];
}

@end

// add by bwzhu
//
//  获取文本需要的高度
//
@implementation NSString (Size)

+ (float)heightWithFont:(UIFont *)font
{
    NSString *test = @"测试";
    return [test sizeWithFont:font].height;
}

+ (float)heightContent:(NSString *)str font:(UIFont *)font width:(float)width
{
    if (!font || !str)
    {
        return 0;
    }
    CGSize size = [str sizeWithFont:font constrainedToSize:CGSizeMake(width,NSIntegerMax) lineBreakMode:UILineBreakModeWordWrap];
    return size.height;
}

@end

@implementation NSString (Character)

- (NSString *)stringWithNormalCharacter
{
    NSMutableString *str = [NSMutableString string];
    NSRange range;
    range.length = 1;
    for (int i = 0; i < self.length; i++)
    {
        range.location = i;
        NSString *singleStr = [self substringWithRange:range];
        int unicode = [self characterAtIndex:i];
        //
        if ((unicode >= 0x4e00 && unicode <= 0x9fa5) || (unicode <= 128))
        {
            [str appendString:singleStr];
        }
    }
    return str;
}

- (NSString *) getFirstLetter {
    
    if (self.length == 0)
    {
        return nil;
    }
    NSString *firstStr = [self substringToIndex:1];
    if ([firstStr canBeConvertedToEncoding: NSASCIIStringEncoding]) {//如果是英语
        return firstStr;
    }
    else { //如果是非英语
        return [NSString stringWithFormat:@"%c",pinyinFirstLetter([firstStr characterAtIndex:0])];
    }
}

@end

@implementation NSString (NSDate)

+ (NSString *)stringWithDate:(NSDate *)date fromat:(NSString *)fromatStr
{
    if (!date || !fromatStr)
    {
        return nil;
    }
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:fromatStr];
    
    return [formatter stringFromDate:date];
}

+ (NSString *)stringWithTimeStr:(NSString *)timeStr
{
    if ( !timeStr || [timeStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
    {
        return nil;
    }
    
    if ([timeStr rangeOfString:@"+0000"].length > 0)
    {
        timeStr = [timeStr substringToIndex:[timeStr rangeOfString:@"+0000"].location];
    }
    
    // 现在时间
    NSDate *now = [NSDate date];

    NSString *retStr = nil;
    //格式化
    NSDateFormatter *formatter = [[[NSDateFormatter alloc]init] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *mydate = [formatter dateFromString:timeStr];

    [formatter setDateFormat:@"MM-dd HH:mm"];
    retStr = [formatter stringFromDate:mydate];
    
    // 与现在的时间间隔
    NSTimeInterval interval = fabs([now timeIntervalSinceDate:mydate]);

    // 昨天和今天 肯定小于两天
    if (interval > 0 && interval < 24*60*60*2)
    {
        [formatter setDateFormat:@"DD"];
        int createdDay = [formatter stringFromDate:mydate].intValue;
        int today = [formatter stringFromDate:now].intValue;
        
        
        [formatter setDateFormat:@"HH:mm"];
        // 今天
        if (today == createdDay)
        {
            retStr = [NSString stringWithFormat:@"今天 %@",[formatter stringFromDate:mydate]];
        }
        // 昨天
        else if (createdDay + 1 == today)
        {
            retStr = [NSString stringWithFormat:@"昨天 %@",[formatter stringFromDate:mydate]];
        }
//        else if (createdDay > today)
//        {
//            // 昨天
//            if (interval < 24*60*60)
//            {
//                retStr = [NSString stringWithFormat:@"昨天 %@",[formatter stringFromDate:mydate]];
//            }
//        }
    }
    else
    {
        // 是否为同一年
        [formatter setDateFormat:@"yyyy"];
        int myYear = [formatter stringFromDate:mydate].intValue;
        int toYear = [formatter stringFromDate:now].intValue;
        // 不是同一年， 要显示全部时间
        if (myYear != toYear)
        {
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            retStr = [formatter stringFromDate:mydate];
        }
    }

    return retStr;
}
- (NSDate *)date
{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:self];
    return date;
}
- (NSDate *)dateOfYear
{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:self];
    return date;
}
@end


@implementation NSString (Convert)

+(NSURL*)urlEncodeFromString:(NSString *)str
{
//    if (str==nil) {
//        return [NSURL URLWithString:@""];
//    }
    if ([str rangeOfString:@"%"].location!=NSNotFound) {
        return [NSURL URLWithString:str];
    }
    NSString *convertstr = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, nil, nil, kCFStringEncodingUTF8);
    
    NSURL *url = [NSURL URLWithString:convertstr];
    [convertstr release];
    return url;
}

+ (NSString*)stringDecodeFromString:(NSString*)str
{
    NSString *convertStr = (NSString*)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (CFStringRef)str, NULL, NSUTF8StringEncoding);
    NSString *decodeStr = [convertStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [convertStr release];
    return decodeStr;
}

-(NSString*)substringToIndexForChinese:(NSInteger)index
{
    NSInteger ret = 0;
    for(int i = 0; i< self.length; i++)
    {
        unichar ch = [self characterAtIndex:i];
        
        if (IS_CH_SYMBOL(ch)) {
            ret = ret + 2;
        }else
        {
            ret = ret + 1;
        }
        
        if (ret >= index) {
            return [self substringToIndex:i+1];
        }
    }
    
    return [self substringToIndex:index];
}

-(NSInteger)getChineseLength
{
    NSInteger ret = 0;
    
    for(int i = 0; i< self.length; i++)
    {
        unichar ch = [self characterAtIndex:i];
        
        if (IS_CH_SYMBOL(ch)) {
            ret = ret + 2;
        }else
        {
            ret = ret + 1;
        }
    }
    
    return ret;
}

@end

@implementation NSString (Weibo)

+ (NSDictionary *)dictionaryFromString:(NSString *)str
{
    NSArray *array = [str componentsSeparatedByString:@"&"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    for (NSString *subStr in array)
    {
        NSArray *keyValue = [subStr componentsSeparatedByString:@"="];
        if (keyValue && [keyValue count] == 2)
        {
            [dict setObject:[keyValue objectAtIndex:1] forKey:[keyValue objectAtIndex:0]];
        }
    }
    DLOG(@"dict :%@", dict);
    return dict;
}

+ (NSString *)stringFromDictionary:(NSDictionary *)dict
{
    DLOG(@"%@", dict);
    NSMutableArray *pairs = [NSMutableArray array];
	for (NSString *key in [dict keyEnumerator])
	{
		if (!([[dict valueForKey:key] isKindOfClass:[NSString class]]))
		{
			continue;
		}
		[pairs addObject:[NSString stringWithFormat:@"%@=%@", key, [[dict objectForKey:key] URLEncodedString]]];
	}
	NSString *str = [pairs componentsJoinedByString:@"&"];
    DLOG(@"post body:%@",str);
	return [pairs componentsJoinedByString:@"&"];
}

+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params httpMethod:(NSString *)httpMethod
{
    if (![httpMethod isEqualToString:@"GET"])
    {
        return baseURL;
    }
    
    NSURL *parsedURL = [NSURL URLWithString:baseURL];
	NSString *queryPrefix = parsedURL.query ? @"&" : @"?";
	NSString *query = [NSString stringFromDictionary:params];
	
	return [NSString stringWithFormat:@"%@%@%@", baseURL, queryPrefix, query];
}

@end


#pragma mark - NSString (WBEncode)

@implementation NSString (WBEncode)

- (NSString *)MD5EncodedString
{
	return [[self dataUsingEncoding:NSUTF8StringEncoding] MD5EncodedString];
}

//- (NSData *)HMACSHA1EncodedDataWithKey:(NSString *)key
//{
//	return [[self dataUsingEncoding:NSUTF8StringEncoding] HMACSHA1EncodedDataWithKey:key];
//}
//
//- (NSString *) base64EncodedString
//{
//	return [[self dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
//}

- (NSString *)URLEncodedString
{
	return [self URLEncodedStringWithCFStringEncoding:kCFStringEncodingUTF8];
}

- (NSString*)URLDecodedString
{
	NSString *result = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,(CFStringRef)self,CFSTR(""),kCFStringEncodingUTF8);
    [result autorelease];
	return result;
}

- (NSString *)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding
{
	return [(NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[[self mutableCopy] autorelease], NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), encoding) autorelease];
}

@end


@implementation NSString(DES_Base64)

- (NSString *)desBase64Encode:(NSString *)key
{
    NSData *data = [NSData DesEncrypt:self withKey:key];
    NSString * str = [NSData encodeBase64WithData:data];
    return str;
}

- (NSString *)desBase64Unencode:(NSString *)key
{
    NSData *data = [NSData decodeBase64WithString:self];
    data = [NSData DESDecrypt:data WithKey:key];
    NSString *str = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    return str;
}
//



@end
@implementation NSString(Format_Email_Phone)
//邮箱格式校验
- (BOOL)isvalidateEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}
- (BOOL)isValidatePhoneNumber
{
//    
//    
//    //最新号段  2014.04.23 罗彪
//    
//
//    //虚拟运营商
//    NSString *VNO = @"^1(70)\\d{8}$";
//    
//    //中国移动号段：134、135、136、137、138、139、150、151、152、157、158、159、182、183、184、187、188、178(4G)、147(上网卡)
//    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[0127-9]|8[23478]|78|47)\\d)\\d{7}$";
//    
//    //中国联通号段：130、131、132、155、156、185、186、176(4G)、145(上网卡)
//    NSString * CU = @"^1(3[0-2]|5[56]|8[56]|76|45)\\d{8}$";
//    
//    //中国电信号段：133、153、180、181、189 、177(4G)
//    NSString * CT = @"^1(33|53|8[019]|77)\\d{8}$";
    
    //匹配所有1开头的11位数
    NSString * ALL = @"^1[0-9]{10}$";
    NSPredicate *regextestall = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ALL];
    return [regextestall evaluateWithObject:self];
//    NSPredicate *regextestvno = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", VNO];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//
//    BOOL res1 = [regextestvno evaluateWithObject:self];
//    BOOL res2 = [regextestcm evaluateWithObject:self];
//    BOOL res3 = [regextestcu evaluateWithObject:self];
//    BOOL res4 = [regextestct evaluateWithObject:self];
    
//    if (res1 || res2 || res3 || res4 )
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
}
- (int)countWord//汉字算一个，英文字母和数字算半个
{
    int i,n = [self length],l = 0,a=0,b=0;
    unichar c;
    for (i=0; i<n; i++) {
        c = [self characterAtIndex:i];
        if (isblank(c)) {
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;
        }
    }
    if (a==0 && l==0) {
        return 0;
    }
    return (l+(int)ceilf((float)(a+b)/2.0));
}

@end

@implementation NSString (Date)

- (NSString *)dateString
{
    return [self dateStringWithFormatter:@"yyyy-MM-dd HH:mm:ss"];
}

//• 刚刚（10分钟内）
//• XX分钟前（10分钟后-1小时内）
//• XX小时前（1小时后-24小时内）
//• 昨天09:35（24小时后-48小时内）
//• 前天09:35（48小时后-72小时内）
//• 09.23 09:35 （当年72小时后）
//• 2014.08.21 12:30（不在当年）
- (NSString *)dateStringWithFormatter:(NSString *)formatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = formatter;
    NSDate *date = [dateFormatter dateFromString:self];
    return [NSString stringFromDate:date];
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    NSDate *curDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *curDateComponents = [calendar components:unitFlags fromDate:curDate];
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
    
    if (curDateComponents.year != dateComponents.year) {
        return [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld", (long)dateComponents.year, (long)dateComponents.month, (long)dateComponents.day, (long)dateComponents.hour, (long)dateComponents.minute];
    } else {
        NSTimeInterval interval = [curDate timeIntervalSinceDate:date];
        if (interval <= 10 * 60) {
            return @"刚刚";
        } else if (interval <= 60 * 60) {
            return [NSString stringWithFormat:@"%d分钟前", (int)interval / 60];
        } else if (interval <= 24 * 60 * 60) {
            return [NSString stringWithFormat:@"%d小时前", (int)interval / (60 * 60)];
        } else if ([NSString isYesterday:dateComponents curDate:curDateComponents]) {
            return [NSString stringWithFormat:@"昨天 %02ld:%02ld", (long)dateComponents.hour, (long)dateComponents.minute];
        } else {
            long curInterval = [NSDate timeIntervalSinceReferenceDate];
            long preInterval = [date timeIntervalSinceReferenceDate];
            
            int day = 24 * 60 * 60;
            
            int curDay = curInterval / day;
            int preDay = preInterval / day;
            if (curDay - preDay == 2) {
                return [NSString stringWithFormat:@"前天 %02ld:%02ld", (long)dateComponents.hour, (long)dateComponents.minute];
            } else {
                return [NSString stringWithFormat:@"%02ld-%02ld %02ld:%02ld", (long)dateComponents.month, (long)dateComponents.day, (long)dateComponents.hour, (long)dateComponents.minute];
            }
        }
    }
    return nil;
}

+ (NSString *)stringFromIMDate:(NSDate *)date
{
    NSDate *curDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *curDateComponents = [calendar components:unitFlags fromDate:curDate];
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
    
    if (curDateComponents.year != dateComponents.year) {
        return [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld", (long)dateComponents.year, (long)dateComponents.month, (long)dateComponents.day, (long)dateComponents.hour, (long)dateComponents.minute];
    } else {
        NSTimeInterval interval = [curDate timeIntervalSinceDate:date];
        if (interval <= 60) {
            return @"刚刚";
        } else if ([NSString isToday:dateComponents curDate:curDateComponents]) {
            return [NSString stringWithFormat:@"今天 %02ld:%02ld", (long)dateComponents.hour, (long)dateComponents.minute];
        } else if ([NSString isYesterday:dateComponents curDate:curDateComponents]) {
            return [NSString stringWithFormat:@"昨天 %02ld:%02ld", (long)dateComponents.hour, (long)dateComponents.minute];
        } else {
            long curInterval = [NSDate timeIntervalSinceReferenceDate];
            long preInterval = [date timeIntervalSinceReferenceDate];
            
            int day = 24 * 60 * 60;
            
            int curDay = curInterval / day;
            int preDay = preInterval / day;
            if (curDay - preDay == 2) {
                return [NSString stringWithFormat:@"前天 %02ld:%02ld", (long)dateComponents.hour, (long)dateComponents.minute];
            } else {
                return [NSString stringWithFormat:@"%02ld-%02ld %02ld:%02ld", (long)dateComponents.month, (long)dateComponents.day, (long)dateComponents.hour, (long)dateComponents.minute];
            }
        }
    }
    return nil;
}

+ (BOOL)isToday:(NSDateComponents *)date curDate:(NSDateComponents *)curDate
{
    return date.month == curDate.month && date.day == curDate.day;
}

+ (BOOL)isYesterday:(NSDateComponents *)date curDate:(NSDateComponents *)curDate
{
    BOOL is = (date.month == curDate.month && (curDate.day - date.day == 1)) ||
               ((curDate.month - date.month == 1) && curDate.day == 1);
    return is;
}


@end
















