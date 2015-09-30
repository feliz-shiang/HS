//
//  GYBuyGoodTableViewCell.h
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SearchGoodModel.h"
@interface GYBuyGoodTableViewCell : UITableViewCell
@property (nonatomic,strong) SearchGoodModel * model;

@property (weak, nonatomic) IBOutlet UIButton *btnShopTel;


-(void)refreshUIWithModel:(SearchGoodModel *)model;

-(void)setTopIcon:(NSInteger )count;
@end
