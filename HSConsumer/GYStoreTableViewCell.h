//
//  GYStoreTableViewCell.h
//  HSConsumer
//
//  Created by apple on 15/8/18.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kStoreTableViewCell @"StoreTableViewCell"
@class GYShopGoodListModel;
@class GYStoreTableViewCell;

@protocol StoreTableViewCellDelegate <NSObject>
@optional
-(void)StoreTableView:(GYStoreTableViewCell*)cell chooseOne:(NSInteger) type model:(GYShopGoodListModel*)model;

@end

@interface GYStoreTableViewCell : UITableViewCell
@property (nonatomic,strong)GYShopGoodListModel * leftModel;
@property (nonatomic,strong)GYShopGoodListModel * rightModel;
@property (nonatomic,weak) id<StoreTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;

+(instancetype)cellWithTableView:(UITableView*)tableView;
@end
