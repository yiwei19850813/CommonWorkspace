//
//  NetworkManager.h
//
//  description:网络请求
//
//  网络请求类，并监控网络的开关、监控当前网络连接状态的改变
//
//  Created by xdyang on 14-8-16.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "BaseEntity.h"

//返回数据为空的返回码
#define No_Result_Code  404

//每页的请求条数
#define Page_Size_MiguMV  20

@interface NetworkManager : NSObject


+ (instancetype)getInstance;


#pragma mark - 当前网络状态相关
@property (nonatomic)BOOL isConnectToNet;
@property (nonatomic)BOOL isWifi;

//是否校验过服务端时间
@property (nonatomic)BOOL isHavedProofreadTime;


#pragma mark - 功能接口相关

/**
 *  带参数的GET网络请求
 *
 *  @param service      service description
 *  @param paramDic     paramDic description
 *  @param successBlock successBlock description
 *  @param failedBlock  failedBlock description
 */
+ (void)getRequestForService:(NSString *)service withParamDic:(NSDictionary *)paramDic withResponseName:(NSString *)responseClassName withSuccBlock:(void(^)(StatusEntity *responseEntity))succBlock  withFailedBlock:(void(^)(NSString *errorMsg, StatusEntity *statusEntity))failedBlock;

/**
 *  带缓存的数据GET网络请求
 *  调用改接口的数据，可以缓存数据，默认是对缓存第一页的数据，如果不是分页数据，则缓存所有数据
 *
 *  @param service           service description
 *  @param paramDic          paramDic description
 *  @param requestTyep       requestTyep description
 *  @param responseClassName responseClassName description
 *  @param succBlock         succBlock description
 *  @param failedBlock       failedBlock description
 */
+ (void)getRequestForService:(NSString *)service withParamDic:(NSDictionary *)paramDic withResponseName:(NSString *)responseClassName withRequestType:(RequestType)requestTyep withSuccBlock:(void(^)(StatusEntity *responseEntity))succBlock  withFailedBlock:(void(^)(NSString *errorMsg, StatusEntity *statusEntity))failedBlock;

/**
 *  不带参数的GET网络请求
 *
 *  @param service      <#service description#>
 *  @param paramDic     <#paramDic description#>
 *  @param successBlock <#successBlock description#>
 *  @param failedBlock  <#failedBlock description#>
 */
+ (void)getRequestForService:(NSString *)service withSuccBlock:(void(^)(NSDictionary *responseDic))successBlock  withFailedBlock:(void(^)(NSString *errorMsg, NSDictionary *errorResponseDic))failedBlock;

/**
 *  带参数的POST网络请求
 *
 *  @param service      service description
 *  @param paramDic     paramDic description
 *  @param successBlock successBlock description
 *  @param failedBlock  failedBlock description
 */
+ (void)postRequestForService:(NSString *)service withParamDic:(NSDictionary *)paramDic withResponseName:(NSString *)responseClassName withSuccBlock:(void(^)(StatusEntity *responseEntity))succBlock  withFailedBlock:(void(^)(NSString *errorMsg, StatusEntity *statusEntity))failedBlock;

/**
 *  获取六位随机数
 *
 *  @return <#return value description#>
 */
+ (NSString*)getRandomNumStr;
/**
 *  加密请求参数
 *
 *  @param dic  dic description
 *  @param salt salt description
 *
 *  @return return value description
 */
+ (NSString *)encodeBodyWithParamDic:(NSDictionary *)dic  withSalt:(NSString *)salt;

/**
 *  获取请求的url，包括计算token的步骤
 *
 *  @param service service description
 *  @param data    data description
 *  @param time    time description
 *
 *  @return return value description
 */
+ (NSString *)getRequestUrlWithService:(NSString *)service withData:(NSString *)data withSalt:(NSString *)salt;

+ (NSString *)getRequestFileUrlWithService:(NSString *)service withData:(NSString *)data withSalt:(NSString *)salt;

//获取请求参数
+ (NSMutableDictionary *)getRequestDicWithService:(NSString *)service withData:(NSString *)data withSalt:(NSString *)salt;

/**
 *  解析相应地包中的body部分,并返回所有的相应字典
 *
 *  @param dic <#dic description#>
 *
 *  @return <#return value description#>
 */
+ (NSMutableDictionary *)getResponseBodyWithResponseDic:(NSDictionary *)dic;



#pragma mark - 业务相关(公共部分)
/**
 *  获取服务端时间戳，并计算与本地时间的差值
 */
+ (void)getServiceTime;

//根据service获取URL
+ (NSString *)getUploadFileUrlWithService:(NSString *)service withData:(NSString *)data withSalt:(NSString *)salt;

@end
