//
//  GYGoodsDetailModel.m
//  HSConsumer
//
//  Created by 00 on 15-2-4.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYGoodsDetailModel.h"

@implementation SelShopModel


@end


@implementation ArrSubsModel


@end

@implementation ArrModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.arrSubs = [[NSMutableArray alloc] init];
    }
    return self;
}
@end

@implementation GYGoodsDetailModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.arrBasicParameter = [[NSMutableArray alloc] init];
        self.arrPicList = [[NSMutableArray alloc] init];
        self.arrPropList = [[NSMutableArray alloc] init];
    }
    return self;
}


@end


