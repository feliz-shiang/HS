//
//  GYPayoffViewController.h
//  HSConsumer
//
//  Created by 00 on 14-12-18.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYGoodsDetailModel.h"


@interface GYPayoffViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lbPrice;

@property (weak, nonatomic) IBOutlet UILabel *lbPV;

@property (strong , nonatomic) GYGoodsDetailModel *detailModel;

@property (weak, nonatomic) IBOutlet UIView *vBottomBackground;

@property (strong , nonatomic) NSMutableArray *mArrShop;
@property (strong , nonatomic) NSString *isRightAway;

@property (nonatomic ,copy)NSString * strPictureUrl;

@end
