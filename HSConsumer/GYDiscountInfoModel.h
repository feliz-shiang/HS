//
//  GYDiscountInfoModel.h
//  HSConsumer
//
//  Created by Apple03 on 15/9/14.
//  Copyright (c) 2015年 guiyi. All rights reserved.
// 获取抵扣券数据的模型

#import <Foundation/Foundation.h>

//"data": {
//    "expressFeeList": [
//                       {
//                           "expressFee": "8.0",
//                           "orderKey": null
//                       }
//                       ],
//    "orderCouponList": [
//                        {
//                            "list": [
//                                     {
//                                         "amount": "100.00",
//                                         "couponId": "1",
//                                         "couponName": "测试抵扣劵",
//                                         "num": "1"
//                                     }
//                                     ],
//                            "orderKey": null
//                        }
//                        ]
//}

@interface GYDiscountInfoModel : NSObject

@property (nonatomic,strong) NSArray * expressFeeList;
@property (nonatomic,strong) NSArray * orderCouponList;
@end


@interface GYExpressFeeModel : NSObject
@property (nonatomic,copy) NSString * expressFee;
@property (nonatomic,copy) NSString * orderKey;
@end

@interface GYDiscountFeeModel : NSObject
@property (nonatomic,copy) NSString * orderKey;
@property (nonatomic,strong) NSArray * list;
@end

@interface GYDiscountFeeDetailModel : NSObject
@property (nonatomic,copy) NSString * amount;
@property (nonatomic,copy) NSString * couponId;
@property (nonatomic,copy) NSString * couponName;
@property (nonatomic,copy) NSString * num;
@end