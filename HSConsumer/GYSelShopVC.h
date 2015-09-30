//
//  GYSelShopVC.h
//  HSConsumer
//
//  Created by 00 on 15-2-6.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYGoodsDetailModel.h"
#import <BaiduMapAPI/BMapKit.h>
@protocol GYSelShopDelegate <NSObject>

@optional
-(void)returnSelShopModel:(SelShopModel *)selShopModel :(NSInteger)index;
-(void)returnSelShopModel:(SelShopModel *)selShopModel selectIndex:(NSInteger)index tag:(NSInteger)tag WithShopid :(NSString *)shopid;

@end


@interface GYSelShopVC : UIViewController

@property (assign , nonatomic) NSInteger selIndex;
@property (assign ,nonatomic) id<GYSelShopDelegate> delegate;
@property (strong , nonatomic) GYGoodsDetailModel *model;
@property (assign , nonatomic) NSInteger tag;
@property (nonatomic,copy)NSString * shopid;

@end
