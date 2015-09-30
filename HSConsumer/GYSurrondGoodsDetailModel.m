//
//  GYSurrondGoodsDetailModel.m
//  HSConsumer
//
//  Created by apple on 15-3-9.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYSurrondGoodsDetailModel.h"

@implementation GYSurrondGoodsDetailModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _propList=[NSMutableArray array];
        _shopUrl=[NSMutableArray array];
    }
    return self;
}
@end
