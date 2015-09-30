//
//  GYAddressModel.h
//  HSConsumer
//
//  Created by apple on 14-10-17.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYAddressModel : NSObject
@property (nonatomic,copy)NSString * CustomerName;//消费者姓名
@property (nonatomic,copy)NSString * CustomerPhone;//电话
@property (nonatomic,copy)NSString * Province;//省
@property (nonatomic,copy)NSString * City;//城市
@property (nonatomic,copy)NSString * Area;//区
@property (nonatomic,copy)NSString * DetailAddress;//详细地址
@property (nonatomic,copy)NSString * TelphoneNumber;//固定电话 返回的数据中没有
@property (nonatomic,copy)NSString * PostCode;//邮编 返回的数据中没有
@property (nonatomic,copy)NSString * AddressId;// 地址ID
@property (nonatomic,copy)NSString * BeDefault;// 是否是默认地址
@property (nonatomic,copy)NSString * idString;// 地址ID

@property (nonatomic,copy)NSString * fullAddress;// 省+城市+区+详细地址 //add by liangzm
@property (nonatomic,assign)BOOL isSelect;
@property (nonatomic,assign)float height;
@end
