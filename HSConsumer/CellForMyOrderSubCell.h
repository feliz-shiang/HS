//
//  CellForMyOrderSubCell.h
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#define kCellForMyOrderSubCellIdentifier @"CellForMyOrderSubCellIdentifier"

#import <UIKit/UIKit.h>

@interface CellForMyOrderSubCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *viewContentBkg;
@property (strong, nonatomic) IBOutlet UIImageView *ivGoodsPicture;
@property (strong, nonatomic) IBOutlet UILabel *lbGoodsName;
@property (strong, nonatomic) IBOutlet UILabel *lbGoodsPrice;
@property (strong, nonatomic) IBOutlet UILabel *lbGoodsCnt;
@property (strong, nonatomic) IBOutlet UILabel *lbGoodsProperty;
@property (strong, nonatomic) IBOutlet UIImageView *ivHsbLogo;

@end
