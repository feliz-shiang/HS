//
//  CellGoodsNameAndPriceCell.h
//  HSConsumer
//
//  Created by apple on 14-12-1.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//


#define kCellGoodsNameAndPriceCellIdentifier @"CellGoodsNameAndPriceCellIdentifier"

#import <UIKit/UIKit.h>

@interface CellGoodsNameAndPriceCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *ivGoodsImage;   //商品图标
@property (strong, nonatomic) IBOutlet UILabel *lbGoodsName;        //商品名称
@property (strong, nonatomic) IBOutlet UILabel *lbPrice;            //商品价格

@end
