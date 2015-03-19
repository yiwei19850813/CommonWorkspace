//
//  LocationManager.m
//  iSing
//
//  Created by bwzhu on 14-1-14.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager ()
{
    CLLocationManager *locationManager;
    CLLocationCoordinate2D mylocation;//存储定位得到的精度和纬度
    CLGeocoder *Geocoder;//CLGeocoder
    bool _isNeedSearch;
    NSMutableArray  *_delegates;
    
}

@end

@implementation LocationManager

static LocationManager * instance;

+ (LocationManager *)getInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LocationManager alloc] init];
    });
    
    return instance;
}

- (id)init
{
    if (self = [super init])
    {
        locationManager = [[CLLocationManager alloc] init];         //创建位置管理器
        locationManager.delegate = self;                            //设置代理
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;  //指定需要的精度级别
        locationManager.distanceFilter = kCLDistanceFilterNone;     //设置距离筛选器 ，动1000米才有反应
        if(IOS_VERSION >= 8){
            
            [locationManager requestAlwaysAuthorization];
        }
    }
    return self;
}

// 开启定位
- (void)startLocation
{
    _isNeedSearch = true;
    [locationManager startUpdatingLocation];
}
- (void)startLocationWithChose
{
    
}
// 关闭定位
- (void)stopLocation
{
    _isNeedSearch = false;
    [locationManager stopUpdatingLocation];
}

// 解析位置
- (void)showWithlocation:(CLLocationCoordinate2D)location
{
    if (Geocoder == nil)
    {
        Geocoder = [[CLGeocoder alloc] init];
    }
    
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
    
    [Geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark *placemark in placemarks)
        {
             self.country = [placemark.addressDictionary objectForKey:@"Country"];
            DLOG(@"Country %@",self.country);
            
            self.province = [placemark.addressDictionary objectForKey:@"State"];
            DLOG(@"State %@",self.province);
            
            self.city = [placemark.addressDictionary objectForKey:@"City"];
            DLOG(@"City %@",self.city);
            
            self.cityCode = [placemark.addressDictionary objectForKey:@"CountryCode"];
            DLOG(@"CountryCode %@",self.cityCode);
            
            self.subLocality = [placemark.addressDictionary objectForKey:@"SubLocality"];
            DLOG(@"SubLocality %@",self.subLocality);
            
            self.street = [placemark.addressDictionary objectForKey:@"Street"];
            DLOG(@"Street %@",self.street);
            
            self.zip = [placemark.addressDictionary objectForKey:@"ZIP"];
            DLOG(@"ZIP %@",self.zip);
            
            //Post获取地理信息成功
            [[NSNotificationCenter defaultCenter] postNotificationName:LM_LOCATION_GET_SUCCESS
                                                                object:nil];
            break;
        }
    }];
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if ([CLLocationManager locationServicesEnabled] && (kCLAuthorizationStatusAuthorized == status || kCLAuthorizationStatusNotDetermined == status))
    {
        if(IOS_VERSION >= 8.0 && kCLAuthorizationStatusNotDetermined == status){
            
            [manager requestAlwaysAuthorization];
            return;
        }
        
        //上一次已经授权对应的GPS权限
        DLOG(@"can update location");
        CLLocationDegrees latitude = manager.location.coordinate.latitude;
        CLLocationDegrees longitude = manager.location.coordinate.longitude;
        DLOG(@"latitude %f",latitude);
        DLOG(@"longitude %f",longitude);
        self.loaction = manager.location;
        mylocation.latitude=latitude;
        mylocation.longitude=longitude;
        [self showWithlocation:mylocation];
        [self stopLocation];
    }else if(kCLAuthorizationStatusDenied == status){
        
        [UIAlertView showWithTitle:@"定位服务未开启" message:@"你可以在系统设置中开启定位服务。\n(设置>隐私>定位服务>开启咪咕爱唱)" cancelButtonTitle:@"知道了" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            
        }];
        DLOG(@"没有获取到地里位置信息权限");
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //获取地理位置失败
    DLOG(@"locationManager failed: %@", error);
    [[NSNotificationCenter defaultCenter] postNotificationName:LM_LOCATION_GET_FAIL
                                                        object:nil];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if(_isNeedSearch == false)
    {
        return;
    }
    
    for (CLLocation *location in locations)
    {
        self.loaction = location;
        mylocation.latitude = location.coordinate.latitude;
        mylocation.longitude = location.coordinate.longitude;
        [self showWithlocation:mylocation];
        [self stopLocation];
        break;
    }
}
#else
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    if(_isNeedSearch == false)
    {
        return;
    }
    
    self.loaction = newLocation;
    CLLocationDegrees latitude = newLocation.coordinate.latitude; //float也行，获得当前位置的纬度.location属性获
    CLLocationDegrees longitude = newLocation.coordinate.longitude;
    DLOG(@"latitude %f",latitude);
    DLOG(@"longitude %f",longitude);
    mylocation.latitude=latitude;
    mylocation.longitude=longitude;
    [self showWithlocation:mylocation];
    [self stopLocation];
}
#endif

#pragma mark-
#pragma mark 外部接口
-(void) getMyLocation{
    
    [self startLocation];
}

@end
