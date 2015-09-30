//
//  GYGetGoodTableViewCell.h
//  HSConsumer
//
//  Created by apple on 14-10-17.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "GYAddressModel.h"
#import "GYsenderButton.h"
@interface GYGetGoodTableViewCell : UITableViewCell
-(void)refreshUIWith:( GYAddressModel *)model;


@property (weak,nonatomic)id senderBtnDelegate;
@property (weak, nonatomic) IBOutlet UILabel *lbCustomerName;
@property (weak, nonatomic) IBOutlet UILabel *lbCustomerPhone;
@property (weak, nonatomic) IBOutlet UILabel *lbCustomerAddress;
@property (weak, nonatomic) IBOutlet UIButton *btnChooseDefaultAddress;

@property (nonatomic,strong)GYAddressModel * mod;//将地址模型传到VC 用于单选中提取 地址ID

@end
