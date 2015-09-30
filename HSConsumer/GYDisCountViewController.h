//
//  GYDisCountViewController.h
//  HSConsumer
//
//  Created by apple on 15-4-18.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscountCell.h"
#import "DiscountModel.h"

@protocol GYDisCountVCDelegate <NSObject>

-(void)returnDiscount:(DiscountModel *)discount WithIndex:(NSInteger)index;

@end

@interface GYDisCountViewController : UIViewController

@property (assign ,nonatomic) id<GYDisCountVCDelegate> delegateDisCount;

@property (assign , nonatomic) NSInteger index;

@property (copy , nonatomic) NSString *vShopId;
@property (copy , nonatomic) NSString *shopId;
@property (nonatomic,strong)NSMutableArray * marrJeson;
//@property (copy , nonatomic) NSString *amount;

@end
