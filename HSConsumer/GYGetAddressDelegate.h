//
//  GYGetAddressDelegate.h
//  HSConsumer
//
//  Created by apple on 14-11-6.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYAddressModel.h"
@protocol GYGetAddressDelegate <NSObject>
@optional
-(void)getAddressModle:(GYAddressModel *)model;
@end
