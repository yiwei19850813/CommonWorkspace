//
//  NetworkManager.m
//  MiguMV
//
//  Created by xdyang on 14-8-16.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import "NetworkManager.h"
#import "NSString+NSStringAddition.h"
#import "NSString+Encrypt3DESandBase64.h"
#import "AFHTTPRequestOperation.h"

#import "DataStoreManager.h"


#define E_KEY  @"9HkocpYLeG1LNi5m"
#define Version @"2.0"

//网络请求成功返回码
#define SuccStatus 200
//服务端和本地时间插值超过了规定时间
#define LocalServiceTimeOut  @"-600"

static NetworkManager *instance = nil;


@interface NetworkManager ()
{
    
}

//本地时间和服务端时间的差值(当计算本地时间戳的时候，直接加改值即可)
@property(nonatomic) long long local_service_timeInterval;
//是否正在获取服务端时间
@property(nonatomic) BOOL isGetServieTime;

//是否是第一次检测网络
@property (nonatomic)BOOL isFirstMonitorNet;

@end



@implementation NetworkManager

+ (instancetype)getInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NetworkManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if(self = [super init]){
        
        _local_service_timeInterval = 0;
        _isGetServieTime = NO;
        _isFirstMonitorNet = YES;
        _isHavedProofreadTime = NO;
        
        //检测网络
        AFNetworkReachabilityManager *netReachManager = [AFNetworkReachabilityManager sharedManager];
        //动态检测的改变，只作为状态提醒
        [netReachManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
            
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                {
                    break;
                }
                case AFNetworkReachabilityStatusNotReachable:
                {
                    if(!_isFirstMonitorNet){
                        [SVProgressHUD showWithTitle:@"网络连接中断，请检查网络!" withTime:1.0f];
                    }
                    break;
                }
                case AFNetworkReachabilityStatusReachableViaWiFi:
                {
                    if(!_isFirstMonitorNet){
                        [SVProgressHUD showWithTitle:@"已经切换至Wi-Fi连接" withTime:1.0f];
                    }
                    break;
                }
                case AFNetworkReachabilityStatusReachableViaWWAN:
                {
                    if(!_isFirstMonitorNet){
                        [SVProgressHUD showWithTitle:@"已经切换至2G/3G连接" withTime:1.0f];
                    }
                    break;
                }
                    _isFirstMonitorNet = NO;
                    
                default:
                    break;
            }
        }];
        [netReachManager startMonitoring];
    }
    return self;
}

//这里防止状态不对，每次都重新请求
- (BOOL)isConnectToNet
{
    return [[AFNetworkReachabilityManager sharedManager] isReachable];
}

//这里防止状态不对，每次都重新请求
- (BOOL)isIsWifi
{
    return [[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi];
}

+ (NSDictionary *)addBaseParamWithParamDic:(NSDictionary *)dic
{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    
    [paramDic setObject:@"iphone" forKey:@"os"];
    [paramDic setObject:@"03" forKey:@"clientName"];
    [paramDic setObject:@"ac_ios" forKey:@"ua"];
    [paramDic setObject:@"WLAN" forKey:@"serverType"];
    
    AppConfigInfo *appInfo = [AppStartManager getInstance].appConfigInfo;
    if(appInfo.clientVersion){
        [paramDic setObject:appInfo.clientVersion forKey:@"clientVersion"];
    }
    if(appInfo.mobileType){
        [paramDic setObject:appInfo.mobileType forKey:@"mobileType"];
    }
    if(appInfo.imei){
        [paramDic setObject:appInfo.imei forKey:@"imei"];
    }
    if(appInfo.imsi){
       [paramDic setObject:appInfo.imsi forKey:@"imsi"];
    }
    NSString *apn = [NetworkUtility getApnName];
    if(apn){
        [paramDic setObject:apn forKey:@"netType"];
    }
    NSString *netStandard = appInfo.currentRadioAccessTechnology;
    if(netStandard){
        
        [paramDic setObject:netStandard forKey:@"netStandard"];
    }
    if([LoginManager getInstance].bLogined && [[LoginManager getInstance] getUserID_String].length > 0){
     
        [paramDic setObject:[[LoginManager getInstance] getUserID_String] forKey:@"phoneMobile"];
        [paramDic setObject:[LoginManager getInstance].userInfo.nickname forKey:@"userName"];
    }
    
    
    return paramDic;
}



#pragma mark - 功能接口相关
#pragma mark - GET请求相关
/**
 *  带参数的GET网络请求
 *
 *  @param service      <#service description#>
 *  @param paramDic     <#paramDic description#>
 *  @param successBlock <#successBlock description#>
 *  @param failedBlock  <#failedBlock description#>
 */
+ (void)getRequestForService:(NSString *)service withParamDic:(NSDictionary *)paramDic withResponseName:(NSString *)responseClassName withSuccBlock:(void(^)(StatusEntity *responseEntity))succBlock  withFailedBlock:(void(^)(NSString *errorMsg, StatusEntity *statusEntity))failedBlock
{
    [NetworkManager getRequestForService:service withParamDic:paramDic withResponseName:responseClassName withRequestType:Req_NoCache withSuccBlock:succBlock withFailedBlock:failedBlock];
}

/**
 *  带缓存的数据GET网络请求
 *  调用改接口的数据，可以缓存数据，默认是对缓存第一页的数据，如果不是分页数据，则缓存所有数据
 *
 *  @param service           <#service description#>
 *  @param paramDic          <#paramDic description#>
 *  @param requestTyep       <#requestTyep description#>
 *  @param responseClassName <#responseClassName description#>
 *  @param succBlock         <#succBlock description#>
 *  @param failedBlock       <#failedBlock description#>
 */
+ (void)getRequestForService:(NSString *)service withParamDic:(NSDictionary *)paramDic withResponseName:(NSString *)responseClassName withRequestType:(RequestType)requestTyep withSuccBlock:(void(^)(StatusEntity *responseEntity))succBlock  withFailedBlock:(void(^)(NSString *errorMsg, StatusEntity *statusEntity))failedBlock
{
    if(!service){
        NDLOG(@"~~~~~~~~~~~~~~~~~error~~~~~~~~~~~~~~~~~~~~~~~~\n必填参数未填:service\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
        return;
    }
    if(!paramDic){
        NDLOG(@"~~~~~~~~~~~~~~~~~maybe error~~~~~~~~~~~~~~~~~~~~~~~~\n未设定请求参数\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
    }
    
    //************************************************************************/
    //取缓存相关,这里默认对需要缓存的接口，缓存两页数据
    id pageTemp = [paramDic objectForKey:@"page"];
    int pageNum = 1;
    if(pageTemp){
        
        if([pageTemp isKindOfClass:[NSString class]]){
            NSString *tempStr = (NSString *)pageTemp;
            pageNum = [tempStr intValue];
        }else if([pageTemp isKindOfClass:[NSNumber class]]){
            NSNumber *tempNum = (NSNumber *)pageTemp;
            pageNum = [tempNum intValue];
        }
    }
    if(requestTyep == Req_RefreshAfterCache){
        
        Backcache *cache = [DataStoreManager getBackCacheWithService:service pageindex:pageNum];
        
        if(cache && cache.jsonStr){
            
            NSString *jsonStr = cache.jsonStr;
            NSDictionary *dic = [jsonStr objectFromJSONString];
            
            if(responseClassName && responseClassName.length > 0){
                
                Class entityClass = NSClassFromString(responseClassName);
                
                if(entityClass){
                    
                    NSError *error = nil;
                    
                    if ([entityClass instancesRespondToSelector:@selector(initWithDictionary:error:)]) {
                        
                        id entity = [[entityClass alloc] initWithDictionary:dic error:&error];
                        
                        if(entity){
                            
                            succBlock(entity);
                        }else{
                            
                            failedBlock(@"数据解析错误", nil);
                            NDLOG(@":数据解析错误network parse error:%@", error.description);
                        }
                    }else{
                        
                        failedBlock(@"数据解析错误", nil);
                        NDLOG(@"数据解析错误:提供的返回数据解析类不响应相关函数");
                    }
                    
                }else{
                    failedBlock(@"数据解析错误", nil);
                    NDLOG(@"数据解析错误:创建response类错误");
                }
            }
        }
    }
    /*********************************************************************/
    
    
    NSString *salt = [NetworkManager getRandomNumStr];
    NSDictionary *withBaseParam = [NetworkManager addBaseParamWithParamDic:paramDic];
    NSString *body = [NetworkManager encodeBodyWithParamDic:withBaseParam withSalt:salt];
    
    NSString *urlStr = [NetworkManager getRequestUrlWithService:service withData:body withSalt:salt];
    
    //输出日志
    NDLOG(@"~~~~~~~~~~~~~~~~~~请求url~~~~~~~~~~~~~~~~~~~~~~~\n");
    NDLOG(@"%@\n", urlStr);
    NDLOG(@"请求参数:\n");
    NDLOG(@"%@", withBaseParam);
    NDLOG(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
    
    
    NSMutableURLRequest *_urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    [_urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [_urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [_urlRequest setTimeoutInterval: 30];       //设置超时时间;
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:_urlRequest];
    AFJSONResponseSerializer *ser = [AFJSONResponseSerializer serializer];
    NSMutableSet *acceptableContentTypes = [[NSMutableSet alloc] initWithSet:ser.acceptableContentTypes];
    ser.acceptableContentTypes = acceptableContentTypes;
    [op  setResponseSerializer:ser];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableDictionary *fullResponseDic = [NetworkManager getResponseBodyWithResponseDic:responseObject];
        
        //输出日志
        NDLOG(@"~~~~~~~~~~~~~~~~~~~接口返回字典~~~~~~~~~~~~~~~~~~~~~~\n");
        NDLOG(@"%@", fullResponseDic);
        NDLOG(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
        
        [fullResponseDic removeObjectForKey:@"body_test"];
        
        NSString *status = [fullResponseDic objectForKey:@"status"];
        if([status intValue] == SuccStatus){
            
            //请求成功
            if(responseClassName && responseClassName.length > 0){
                
                Class entityClass = NSClassFromString(responseClassName);
                
                if(entityClass){
                    
                    NSError *error = nil;
                    
                    if ([entityClass instancesRespondToSelector:@selector(initWithDictionary:error:)]) {
                        
                        id entity = [[entityClass alloc] initWithDictionary:fullResponseDic error:&error];
                        
                        if(entity){
                            
                            succBlock(entity);
                        }else{
                            
                            failedBlock(@"数据解析错误", nil);
                            NDLOG(@"数据解析错误:network parse error:%@", error.description);
                        }
                    }else{
                        
                        failedBlock(@"数据解析错误", nil);
                        NDLOG(@"数据解析错误:提供的返回数据解析类不响应相关函数");
                    }
                    
                }else{
                    failedBlock(@"数据解析错误", nil);
                    NDLOG(@"数据解析错误:创建response类错误");
                }
            }else{
                
                succBlock(nil);
            }
            
            /**************************************************/
            //存储缓存相关
            if(requestTyep == Req_RefreshAfterCache){
                
                if(pageTemp && pageNum <= 2){

                    [DataStoreManager deleteBackCacheWithService:service pageindex:pageNum];
                    [DataStoreManager addBackCacheWithService:service pageindex:pageNum jsonStr:[fullResponseDic JSONString]];
                }else{
                    //没有分页，则直接缓存全部
                    [DataStoreManager deleteBackCacheWithService:service pageindex:1];
                    [DataStoreManager addBackCacheWithService:service pageindex:1 jsonStr:[fullResponseDic JSONString]];
                }
            }
            /**************************************************/
            
        }else{
            NSString *errorMsg = [fullResponseDic objectForKey:@"message"];
            
            StatusEntity *statusEntity = nil;
            NSError *error = nil;
            statusEntity = [[StatusEntity alloc] initWithDictionary:fullResponseDic error:&error];
            if(error){
                NDLOG(@"network parse error:%@", error.description);
            }
            failedBlock(errorMsg, statusEntity);
            
            //如果为时间验证失败，则重新请求服务端时间
            NSString *status = [fullResponseDic objectForKey:@"status"];
            if([status intValue] == [LocalServiceTimeOut intValue]  && instance.isConnectToNet){
                //需要重新请求时间,并且当前有网络
                [NetworkManager getServiceTime];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failedBlock(@"网络错误", nil);
    }];
    [op start];
}

/**
 *  不带参数的GET网络请求
 *
 *  @param service      <#service description#>
 *  @param paramDic     <#paramDic description#>
 *  @param successBlock <#successBlock description#>
 *  @param failedBlock  <#failedBlock description#>
 */
+ (void)getRequestForService:(NSString *)service withSuccBlock:(void(^)(NSDictionary *responseDic))successBlock  withFailedBlock:(void(^)(NSString *errorMsg, NSDictionary *errorResponseDic))failedBlock;
{
    if(!service){
        NDLOG(@"~~~~~~~~~~~~~~~~~~~error~~~~~~~~~~~~~~~~~~~~~~\n必填参数未填:service\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
        return;
    }
    
    NSString *urlStr = [NetworkManager getRequestUrlWithService:service withData:nil withSalt:nil];
    
    //输出日志
    NDLOG(@"~~~~~~~~~~~~~~~~~~请求url~~~~~~~~~~~~~~~~~~~~~~~\n");
    NDLOG(@"%@\n", urlStr);
    NDLOG(@"没有相应地请求参数:\n");
    NDLOG(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
    
    
    NSMutableURLRequest *_urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    [_urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [_urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:_urlRequest];
    AFJSONResponseSerializer *ser = [AFJSONResponseSerializer serializer];
    //ser.needRemoveEscapeCharacter = NO;
    NSMutableSet *acceptableContentTypes = [[NSMutableSet alloc] initWithSet:ser.acceptableContentTypes];
    ser.acceptableContentTypes = acceptableContentTypes;
    [op  setResponseSerializer:ser];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *fullResponseDic = [NetworkManager getResponseBodyWithResponseDic:responseObject];
        
        //输出日志
        NDLOG(@"~~~~~~~~~~~~~~~~接口返回字典~~~~~~~~~~~~~~~~~~~~~~~~~\n");
        NDLOG(@"%@", fullResponseDic);
        NDLOG(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
        
        NSString *status = [fullResponseDic objectForKey:@"status"];
        if([status intValue] == SuccStatus){
            //请求成功
            NSDictionary *bodyDic = [fullResponseDic objectForKey:@"body"];
            successBlock(bodyDic);
        }else{
            NSString *errorMsg = [fullResponseDic objectForKey:@"message"];
            failedBlock(errorMsg, fullResponseDic);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failedBlock(@"网络错误", nil);
    }];
    [op start];
}


#pragma mark - POST请求相关
/**
 *  带参数的POST网络请求
 *
 *  @param service      service description
 *  @param paramDic     paramDic description
 *  @param successBlock successBlock description
 *  @param failedBlock  failedBlock description
 */
+ (void)postRequestForService:(NSString *)service withParamDic:(NSDictionary *)paramDic withResponseName:(NSString *)responseClassName withSuccBlock:(void(^)(StatusEntity *responseEntity))succBlock  withFailedBlock:(void(^)(NSString *errorMsg, StatusEntity *statusEntity))failedBlock
{
    if(!service){
        NDLOG(@"~~~~~~~~~~~~~~~~~~~error~~~~~~~~~~~~~~~~~~~~~~\n必填参数未填:service\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
        return;
    }
    
    NSString *baseUrl = [AppStartManager getBaseUrl];
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@/do",baseUrl];
    
    NSString *salt = [NetworkManager getRandomNumStr];
    NSDictionary *withBaseParam = [NetworkManager addBaseParamWithParamDic:paramDic];
    NSString *body = [NetworkManager encodeBodyWithParamDic:withBaseParam withSalt:salt];
    
    NSString *time = [NSString stringWithFormat:@"%lld", [instance getRequestTimestamp]];
    
    NSMutableString *token = [[NSMutableString alloc] initWithString:@""];
    [token appendString:service];
    [token appendString:time];
    [token appendString:body];
    [token appendString:salt];
    [token appendString:Version];
    [token appendString:E_KEY];
    NSString *tokenStr = [token stringFromMD5];
    
    NSString *data =  [NetworkManager encodeToPercentEscapeString:body];
    
    NSMutableDictionary *postParamDic = [[NSMutableDictionary alloc] initWithDictionary:withBaseParam];
    [postParamDic setValue:tokenStr forKey:@"token"];
    if(data.length > 0){
        [postParamDic setValue:data forKey:@"data"];
    }
    [postParamDic setValue:time forKey:@"time"];
    [postParamDic setValue:service forKey:@"service"];
    [postParamDic setValue:Version forKey:@"version"];
    [postParamDic setValue:salt forKey:@"salt"];
    
    //输出日志
    NDLOG(@"~~~~~~~~~~~~~~~~~~请求url~~~~~~~~~~~~~~~~~~~~~~~\n");
    NDLOG(@"%@\n", urlStr);
    NDLOG(@"请求参数:%@\n", postParamDic);
    NDLOG(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
    
    
    NSMutableURLRequest *_urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    [_urlRequest setHTTPMethod:@"POST"];
    
    NSString *bodyString = [NetworkManager HTTPBodyWithParameters :postParamDic];
    NDLOG(@"请求body字符串:%@", bodyString);
    [_urlRequest setHTTPBody :[bodyString dataUsingEncoding : NSUTF8StringEncoding ]];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:_urlRequest];
    AFJSONResponseSerializer *ser = [AFJSONResponseSerializer serializer];
    NSMutableSet *acceptableContentTypes = [[NSMutableSet alloc] initWithSet:ser.acceptableContentTypes];
    ser.acceptableContentTypes = acceptableContentTypes;
    [op  setResponseSerializer:ser];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        
        NSMutableDictionary *fullResponseDic = [NetworkManager getResponseBodyWithResponseDic:responseObject];
        
        //输出日志
        NDLOG(@"~~~~~~~~~~~~~~~~~~~接口返回字典~~~~~~~~~~~~~~~~~~~~~~\n");
        NDLOG(@"%@", fullResponseDic);
        NDLOG(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
        
        [fullResponseDic removeObjectForKey:@"body_test"];
        
        NSString *status = [fullResponseDic objectForKey:@"status"];
        if([status intValue] == SuccStatus){
            
            //请求成功
            if(responseClassName && responseClassName.length > 0){
                
                Class entityClass = NSClassFromString(responseClassName);
                
                if(entityClass){
                    
                    NSError *error = nil;
                    
                    if ([entityClass instancesRespondToSelector:@selector(initWithDictionary:error:)]) {
                        
                        id entity = [[entityClass alloc] initWithDictionary:fullResponseDic error:&error];
                        
                        if(entity){
                            
                            succBlock(entity);
                        }else{
                            
                            failedBlock(@"数据解析错误", nil);
                            NDLOG(@"数据解析错误:network parse error:%@", error.description);
                        }
                    }else{
                        
                        failedBlock(@"数据解析错误", nil);
                        NDLOG(@"数据解析错误:提供的返回数据解析类不响应相关函数");
                    }
                    
                }else{
                    failedBlock(@"数据解析错误", nil);
                    NDLOG(@"数据解析错误:创建response类错误");
                }
            }else{
                
                succBlock(nil);
            }
            
        }else{
            NSString *errorMsg = [fullResponseDic objectForKey:@"message"];
            
            StatusEntity *statusEntity = nil;
            NSError *error = nil;
            statusEntity = [[StatusEntity alloc] initWithDictionary:fullResponseDic error:&error];
            if(error){
                NDLOG(@"network parse error:%@", error.description);
            }
            failedBlock(errorMsg, statusEntity);
            
            //如果为时间验证失败，则重新请求服务端时间
            NSString *status = [fullResponseDic objectForKey:@"status"];
            if([status intValue] == [LocalServiceTimeOut intValue]  && instance.isConnectToNet){
                //需要重新请求时间,并且当前有网络
                [NetworkManager getServiceTime];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failedBlock(@"网络错误", nil);
    }];
    [op start];
}

+ ( NSString *)HTTPBodyWithParameters:( NSDictionary *)parameters
{
    NSMutableArray *parametersArray = [[ NSMutableArray alloc ] init ];
    
    for ( NSString *key in [parameters allKeys ]) {
        id value = [parameters objectForKey :key];
        if ([value isKindOfClass :[ NSString class ]]) {
            [parametersArray addObject :[ NSString stringWithFormat :@"%@=%@" ,key,value]];
        }
        
    }
    
    return [parametersArray componentsJoinedByString : @"&" ];
}


/**
 *  获取六位随机数
 *
 *  @return <#return value description#>
 */
+ (NSString*)getRandomNumStr
{
    char cradom[6];
    for (int i=0; i<6; cradom[i++]='0'+arc4random_uniform(9)) ;
    
    return [[NSString alloc] initWithBytes:cradom length:6 encoding:NSUTF8StringEncoding];
}


#pragma mark - 业务相关(公共部分)
/**
 *  获取服务端时间戳，并计算与本地时间的差值
 */
+ (void)getServiceTime
{
    if(instance.isGetServieTime){
        return;
    }
    
    instance.isGetServieTime = YES;
    [NetworkManager getRequestForService:@"systemTime" withSuccBlock:^(NSDictionary *dic){
        
        instance.isGetServieTime = NO;

        NSString *re = [dic objectForKey:@"time"];
        
        NSDate *date=[NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval time=[date timeIntervalSince1970];
        long long deviceTime = (long long)time;
        NSString *strTime = [NSString stringWithFormat:@"%lld",deviceTime];
        NDLOG(@"%@  server time", re);
        NDLOG(@"%@  device time",strTime);
        
        instance.local_service_timeInterval = deviceTime - [re longLongValue];
        instance.local_service_timeInterval = -instance.local_service_timeInterval;
        
        instance.isHavedProofreadTime = YES;

    }withFailedBlock:^(NSString *errorMsg, NSDictionary *dic){
        
        NDLOG(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n获取服务端时间失败\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
        instance.isGetServieTime = NO;
    }];
}


#pragma mark - 内部调用接口
/**
 *  获取客户端本地的unix时间戳
 *
 *  @return <#return value description#>
 */
- (long long)getDeviceUnixTimestamp
{
    NSDate *date=[NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[date timeIntervalSince1970];
    long long deviceTime = (long long)time;
    return deviceTime;
}

/**
 *  获取计算了偏差的时间戳
 *
 *  @return <#return value description#>
 */
- (long long)getRequestTimestamp
{
    return [self getDeviceUnixTimestamp] + self.local_service_timeInterval;
}


/**
 *  根据盐值获取加解密的KEY
 *
 *  @param salt <#salt description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)getKeyWithSalt:(NSString *)salt
{
    if(!salt){
        return nil;
    }
    NSString *tempKey = [NSString stringWithFormat:@"%@%@", salt, E_KEY];
    NSString *key = [tempKey stringFromMD5];
    return key;
}

/**
 *  加密请求参数
 *
 *  @param dic  dic description
 *  @param salt salt description
 *
 *  @return return value description
 */
+ (NSString *)encodeBodyWithParamDic:(NSDictionary *)dic  withSalt:(NSString *)salt
{
    NSString *key = [NetworkManager getKeyWithSalt:salt];
    NSString *data = [dic JSONString];
    data = [data encryptStringWithKey:key];
    return data;
}

/**
 *  获取请求的url，包括计算token的步骤
 *
 *  @param service service description
 *  @param data    data description
 *  @param time    time description
 *
 *  @return return value description
 */
+ (NSString *)getRequestUrlWithService:(NSString *)service withData:(NSString *)data withSalt:(NSString *)salt
{
    NSString *baseUrl = [AppStartManager getBaseUrl];
    
    if(!data){
        //没有请求参数则直接拼接service
        NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@/do?service=%@",baseUrl, service];
        
        return urlStr;
    }
    
    NSString *time = [NSString stringWithFormat:@"%lld", [instance getRequestTimestamp]];
    
    NSMutableString *token = [[NSMutableString alloc] initWithString:@""];
    [token appendString:service];
    [token appendString:time];
    [token appendString:data];
    [token appendString:salt];
    [token appendString:Version];
    [token appendString:E_KEY];
    NSString *tokenStr = [token stringFromMD5];
    
    data =  [NetworkManager encodeToPercentEscapeString:data];
    
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@/do?service=%@&token=%@&data=%@&time=%@&version=%@&salt=%@",baseUrl, service, tokenStr, data, time, Version, salt];

    return urlStr;
}

+ (NSString *)getRequestFileUrlWithService:(NSString *)service withData:(NSString *)data withSalt:(NSString *)salt
{
    NSString *baseUrl = [AppStartManager getBaseUrl];
    
    if(!data){
        //没有请求参数则直接拼接service
        NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@/do?service=%@",baseUrl, service];
        
        return urlStr;
    }
    
    NSString *time = [NSString stringWithFormat:@"%lld", [instance getRequestTimestamp]];
    
    NSMutableString *token = [[NSMutableString alloc] initWithString:@""];
    [token appendString:service];
    [token appendString:time];
    [token appendString:data];
    [token appendString:salt];
    [token appendString:Version];
    [token appendString:E_KEY];
    NSString *tokenStr = [token stringFromMD5];
    
    data =  [NetworkManager encodeToPercentEscapeString:data];
    
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@/do_file?service=%@&token=%@&data=%@&time=%@&version=%@&salt=%@",baseUrl, service, tokenStr, data, time, Version, salt];
    
    return urlStr;
}

//获取请求参数
+ (NSMutableDictionary *)getRequestDicWithService:(NSString *)service withData:(NSString *)data withSalt:(NSString *)salt
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSString *time = [NSString stringWithFormat:@"%lld", [instance getRequestTimestamp]];
    
    NSMutableString *token = [[NSMutableString alloc] initWithString:@""];
    [token appendString:service];
    [token appendString:time];
    [token appendString:data];
    [token appendString:salt];
    [token appendString:Version];
    [token appendString:E_KEY];
    NSString *tokenStr = [token stringFromMD5];
    
    //data =  [NetworkManager encodeToPercentEscapeString:data];
    
    [dic setObject:service forKey:@"service"];
    [dic setObject:tokenStr forKey:@"token"];
    [dic setObject:data forKey:@"data"];
    [dic setObject:time forKey:@"time"];
    [dic setObject:Version forKey:@"version"];
    [dic setObject:salt forKey:@"salt"];
    
    return dic;
}

+ (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    NSString*
    outputStr = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                             
                                                                             NULL, /* allocator */
                                                                             
                                                                             (__bridge CFStringRef)input,
                                                                             
                                                                             NULL, /* charactersToLeaveUnescaped */
                                                                             
                                                                             (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                             
                                                                             kCFStringEncodingUTF8);
    
    
    return
    outputStr;
}


/**
 *  解析相应地包中的body部分,并返回所有的相应字典
 *
 *  @param dic <#dic description#>
 *
 *  @return <#return value description#>
 */
+ (NSMutableDictionary *)getResponseBodyWithResponseDic:(NSDictionary *)dic
{
    NSString *salt = [dic objectForKey:@"salt"];
    NSString *body = [dic objectForKey:@"body"];
    
     NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    
    if(!salt || !body){
        //如果没有盐值，或者body参数，则直接返回原字典
        return bodyDic;
    }
    
    NSString *key = [NetworkManager getKeyWithSalt:salt];
    NSString *bodyStr = [body decryptStringWithKey:key];
    NSDictionary *desBodyDic = [bodyStr objectFromJSONString];
    
    [bodyDic removeObjectForKey:@"body"];
    if(!desBodyDic){
        NDLOG(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n网络请求body解析错误!\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
    }else{
        [bodyDic setObject:desBodyDic forKey:@"body"];
    }
    return bodyDic;
}

+ (NSString *)getUploadFileUrlWithService:(NSString *)service withData:(NSString *)data withSalt:(NSString *)salt
{
    NSString *baseUrl = [AppStartManager getBaseUrl];

    NSString *key = [NetworkManager getKeyWithSalt:salt];
    data = [data encryptStringWithKey:key];
    
    NSString *time = [NSString stringWithFormat:@"%lld", [instance getRequestTimestamp]];
    
    NSMutableString *token = [[NSMutableString alloc] initWithString:@""];
    [token appendString:service];
    [token appendString:time];
    [token appendString:data];
    [token appendString:salt];
    [token appendString:Version];
    [token appendString:E_KEY];
    NSString *tokenStr = [token stringFromMD5];
    
    data =  [NetworkManager encodeToPercentEscapeString:data];
    
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@/do_file?service=%@&token=%@&data=%@&time=%@&version=2.0&salt=%@", baseUrl, service, tokenStr, data, time, salt];
    
    return urlStr;
}
@end
