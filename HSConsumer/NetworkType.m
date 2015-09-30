//
//  NetworkType.m
//  HSConsumer
//
//  Created by apple on 14-10-10.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "NetworkType.h"

@implementation NetworkType

+ (NETWORK_TYPE)getNetworkType
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSNumber *dataNetworkItemView = nil;
	for (id subview in subviews)
    {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]])
        {
            dataNetworkItemView = subview;
            break;
        }
    }
    NETWORK_TYPE nettype = kNetworkTypeNone;
    NSNumber *num = [dataNetworkItemView valueForKey:@"dataNetworkType"];
    nettype = [num intValue];
    return nettype;
}

+ (NSString *)getNetworkTypeString
{
    NSString *type = @"UNKNOW NETWORK";
    switch ([self getNetworkType])
    {
        case kNetworkTypeNone:
            type = @"NONE NETWORK";
            break;
        case kNetworkType2G:
            type = @"2G";
            break;
        case kNetworkType3G:
            type = @"3G";
            break;
        case kNetworkType4G:
            type = @"4G";
            break;
        case kNetworkType5G:
            type = @"5G";
            break;
        case kNetworkTypeWifi  :
            type = @"WIFI";
            break;
        default:
            break;
    }
    return type;
}

@end
