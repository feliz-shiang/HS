//
//  GYChooseGoodsCategoryViewController.h
//  HSConsumer
//
//  Created by apple on 15/8/27.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//
typedef void(^reloadGoodsDataBolck)(NSString*,NSString*);
#import <UIKit/UIKit.h>

@interface GYChooseGoodsCategoryViewController : UITableViewController
@property (nonatomic,copy) NSString * strShopID;
@property (nonatomic,weak) UIViewController *pushedVC;
@property (nonatomic,copy) reloadGoodsDataBolck CompletionBlock;
@end
