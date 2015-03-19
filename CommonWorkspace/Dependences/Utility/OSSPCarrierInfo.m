//
//  CarrierInfo.m
//  STMLite
//
//  Created by 陈曦 xichen2 on 11-5-5.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OSSPCarrierInfo.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

const NSString *const CarrierApTypeStr[] = 
{
	@"cmnet",
	@"uninet",
	@"ctnet",
	@"Unkownn"
};

@implementation OSSPCarrierInfo

+ (NSString *)getCarrierName
{
	CTTelephonyNetworkInfo *info = [[[CTTelephonyNetworkInfo alloc] init] autorelease];
	CTCarrier *carrier = info.subscriberCellularProvider;
    NSLog(@"%@", info.currentRadioAccessTechnology);
	
	return carrier.carrierName;
}

+ (CARRIER_AP_TYPE)getApTypeByCarrierName:(NSString *)carrierName
{
	if(!carrierName)
	{
		return CARRIER_AP_TYPE_MAX;
	}
	
	if([carrierName isEqualToString:@"中国移动"])
	{
		return CARRIER_AP_TYPE_CMNET;
	}
	else if([carrierName isEqualToString:@"中国联通"])
	{
		return CARRIER_AP_TYPE_UNINET;
	}
	else if([carrierName isEqualToString:@"中国电信"])
	{
		return CARRIER_AP_TYPE_CTNET;
	}
	else
	{
		return CARRIER_AP_TYPE_MAX;
	}
}

+ (NSString *)getApTypeStrByType:(CARRIER_AP_TYPE)type
{
	return (NSString*)CarrierApTypeStr[(int)type];
}

+ (NSString *)getApTypeStrByCarrierName:(NSString *)carrierName
{
	return [self getApTypeStrByType:[self getApTypeByCarrierName:carrierName]];
}

+ (NSString *)getCarrierEnName
{
    return [self getApTypeStrByCarrierName:[self getCarrierName]];
}

@end
