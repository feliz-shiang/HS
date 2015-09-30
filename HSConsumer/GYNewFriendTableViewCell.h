//
//  GYNewFriendTableViewCell.h
//  HSConsumer
//
//  Created by apple on 14-12-29.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//
//typedef enum
//{
//    kAskForAdd=1,
//    kAgreeForAdd,
//    kRefuseForAdd,
//    kDeleteFriend,
//    kAskForAuth,
//    
//}KFriendStatus;
#import <UIKit/UIKit.h>
#import "GYNewFiendModel.h"
@interface GYNewFriendTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (nonatomic,assign) BOOL fromAddFriendVc;
//@property (weak, nonatomic) IBOutlet UILabel *lbTitileName;
//@property (nonatomic,assign)KFriendStatus friendStatus;
-(void)refreshUIWith:(GYNewFiendModel *)model;

-(void)test:(NSString *)str;
@end
