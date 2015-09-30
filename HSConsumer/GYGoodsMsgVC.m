//
//  GYGoodsMsgVC.m
//  HSConsumer
//
//  Created by 00 on 15-2-28.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYGoodsMsgVC.h"
#import "GYGoodsMsgCell.h"
#import "GYEasyBuyModel.h"
#import "UIImageView+WebCache.h"
#import "GYChatViewController.h"
#import "GYChatItem.h"
#import "UIButton+enLargedRect.h"
#import "GYGoodsDetailController.h"
#import "UIView+CustomBorder.h"

@interface GYGoodsMsgVC ()<UITableViewDataSource,UITableViewDelegate>


{

    __weak IBOutlet UITableView *tbv;//消息tableview
    
    __weak IBOutlet UIView *vTitle;//标题View
    __weak IBOutlet UIImageView *imgGoods;//产品图标
    __weak IBOutlet UILabel *lbGoodsTitle;//产品标题
    __weak IBOutlet UILabel *lbGoodsDescribe;//产品描述
   
    __weak IBOutlet UIView *vShop;//商品View
    __weak IBOutlet UILabel *lbShopName;//商铺名称
    __weak IBOutlet UIButton *btnCtShop;//联系商家按钮
 
    
    GYEasyBuyModel *model;//需要传 shopid  goodsid 到商品详情页面
    
    NSMutableArray *mArrData;
    
}

@end

@implementation GYGoodsMsgVC
//点击进入商品详情

- (IBAction)btnGoodsDetail:(id)sender {
   
//    GYGoodsDetailController * vcGoodDetail = kLoadVcFromClassStringName(NSStringFromClass([GYGoodsDetailController class]));
//    vcGoodDetail.model = self.arrResult[indexPath.row];
//    
//    GYEasyBuyModel *model = self.arrResult[indexPath.row];
//    DDLogDebug(@"model.goodsid:%@", model.strGoodId);
//    DDLogDebug(@"model.shopInfo.strShopId:%@", model.shopInfo.strShopId);
//
//    self.hidesBottomBarWhenPushed = YES;
//    [self pushVC:vcGoodDetail animated:YES];

}

- (IBAction)btnCtShopClick:(id)sender {
    
    GYChatViewController *vc = [[GYChatViewController alloc] init];
    
    vc.chatItem = self.chatItem;
    
    vc.chatItem.fromUserId = [NSString stringWithFormat:@"%@@im.gy.com",self.chatItem.resNo];
    vc.chatItem.msgNote = vc.chatItem.vshopName;
    vc.chatItem.content = @"";
    vc.chatItem.msg_Type = 1;
    vc.chatItem.msg_Code = 103;
    vc.chatItem.sub_Msg_Code = 10301;
    vc.navigationItem.title = self.chatItem.vshopName;
    // add by songjk
    vc.dicShopInfo = [NSDictionary dictionaryWithObject:self.chatItem.vshopName forKey:@"vShopName"];
    // 取得vshopid
    NSArray * arrShopInf = [vc.chatItem.msgId componentsSeparatedByString:@","];
    if (arrShopInf.count>=2)
    {
        vc.chatItem.vshopID = arrShopInf[1];
    }
//    [vc.chatItem updateNotReadWithKey:vc.chatItem WithTableType:2];
    //    vc.chatItem
    /*dicInsert = @{kUserJid: self.resNo,
     kMessageType: @(self.msg_Type),
     kMessageCode: str_msg_Code,
     kMessageSubCode: @(self.sub_Msg_Code),
     kMessageFrom: self.fromUserId,
     kDisplayName: self.msgNote,//店铺名称
     kMessageIcon: self.msgIcon,
     kLastMsg: self.content,
     kDatetimeSend:self.dateTimeSend,
     kUnreadMsgCnt: @(0)
     };*/
    
    vc.msgType = 2;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    [vc.chatItem updateNotReadWithKey:vc.chatItem WithTableType:2];

    
    /*
     datetimeReceive = "";
     datetimeSend = "2015-03-05 10:25:56";
     fromUserId = "m_c_06186010007@im.gy.com";
     messageId = "3A4136D2-E69C-4CE4-B3BC-870F24543461";
     "msg_code" = 00;
     "msg_content" = yiuyiyiyiouo;
     "msg_icon" = "";
     "msg_id" = "";
     "msg_note" = "";
     "msg_send_state" = 1;
     "msg_type" = 2;
     "picture_local_fullname" = "";
     "picture_url" = "";
     "receive_isread" = 0;
     "res_no" = 06186010000;
     "sub_msg_code" = 10101;
     toUserId = "06186010000@im.gy.com";
     */
}




- (void)viewDidLoad {
    [super viewDidLoad];
    mArrData = [[NSMutableArray alloc] init];
    [imgGoods sd_setImageWithURL:[NSURL URLWithString:self.chatItem.msgIcon] placeholderImage:kLoadPng(@"ep_placeholder_image_type1")];

    lbGoodsTitle.text = self.chatItem.itemName;
    lbShopName.text = self.chatItem.vshopName;

    lbGoodsDescribe.text = self.chatItem.selInfo;
    
    [btnCtShop setTitle:@"联系客服" forState:UIControlStateNormal];
    [btnCtShop setBackgroundColor:kClearColor];
    [btnCtShop setTitleColor:kCorlorFromRGBA(0, 143, 215, 1) forState:UIControlStateNormal];
    [btnCtShop setBorderWithWidth:1.0 andRadius:2.0 andColor:kCorlorFromRGBA(0, 143, 215, 1)];

    mArrData = [self selectFromDBWithMsgId:self.chatItem.msgId];
    NSLog(@"self.chatItem.msgId ==== %@",self.chatItem.msgId);
    
    NSLog(@"mArrData.count === %d",mArrData.count);
    tbv.delegate = self;
    tbv.dataSource = self;
    
    [tbv registerNib:[UINib nibWithNibName:@"GYGoodsMsgCell" bundle:nil] forCellReuseIdentifier:@"CELL"];
    tbv.tableFooterView = [[UIView alloc] init];
    tbv.backgroundView = [[UIView alloc] init];
    tbv.backgroundColor = [UIColor clearColor];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [vShop addTopBorderAndBottomBorder];
    [vShop setBottomBorderInset:YES];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //离开页面，移除所有的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    GYChatItem * m1 = [[GYChatItem alloc] init];
    [m1 updateIsReadToZeroWithKey:self.chatItem.msgId WithMsgType:3];
    
}

-(void)viewWillUnload
{
    GYChatItem * m1 = [[GYChatItem alloc] init];
   
    [m1 updateIsReadToZeroWithKey:self.chatItem.msgId WithMsgType:3];
  
}


#pragma mark - UITableViewDataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mArrData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYGoodsMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    GYChatItem *chatItem = mArrData[indexPath.row];
    cell.lbTime.text = [self changeDateFormat:chatItem.dateTimeSend :6];
    cell.lbMsg.text = chatItem.content;
 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSMutableArray *)selectFromDBWithMsgId:(NSString *)msgID
{
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    NSMutableArray * mArr = [[NSMutableArray alloc] init];
    
    FMResultSet * set = [[GYXMPP sharedInstance].imFMDB executeQuery:@"select * from tb_msg where msg_id = ? and msg_code = ? order by messageTurnID desc limit 20",msgID,@(102)];

    while ([set next]) {
        
        GYChatItem * m = [[GYChatItem alloc] init];
        m.messageId = [set stringForColumn:@"messageId"];
        m.msg_Type = [set intForColumn:@"msg_type"];
        m.msg_Code = [set intForColumn:@"msg_code"];
        m.sub_Msg_Code = [set intForColumn:@"sub_msg_code"];
        m.fromUserId = [set stringForColumn:@"fromUserId"];
        m.toUserId = [set stringForColumn:@"toUserId"];
        m.content = [set stringForColumn:@"msg_content"];
        m.msgNote = [set stringForColumn:@"msg_note"];
        m.msgIcon = [set stringForColumn:@"msg_icon"];
        m.dateTimeSend = [set stringForColumn:@"datetimeSend"];
        m.dateTimeReceive = [set stringForColumn:@"datetimeReceive"];
        m.pictureRUL = [set stringForColumn:@"picture_url"];
        m.pictureName = [set stringForColumn:@"picture_local_fullname"];
        m.msgSendState = [set intForColumn:@"msg_send_state"];
        m.isRead = [set boolForColumn:@"receive_isread"];
        m.resNo = [set stringForColumn:@"res_no"];
    
       
        [arr addObject:m];
        NSLog(@"arr.count == %d",arr.count);
    }
    //逆向排序
    NSEnumerator *enumerator = [arr reverseObjectEnumerator];
    id obj;
    while (obj = [enumerator nextObject]) {
        [mArr addObject:obj];
    }
    return mArr;
}

-(NSString *)changeDateFormat:(NSString *)strDate :(NSInteger)dateType
{
    NSDateFormatter * inputFormatter = [[NSDateFormatter alloc] init];
    inputFormatter.locale = [NSLocale currentLocale];
    NSLog(@"strDate === %@",strDate);
    [inputFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate  *inputDate = [inputFormatter dateFromString :strDate];
    
    
    NSDateFormatter * outputFormatter = [[NSDateFormatter alloc] init];
    
    if (dateType == 1) {
        [outputFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    }
    if (dateType == 2) {
        [outputFormatter setDateFormat: @"HH:mm:ss"];
    }
    
    if (dateType == 3) {
        [outputFormatter setDateFormat: @"yyyy-MM-dd"];
    }
    
    if (dateType == 4) {
        [outputFormatter setDateFormat: @"MM-dd"];
    }
    
    if (dateType == 5) {
        [outputFormatter setDateFormat: @"MM月dd日"];
    }
    
    if (dateType == 6) {
        [outputFormatter setDateFormat: @"M月d日"];
    }
    outputFormatter.locale = [NSLocale currentLocale];
    
    NSString *retDate = [outputFormatter stringFromDate:inputDate];

    return retDate;
}


@end
