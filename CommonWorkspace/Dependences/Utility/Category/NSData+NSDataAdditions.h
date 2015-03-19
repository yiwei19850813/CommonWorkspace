//
//  NSData+NSDataAdditions.h
//  iSing
//
//  Created by cui xiaoqian on 13-4-21.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Encrypt)

+ (NSData*)DesEncrypt:(NSString*)src withKey:(NSString*)key;
+ (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key;

@end

@interface NSData (Base64)

+ (NSString *)encodeBase64WithData:(NSData *)theData;
+ (NSData *)decodeBase64WithString: (NSString *)string;

// 先des加密，再base64加密
+ (NSString *)encodeBase64AfterDesEncryptWithString:(NSString *)string withKey:(NSString *)key;
@end


//Functions for Encoding Data.
@interface NSData (WBEncode)
- (NSString *)MD5EncodedString;
//- (NSData *)HMACSHA1EncodedDataWithKey:(NSString *)key;
//- (NSString *)base64EncodedString;
@end