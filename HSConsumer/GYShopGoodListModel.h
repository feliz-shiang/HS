//
//  GYShopGoodListModel.h
//  HSConsumer
//
//  Created by Apple03 on 15/8/25.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//
typedef void(^CompletionBlock)(NSArray *goodsList,NSError *error);
#import <Foundation/Foundation.h>
#import "JSONModel.h"
//"itemId": "2405552721003520",
//"itemName": "畅想KTV",
//"price": 18,
//"pv": 1,
//"rate": null,
//"salesCount": 2
//shopId
//"url": "http://192.168.228.97:9099/v1/tfs//T1hNxTBCAT1RXrhCrK.jpg"
@interface GYShopGoodListModel : JSONModel
@property (nonatomic,copy) NSString * itemId;
@property (nonatomic,copy) NSString * itemName;
@property (nonatomic,copy) NSString * price;
@property (nonatomic,copy) NSString * pv;
@property (nonatomic,copy) NSString * rate;
@property (nonatomic,copy) NSString * salesCount;
@property (nonatomic,copy) NSString * url;
@property (nonatomic,copy) NSString * shopId;

+ (void)loadDataFromNetWorkWithParams:(NSDictionary *)params Complection:(CompletionBlock)block;
@end
