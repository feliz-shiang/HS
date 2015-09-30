//
//  IMMessageObject.m
//
//  Created by Reese on 13-8-11.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import "GYChatItem.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "NSData+XMPP.h"
#import "GYXMPP.h"
#import "GYDBCenter.h"

@interface GYChatItem()
{
    GYXMPP *xmp;
}

@end

@implementation GYChatItem
@synthesize msgIcon = _msgIcon;

-(id)init{
    self = [super init];
    if(self)
    {
        //防止插入数据出错，初始化一些默认值
        self.messageId = [XMPPStream generateUUID];
        self.msg_Type = kMsg_Type_Immediate_Chat;
        self.msg_Code = kMsg_Code_Text_Msg;
        self.sub_Msg_Code = kSub_Msg_Code_Person_HS_Msg;
        self.fromUserId = @"";
        self.toUserId = @"";
        self.content = @"";
        self.dateTimeSend = @"";
        self.dateTimeReceive = @"";
        self.pictureRUL = @"";
        self.pictureName = @"";
        self.resNo = @"";
        self.msgId = @"";
        self.msgSubject = @"";
        self.msgNote = @"";
        self.msgSendState = kMessagSentState_Sending;
        self.isRead = NO;
        self.msgSubject = @"";
        xmp = [GYXMPP sharedInstance];
    }
    return self;
}

- (BOOL)saveMessageToDB
{
    NSString *str_msg_Code = (self.msg_Code == kMsg_Code_Text_Msg ? @"00" : [@(self.msg_Code) stringValue]);//因为使用了枚举类型，协议定的是00,所以发送消息时，要转换好，接收可以忽略

    //构造键值对，以后要添加或删除，只要修改此键值对
    NSDictionary *dicInsert = @{kMessageID: self.messageId,
                                kMessageType: @(self.msg_Type),
                                kMessageCode: str_msg_Code,
                                kMessageSubCode: @(self.sub_Msg_Code),
                                kMessageFrom: self.fromUserId,
                                kMessageTo: self.toUserId,
                                kMessageNote: self.msgNote,
                                kMessageIcon: kSaftToNSString(self.msgIcon),
                                kMsgSubject: self.msgSubject,
                                kMessageContent: self.content,
                                kMessageSendDateTime: self.dateTimeSend,
                                kMessageReceiveDateTime: self.dateTimeReceive,
                                kMessagePictureRUL: self.pictureRUL,
                                kMessagePictureFullName: self.pictureName,
                                kMessageSendState: @(self.msgSendState),
                                kResNo: self.resNo,
                                kMsgId: self.msgId,
                                kMessageReceiveIsRead: @(self.isRead)
                                };
    
    DDLogInfo(@"插入数据到msg表中，字典:%@",dicInsert);
    
    NSMutableString *sql1 = [NSMutableString stringWithFormat:@"INSERT INTO %@ (", [GYDBCenter getDefaultTableNameForMessageRecord]];
    NSMutableString *sql2 = [NSMutableString stringWithString:@" VALUES ("];

    for (NSString *field in [dicInsert allKeys])
    {
        [sql1 appendFormat:@"%@,", field];
        [sql2 appendFormat:@"'%@',", dicInsert[field]];
    }
    
    NSMutableString *sql3 = [NSMutableString stringWithString:[sql1 substringToIndex:sql1.length - 1]];//删除最后一个逗号
    [sql3 appendString:@")"];
    [sql3 appendString:[sql2 substringToIndex:sql2.length - 1]];//删除最后一个逗号
    [sql3 appendString:@")"];//组合完成
    
    DDLogInfo(@"insertSql:%@", sql3);
    return [xmp.imFMDB executeUpdate:sql3];
}


//未读消息数量自增
-(void)updateNotReadWithKey:(GYChatItem *)chatItem WithTableType:(NSInteger)tbType
{
    DDLogInfo(@"存入对应表格中");
    DDLogInfo(@"tbType == %d",tbType);
    
    
    switch (tbType) {
        case 1://个人消息
        {
            if ([self savePersonToDB]) {
                DDLogInfo(@"插入记录到个人list表中，状态：成功。");
                
            }else
            {
                NSString *last_msg = chatItem.content;
                
                NSString *tCode = [@(self.sub_Msg_Code) stringValue];
                BOOL isBusiness_Msg = [tCode hasPrefix:[@(kSub_Msg_Code_Person_Business_Msg) stringValue]];//业务消息
                
                if ((self.msg_Type == kMsg_Type_System_Push && self.sub_Msg_Code == kSub_Msg_Code_Person_HS_Msg) ||
                    (self.msg_Type == kMsg_Type_System_Push && isBusiness_Msg)
                    )
                {
                    last_msg = chatItem.msgSubject;
                }
                
                NSString *upSetSql = [NSString stringWithFormat:@"update tb_list_person set unread_msg_cnt = unread_msg_cnt+1 ,last_msg = '%@' ,displayname = '%@',msg_icon = '%@',datetimeSend = '%@',msg_type='%d',msg_code='%d',sub_msg_code='%d' where user_jid='%@'",last_msg,chatItem.friendName,chatItem.friendIcon,chatItem.dateTimeSend,chatItem.msg_Type,chatItem.msg_Code,chatItem.sub_Msg_Code,chatItem.friendId];
                DDLogInfo(@"updateSql:%@", upSetSql);
                
                if ([xmp.imFMDB executeUpdate:upSetSql]) {
                    DDLogInfo(@"插入记录到个人list表中，状态：成功；更新未读数量。");
                    
                }else{
                    DDLogInfo(@"插入记录到个人list表中，状态：失败。");
                }
            }
        }
            break;
        case 2://商铺消息
        {
            if ([self saveShopToDB])
            {
                DDLogInfo(@"插入记录到商铺list表中，状态：成功。");

            }else
            {
                
                NSString *sql = [NSString stringWithFormat:@"update tb_list_shops set unread_msg_cnt = unread_msg_cnt+1 ,last_msg = '%@',displayname = '%@',fromUserId = '%@',datetimeSend = '%@' where user_jid='%@'",chatItem.content,chatItem.msgNote,chatItem.fromUserId,chatItem.dateTimeSend,chatItem.resNo];

                if (_isSelf)
                {
                    sql = [NSString stringWithFormat:@"update tb_list_shops set unread_msg_cnt = unread_msg_cnt+1 ,last_msg = '%@',fromUserId = '%@',datetimeSend = '%@' where user_jid='%@'",chatItem.content,chatItem.fromUserId,chatItem.dateTimeSend,chatItem.resNo];
                    if (self.msgIcon && self.msgIcon.length>0) {
                        sql = [NSString stringWithFormat:@"update tb_list_shops set unread_msg_cnt = unread_msg_cnt+1 ,last_msg = '%@',fromUserId = '%@',datetimeSend = '%@' ,msg_icon = '%@' where user_jid='%@'",chatItem.content,chatItem.fromUserId,chatItem.dateTimeSend,self.msgIcon,chatItem.resNo];
                    }
                    if (self.msgNote && self.msgNote.length>0) {
                        sql = [NSString stringWithFormat:@"update tb_list_shops set unread_msg_cnt = unread_msg_cnt+1 ,last_msg = '%@',fromUserId = '%@',datetimeSend = '%@' ,displayname = '%@' where user_jid='%@'",chatItem.content,chatItem.fromUserId,chatItem.dateTimeSend,self.msgNote,chatItem.resNo];
                    }
                    if ((self.msgIcon && self.msgIcon.length>0) && (self.msgNote && self.msgNote.length>0))
                    {
                        sql = [NSString stringWithFormat:@"update tb_list_shops set unread_msg_cnt = unread_msg_cnt+1 ,last_msg = '%@',fromUserId = '%@',datetimeSend = '%@' ,displayname = '%@',msg_icon = '%@'  where user_jid='%@'",chatItem.content,chatItem.fromUserId,chatItem.dateTimeSend,self.msgNote,self.msgIcon,chatItem.resNo];
                    }
                }
                NSLog(@"Update:sql: %@",sql);

                if ([xmp.imFMDB executeUpdate:sql])
                {
                    DDLogInfo(@"插入记录到商铺list表中，状态：成功；更新未读数量。");
                    
                }else{
                    DDLogInfo(@"插入记录到商铺list表中，状态：失败。");
                }
            }
        }
            break;
        case 3://商品消息
        {
            
            if ([self saveGoodsToDB]) {
                DDLogInfo(@"插入记录到商品list表中，状态：成功。");
                
            }else{
                if ([xmp.imFMDB executeUpdate:@"update tb_list_goods set unread_msg_cnt = unread_msg_cnt+1 ,last_msg = ?,item_name = ?,sel_info = ?,vshop_name = ?,msg_icon = ? ,datetimeSend = ? where user_jid=?",chatItem.content,chatItem.itemName,chatItem.selInfo,chatItem.vshopName,chatItem.msgIcon,chatItem.dateTimeSend,chatItem.msgId]) {
                    DDLogInfo(@"插入记录到商品list表中，状态：成功；更新未读数量。");
                    
                }else{
                    DDLogInfo(@"插入记录到商品list表中，状态：失败。");
                }
                
            }
        
        }
            break;
            
        default:
            break;
    }
   
    NSString *notificationName = @"ChangeMsgCount";
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:nil];
    
}
//设置未读信息条数量为0
-(void)updateIsReadToZeroWithKey:(NSString *)UserId WithMsgType:(NSInteger)msgType
{
    if (msgType == 1)//人个消息列表
    {
        if ([xmp.imFMDB executeUpdate:@"update tb_list_person set unread_msg_cnt = 0 where user_jid=?",UserId]) {
            DDLogInfo(@"更新人个消息列表，未读信息条数量为0，状态：成功。");
            
        }else{
            DDLogInfo(@"更新人个消息列表，未读信息条数量为0，状态：失败。");
        }
        
    }
    if (msgType == 2)//商铺消息列表
    {
        if ([xmp.imFMDB executeUpdate:@"update tb_list_shops set unread_msg_cnt = 0 where user_jid=?",UserId]) {
            DDLogInfo(@"更新商铺消息列表，未读信息条数量为0，状态：成功。");
            
        }else{
            DDLogInfo(@"更新商铺消息列表，未读信息条数量为0，状态：失败。");
        }
        
    }
    if (msgType == 3) //商品消息列表
    {
        if ([xmp.imFMDB executeUpdate:@"update tb_list_goods set unread_msg_cnt = 0 where user_jid=?",UserId]) {
            DDLogInfo(@"更新商品消息列表，未读信息条数量为0，状态：成功。");
            
        }else{
            DDLogInfo(@"更新商品消息列表，未读信息条数量为0，状态：失败。");
        }
        
    }
    
    NSString *notificationName = @"ChangeMsgCount";
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:nil];
}


//在数据库中删除信息
-(void)deleteTableWithName:(NSString *)tableName WithKey:(NSString *)key andRemoveMessage:(BOOL)isRemove
{
    DDLogInfo(@"删除");
    if (![xmp.imFMDB executeUpdate:[NSString stringWithFormat:@"delete from %@ where user_jid=?",tableName],key]) {
        DDLogInfo(@"删除 %@ 失败",key);
    }
    if (isRemove)
    {
        if (![xmp.imFMDB executeUpdate:@"delete from tb_msg where fromUserId=? or toUserId=? or res_no=?",key,key,key]) {
            DDLogInfo(@"删除 %@ 失败",key);
        }
    }
}

//根据messageId 删除单条信息
-(BOOL)deleteMsgWithID:(NSString *)messageId
{
    return [xmp.imFMDB executeUpdate:@"delete from tb_msg where messageId=?",messageId];
}


//查重复，删除
-(void)searchInDBWithChatItem:(GYChatItem *)chatItem
{
    
    FMResultSet * set = [[GYXMPP sharedInstance].imFMDB executeQuery:[NSString stringWithFormat:@"select * from tb_list_person where user_jid=%@",chatItem.fromUserId]];
    
    GYChatItem * m = [[GYChatItem alloc] init];
    while ([set next]) {
        m.fromUserId = [set stringForColumn:@"user_jid"];
        [xmp.imFMDB executeUpdate:@"delete from tb_list_person where user_jid=?",m.fromUserId];
    }
}


-(BOOL)savePersonToDB
{
    NSString *str_msg_Code = [@(self.msg_Code) stringValue];
    
    NSDictionary *dicInsert;
    
    if (self.isSelf) {
        dicInsert = @{kUserJid: self.toUserId,
                      kMessageType: @(self.msg_Type),
                      kMessageCode: str_msg_Code,
                      kMessageSubCode: @(self.sub_Msg_Code),
                      kDisplayName: self.msgNote,
                      kMessageIcon: self.msgIcon,
                      kLastMsg: self.content,
                      kDatetimeSend:self.dateTimeSend,
                      kUnreadMsgCnt: @(0)
                      };
        self.friendId = self.toUserId;
    }else
    {
        NSString *con = self.content;
        if (self.sub_Msg_Code == kSub_Msg_Code_Person_HS_Msg ||
            self.sub_Msg_Code == kSub_Msg_Code_Person_Business_Bind_HSCard_Msg
            )
        {
            con = self.msgSubject;
        }
        dicInsert = @{kUserJid: self.fromUserId,
                      kMessageType: @(self.msg_Type),
                      kMessageCode: str_msg_Code,
                      kMessageSubCode: @(self.sub_Msg_Code),
                      kDisplayName: self.msgNote,
                      kMessageIcon: kSaftToNSString(self.msgIcon),
                      kLastMsg: con,
                      kDatetimeSend:self.dateTimeSend
                      };
        self.friendId = self.fromUserId;
    }
    
    NSMutableString *sql1 = [NSMutableString stringWithFormat:@"INSERT INTO %@ (", [GYDBCenter getTableNameFroMsgType:1]];
    NSMutableString *sql2 = [NSMutableString stringWithString:@" VALUES ("];
    
    for (NSString *field in [dicInsert allKeys])
    {
        [sql1 appendFormat:@"%@,", field];
        [sql2 appendFormat:@"'%@',", dicInsert[field]];
    }
    
    NSMutableString *sql3 = [NSMutableString stringWithString:[sql1 substringToIndex:sql1.length - 1]];//删除最后一个逗号
    [sql3 appendString:@")"];
    [sql3 appendString:[sql2 substringToIndex:sql2.length - 1]];//删除最后一个逗号
    [sql3 appendString:@")"];//组合完成
    
    DDLogInfo(@"insertSql:%@", sql3);
    
    return [xmp.imFMDB executeUpdate:sql3];
}


-(BOOL)saveShopToDB
{
    NSString *str_msg_Code = [@(self.msg_Code) stringValue];
    //构造键值对，以后要添加或删除，只要修改此键值对
    NSDictionary *dicInsert;
    if (self.isSelf) {
      
        dicInsert = @{kUserJid: self.resNo,
                      kMessageType: @(self.msg_Type),
                      kMessageCode: str_msg_Code,
                      kMessageSubCode: @(self.sub_Msg_Code),
                      kMessageFrom: self.fromUserId,
                      kDisplayName: self.msgNote,//店铺名称
                      kMessageIcon: self.msgIcon,
                      kLastMsg: self.content,
                      kShopId: self.vshopID,
                      kDatetimeSend:self.dateTimeSend,
                      kUnreadMsgCnt: @(0)
                      };
    }else
    {
        dicInsert = @{kUserJid: self.resNo,
                      kMessageType: @(self.msg_Type),
                      kMessageCode: str_msg_Code,
                      kMessageSubCode: @(self.sub_Msg_Code),
                      kMessageFrom: self.fromUserId,
                      kDisplayName: self.msgNote,//店铺名称
                      kMessageIcon: self.msgIcon,
                      kLastMsg: self.content,
                      kShopId: self.vshopID,
                      kDatetimeSend:self.dateTimeSend
                      };
    }
    NSMutableString *sql1 = [NSMutableString stringWithFormat:@"INSERT INTO %@ (", [GYDBCenter getTableNameFroMsgType:2]];
    NSMutableString *sql2 = [NSMutableString stringWithString:@" VALUES ("];
    
    for (NSString *field in [dicInsert allKeys])
    {
        [sql1 appendFormat:@"%@,", field];
        [sql2 appendFormat:@"'%@',", dicInsert[field]];
    }
    
    NSMutableString *sql3 = [NSMutableString stringWithString:[sql1 substringToIndex:sql1.length - 1]];//删除最后一个逗号
    [sql3 appendString:@")"];
    [sql3 appendString:[sql2 substringToIndex:sql2.length - 1]];//删除最后一个逗号
    [sql3 appendString:@")"];//组合完成
    
    DDLogInfo(@"insertSql:%@", sql3);
    return [xmp.imFMDB executeUpdate:sql3];
}

-(BOOL)saveGoodsToDB
{
//    NSString *str_msg_Code = [@(self.msg_Code) stringValue];

    //构造键值对，以后要添加或删除，只要修改此键值对
    NSDictionary *dicInsert;
    

    dicInsert = @{kUserJid: self.msgId,
                  kMessageType: @(self.msg_Type),
                  kResNo: self.resNo,
                  kItemName: self.itemName,
                  kSelInfo: self.selInfo,
                  kVshopName: self.vshopName,
                  kMessageCode: [@(self.msg_Code) stringValue],
//                  kMessageNote: self.msgNote,
                  kMessageIcon: self.msgIcon,
                  kLastMsg: self.content,
                  kDatetimeSend:self.dateTimeSend,
                  };
    
    
    NSMutableString *sql1 = [NSMutableString stringWithFormat:@"INSERT INTO %@ (", [GYDBCenter getTableNameFroMsgType:3]];
    NSMutableString *sql2 = [NSMutableString stringWithString:@" VALUES ("];
    
    for (NSString *field in [dicInsert allKeys])
    {
        [sql1 appendFormat:@"%@,", field];
        [sql2 appendFormat:@"'%@',", dicInsert[field]];
    }
    
    NSMutableString *sql3 = [NSMutableString stringWithString:[sql1 substringToIndex:sql1.length - 1]];//删除最后一个逗号
    [sql3 appendString:@")"];
    [sql3 appendString:[sql2 substringToIndex:sql2.length - 1]];//删除最后一个逗号
    [sql3 appendString:@")"];//组合完成
    
    DDLogInfo(@"insertSql:%@", sql3);
    return [xmp.imFMDB executeUpdate:sql3];
}

//修改数据库信息发送状态
+(BOOL)changeSendMsgStatusWithMsgID:(NSString *)MsgID WithStatus:(NSInteger)status
{
    NSString *sqlStr = [NSString stringWithFormat:@"update tb_msg set msg_send_state =%d where messageId='%@'", (int)status, MsgID];
    return [[GYXMPP sharedInstance].imFMDB executeUpdate:sqlStr];
}



+ (NSString *)createMsgTableSqlString:(NSString *)tableName
{
    NSMutableString *sql = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (", tableName];
    [sql appendFormat:@"'%@' integer PRIMARY KEY AUTOINCREMENT,", kMessageTurnID];
    [sql appendFormat:@"'%@' VARCHAR(100),", kMessageID];
    [sql appendFormat:@"'%@' VARCHAR(10),", kMessageType];
    [sql appendFormat:@"'%@' VARCHAR(10),", kMessageCode];
    [sql appendFormat:@"'%@' VARCHAR(10),", kMessageSubCode];
    [sql appendFormat:@"'%@' VARCHAR(50),", kMessageFrom];
    [sql appendFormat:@"'%@' VARCHAR(50),", kMessageTo];
    
    [sql appendFormat:@"'%@' VARCHAR(50),", kMessageNote];
    [sql appendFormat:@"'%@' TEXT,", kMessageIcon];
    
    [sql appendFormat:@"'%@' TEXT,", kMsgSubject];
    [sql appendFormat:@"'%@' TEXT,", kMessageContent];
    [sql appendFormat:@"'%@' DATETIME,", kMessageSendDateTime];
    [sql appendFormat:@"'%@' DATETIME,", kMessageReceiveDateTime];
    [sql appendFormat:@"'%@' TEXT,", kMessagePictureRUL];
    [sql appendFormat:@"'%@' TEXT,", kMessagePictureFullName];
    [sql appendFormat:@"'%@' INTEGER,", kMessageSendState];
    [sql appendFormat:@"'%@' VARCHAR(50),", kResNo];
    [sql appendFormat:@"'%@' TEXT,", kMsgId];
    [sql appendFormat:@"'%@' INTEGER", kMessageReceiveIsRead];

    //最后一个字段不要带逗号
    [sql appendString:@")"];//组合完成
    return [NSString stringWithString:sql];
}

// add by songjk
-(void)setMsgIcon:(NSString *)v
{
    NSString * str = [v stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    _msgIcon = str;
}

+ (NSString *)createMessageID
{
    NSDate *date = [NSDate date];
    long long t = ([date timeIntervalSince1970] + [[GlobalData shareInstance] getTimeDifference:NO]) * 1000;
    NSNumber *n = [NSNumber numberWithLongLong:t];
    return [n stringValue];
}
// 设置好友备注
+(void)setRemark:(NSString *)remark dictData:(NSDictionary *)dictData
{
    NSDictionary *dicInsert;
    
        dicInsert = @{@"friend_id": [dictData objectForKey:@"friend_id"],
                      @"my_id": [dictData objectForKey:@"my_id"],
                      @"msg_type": [dictData objectForKey:@"msg_type"],
                      @"res_no": [dictData objectForKey:@"res_no"],
                      @"friend_remark": remark
                      };
    
    NSString * tableName = [GYDBCenter getTableNameFroMsgType:4];
    NSMutableString *sql1 = [NSMutableString stringWithFormat:@"INSERT INTO %@ (", tableName];
    NSMutableString *sql2 = [NSMutableString stringWithString:@" VALUES ("];
    
    for (NSString *field in [dicInsert allKeys])
    {
        [sql1 appendFormat:@"%@,", field];
        [sql2 appendFormat:@"'%@',", dicInsert[field]];
    }
    
    NSMutableString *sql3 = [NSMutableString stringWithString:[sql1 substringToIndex:sql1.length - 1]];//删除最后一个逗号
    [sql3 appendString:@")"];
    [sql3 appendString:[sql2 substringToIndex:sql2.length - 1]];//删除最后一个逗号
    [sql3 appendString:@")"];//组合完成
    
    DDLogInfo(@"insertSql:%@", sql3);
    
    if ([[GYXMPP sharedInstance].imFMDB executeUpdate:sql3])
    {
                DDLogInfo(@"设置备注成功。");
                
     }else
     {
         
         NSString *upSetSql = [NSString stringWithFormat:@"update %@ set friend_remark='%@' where friend_id ='%@' and my_id = '%@' ",tableName,remark,[dictData objectForKey:@"friend_id"],[dictData objectForKey:@"my_id"]];
         DDLogInfo(@"updateSql:%@", upSetSql);
         
         if ([[GYXMPP sharedInstance].imFMDB executeUpdate:upSetSql])
         {
             DDLogInfo(@"修改备注成功。");
             
         }else{
             DDLogInfo(@"修改备注失败。");
         }
     }
    
    
        // 发送修改备注的通知
    NSString *notificationName = [NSString stringWithFormat:@"setRemark%@%@",[Utils getResNO:[dictData objectForKey:@"friend_id"]],[dictData objectForKey:@"my_id"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:remark userInfo:nil];
    
}


+(NSString *)getRemarkWithFriendId:(NSString *)friendID myID:(NSString *)myID
{
    NSString *sql = [NSString stringWithFormat:@"select *  from %@ where friend_id = '%@' and my_id='%@' ",[GYDBCenter getTableNameFroMsgType:4],friendID,myID];
    FMResultSet * set = [[GYXMPP sharedInstance].imFMDB executeQuery:sql];
    NSString * remark = @"";
    while ([set next])
    {
        remark = [set stringForColumn:@"friend_remark"];
    }
    return remark;
}

///////////////////////////////以下保证取得的string不为nil null /////////////////////////////
- (NSString *)displayName
{
    return kSaftToNSString(_displayName);
}

- (NSString *)lastMsg
{
    return kSaftToNSString(_lastMsg);
}

- (NSString *)msgType
{
    return kSaftToNSString(_msgType);
}

- (NSString *)msgCode
{
    return kSaftToNSString(_msgCode);
}

- (NSString *)subMsgCode
{
    return kSaftToNSString(_subMsgCode);
}

- (NSString *)resNo
{
    return kSaftToNSString(_resNo);
}

- (NSString *)msgId
{
    return kSaftToNSString(_msgId);
}

- (NSString *)msgSubject
{
    return kSaftToNSString(_msgSubject);
}

- (NSString *)msgNote
{
    return kSaftToNSString(_msgNote);
}

- (NSString *)msgIcon
{
    return kSaftToNSString(_msgIcon);
}

- (NSString *)friendName
{
    return kSaftToNSString(_friendName);
}

- (NSString *)friendId
{
    return kSaftToNSString(_friendId);
}

- (NSString *)friendIcon
{
    return kSaftToNSString(_friendIcon);
}

- (NSString *)itemName
{
    return kSaftToNSString(_itemName);
}

- (NSString *)selInfo
{
    return kSaftToNSString(_selInfo);
}

- (NSString *)vshopName
{
    return kSaftToNSString(_vshopName);
}

- (NSString *)vshopID
{
    return kSaftToNSString(_vshopID);
}

- (NSString *)messageId
{
    return kSaftToNSString(_messageId);
}

- (NSString *)fromUserId
{
    return kSaftToNSString(_fromUserId);
}

- (NSString *)toUserId
{
    return kSaftToNSString(_toUserId);
}

- (NSString *)content
{
    return kSaftToNSString(_content);
}

- (NSString *)pictureRUL
{
    return kSaftToNSString(_pictureRUL);
}

- (NSString *)pictureName
{
    return kSaftToNSString(_pictureName);
}

- (NSString *)dateTimeSend
{
    return kSaftToNSString(_dateTimeSend);
}

- (NSString *)dateTimeReceive
{
    return kSaftToNSString(_dateTimeReceive);
}


@end