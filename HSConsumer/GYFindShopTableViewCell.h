//
//  GYFindShopTableViewCell.h
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYEasyBuyModel.h"

@interface GYFindShopTableViewCell : UITableViewCell
-(void)refreshUIWith:(ShopModel *)model;
@property(nonatomic,strong) ShopModel * model;
@property (weak, nonatomic) IBOutlet UIButton *btnShopTel;
@end
