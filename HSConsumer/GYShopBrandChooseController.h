//
//  GYShopBrandChooseController.h
//  HSConsumer
//
//  Created by Apple03 on 15/8/26.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYShopBrandChooseController;

@protocol ShopBrandChooseControllerDelegate <NSObject>
@optional
-(void)ShopBrandChooseControllerDidChooseBrand:(NSString *)brand;

@end

@interface GYShopBrandChooseController : UITableViewController
@property (nonatomic,copy) NSString * strShopID;
@property (nonatomic,weak) id <ShopBrandChooseControllerDelegate> delegate;
@end
