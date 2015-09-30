//
//  GYShopGoodsListShowController.h
//  HSConsumer
//
//  Created by Apple03 on 15/8/25.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYShopBaseInfoModel;
@class GYShopGoodsListShowController;
@class GYShopGoodListModel;
@protocol ShopGoodsListShowControllerDelegate <NSObject>
@optional
-(void)ShopGoodsListShowController:(GYShopGoodsListShowController *)vc model:(GYShopGoodListModel*)model;

@end

@interface GYShopGoodsListShowController : UITableViewController
@property (nonatomic,strong) GYShopBaseInfoModel * shopDetailInfo;
@property (nonatomic,copy) NSString * strBrandName;
@property (nonatomic,weak) id <ShopGoodsListShowControllerDelegate> delegate;
@property (nonatomic , assign)BOOL isHotGood;

-(void)httpRequestForGoodsWithKeyWords:(NSString *)keyWords categoryName:(NSString *)categoryName brandName:(NSString *)brandName sortType:(NSString *)sortType;
-(void)getHotGoods;
@end
