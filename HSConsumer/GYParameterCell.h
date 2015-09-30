//
//  GYParameterCell.h
//  HSConsumer
//
//  Created by 00 on 15-2-5.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYGoodsDetailModel.h"
@interface GYParameterCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

@property (weak, nonatomic) IBOutlet UILabel *lbContent;
@property(strong ,nonatomic)ArrModel *model;



@end
