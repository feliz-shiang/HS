//
//  GYEasyBuySearchList.h
//  HSConsumer
//
//  Created by apple on 15-4-16.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYEasyBuyModel.h"
@interface GYEasyBuySearchList : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgvGoodsPicture;
@property (weak, nonatomic) IBOutlet UILabel *lbGoodsName;
@property (weak, nonatomic) IBOutlet UIImageView *imgvCoin;
@property (weak, nonatomic) IBOutlet UILabel *lbPrice;
@property (weak, nonatomic) IBOutlet UIImageView *imgvPoint;
@property (weak, nonatomic) IBOutlet UILabel *lbPoint;
@property (weak, nonatomic) IBOutlet UILabel *lbCompanyName;

@property (weak, nonatomic) IBOutlet UILabel *lbCity;
@property (weak, nonatomic) IBOutlet UILabel *lbMonthlyRate;

@property (nonatomic,copy) NSString *beReach;
@property (nonatomic,copy) NSString *beSell;
@property (nonatomic,copy) NSString *beCash;
@property (nonatomic,copy) NSString *beTake;
@property (nonatomic,copy) NSString *beTicket;
-(void)refreashUIWithModel:(GYEasyBuyModel *)model;

@end
