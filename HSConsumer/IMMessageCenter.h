//
//  IMMessageCenter.h
//

//消息类型
#define kKeyForMsg_type @"msg_type"
typedef enum : NSInteger
{
    kMsg_Type_System_Push = 1,    //系统推送消息
    kMsg_Type_Immediate_Chat = 2 //即时聊天消息
    
}EMMsg_Type;

//消息代码
#define kKeyForMsg_code @"msg_code"
typedef enum : NSInteger
{
    kMsg_Code_Text_Msg = 00, //文本消息
    kMsg_Code_Picture_Msg = 10, //图片消息
    kMsg_Code_File_Msg = 12, //文件消息
    kMsg_Code_Person = 101, //个人消息
    kMsg_Code_Goods = 102,  //商品消息
    kMsg_Code_Shops = 103,  //商铺消息
    kMsg_Code_Advisory = 201,   //咨询消息
    kMsg_Code_Order = 202,      //订单消息
    kMsg_Code_Internal = 203,   //内部消息
    kMsg_Code_Command= 500      //指令消息
}EMMsg_Code;

//子业务消息代码
#define kKeyForSub_msg_code @"sub_msg_code"
typedef enum : NSInteger
{
    kSub_Msg_Code_Person_HS_Msg = 10101,                //消费者个人消息 ----- 互生消息
    kSub_Msg_Code_Person_Business_Msg = 10102,          //消费者个人消息 ----- 业务消息(总类)
    kSub_Msg_Code_Person_Business_Bind_HSCard_Msg = 1010201,//消费者个人消息 ----- 业务消息(小类)绑定互生卡
    kSub_Msg_Code_Person_Business_Order_Pay_Success = 1010202,//消费者个人消息 ----- 业务消息(小类)订单消息 -----订单支付成功
    kSub_Msg_Code_Person_Business_Order_Confirm_Receiving = 1010203,//消费者个人消息 ----- 业务消息(小类)订单消息 -----确认收货
    kSub_Msg_Code_Person_Business_Order_PickUpCargo = 1010204,//消费者个人消息 ----- 业务消息(小类)订单消息 -----待自提
    kSub_Msg_Code_Person_Business_Order_Cancel = 1010205,//消费者个人消息 ----- 业务消息(小类)订单消息 -----取消订单
    kSub_Msg_Code_Person_Business_Order_Refund_Success_For_Cancel  = 1010206,//消费者个人消息 ----- 业务消息(小类)订单消息 -----退款完成【订单取消】
    kSub_Msg_Code_Person_Business_Order_Refund_Success_For_Sale_After = 1010207,//消费者个人消息 ----- 业务消息(小类)订单消息 -----退款完成【售后】
    kSub_Msg_Code_Person_Business_Get_Coupons = 1010208,//消费者个人消息 ----- 业务消息(小类)订单消息 -----申领抵扣券消息
    // add by songjk
    kSub_Msg_Code_Person_Business_Accidental_valid = 1010209, //消费者个人消息 ----- 意外伤害 您的互生意外伤害保障已生效
    kSub_Msg_Code_Person_Business_Accidental_Invalid = 1010210, //消费者个人消息 ----- 意外伤害保障失效
    kSub_Msg_Code_Person_Business_Free_Insurance = 1010211, //消费者个人消息 ----- 积分投资达到10000 推送可以申请免费医疗
    
    kSub_Msg_Code_Order_Shipped_Remind = 20201,         //订单消息 -----  发货提醒
    kSub_Msg_Code_Order_Refundable_Notice = 20202,      //订单消息 -----  退款通知
    kSub_Msg_Code_Order_Aftermarket_Complaints = 20203, //订单消息 -----  售后申拆
    kSub_Msg_Code_Order_Abuse_Report = 20204,           //订单消息 -----  违规举报（含商品违规举报）
    kSub_Msg_Code_Order_Evaluation = 20205,             //订单消息 -----  订单评价
    kSub_Msg_Code_Order_Transaction_Succeed = 20206,    //订单消息 -----  交易成功
    kSub_Msg_Code_Order_Businesses_To_Be_Confirmed_Orders = 20207,  //订单消息 -----  待商家确认订单
    kSub_Msg_Code_Order_Closed = 20208,                             //订单消息 -----  订单关闭
    // add by songjk
    
    kSub_Msg_Code_Order_Stocking = 1010212, //消费者个人消息 ----- 订单消息 企业备货中
    kSub_Msg_Code_Order_byer_cancel = 1010213, //消费者个人消息 ----- 订单消息 买家申请取消订单
    
    kSub_Msg_Code_Internal_HS_Msg = 20302,  //内部消息 ----- 互生消息
    kSub_Msg_Code_Internal_Business_Msg = 20301,   //内部消息 ----- 业务消息
    kSub_Msg_Code_User_Force_Users_To_Logout = 50001,   //强制用户登出指令
    kSub_Msg_Code_User_User_Add_Request = 50011,        //好友添加请求
    kSub_Msg_Code_User_User_Add_Confirm = 50012,        //好友确认
    kSub_Msg_Code_User_User_Add_Refuse = 50013,         //好友拒绝
    kSub_Msg_Code_User_User_Del_Friend = 50014          //删除好友

}EMSub_Msg_Code;

#import <Foundation/Foundation.h>

@class GYChatItem;
@interface IMMessageCenter : NSObject

@property (nonatomic,assign) EMMsg_Type msg_Type; //消息类型
@property (nonatomic,assign) EMMsg_Code msg_Code; //消息代码
@property (nonatomic,assign) EMSub_Msg_Code sub_Msg_Code; //子业务消息代码
@property (nonatomic,copy) NSString *msgNote; //昵称
@property (nonatomic,copy) NSString *msgIcon; //头像URl
@property (nonatomic,copy) NSString *resNo; //res_no 字段
@property (nonatomic,copy) NSString *msgId; //res_no 字段
@property (nonatomic,copy) NSString *msgSubject; //msg_subject 字段

@property (nonatomic, strong) XMPPMessage *xMPPMessage; //未解析的xmpp消息
@property (nonatomic, strong) NSString *bodyMessage;    //解析后的body字符串
@property (nonatomic, strong) GYChatItem *msgObject;//解析后的消息体


-(id)initWithReceiveXMPPMessage:(XMPPMessage *)xmppMessage;

- (id)initWithSendMessage:(GYChatItem *)messageObject;

- (void)forwardedReceiveMessage;//转发收到的消息

- (void)sendMessageToUserIsRequest_Receipts:(BOOL)isRequest;

@property (nonatomic, strong) NSMutableDictionary*  dictionary;
@property (nonatomic,assign) float  progress;
@property (nonatomic,assign) int    index;

@end
