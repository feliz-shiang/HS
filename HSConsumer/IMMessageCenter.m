

//
//  IMMessageCenter.m
//
//  Created by Reese on 13-8-11.
//  Copyright (c) 2013年 Reese. All rights reserved.
//
#define kSystemPushMessageSound 1016
#define kImmediateMessageSound 1002

#import "IMMessageCenter.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "NSData+XMPP.h"
#import "GYXMPP.h"
#import "GYChatItem.h"
#import "GYDBCenter.h"
#import <AudioToolbox/AudioToolbox.h>

@interface IMMessageCenter()
{
    GYChatItem *mObj;
    GYXMPP *xmp;
}

@end

@implementation IMMessageCenter

- (id)init
{
    self = [super init];
    if(self)
    {
    
    }
    return self;
}

//实例化转发一个收到的消息
- (id)initWithReceiveXMPPMessage:(XMPPMessage *)xmppMessage
{
    self = [super init];
    if(self)
    {
        DDLogInfo(@"您好，这里是消息转发中心，很高兴为您服务。");
        self.xMPPMessage = xmppMessage;
        xmp = [GYXMPP sharedInstance];
    }
    return self;
}

//实例化发送一个消息
- (id)initWithSendMessage:(GYChatItem *)messageObject
{
    self = [super init];
    if(self)
    {
        mObj = messageObject;
        xmp = [GYXMPP sharedInstance];
    }
    return self;
}

#pragma mark - 处理收到一个消息
- (void)forwardedReceiveMessage
{
    if (!self.xMPPMessage) return;
    NSString *body = [[self.xMPPMessage elementForName:@"body"] stringValue];
    self.bodyMessage = body;
    NSDictionary *dicBody = [Utils stringToDictionary:self.bodyMessage];// [self bodyMessageToDictionary:self.bodyMessage];
    self.msg_Type = [dicBody[kKeyForMsg_type] integerValue];
    switch (self.msg_Type)
    {
        case kMsg_Type_System_Push:
            DDLogInfo(@"收到系统推送消息，转发...");
            [self forwardedSystemPushMessage];
            break;
            case kMsg_Type_Immediate_Chat:
            DDLogInfo(@"收到即时消息，转发...");
            [self forwardedImmediateMessage];
            break;
        default:
            break;
    }
    
}

- (void)forwardedImmediateMessage
{
    NSString *body = [[self.xMPPMessage elementForName:@"body"] stringValue];
    NSString *fromJID = [[self.xMPPMessage attributeForName:@"from"] stringValue];
    NSString *jidString = [[[XMPPJID jidWithString:fromJID] bareJID] bare];
    NSString *messageId = [[self.xMPPMessage attributeForName:@"id"] stringValue];
    if (!messageId)//必须要有一个id
    {
		NSDate *date = [NSDate date];
		long long t = [date timeIntervalSince1970] * 1000;
		NSNumber *n = [NSNumber numberWithLongLong:t];
        messageId = [n stringValue];
    }
    
    self.bodyMessage = body;
    
    
    NSDictionary *dicBody = [Utils stringToDictionary:self.bodyMessage];// [self bodyMessageToDictionary:self.bodyMessage];
    DDLogInfo(@"dicBody is ========== %@",dicBody);
    self.msg_Type = [dicBody[kKeyForMsg_type] integerValue];
    self.msg_Code = [dicBody[kKeyForMsg_code] integerValue];
    self.sub_Msg_Code = [dicBody[kKeyForSub_msg_code] integerValue];

    self.msgIcon = dicBody[kMessageIcon];
    self.resNo = dicBody[kResNo];
    

    
    mObj = [[GYChatItem alloc] init];
    // add by songjk
    self.msgNote = dicBody[kMessageNote];
    
   
    long long t = [messageId longLongValue];
    NSDate *date0 = [[NSDate alloc] initWithTimeIntervalSince1970:t / 1000];
    
//通用数据赋值 －－－－接收的为文本消息
    mObj.msg_Type = self.msg_Type;
    mObj.msg_Code = self.msg_Code;
    mObj.sub_Msg_Code = self.sub_Msg_Code;
    mObj.dateTimeSend = [Utils dateToString:date0];
    mObj.dateTimeReceive = [Utils dateToString:date0];
    mObj.content = dicBody[kMessageContent];
    mObj.fromUserId = jidString;//不带resource
    
    mObj.toUserId = [xmp.xmppStream.myJID bare];//不带resource
    mObj.messageId = messageId;
    mObj.isRead = NO;
    mObj.msgNote = self.msgNote;
    mObj.msgIcon = self.msgIcon;
    mObj.friendName = mObj.msgNote;
    mObj.friendIcon = mObj.msgIcon;
//    mObj.resNo = self.resNo;
    NSString *str = mObj.fromUserId;
    NSString *subStr = @"e_";
    NSRange range = [str rangeOfString:subStr];
    NSInteger location = range.location;
    NSLog(@"%@-------str",str);
    NSString * midString =@"c_";
    NSRange range2 = [str rangeOfString:midString];
    NSInteger locaton2=range2.location;
    NSRange range2Cut;
    range2Cut.location=locaton2+2;
    range2Cut.length=11;
    NSString * strAccountID;
    if (locaton2 >= 0 && locaton2 < 10) {
        strAccountID =[str substringWithRange:range2Cut];
    }

    NSLog(@"%@-----strAccountID",strAccountID);
    
    
    NSRange rangeCut;
    rangeCut.location =location + 2;
    rangeCut.length = 11;
    NSString *cutStr;
    
    if (location >= 0 && location < 10) {
        cutStr= [str substringWithRange:rangeCut];
        mObj.resNo = cutStr;
        DDLogInfo(@"切割后的字符串 ＝＝＝＝＝cutStr == %@",cutStr);
        
        NSString *disPlayName = dicBody[kMessageNote];
        if (disPlayName.length < 1)
        {
            disPlayName = mObj.resNo;
        }
        self.msgNote = disPlayName;//dicBody[kMessageNote];

    }else{
        NSString *disPlayName = dicBody[kMessageNote];
        if (disPlayName.length < 1)
        {
            XMPPJID *j= [self reGetJID:jidString];
            disPlayName = j.user;
            
            NSInteger index = [disPlayName rangeOfString:@"c_"].location ;
            //        NSLog(@"disPlayName index:%d", index);
            disPlayName = [disPlayName substringFromIndex:index + 2];
        }
        self.msgNote = disPlayName;//dicBody[kMessageNote];
    }
    
 
    
    if (!self.msgNote || self.msgNote.length==0)
    {
        self.msgNote = dicBody[kMessageNote];
    }
    NSString * strRemark = [GYChatItem getRemarkWithFriendId:strAccountID myID:[GlobalData shareInstance].IMUser.strAccountNo];
   
    if (strRemark.length>0) {
        self.msgNote=strRemark;
    }
    mObj.friendName = mObj.msgNote = self.msgNote;
    
    
    
    if (mObj.resNo.length > 10)
    {
        //处理web商铺发送的转义、标签
        NSString *con = [NSString stringWithString:mObj.content];
        con = [con stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
        con = [con stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
        con = [con stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        con = [con stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
        con = [con stringByReplacingOccurrencesOfString:@"<div>" withString:@"\n"];
        con = [con stringByReplacingOccurrencesOfString:@"</div>" withString:@""];
        mObj.content = con;
    }
    
    switch (self.msg_Code)
    {
        case kMsg_Code_Text_Msg://文本消息
        {
            //保存到本数据库
            if ([mObj saveMessageToDB])
            {
                DDLogInfo(@"消息体已经保存");
            }
            
            if (mObj.resNo.length > 10) {
                DDLogInfo(@"有资源号");
                [mObj updateNotReadWithKey:mObj WithTableType:2];
            }else{
                [mObj updateNotReadWithKey:mObj WithTableType:1];
            }
        }
            break;
        case kMsg_Code_Picture_Msg://图片消息
        {
            mObj.pictureRUL = dicBody[kMessageContent];
            mObj.content = @"[图片]";
            
            //保存到本数据库
            if ([mObj saveMessageToDB])
                
            {
                DDLogInfo(@"消息体已经保存");
            }
            
            if (mObj.resNo.length >10) {
                [mObj updateNotReadWithKey:mObj WithTableType:2];
            }else{
                [mObj updateNotReadWithKey:mObj WithTableType:1];
            }
        }
            break;
            
            
        default:
            break;
    }
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    {
        NSString *notiBodyString = [NSString stringWithFormat:@"来自%@ 的消息: %@", mObj.msgNote, mObj.content];
        [Utils creatLocalNotification:0.3f timeZone:[NSTimeZone defaultTimeZone] userInfor:@{@"hsmsg":@"hsmsg"} alertBody:notiBodyString];

    }else
    {
        AudioServicesPlaySystemSound(kImmediateMessageSound);
    }
    if (mObj.resNo.length > 10) {
        NSString *notificationName = [kNotificationNameFromJIDPrefix stringByAppendingString:mObj.resNo];
        DDLogInfo(@"收到在线客服即时聊天消息，串行队列 异步处理消息: %@    from:%@  notificationName:%@", body, jidString, notificationName);
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:mObj userInfo:nil];
        
    }else{
        NSString *notificationName = [kNotificationNameFromJIDPrefix stringByAppendingString:jidString];
        DDLogInfo(@"收到即时聊天消息，串行队列 异步处理消息: %@    from:%@  notificationName:%@", body, jidString, notificationName);
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:mObj userInfo:nil];
    
    }
    
}

- (void)forwardedSystemPushMessage
{
    NSString *body = [[self.xMPPMessage elementForName:@"body"] stringValue];
    NSString *fromJID = [[self.xMPPMessage attributeForName:@"from"] stringValue];
    NSString *jidString = [[[XMPPJID jidWithString:fromJID] bareJID] bare];
    NSString *messageId = [[self.xMPPMessage attributeForName:@"id"] stringValue];
    
    NSLog(@"%@----body",body);
    if (!messageId)//必须要有一个id
    {
		NSDate *date = [NSDate date];
		long long t = [date timeIntervalSince1970] * 1000;
		NSNumber *n = [NSNumber numberWithLongLong:t];
        messageId = [n stringValue];
    }
    
    self.bodyMessage = body;
    
    NSDictionary *dicBody = [Utils stringToDictionary:self.bodyMessage];
    DDLogInfo(@"dicBody is === %@",dicBody);
   
    self.msg_Type = [dicBody[kKeyForMsg_type] integerValue];
    self.msg_Code = [dicBody[kKeyForMsg_code] integerValue];
    self.sub_Msg_Code = [dicBody[kKeyForSub_msg_code] integerValue];
    self.msgNote = dicBody[kMessageNote];
    self.msgIcon = dicBody[kMessageIcon];
    self.resNo = dicBody[kResNo];
    
    self.msgId = dicBody[kMsgId];
    self.msgSubject = dicBody[kMsgSubject];
    
    if (!self.resNo)
    {
        self.resNo = @"";
    }
    
    if (!self.msgId)
    {
        self.msgId = @"";
    }
    
    mObj = [[GYChatItem alloc] init];
    long long t = [messageId longLongValue];
    NSDate *date0 = [[NSDate alloc] initWithTimeIntervalSince1970:t / 1000];

    mObj.msg_Type = kMsg_Type_System_Push;
    mObj.msg_Code = self.msg_Code;
    mObj.sub_Msg_Code = self.sub_Msg_Code;
    mObj.dateTimeSend = [Utils dateToString:date0];
    mObj.dateTimeReceive = [Utils dateToString:date0];
    mObj.content = dicBody[kMessageContent];
    mObj.fromUserId = jidString;//不带resource
    mObj.toUserId = [xmp.xmppStream.myJID bare];//不带resource
    mObj.messageId = messageId;
    mObj.isRead = NO;
    mObj.msgNote = self.msgNote;
    mObj.msgIcon = self.msgIcon;
    mObj.resNo = self.resNo;
    mObj.msgId = self.msgId;
    mObj.msgSubject = self.msgSubject;
    
    //把信息保存在对应的表格中，个人、商铺、商品
    switch (self.msg_Code)
    {
        case kMsg_Code_Person://101 个人系统推送消息
        {
            switch (self.sub_Msg_Code)
            {
                case kSub_Msg_Code_Person_HS_Msg://消费者个人消息--互生消息
                {
                    mObj.msgNote = @"互生消息";
                    NSData *jsonData = [dicBody[kMessageContent] dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
                    
//                    NSLog(@"消费者个人消息--互生消息 content dic:%@", dic);
                    mObj.content = [Utils dictionaryToString:dic];
                    mObj.fromUserId = kSystemPushPersonHSMsgJID;
                    mObj.friendName = mObj.msgNote;
                    mObj.friendIcon = self.msgIcon;
                    [mObj updateNotReadWithKey:mObj WithTableType:1];
                    //保存到本数据库
                    if ([mObj saveMessageToDB])
                    {
                        DDLogInfo(@"消费者个人消息--互生消息保存成功");
                        NSString *no = [NSString stringWithFormat:@"%@_%zi_%zi_%zi",
                                        kNotificationNameForSystemPushPersonMsg,
                                        self.msg_Type,
                                        self.msg_Code,
                                        self.sub_Msg_Code];
                        DDLogInfo(@"send notificationCenter:%@", no);

                        [[NSNotificationCenter defaultCenter] postNotificationName:no object:mObj userInfo:nil];
                        
                        if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
                        {
                            NSString *notiBodyString = [NSString stringWithFormat:@"互生消息: %@", mObj.msgSubject];
                            [Utils creatLocalNotification:0.3f timeZone:[NSTimeZone defaultTimeZone] userInfor:@{@"hsmsg":@"hsmsg"} alertBody:notiBodyString];
                            
                        }else
                        {
                            AudioServicesPlaySystemSound(kSystemPushMessageSound);
                        }
                    }
                }
                    break;
                case kSub_Msg_Code_Person_Business_Msg://消费者个人消息--业务消息(总类)
                {
                    
                }
                    break;
                case kSub_Msg_Code_Person_Business_Bind_HSCard_Msg://消费者个人消息--业务消息(小类)绑定互生卡
                {
                    NSData *jsonData = [dicBody[kMessageContent] dataUsingEncoding:NSUTF8StringEncoding];
                    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
//                    [dic setObject:mObj.msgNote forKey:@"addcontentbymyself"];  //添加内容
                    [dic setObject:@"0" forKey:@"addiscommitflag"]; //添加是否已经确认标志 不为1时为未确认;
                    //NSLog(@"消费者个人消息--互生消息 content dic:%@", dic);
                    
                    mObj.msgNote = @"业务消息";
                    mObj.content = [Utils dictionaryToString:dic];
                    mObj.fromUserId = kSystemPushPersonBusinessMsgJID;
                    mObj.friendName = mObj.msgNote;
                    mObj.friendIcon = self.msgIcon;
                    [mObj updateNotReadWithKey:mObj WithTableType:1];
                    //保存到本数据库
                    if ([mObj saveMessageToDB])
                    {
                        DDLogInfo(@"消费者个人消息--业务消息(小类)绑定互生卡消息保存成功");
                        NSString *no = [NSString stringWithFormat:@"%@_%d_%d_%d",
                                        kNotificationNameForSystemPushPersonMsg,
                                        self.msg_Type,
                                        self.msg_Code,
                                        kSub_Msg_Code_Person_Business_Msg
                                        //self.sub_Msg_Code
                                        ];
                        DDLogInfo(@"send notificationCenter:%@", no);
                        [[NSNotificationCenter defaultCenter] postNotificationName:no object:mObj userInfo:nil];
                        if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
                        {
                            NSString *notiBodyString = [NSString stringWithFormat:@"业务消息: %@", mObj.msgSubject];
                            [Utils creatLocalNotification:0.3f timeZone:[NSTimeZone defaultTimeZone] userInfor:@{@"hsmsg":@"hsmsg"} alertBody:notiBodyString];
                        }else
                        {
                            AudioServicesPlaySystemSound(kSystemPushMessageSound);
                        }
                    }
                }
                    break;
                
                case kSub_Msg_Code_Person_Business_Order_Pay_Success://消费者个人消息 ----- 业务消息(小类)订单消息 -----订单支付成功
                case kSub_Msg_Code_Person_Business_Order_Confirm_Receiving://确认收货
                case kSub_Msg_Code_Person_Business_Order_PickUpCargo://待自提
                case kSub_Msg_Code_Person_Business_Order_Cancel://取消订单
                case kSub_Msg_Code_Person_Business_Order_Refund_Success_For_Cancel://退款完成【订单取消】
                case kSub_Msg_Code_Person_Business_Order_Refund_Success_For_Sale_After://退款完成【售后】
                case kSub_Msg_Code_Person_Business_Get_Coupons://申领抵扣券消息
                case kSub_Msg_Code_Person_Business_Accidental_valid: // add by songjk
                case kSub_Msg_Code_Person_Business_Accidental_Invalid: // add by songjk
                case kSub_Msg_Code_Person_Business_Free_Insurance: // add by songjk
                case kSub_Msg_Code_Order_Stocking: // add by songjk
                case kSub_Msg_Code_Order_byer_cancel: // add by songjk
                {
                    mObj.msgNote = @"业务消息";
                    mObj.content = dicBody[kMessageContent];
                    mObj.fromUserId = kSystemPushPersonBusinessMsgJID;
                    mObj.friendName = mObj.msgNote;
                    mObj.friendIcon = self.msgIcon;
                    [mObj updateNotReadWithKey:mObj WithTableType:1];
                    //保存到本数据库
                    if ([mObj saveMessageToDB])
                    {
                        NSString *no = [NSString stringWithFormat:@"%@_%zi_%zi_%zi",
                                        kNotificationNameForSystemPushPersonMsg,
                                        self.msg_Type,
                                        self.msg_Code,
                                        kSub_Msg_Code_Person_Business_Msg
                                        //self.sub_Msg_Code
                                        ];
                        DDLogInfo(@"send notificationCenter:%@", no);
                        [[NSNotificationCenter defaultCenter] postNotificationName:no object:mObj userInfo:nil];
                        if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
                        {
                            NSString *notiBodyString = [NSString stringWithFormat:@"%@: %@", mObj.msgSubject, mObj.content];                           [Utils creatLocalNotification:0.3f timeZone:[NSTimeZone defaultTimeZone] userInfor:@{@"hsmsg":@"hsmsg"} alertBody:notiBodyString];
                        }else
                        {
                            AudioServicesPlaySystemSound(kSystemPushMessageSound);
                        }
                    }
                }
                    break;

                default:
                    break;
            }
        }
            break;
        case kMsg_Code_Goods://102
        {
            DDLogInfo(@"self.msgNote ===== %@",self.msgNote);
            
            NSData *jsonData = [self.msgNote dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
            
            mObj.itemName = dic[@"itemName"];
            mObj.selInfo = dic[@"selInfo"];
            mObj.vshopName = dic[@"vshopName"];
            mObj.displayName = mObj.itemName;
            DDLogInfo(@"有进入商品信息");
            [mObj updateNotReadWithKey:mObj WithTableType:3];
            //保存到本数据库
            if ([mObj saveMessageToDB])
            {
                DDLogInfo(@"消息体已经保存");
                if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
                {
                    NSString *notiBodyString = [NSString stringWithFormat:@"%@: %@", mObj.msgSubject, mObj.content];                           [Utils creatLocalNotification:0.3f timeZone:[NSTimeZone defaultTimeZone] userInfor:@{@"hsmsg":@"hsmsg"} alertBody:notiBodyString];
                }else
                {
                    AudioServicesPlaySystemSound(kSystemPushMessageSound);
                }
            }
            
        }
            break;
        case kMsg_Code_Shops://103
        {
            DDLogInfo(@"有进入商铺信息");
            [mObj updateNotReadWithKey:mObj WithTableType:2];
            //保存到本数据库
            if ([mObj saveMessageToDB])
            {
                DDLogInfo(@"消息体已经保存");
//                AudioServicesPlaySystemSound(kSystemPushMessageSound);

            }
            
        }
            break;
        case kMsg_Code_Advisory://201
        {
            
        }
            break;
        case kMsg_Code_Order://202
        {
            
        }
            break;
        case kMsg_Code_Internal://203
        {
            
        }
            break;
        case kMsg_Code_Command://500
        {
            switch (self.sub_Msg_Code)
            {
                    //好友添加请求
                case kSub_Msg_Code_User_User_Add_Request:
                {
                    NSString *disPlayName = self.msgNote;
                    disPlayName = [disPlayName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    if (disPlayName.length < 1)
                    {
                        XMPPJID *j= [self reGetJID:dicBody[@"from"]];
                        disPlayName = j.user;
                        NSInteger index = [disPlayName rangeOfString:@"c_"].location ;
                        disPlayName = [disPlayName substringFromIndex:index + 2];
                    }

                    //修改存入数据库中的 jid 主键
                    NSString *_fromUserId = [NSString stringWithFormat:@"%@@im.gy.com",dicBody[@"from"]];
                    if (![_fromUserId hasPrefix:@"m_"])
                    {
                        _fromUserId = [@"m_" stringByAppendingString:_fromUserId];
                    }
                    mObj.fromUserId = _fromUserId;//[NSString stringWithFormat:@"%@@im.gy.com",dicBody[@"from"]];
                    mObj.msgNote = disPlayName;
                    mObj.friendName = mObj.msgNote;
                    mObj.msgIcon = self.msgIcon;
                    
                    [mObj updateNotReadWithKey:mObj WithTableType:1];
                    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
                    {
                        NSString *notiBodyString = [NSString stringWithFormat:@"%@: %@", mObj.msgSubject, mObj.content];                           [Utils creatLocalNotification:0.3f timeZone:[NSTimeZone defaultTimeZone] userInfor:@{@"hsmsg":@"hsmsg"} alertBody:notiBodyString];
                    }else
                    {
                        AudioServicesPlaySystemSound(kSystemPushMessageSound);
                    }
                }
                    break;
                    //好友确认
                case kSub_Msg_Code_User_User_Add_Confirm:
                {
                    NSString *disPlayName = self.msgNote;
                    disPlayName = [disPlayName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    if (disPlayName.length < 1)
                    {
                        XMPPJID *j= [self reGetJID:dicBody[@"from"]];
                        disPlayName = j.user;
                        NSInteger index = [disPlayName rangeOfString:@"c_"].location ;
                        disPlayName = [disPlayName substringFromIndex:index + 2];
                    }
                    
                    //修改存入数据库中的 jid 主键
                    NSString *_fromUserId = [NSString stringWithFormat:@"%@@im.gy.com",dicBody[@"from"]];
                    if (![_fromUserId hasPrefix:@"m_"])
                    {
                        _fromUserId = [@"m_" stringByAppendingString:_fromUserId];
                    }
                    mObj.fromUserId = _fromUserId;//[NSString stringWithFormat:@"%@@im.gy.com",dicBody[@"from"]];
                    mObj.msgNote = disPlayName;
                    mObj.friendName = mObj.msgNote;
                    mObj.msgIcon = self.msgIcon;
                    
                    [mObj updateNotReadWithKey:mObj WithTableType:1];
                    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
                    {
                        NSString *notiBodyString = [NSString stringWithFormat:@"%@: %@", mObj.msgSubject, mObj.content];                           [Utils creatLocalNotification:0.3f timeZone:[NSTimeZone defaultTimeZone] userInfor:@{@"hsmsg":@"hsmsg"} alertBody:notiBodyString];
                    }else
                    {
                        AudioServicesPlaySystemSound(kSystemPushMessageSound);
                    }
                }
                    break;
                case kSub_Msg_Code_User_User_Del_Friend://删除好友
                {
                    //清理信息
                    NSString *_fromUserId = [NSString stringWithFormat:@"%@",dicBody[@"from"]];
//                    NSLog(@"kSub_Msg_Code_User_User_Del_Friend:%@", _fromUserId);
                    //如果正在聊天，禁止发送及保存数据库
                    
                    NSString *userId = _fromUserId;
                    if (![userId hasPrefix:@"m_"])
                    {
                        userId = [@"m_" stringByAppendingString:userId];
                    }
                    userId = [NSString stringWithFormat:@"%@@%@", userId, [GlobalData shareInstance].hdDomain];
                    
                    NSString *notificationName = [kNotificationNameFromJIDPrefix stringByAppendingString:userId];
                    DDLogInfo(@"收到即时聊天消息，串行队列 异步处理消息: %@    from:%@  notificationName:%@", body, jidString, notificationName);
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:mObj userInfo:nil];

                    if([GYDBCenter deleteUserAllMessageWithUserAccount:_fromUserId])
                    {
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameInitDB object:nil];
                    }
                }
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
            
        default:
            break;
    }
    
    NSString *notificationName = [kNotificationNameFromJIDPrefix stringByAppendingString:mObj.resNo];
    DDLogInfo(@"收到系统推送消息，串行队列 异步处理消息: %@    from:%@  notificationName:%@", body, jidString, notificationName);
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:mObj userInfo:nil];
    
}

//往外发送信息
- (void)sendMessageToUserIsRequest_Receipts:(BOOL)isRequest
{
    if (![xmp connect])
    {
        return;
    }
    
    //补充 mObj对象必要的属性
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[mObj.messageId doubleValue] / 1000]; //校准后的时间
    mObj.dateTimeSend = [Utils dateToString:date];
    mObj.dateTimeReceive = [Utils dateToString:date];
    
    //组装发送的XMPPMessage
    XMPPJID *jid = [self reGetJID:mObj.toUserId];
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:jid elementID:mObj.messageId];
    if (isRequest)
    {
        NSXMLElement *receipt = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
        [message addChild:receipt];
    }

    NSString *disPlayName = mObj.msgNote;
    if (disPlayName.length < 1)
    {
        XMPPJID *j= [self reGetJID:mObj.fromUserId];
        disPlayName = j.user;
        
        NSInteger index = [disPlayName rangeOfString:@"c_"].location ;
        //        NSLog(@"disPlayName index:%d", index);
        disPlayName = [disPlayName substringFromIndex:index + 2];
        mObj.msgNote = disPlayName;
    }
    
    NSString *str_msg_Code = (mObj.msg_Code == kMsg_Code_Text_Msg ? @"00" : [@(mObj.msg_Code) stringValue]);//因为使用了枚举类型，协议定的是00,所以发送消息时，要转换好，接收可以忽略
    
//组装消息body结构
    
    NSString *strTemp;
    
    switch (mObj.msg_Code) {
//文本消息
        case kMsg_Code_Text_Msg:
        {
            DDLogInfo(@"＝＝＝＝＝＝＝＝＝＝＝＝这是文字消息＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝");
            strTemp = mObj.content;

        }
            break;
//图片消息
        case kMsg_Code_Picture_Msg:
        {
            DDLogInfo(@"＝＝＝＝＝＝＝＝＝＝＝＝这是图片消息＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝");
            strTemp = mObj.pictureRUL;
            DDLogInfo(@"strTemp == %@",strTemp);
        }
            break;
        default:
            break;
    }
    
    NSDictionary * dic = @{kKeyForMsg_type: @(mObj.msg_Type),
            kKeyForMsg_code: str_msg_Code,
            kKeyForSub_msg_code: @(mObj.sub_Msg_Code),
            kMessageContent: strTemp,
            kMessageNote:mObj.msgNote,
            kMessageIcon:mObj.msgIcon
            };
    
    NSString *dicString = [Utils dictionaryToString:dic];

    [message addAttributeWithName:@"from" stringValue:xmp.xmppStream.myJID.full];
    
    [message addBody:dicString];
//    [message addBody:mObj.content];
    
    DDLogInfo(@"mObj.msgtype == %d",mObj.msgtype);
    
    
    dispatch_async([xmp getMessageQueue], ^{
        dispatch_queue_t q = dispatch_queue_create("com.gyist.message_tran_center", DISPATCH_QUEUE_CONCURRENT);
        dispatch_sync(q, ^{
            //保存到本地数据库
            
            if([mObj saveMessageToDB])
                DDLogInfo(@"发送的消息体已经保存");
            
            if (mObj.friendId.length > 1) {
                mObj.msgNote = mObj.friendName;
                mObj.msgIcon = mObj.friendIcon;
                [mObj updateNotReadWithKey:mObj WithTableType:mObj.msgtype];
                [mObj updateIsReadToZeroWithKey:mObj.toUserId WithMsgType:mObj.msgtype];
            }else{
                mObj.msgNote = [GlobalData shareInstance].IMUser.strNickName;
                mObj.msgIcon = [GlobalData shareInstance].IMUser.strHeadPic;
                
                
                [mObj updateNotReadWithKey:mObj WithTableType:mObj.msgtype];
                [mObj updateIsReadToZeroWithKey:mObj.toUserId WithMsgType:mObj.msgtype];
            }
                mObj.msgNote = [GlobalData shareInstance].IMUser.strNickName;
                mObj.msgIcon = [GlobalData shareInstance].IMUser.strHeadPic;
         
            
            
        });
        dispatch_sync(q, ^{
            //发送
            [xmp.xmppStream sendElement:message];
        });
        
    });
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
    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@", u, xmp.xmppStream.myJID.domain]];
    return jid;
}

//切割字符串
-(NSString *)cutUserJID:(GYChatItem *)chatItem
{
    NSString *str = [XMPPJID jidWithString:chatItem.toUserId].user;
    NSString *subStr = @"e_";
    NSRange range = [str rangeOfString:subStr];
    NSInteger location = range.location;
    NSString *cutStr;

    if (location > 0 && location < 10) {
        DDLogInfo(@"location == %i",location);
        cutStr= [str substringFromIndex:location];
    }

    return cutStr;
}

-(NSArray *)getPropertyArray
{
    NSArray *array = [[NSArray alloc] initWithObjects:@(self.msg_Type),@(self.msg_Code),@(self.sub_Msg_Code),self.msgNote,self.msgIcon,self.resNo,self.msgId,self.msgSubject, nil];
    return array;
}


@end