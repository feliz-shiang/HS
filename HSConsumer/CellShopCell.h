//
//  CellShopCell.h
//  HSConsumer
//
//  Created by apple on 14-12-1.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//


#define kCellShopCellIdentifier @"CellShopCellIdentifier"

#import <UIKit/UIKit.h>

@interface CellShopCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *ivShopImage;//商铺图标
@property (strong, nonatomic) IBOutlet UILabel *lbShopName;     //商铺名称
//@property (strong, nonatomic) IBOutlet UILabel *lbShopAddress;//商铺地址
//@property (strong, nonatomic) IBOutlet UILabel *lbShopTel;    //商铺电话
@property (strong, nonatomic) IBOutlet UILabel *lbShopScope;    //商铺经营范围
@property (strong, nonatomic) IBOutlet UILabel *lbShopConcernTime;//商铺关注时间

@end
