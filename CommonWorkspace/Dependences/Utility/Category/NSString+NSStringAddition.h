//
//  NSString+NSStringAddition.h
//  iSing
//
//  Created by cui xiaoqian on 13-4-21.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Base64)

+ (NSString *)encodeBase64UrlWithBase64:(NSString *)strBase64;
+ (NSString *)encodeBase64WithString:(NSString *)strData;

/******************************************************************************
 函数名称 : + (NSString *)base64StringFromText:(NSString *)text
 函数描述 : 将文本转换为base64格式字符串
 输入参数 : (NSString *)text    文本
 输出参数 : N/A
 返回参数 : (NSString *)    base64格式字符串
 备注信息 :
 ******************************************************************************/
+ (NSString *)base64StringFromText:(NSString *)text;

/******************************************************************************
 函数名称 : + (NSString *)textFromBase64String:(NSString *)base64
 函数描述 : 将base64格式字符串转换为文本
 输入参数 : (NSString *)base64  base64格式字符串
 输出参数 : N/A
 返回参数 : (NSString *)    文本
 备注信息 :
 ******************************************************************************/
+ (NSString *)textFromBase64String:(NSString *)base64;

@end


@interface NSString(MD5Addition)

- (NSString *) stringFromMD5;

@end


// add by bwzhu
//
//  获取文本需要的高度
//
@interface NSString (Size)

+ (float)heightWithFont:(UIFont *)font;

+ (float)heightContent:(NSString *)str font:(UIFont *)font width:(float)width;

@end

@interface NSString (Character)

// 返回只有汉字、英文和数字的字符串
- (NSString *)stringWithNormalCharacter;

- (NSString *) getFirstLetter;

@end

//
// 如果url字符串中包含有中文字符，再发起请求之前需要转换了。
//
@interface NSString (Covert)

+ (NSURL*)urlEncodeFromString:(NSString*)str;

+ (NSString*)stringDecodeFromString:(NSString*)str;

-(NSString*)substringToIndexForChinese:(NSInteger)index;

-(NSInteger)getChineseLength;

@end

@interface NSString (NSDate)

// 获取现在的时间str
+ (NSString *)stringWithDate:(NSDate *)date fromat:(NSString *)fromatStr;

// 把制定的时间str进行转换（与现在时间相比较）
+ (NSString *)stringWithTimeStr:(NSString *)timeStr;

- (NSDate *)date;
- (NSDate *)dateOfYear;
@end

@interface NSString (Weibo)

+ (NSDictionary *)dictionaryFromString:(NSString *)str;

+ (NSString *)stringFromDictionary:(NSDictionary *)dict;

+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params httpMethod:(NSString *)httpMethod;

@end


//Functions for Encoding String.
@interface NSString (WBEncode)
- (NSString *)MD5EncodedString;
//- (NSData *)HMACSHA1EncodedDataWithKey:(NSString *)key;
//- (NSString *)base64EncodedString;
- (NSString *)URLEncodedString;
- (NSString *)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding;
- (NSString*)URLDecodedString;

@end

// DES加密后，再base64
@interface NSString (DES_Base64)

- (NSString *)desBase64Encode:(NSString *)key;

- (NSString *)desBase64Unencode:(NSString *)key;




@end
@interface NSString (Format_Email_Phone)
//added by luobiao
//校验邮箱格式和手机号码格式
- (BOOL)isvalidateEmail;
- (BOOL)isValidatePhoneNumber;

@end


/**
 *  日期转换
 */
@interface NSString (Date)

- (NSString *)dateString;

- (NSString *)dateStringWithFormatter:(NSString *)formatter;

+ (NSString *)stringFromDate:(NSDate *)date;

+ (NSString *)stringFromIMDate:(NSDate *)date;

@end
