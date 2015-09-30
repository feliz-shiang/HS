//
//  GYShopDetailViewController.h
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYEasyBuyModel.h"
#import "GYCitySelectViewController.h"
#import "UIImageView+WebCache.h"
#import  <BaiduMapAPI/BMapKit.h>
#import "JGActionSheet.h"
@interface GYShopDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,BMKLocationServiceDelegate,UIScrollViewDelegate>
{
  BMKLocationService* _locService;
    @public
    BMKMapPoint mp1;
}

@property (nonatomic,copy) NSString *ShopID;//传值：商铺ID
@property (nonatomic,copy) NSString * strVshopId;
@property  (nonatomic,copy)NSString *strShopDistance;
@property  (nonatomic,assign)int fromEasyBuy;
@property (nonatomic,strong)ShopModel * model;
@property (nonatomic,assign)BMKMapPoint currentMp1;
@property (nonatomic,assign)BOOL newshop;

@end
