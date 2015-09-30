//
//  GYPersonDetailInfoViewController.h
//  HSConsumer
//
//  Created by apple on 14-12-29.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//
@class GYNewFiendModel;
@protocol refreshFriendTable <NSObject>

@required
- (void)refreshTableAfterDeleteFriend:(GYNewFiendModel *)deleteFriend;

@end

#import <UIKit/UIKit.h>
#import "GYNewFiendModel.h"
#import "GYPopView.h"
#import "GYupdateNicknameViewController.h"
@class GYAddFriendViewController;
typedef enum
{
    kPersonInfoFromChat=0,
    KPersonInfoFromCheck,
    KPersonInfoFromFriendList

}kPersonInfoType;

@interface GYPersonDetailInfoViewController : UIViewController<GYPopViewDelegate,getRemarkDelegate>

@property (nonatomic,strong) GYNewFiendModel * model;
@property  (nonatomic,assign)kPersonInfoType useType;
@property (nonatomic,assign)BOOL isAdded;

@property (nonatomic,strong)GYAddFriendViewController * vcFriend;
@property (nonatomic,strong)id<refreshFriendTable> delegate;
@end
