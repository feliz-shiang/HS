//
//  GYXMPP.m
//  IMXMPPPro
//
//  Created by liangzm on 15-1-7.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

//用于测试
#define kEnableNSLog YES
#define kEnableXMPPLog NO

#import "GYXMPP.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "IMMessageCenter.h"
#import "GYDBCenter.h"
#import "GYChatItem.h"

static dispatch_queue_t messageQueue = nil;

@interface GYXMPP()
{
    NSMutableArray *arrRoster;
}
@end

@implementation GYXMPP

@synthesize xmppStream;
@synthesize xmppReconnect;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;

+ (GYXMPP *)sharedInstance
{
    static GYXMPP* sGYXMPP = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sGYXMPP = [[super allocWithZone:NULL] init];
    });
    return sGYXMPP;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _connectTimeout = 15.f;
//        [DDLog addLogger:[DDTTYLogger sharedInstance] withLogLevel:ddLogLevel];
        if (kEnableXMPPLog)
            [DDLog addLogger:[DDTTYLogger sharedInstance] withLogLevel:XMPP_LOG_FLAG_SEND_RECV];
    }
    return self;
}

- (dispatch_queue_t)getMessageQueue
{
    if (!messageQueue)
        messageQueue = dispatch_queue_create("com.gyist", DISPATCH_QUEUE_SERIAL);
    return messageQueue;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

//设置主机参数
- (void)setParameterUserName:(NSString *)u
                    password:(NSString *)p
                      domain:(NSString *)d
                    resource:(NSString *)r
                    hostName:(NSString *)h
                    hostPort:(UInt16)pt
{
    userName = u;
    password = p;
    domainString = d;
    resource = r;
    hostName = h;
    hostPort = pt;
    myJID = [NSString stringWithFormat:@"%@@%@",userName, domainString];
    DDLogInfo(@"登录消息服务器用户：%@", myJID);
}

//登录
- (void)login:(LoginBlock)block
{
    loginBlock = block;
    if (!hostName || !myJID)
    {
        loginBlock(kIMLoginStateUnknowError, @"未设置主机参数");
        return;
    }
    [self setupStream];
    [self connect];
    if ([GlobalData shareInstance].isEcLogined || [GlobalData shareInstance].isLogined)
    {
        //检查及创建数据库
        NSString *dbFullName = [GYDBCenter getUserDBNameInDirectory:userName];
        if (![GYDBCenter fileIsExists:dbFullName])
        {
            DDLogInfo(@"用户数据库不存在，将创建");
            if (![GYDBCenter createFile:dbFullName])
            {
                [Utils alertViewOKbuttonWithTitle:nil message:@"sorry, create user's im db error."];
                return;
            }
        }
        
        DDLogInfo(@"im数据库完整路径:%@", dbFullName);
        _imFMDB = [[FMDatabase alloc] initWithPath:dbFullName];
        BOOL isInitDB = [GYDBCenter setDefaultTablesForImDB:_imFMDB];
        if (isInitDB)
        {
            DDLogInfo(@"用户数据库--表结构初始化完成");
        }else
        {
            [Utils alertViewOKbuttonWithTitle:nil message:@"用户数据库--表结构初始化失败."];
            return;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameInitDB object:nil];
    }
}

//退出登录
- (void)Logout
{
//    [self disconnect];
    [self teardownStream];
}

- (XMPPJID *)reGetJID:(NSString *)jidString
{
    //重组合法的XMPPJID
    XMPPJID *_jid = [[XMPPJID jidWithString:jidString] bareJID];
    NSString *u = _jid.user;
    if (!u)
    {
        u = _jid.domain;
    }
    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@", u, domainString]];
    return jid;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Private
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setupStream
{
	if (xmppStream) return;
    NSAssert(xmppStream == nil, @"Method setupStream invoked multiple times");
    
	xmppStream = [[XMPPStream alloc] init];
	
#if !TARGET_IPHONE_SIMULATOR
	{
		xmppStream.enableBackgroundingOnSocket = YES;
	}
#endif
		
	xmppReconnect = [[XMPPReconnect alloc] init];
	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
	[xmppReconnect         activate:xmppStream];
	[xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    //    设置主机，端口号
    [xmppStream setHostName:hostName];
    [xmppStream setHostPort:hostPort];
    
	// You may need to alter these settings depending on the server you're connecting to
	customCertEvaluation = YES;
}

- (void)teardownStream
{
	[xmppStream removeDelegate:self];
	[xmppRoster removeDelegate:self];
	
	[xmppReconnect         deactivate];
	[xmppRoster            deactivate];
	
	[xmppStream disconnect];
	
	xmppStream = nil;
	xmppReconnect = nil;
    xmppRoster = nil;
    xmppRosterStorage = nil;
}

- (void)goOnline
{
	XMPPPresence *presence = [XMPPPresence presence];
    NSString *domain = [xmppStream.myJID domain];
    if([domain isEqualToString:@"gmail.com"]
       || [domain isEqualToString:@"gtalk.com"]
       || [domain isEqualToString:@"talk.google.com"])
    {
        NSXMLElement *priority = [NSXMLElement elementWithName:@"priority" stringValue:@"24"];
        [presence addChild:priority];
    }
	[[self xmppStream] sendElement:presence];
}

- (void)goOffline
{
	XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
	
	[[self xmppStream] sendElement:presence];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Connect/disconnect
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)connect
{
	if (![xmppStream isDisconnected])
    {
		return YES;
	}
	
	if (userName == nil || password == nil)
    {
		return NO;
	}
    
    //两种登录方式
	[xmppStream setMyJID:[XMPPJID jidWithUser:userName domain:domainString resource:resource]];
//	[xmppStream setMyJID:[XMPPJID jidWithString:myJID]];
    
	NSError *error = nil;
	if (![xmppStream connectWithTimeout:_connectTimeout error:&error])//XMPPStreamTimeoutNone
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
		                                                    message:@"See console for error details."
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Ok"
		                                          otherButtonTitles:nil];
		[alertView show];
        
		if (kEnableNSLog) NSLog(@"Error connecting: %@", error);
        
		return NO;
	}
	return YES;
}

- (void)disconnect
{
	[self goOffline];
	[xmppStream disconnect];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
	if (kEnableNSLog) NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
	if (kEnableNSLog) NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
	NSString *expectedCertName = [xmppStream.myJID domain];
	if (expectedCertName)
	{
		[settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
	}
	
	if (customCertEvaluation)
	{
		[settings setObject:@(YES) forKey:GCDAsyncSocketManuallyEvaluateTrust];
	}
}

- (void)xmppStream:(XMPPStream *)sender didReceiveTrust:(SecTrustRef)trust
 completionHandler:(void (^)(BOOL shouldTrustPeer))completionHandler
{
	if (kEnableNSLog) NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
		
	dispatch_queue_t bgQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	dispatch_async(bgQueue, ^{
		
		SecTrustResultType result = kSecTrustResultDeny;
		OSStatus status = SecTrustEvaluate(trust, &result);
		
		if (status == noErr && (result == kSecTrustResultProceed || result == kSecTrustResultUnspecified)) {
			completionHandler(YES);
		}
		else {
			completionHandler(NO);
		}
	});
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
	if (kEnableNSLog) NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
	if (kEnableNSLog) NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	isXmppConnected = YES;
	
	NSError *error = nil;
	
	if (![[self xmppStream] authenticateWithPassword:password error:&error])
	{
		if (kEnableNSLog) NSLog(@"Error authenticating: %@", error);
	}
}

- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender
{
    if (loginBlock)
    {
        loginBlock(kIMLoginStateConnetToServerTimeout, sender);
    }
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
	if (kEnableNSLog) NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
	
    if (loginBlock)
    {
        loginBlock(kIMLoginStateAuthenticateSucced, sender);
    }
	[self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
	if (kEnableNSLog) NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
    if (loginBlock)
    {
        loginBlock(kIMLoginStateAuthenticateFailure, error);
    }
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
	if (kEnableNSLog) NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
    NSLog(@"---%@: %@", sender, iq);
	
	return YES;
}

- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message
{
	if (kEnableNSLog) NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    if ([message isChatMessageWithBody])
	{
        NSString *msgID = [[message attributeForName:@"id"] stringValue];
        if (msgID && [GYChatItem changeSendMsgStatusWithMsgID:msgID WithStatus:kMessagSentState_Sent])
        {
            NSDictionary *dic = @{@"msgID":msgID,@"State":@(kMessagSentState_Sent)};
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameSendResult object:dic];
        }
    }
}

- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error
{
    if ([message isChatMessageWithBody])
    {
        NSString *msgID = [[message attributeForName:@"id"] stringValue];
        if (msgID && [GYChatItem changeSendMsgStatusWithMsgID:msgID WithStatus:kMessagSentState_Send_Failed])
        {
            NSDictionary *dic = @{@"msgID":msgID,@"State":@"3"};
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameSendResult object:dic];
        }
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    NSLog(@"收到消息：%@， %@", sender, message);
    if (![message isErrorMessage])
    {
        dispatch_async([self getMessageQueue], ^{
            IMMessageCenter *msgCent = [[IMMessageCenter alloc] initWithReceiveXMPPMessage:message];
            [msgCent forwardedReceiveMessage];
        });
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
	if (kEnableNSLog) NSLog(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
    if (kEnableNSLog) NSLog(@"---%@: %@", sender, presence);
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(NSXMLElement *)error
{
	if (kEnableNSLog) NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
    NSXMLElement *conflictE = [error elementForName:@"conflict"];
    if (conflictE)
    {
        DDLogInfo(@"xmpp检测到你的账号在其它设备登录，你将被迫断开xmpp连接");
        [GlobalData shareInstance].isHdLogined = NO;
        // add by songjk 清空数据防止自动登录
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserNameKey];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserPasswordKey];
        [[NSUserDefaults standardUserDefaults]  synchronize];
    }else
    {
        //登录时的错误回调
        if (loginBlock)
        {
            loginBlock(kIMLoginStateUnknowError, error);
        }
    }
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
	if (kEnableNSLog) NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	if (!isXmppConnected)
	{
		DDLogError(@"Unable to connect to server. Check xmppStream.hostName");
	}
    
    if (loginBlock)
    {
        if (!isXmppConnected)
            loginBlock(kIMLoginStateConnetToServerFailure, error);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPRosterDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppRoster:(XMPPRoster *)sender didReceiveBuddyRequest:(XMPPPresence *)presence
{
	if (kEnableNSLog) NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    if (kEnableNSLog) NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterPush:(XMPPIQ *)iq
{
    if (kEnableNSLog) NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppRosterDidBeginPopulating:(XMPPRoster *)sender
{
    arrRoster = [NSMutableArray array];
}

- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(NSXMLElement *)item
{
    if (kEnableNSLog) NSLog(@"%@: %@", THIS_FILE, THIS_METHOD);
    NSLog(@"%@", item);
    NSString *jidStr = [item attributeStringValueForName:@"jid"];
    XMPPJID *jid = [[XMPPJID jidWithString:jidStr] bareJID];
    if ([jid.domain isEqualToString:domainString])
    {
        [arrRoster addObject:jidStr];
    }
}

- (void)xmppRosterDidEndPopulating:(XMPPRoster *)sender
{

}

@end
