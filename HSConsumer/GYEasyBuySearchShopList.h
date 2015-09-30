//
//  GYEasyBuySearchList.h
//  HSConsumer
//
//  Created by apple on 15-4-16.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYEasyBuyModel.h"
@interface GYEasyBuySearchShopList : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgvGoodsPicture;

@property (weak, nonatomic) IBOutlet UILabel *lbGoodsName;

@property (weak, nonatomic) IBOutlet UILabel *lbEvaluationCount;

@property (weak, nonatomic) IBOutlet UILabel *lbCompanyHsnumber;

@property (weak, nonatomic) IBOutlet UILabel *lbCompanyAddr;

@property (weak, nonatomic) IBOutlet UILabel *lbCompanyTel;

@property (weak, nonatomic) IBOutlet UILabel *lbDistance;

@property (weak, nonatomic) IBOutlet UIImageView *imgvDistance;

@property (weak, nonatomic) IBOutlet UIButton *btnShopTel;

//
//self.beReach,
//self.beSell,
//self.beCash,
//self.beTake,
//self.beTicket,

@property (nonatomic,copy) NSString *beReach;
@property (nonatomic,copy) NSString *beSell;
@property (nonatomic,copy) NSString *beCash;
@property (nonatomic,copy) NSString *beTake;
@property (nonatomic,copy) NSString *beTicket;
-(void)refreashUIWithModel:(ShopModel *)model;

@end
