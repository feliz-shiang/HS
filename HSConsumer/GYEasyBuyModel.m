//
//  GYEasyBuyModel.m
//  HSConsumer
//
//  Created by apple on 14-11-26.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYEasyBuyModel.h"

//商品模型
@implementation GYEasyBuyModel

+ (GYEasyBuyModel *)initWithName:(NSString *)name pictureURL:(NSString *)picture
{
    GYEasyBuyModel *eb = [[self alloc] init];
    eb.strGoodName = name;
    eb.strGoodPictureURL = picture;
    return eb;
}

+ (GYEasyBuyModel *)initWithName:(NSString *)name price:(NSString *)price_ pictureURL:(NSString *)picture
{
    GYEasyBuyModel *eb = [[self alloc] init];
    eb.strGoodName = name;
    eb.strGoodPrice = price_;
    eb.strGoodPictureURL = picture;
    return eb;

}

@end

//商铺模型
@implementation ShopModel

+ (ShopModel *)initWithName:(NSString *)name address:(NSString *)pAddress tel:(NSString *)pTel pictureURL:(NSString *)picture
{
    ShopModel *shop = [[ShopModel alloc] init];
    shop.strShopName = name;
    shop.strShopAddress = pAddress;
    shop.strShopTel = pTel;
    shop.strShopPictureURL = picture;
    return shop;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.marrAllShop = [NSMutableArray array];
        self.marrHotGoods = [NSMutableArray array];
        self.marrShopImages = [NSMutableArray array];
    }
    return self;
}

//-(NSMutableArray *)marrShopImages
//{
//    
//    if (!self.marrShopImages=marrShopImages) {
//        _marrShopImages=marrShopImages;
//    }
//    return _marrShopImages;
//}

//-(void)setMarrShopImages:(NSMutableArray *)marrShopImages
//{
//    if (!_marrShopImages=marrShopImages) {
//        _marrShopImages=marrShopImages;
//    }
// 
//
//
//}

//- (NSDictionary *)dicHsConfig
//{
//    if (_dicHsConfig) return _dicHsConfig;
//    
//    NSString *configFilePath = [[NSBundle mainBundle] pathForResource:[@"config_" stringByAppendingString:[@(_currentLanguage) stringValue]]
//                                                               ofType:@"plist"];
//    if (!configFilePath)return nil;
//    _dicHsConfig = [NSDictionary dictionaryWithContentsOfFile:configFilePath];
//    return _dicHsConfig;
//}

@end