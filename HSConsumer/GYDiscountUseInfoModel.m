//
//  GYDiscountUseInfoModel.m
//  HSConsumer
//
//  Created by Apple03 on 15/9/15.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYDiscountUseInfoModel.h"

@implementation GYDiscountUseInfoModel
-(NSString *)useNum
{
    if (!_useNum)
    {
        _useNum = @"";
    }
    return _useNum;
}
@end
