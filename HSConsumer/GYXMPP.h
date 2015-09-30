//
//  GYXMPP.h
//  IMXMPPPro
//
//  Created by liangzm on 15-1-7.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

typedef enum : NSInteger
{
    kIMLoginStateUnknowError = 0,
    kIMLoginStateConnetToServerSucced,//连接服务器成功
    kIMLoginStateConnetToServerTimeout,//连接服务器超时
    kIMLoginStateConnetToServerFailure,//连接服务器失败
    kIMLoginStateAuthenticateSucced,//登录验证成功
    kIMLoginStateAuthenticateFailure//登录验证失败，可以提示检查用户和密码
}IMLoginState;

#define kNotificationNameSendResult @"SendResult"
#define kNotificationNameFromJIDPrefix @"refreshMessageFor_"
#define kNotificationNameForSystemPushPersonMsg @"refreshMessageForSystemPushPersonMsg"
#define kNotificationNameInitDB @"InitDB"//初始化数据库后

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
#import "FMDatabase.h"

typedef void (^LoginBlock)(IMLoginState state, id error);

@interface GYXMPP : NSObject
{
	BOOL customCertEvaluation;
	BOOL isXmppConnected;
    NSString *myJID;   //如：liang@im02.dev.gyist.com
    NSString *userName;//用户名，如：liang
    NSString *password;
    NSString *domainString;//域名如：im02.dev.gyist.com
    NSString *resource;
    NSString *hostName;//ip或 域名 im02.dev.gyist.com
    UInt16 hostPort;//端口号
    LoginBlock loginBlock;
}

@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;

@property (nonatomic, strong, readonly) FMDatabase *imFMDB;

@property (nonatomic, assign) NSTimeInterval connectTimeout;

//设置主机参数
- (void)setParameterUserName:(NSString *)u
                    password:(NSString *)p
                      domain:(NSString *)d
                    resource:(NSString *)r
                    hostName:(NSString *)h
                    hostPort:(UInt16)pt;

//登录
- (void)login:(LoginBlock)block;

//断开连接
- (void)disconnect;

//退出登录
- (void)Logout;

+ (GYXMPP *)sharedInstance;

- (dispatch_queue_t)getMessageQueue;

- (BOOL)connect;

@end
