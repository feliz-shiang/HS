//
//  GYBuyGoodDetailModel.h
//  HSConsumer
//
//  Created by Apple03 on 15/9/12.
//  Copyright (c) 2015年 guiyi. All rights reserved.
// 购买商品的详细信息

#import <Foundation/Foundation.h>

@interface GYBuyGoodDetailModel : NSObject
@property (nonatomic,copy) NSString * quantity;
@property (nonatomic,copy) NSString * categoryId;
@property (nonatomic,copy) NSString * vShopId;
@property (nonatomic,copy) NSString * url;
@property (nonatomic,copy) NSString * itemName;
@property (nonatomic,copy) NSString * skuId;
@property (nonatomic,copy) NSString * price;
@property (nonatomic,copy) NSString * subTotal;
@property (nonatomic,copy) NSString * point;
@property (nonatomic,copy) NSString * skus;
@property (nonatomic,copy) NSString * subPoints;
@property (nonatomic,copy) NSString * itemId;
@property (nonatomic,copy) NSString * ruleId; // 抵扣券规则id
@end
