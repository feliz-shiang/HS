//
//  GYDiscountInfoModel.m
//  HSConsumer
//
//  Created by Apple03 on 15/9/14.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYDiscountInfoModel.h"

@implementation GYDiscountInfoModel
+(NSDictionary *)objectClassInArray
{
    
    return @{@"expressFeeList":@"GYExpressFeeModel",@"orderCouponList":@"GYDiscountFeeModel"};
}
@end

@implementation GYExpressFeeModel

@end

@implementation GYDiscountFeeModel
+(NSDictionary *)objectClassInArray
{
    
    return @{@"list":@"GYDiscountFeeDetailModel"};
}
@end

@implementation GYDiscountFeeDetailModel

@end