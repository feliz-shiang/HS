//
//  DiscountModel.h
//  HSConsumer
//
//  Created by apple on 15/7/1.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscountModel : NSObject
@property (nonatomic , copy) NSString *userCouponId;
@property (nonatomic , copy) NSString *couponName;
@property (nonatomic , copy) NSString *amount;
@property (nonatomic , copy) NSString *faceValue;
@property (nonatomic , copy) NSString *surplusNum;
@property (nonatomic , copy) NSString *sum;

@property (nonatomic , copy) NSString *usedNumber;  //已用数量
@property (nonatomic , copy) NSString *expEnd;      //有效期结束时间
@property (nonatomic , copy) NSString *couponUseTime;//使用时间
@property (nonatomic , copy) NSString *orderNo;//订单号
@end
