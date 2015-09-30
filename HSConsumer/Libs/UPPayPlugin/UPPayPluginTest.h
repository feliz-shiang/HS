//
//  UPPayPluginTest.h
//  HSConsumer
//
//  Created by apple on 14-12-9.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "UPPayPlugin.h"

@interface UPPayPluginTest : NSObject
+ (void)UPPayTest:(void (^)(NSString *tn, NSError *error))handler;
@end
