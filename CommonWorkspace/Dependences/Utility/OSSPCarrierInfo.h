//
//  CarrierInfo.h
//  STMLite
//
//  Created by 陈曦 xichen2 on 11-5-5.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _CARRIER_AP_TYPE
{
	CARRIER_AP_TYPE_CMNET,		// cmnet
	CARRIER_AP_TYPE_UNINET,		// uninet
	CARRIER_AP_TYPE_CTNET,		// ctnet
	
	CARRIER_AP_TYPE_MAX
}CARRIER_AP_TYPE;

extern const NSString *const CarrierApTypeStr[];

@interface OSSPCarrierInfo : NSObject 
{
	
}

+ (NSString *)getCarrierName __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);
+ (CARRIER_AP_TYPE)getApTypeByCarrierName:(NSString *)carrierName __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);
+ (NSString *)getApTypeStrByType:(CARRIER_AP_TYPE)type __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);
+ (NSString *)getApTypeStrByCarrierName:(NSString *)carrierName __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);


// 获取运营商名字 "uninew uniwap "等
+ (NSString *)getCarrierEnName;

@end