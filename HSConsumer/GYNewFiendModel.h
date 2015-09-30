//
//  GYNewFiendModel.h
//  HSConsumer
//
//  Created by apple on 14-12-29.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

typedef enum
{
    kCanBeAdd=0,
    kAskForAdd=1,
    kAgreeForAdd,
    kRefuseForAdd,
    kDeleteFriend,
    kAskForAuth,
    
}KFriendStatus;

#import <Foundation/Foundation.h>

@interface GYNewFiendModel : NSObject
@property (nonatomic,copy)NSString * strFriendName;//用户名
@property (nonatomic,copy)NSString * strFriendIconURL;//图片URL
@property (nonatomic,copy)NSString * strUserId;//好友的互动ID
@property (nonatomic,copy)NSString * strFriendID;// friend_id
@property (nonatomic,assign)BOOL isAdd;//是否添加
@property (nonatomic,copy)NSString * strAccountID;
@property (nonatomic,assign) KFriendStatus  friendStatus;
@property (nonatomic,copy) NSString * isShield;
@property (nonatomic,copy) NSString * strVerifyFlag;
@property (nonatomic,copy) NSString * strAccountNo;


//搜索好友 时 用到的参数

@property(nonatomic,copy) NSString * strFriendAddress;

@property(nonatomic,copy) NSString * strFriendInterest;

@property(nonatomic,copy) NSString * strFriendMobile;

@property(nonatomic,copy) NSString *  strFriendNickName;

@property(nonatomic,copy) NSString *  strFriendOccupation;

@property(nonatomic,copy) NSString *  strFriendSign;

@end
