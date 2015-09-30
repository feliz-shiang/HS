//
//  DiscountCell.h
//  HSConsumer
//
//  Created by 00 on 15-3-19.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYDisCountViewController.h"
@class DiscountModel;
@protocol sendSelectDiscountDelegate <NSObject>

-(void)sendSelectDisCount:(id)sender WithDiscountModel : (DiscountModel *)model;

@end

#import <UIKit/UIKit.h>

@interface DiscountCell : UITableViewCell
@property (nonatomic,weak) id <sendSelectDiscountDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *lbDiscountName;//消费券名字
@property (weak, nonatomic) IBOutlet UILabel *lbCount;//消费券数量

@property (weak, nonatomic) IBOutlet UILabel *lbRemain;//消费券剩余数量



@property (weak, nonatomic) IBOutlet UILabel *lbUPFront;//每张可抵
@property (weak, nonatomic) IBOutlet UIImageView *imgUP;//每张 钱图标
@property (weak, nonatomic) IBOutlet UILabel *lbUnitPrice;//每张单价



@property (weak, nonatomic) IBOutlet UILabel *lbTotalFront;//共抵
@property (weak, nonatomic) IBOutlet UIImageView *imgTotal;//共抵 钱图标
@property (weak, nonatomic) IBOutlet UILabel *lbTotal;//共抵

@property (weak, nonatomic) IBOutlet UIButton *btnMutebleSelect;
@property (nonatomic,strong)DiscountModel * model;


-(void)refreshUiWithModel:(DiscountModel *)model;

@end
