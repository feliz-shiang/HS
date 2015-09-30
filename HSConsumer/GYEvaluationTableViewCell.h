//
//  GYEvaluationTableViewCell.h
//  HSConsumer
//
//  Created by apple on 14-12-17.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYEvaluateGoodModel.h"
@interface GYEvaluationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *vWhiteBackground;
@property (weak, nonatomic) IBOutlet UIImageView *imgvGoods;
@property (weak, nonatomic) IBOutlet UILabel *lbGoodTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbGoodShop;
@property (weak, nonatomic) IBOutlet UIButton *btnMakeEvalutaion;



-(void)refreshUIWithModel :(GYEvaluateGoodModel *)model WithType:(int )cellType;
@end
