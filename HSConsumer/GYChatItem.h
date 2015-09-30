//
//  IMMessageObject.h
//

#import <Foundation/Foundation.h>
#import "IMMessageCenter.h"

#define kSystemPushPersonHSMsgJID @"SystemPushPersonHSMsg"  //默认
#define kSystemPushPersonBusinessMsgJID @"SystemPushPersonBusinessMsg"  //默认

#define kMessageTurnID      @"messageTurnID"//消息顺序ID 数据库主键
#define kMessageID          @"messageId"    //消息ID
#define kMessageType        @"msg_type"     //消息类型
#define kMessageCode        @"msg_code"     //消息代码
#define kMessageSubCode     @"sub_msg_code" //子业务消息代码
#define kMessageFrom        @"fromUserId"   //发送者
#define kMessageTo          @"toUserId"     //接收者
#define kMessageContent     @"msg_content"  //内容
#define kMessageNote        @"msg_note"     //昵称
#define kMessageIcon        @"msg_icon"     //头像URL

#define kMessageSendDateTime    @"datetimeSend"     //发送的时间
#define kMessageReceiveDateTime @"datetimeReceive"  //收到的时间
#define kMessagePictureRUL      @"picture_url"      //图片的URL
#define kMessagePictureFullName @"picture_local_fullname"  //图片本地的完整路径
#define kMessageSendState       @"msg_send_state"   //消息发送状态
#define kMessageReceiveIsRead   @"receive_isread"    //收到的消息是否已读

#define kItemName          @"item_name"       //商品名称
#define kSelInfo          @"sel_info"       //商品描述
#define kVshopName          @"vshop_name"   //商品名称

#define kUserJid          @"user_jid"       //用户ID 用户主键

#define kDisplayName      @"displayname"    //用户名
#define kLastMsg          @"last_msg"       //最后一条信息
#define kUnreadMsgCnt     @"unread_msg_cnt" //未读信息条数
#define kDatetimeSend     @"datetimeSend"


#define kResNo              @"res_no"       //企业资源号 用户主键
#define kMsgId              @"msg_id"       //msg_id 字段
#define kMsgSubject         @"msg_subject"  //msg_subject 字段

#define kShopId          @"shop_id"       //用户ID 用户主键
#define kGoodsId          @"goods_id"       //用户ID 用户主键

typedef enum : NSInteger
{
    kMessagSentState_Sending= 1,  //正在发送
    kMessagSentState_Sent = 2,    //已发送，发送成功
    kMessagSentState_Send_Failed = 3//发送失败
}EMMessagSentState;

@class FMResultSet;

@interface GYChatItem : NSObject

//测试－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
//@property (nonatomic, copy) NSString* content;//文本内容
@property (nonatomic,assign) BOOL isSelf;//是否为自己发
@property (nonatomic,assign) BOOL isPic;//是否为图片
@property (nonatomic,assign) NSInteger msgCount;//信息数量
@property (nonatomic,copy) NSString *displayName;//用户名称

@property (nonatomic, copy) NSString *lastMsg;//最后一条信息
@property (nonatomic, copy) NSString *msgType; //消息类型
@property (nonatomic, copy) NSString *msgCode; //消息代码
@property (nonatomic, copy) NSString *subMsgCode;//消息子代码
@property (nonatomic, copy) NSString *resNo;//res_no 字段
@property (nonatomic, copy) NSString *msgId;//msg_id 字段
@property (nonatomic, copy) NSString *msgSubject;//msg_subject 字段

@property (nonatomic, copy) NSString *msgNote;  //昵称
@property (nonatomic, copy) NSString *msgIcon;  //头像

@property (nonatomic, copy) NSString *friendName;  //好友名称
@property (nonatomic, copy) NSString *friendId;  //好友id
@property (nonatomic, copy) NSString *friendIcon;  //好友icon
@property (nonatomic, copy) NSString *itemName;  //商品名称
@property (nonatomic, copy) NSString *selInfo;  //商品描述
@property (nonatomic, copy) NSString *vshopName;  //店名
@property (nonatomic, copy) NSString *vshopID;  //店ID
@property (nonatomic, assign) NSInteger msgtype;  //用于分类

@property (nonatomic , copy) UIImage *img;//头像

//－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－



@property (nonatomic, copy) NSString *messageId;  //消息标识号，字符串 数据库主键
@property (nonatomic, assign) EMMsg_Type msg_Type; //消息类型
@property (nonatomic, assign) EMMsg_Code msg_Code; //消息代码
@property (nonatomic, assign) EMSub_Msg_Code sub_Msg_Code; //子业务消息代码
@property (nonatomic, copy) NSString *fromUserId; //发送者

@property (nonatomic, copy) NSString *toUserId;   //接收者
@property (nonatomic, copy) NSString *content;    //内容
@property (nonatomic, copy) NSString *pictureRUL; //图片的URL
@property (nonatomic, copy) NSString *pictureName;//图片保存在本地的名字
@property (nonatomic, assign) EMMessagSentState msgSendState;//消息发送状态
@property (nonatomic, assign) BOOL isRead;     //是否已读
@property (nonatomic, copy) NSString *dateTimeSend;     //发送的时间
@property (nonatomic, copy) NSString *dateTimeReceive;  //消息收到的时间




/**
 *	保存消息到数据库中
 *
 *	@return	保存成功YES/失败NO
 */
- (BOOL)saveMessageToDB;

-(void)updateNotReadWithKey:(GYChatItem *)chatItem WithTableType:(NSInteger)tbType;//未读信息增加1
-(void)updateIsReadToZeroWithKey:(NSString *)UserId WithMsgType:(NSInteger)msgType;//未读信息数量设置为0

-(BOOL)savePersonToDB;//保存到人物列表

-(BOOL)saveShopToDB;//保存到商铺列表

-(BOOL)saveGoodsToDB;//保存到商品列表

-(void)deleteTableWithName:(NSString *)tableName WithKey:(NSString *)key andRemoveMessage:(BOOL)isRemove;//删除记录

-(BOOL)deleteMsgWithID:(NSString *)messageId;//删除单条聊天信息


+(BOOL)changeSendMsgStatusWithMsgID:(NSString *)MsgID WithStatus:(NSInteger)status;//修改数据库信息发送状态

-(void)searchInDBWithChatItem:(GYChatItem *)chatItem;//查询添加好友是否有重复数据


/**
 *	创建保存记录表的SQL语句
 *
 *	@param 	tableName 	表名
 *
 *	@return	SQL语句
 */
+ (NSString *)createMsgTableSqlString:(NSString *)tableName;

+ (NSString *)createMessageID;
// add by songjk 设置好友备注
+(void)setRemark:(NSString *)remark dictData:(NSDictionary *)dictData;
// 获取备注
+(NSString *)getRemarkWithFriendId:(NSString *)friendID myID:(NSString *)myID;
@end
