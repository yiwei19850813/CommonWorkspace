//
//  LocationManager.h
//  iSing
//
//  Created by xdyang on 14-1-14.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

//GPS State Name
#define LM_LOCATION_GET_SUCCESS    @"LM_LOCATION_GET_SUCCESS"   //获取地点成功
#define LM_LOCATION_GET_FAIL       @"LM_LOCATION_GET_FAIL"      //获取地点失败



// 注意：在不需要使用位置服务时，要将该类的 delegate 设为nil，以防野指针

@class LocationManager;
@protocol LocationMgrDelegate <NSObject>

- (void)locationFinish:(LocationManager *)locationMgr succeed:(BOOL)succeed;

@end

@interface LocationManager : NSObject<CLLocationManagerDelegate>

@property (nonatomic, copy)NSString *country;        // 国家
@property (nonatomic, copy)NSString *province;       // 省份
@property (nonatomic, copy)NSString *city;           // 城市
@property (nonatomic, copy)NSString *cityCode;       // 城市编号
@property (nonatomic, copy)NSString *subLocality;    // 区
@property (nonatomic, copy)NSString *street;         // 街道
@property (nonatomic, copy)NSString *zip;
@property (nonatomic, retain)CLLocation* loaction;   // 位置信息

@property (nonatomic, assign) BOOL beUpdateSuccessful;

+ (LocationManager *)getInstance;

//- (void)addDelegate:(id)delegate;
//- (void)removeDelegate:(id)delegate;
- (void)startLocation;      // 开启定位服务，在获得一个有效数据后，会自动关闭定位服务
- (void)stopLocation;       // 关闭定位服务
- (void) getMyLocation;     // 获得当前位置，信息储存在该类的各属性里（功能等同于startLocation，但函数名字更好理解）


@end
