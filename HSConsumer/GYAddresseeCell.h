//
//  GYAddresseeCell.h
//  HSConsumer
//
//  Created by 00 on 14-12-18.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYCartModel.h"
#import "GYGetGoodViewController.h"
#import "GYGetAddressDelegate.h"

@protocol GYAddresseeCellDelegate <NSObject>

//-(void)pushSelWayViewWithmArray:(NSMutableArray *)mArray;

-(void)pushSelWayVCWithmArray:(NSMutableArray *)mArray WithIndexPath:(NSIndexPath*)IndexPath;


-(void)pushSelAddrVC;

@end


@interface GYAddresseeCell : UITableViewCell


@property (strong ,nonatomic) NSIndexPath *indexPath;

@property (weak, nonatomic) IBOutlet UIButton *btnSelWay;//支付方式
@property (weak, nonatomic) IBOutlet UILabel *lbLine;//分隔线

@property (weak, nonatomic) IBOutlet UILabel *lbAddressee;//收件人
@property (weak, nonatomic) IBOutlet UILabel *lbPhone;//电话

@property (weak, nonatomic) IBOutlet UILabel *lbAddress;//地址

@property (weak, nonatomic) IBOutlet UIButton *btnChangeAddress;






@property (assign , nonatomic) id<GYAddresseeCellDelegate> delegate;





@end
