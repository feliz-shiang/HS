//
//  NetworkType.h
//  HSConsumer
//
//  Created by apple on 14-10-10.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

//手机网络类型  (通过网络图标判断网络类型)

typedef enum
{
    kNetworkTypeNone= 0,
    kNetworkType2G= 1,
    kNetworkType3G= 2,
    kNetworkType4G= 3,
    kNetworkType5G= 4,
    kNetworkTypeWifi= 5
}NETWORK_TYPE;

#import <Foundation/Foundation.h>

@interface NetworkType : NSObject

/**
 *	判断网络类型
 *
 *	@return 网络类型(代码)
     kNetworkTypeNone= 0,
     kNetworkType2G= 1,
     kNetworkType3G= 2,
     kNetworkType4G= 3,
     kNetworkType5G= 4,
     kNetworkTypeWifi= 5
 */
+ (NETWORK_TYPE)getNetworkType;

/**
 *	判断网络类型
 *
 *	@return	网络类型(字符串)
 */
+ (NSString *)getNetworkTypeString;

@end
