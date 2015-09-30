//
//  GYSearchShopGoodsViewController.h
//  HSConsumer
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 zhangqy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShowGoodsDetailDelegate <NSObject>

- (void)loadHotGoodInfoWithItemid:(NSString *)itemid vShopid:(NSString *)vShopid;

@end
@interface GYSearchShopGoodsViewController : UIViewController
@property (copy,nonatomic)NSString *vshopId;
@property (copy,nonatomic)NSString *categoryName;
@property (copy,nonatomic)NSString *categoryId;
@property (strong, nonatomic) NSMutableDictionary *params;
@property (copy,nonatomic)NSString *brandName;
@property (weak,nonatomic)id<ShowGoodsDetailDelegate> delegate;
@end
