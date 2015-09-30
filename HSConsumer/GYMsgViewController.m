//
//  GYMsgViewController.m
//  HSConsumer
//
//  Created by 00 on 14-12-27.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYMsgViewController.h"
#import "GYMsgCell.h"
#import "GYChatViewController.h"
#import "UIView+CustomBorder.h"
#import "GYPopView.h"
#import "GYNewFriendViewController.h"
#import "UIImageView+WebCache.h"
#import "Network.h"
#import "GYGoodsMsgVC.h"
#import "GYHSMsgVC.h"

@interface GYMsgViewController ()<UITableViewDataSource,UITableViewDelegate,GYPopViewDelegate>
{
    __weak IBOutlet UITableView *tbv;
    
    __weak IBOutlet UIView *vRecord;//没聊天记录时展示的页面
    
    
    GYPopView * pv;
    
    //假数据－－－－－－－－－－－－－－－－－－－－－－－－－－－
    NSMutableArray *arrData;

    NSUInteger indexDel;

    NSString *friendJID;//用于屏蔽好友信息的好友JID
    NSString *userJID;//用于屏蔽好友信息的自己JID
    __weak IBOutlet UILabel *lbShopPlaceholder;
    
}


@end

@implementation GYMsgViewController

//按钮点击事件－－－－－－－－－－－－－－－－－－－－－－－－－－


-(void)refreshTbv
{
    [self performSelectorOnMainThread:@selector(refresh) withObject:self waitUntilDone:YES];
}

-(void)refresh
{
    if ([GlobalData shareInstance].isEcLogined || [GlobalData shareInstance].isLogined)
    {
        arrData = [self selectFromDBWithKey:self.msgType];
        NSLog(@"%@-------arrdata",arrData);
    }else
    {
        [arrData removeAllObjects];
    }
    
    [tbv reloadData];
    
    if (self.msgType == 1) {
        [self setRemarkNotification];
        [self getRmark];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTbv)
                                                 name:@"ChangeMsgCount"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTbv)
                                                 name:kNotificationNameInitDB
                                               object:nil];
//    arrData = [self selectFromDBWithKey:self.msgType];
    
    
    //设置弹窗－－－－－－－－－－－－－－－－－－－－－－－
    
//    vPopupWindow.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPress.minimumPressDuration = 0.5;
    [tbv addGestureRecognizer:longPress];
    
    tbv.dataSource = self;
    tbv.delegate = self;
//    tbv.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height + 44);
   
    
//     vcGoodsMsg.msgType = 3;
//    if (self.msgType==3) {
//        lbShopPlaceholder.text=@"您还没有消息哦~\n 赶快去加好友聊天吧！";
//    }
    
    switch (self.msgType) {
        case 1:
        {
            if (!arrData.count>0) {
                lbShopPlaceholder.text=@"您还没有消息哦~\n 赶快去加好友聊天吧！";
            }
            
            
        }
            break;
        case 2:
        {
            lbShopPlaceholder.text=@"您还没有消息哦~\n 赶快去逛商铺吧！";
            
        }
            break;
        case 3:
        {
            lbShopPlaceholder.text=@"您还没有消息哦~\n 赶快去收藏您喜欢的商品吧！";
            
        }
            break;
            
        default:
            break;
    }
    
    
    UIView *vfooter = [[UIView alloc] init];
    vfooter.backgroundColor = kClearColor;
    tbv.tableFooterView = vfooter;
    [tbv registerNib:[UINib nibWithNibName:@"GYMsgCell" bundle:nil] forCellReuseIdentifier:@"MSGCELL"];
    
    [self refreshTbv];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
   

}


//长按手势触发事件－－－－－－－－－－－－－－－－－－－－
-(void)longPressToDo:(UILongPressGestureRecognizer *)longPress
{
    if(longPress.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [longPress locationInView:tbv];
        NSIndexPath * indexPath = [tbv indexPathForRowAtPoint:point];
        if(indexPath == nil) return ;
        
        indexDel = indexPath.row;
        
        //设置弹窗tableView
            
        GYChatItem *chatItem = arrData[indexDel];
        if (!chatItem.displayName) {

            chatItem.displayName = @" ";
        }
        NSArray *arrSel = @[chatItem.displayName,@"删除会话"];
        //设置弹窗tableView 放大Frame
//        if (<#condition#>) {
//            <#statements#>
//        }

        CGRect bigFrame = CGRectMake(30, [UIScreen mainScreen].bounds.size.height/2 - 22* arrSel.count, kScreenWidth - 30 *2, 44* arrSel.count);
        //设置弹窗tableView 缩少Frame
        CGRect smallFrame = CGRectMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2, 0, 0);
        //设置弹窗背景颜色
        UIColor *bgColor = kCorlorFromRGBA(0,0,0,0.5);
            
        pv = [[GYPopView alloc] initWithCellType:2 WithArray:arrSel  WithImgArray:nil WithBigFrame:bigFrame WithSmallFrame:smallFrame WithBgColor:bgColor];
        [pv.popView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        pv.indexPath = indexPath;
        pv.delegate = self;
        
        [self.view.window addSubview:pv];
        pv = nil;
    }
    
}

#pragma mark - GYPopViewDelegate
//代理，根据点击的indexPath delete对应的Cell
-(void)deleteDataWithIndex:(NSIndexPath *)indexPath
{
    DDLogInfo(@"删除哈哈哈");
    DDLogInfo(@" 删除 indexPath.row====%zi",indexPath.row);
    
    
        GYChatItem *chatItem = arrData[indexDel];
        NSString *strTableName;
//判断当前视图对应的表格
        if (self.msgType == 1) {
            strTableName = @"tb_list_person";
            [chatItem deleteTableWithName:strTableName WithKey:chatItem.fromUserId andRemoveMessage:YES];
        }else if (self.msgType == 2){
            strTableName = @"tb_list_shops";
            [chatItem deleteTableWithName:strTableName WithKey:chatItem.resNo andRemoveMessage:YES];
        }else{
            strTableName = @"tb_list_goods";
            [chatItem deleteTableWithName:strTableName WithKey:chatItem.msgId andRemoveMessage:YES];
        }
//        [chatItem deleteTableWithName:strTableName WithKey:chatItem.fromUserId];

        [self refresh];
    
    
}

-(void)didSelWithIndexPath:(NSIndexPath *)indexPath
{
    //屏蔽消息
//    GYChatItem *chatItem = arrData[indexPath.row];
//    friendJID = [self cutFriendJID:chatItem];
//    if (friendJID) {
//        [self shieldMsg:chatItem];
//        DDLogInfo(@"屏蔽消息");
//
//    }else{
//        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"消息屏蔽失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [av show];
//    }
}
-(void)getRmark
{
    for (GYChatItem *chatItem in arrData)
    {
        NSString * resNO = @"";
        if (chatItem.fromUserId.length>0)
        {
            NSRange range = [chatItem.fromUserId rangeOfString:@"@"];
            if (range.location != NSNotFound) {
                resNO = [chatItem.fromUserId substringToIndex:range.location];
                resNO = [Utils getResNO:resNO];
            }
        }
        resNO = [GYChatItem getRemarkWithFriendId:resNO myID:[GlobalData shareInstance].IMUser.strAccountNo];
        if (resNO.length>0)
        {
            chatItem.displayName = resNO;
        }
        
    }
}
-(void)setRemarkNotification
{
    for (GYChatItem *chatItem in arrData)
    {
        // add by songjk
        NSString * resNO = @"";
        if (chatItem.fromUserId.length>0)
        {
            NSRange range = [chatItem.fromUserId rangeOfString:@"@"];
            if (range.location != NSNotFound) {
                resNO = [chatItem.fromUserId substringToIndex:range.location];
                resNO = [Utils getResNO:resNO];
            }
        }
        NSString *notificationName = [NSString stringWithFormat:@"setRemark%@%@",resNO,[GlobalData shareInstance].IMUser.strAccountNo];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTitle:) name:notificationName object:nil];
    }
}
-(void)refreshTitle:(NSNotification*)noti
{
    NSString * name = [noti name];
    NSString * strResno = [name substringWithRange:NSMakeRange(9, 11)];
    for (GYChatItem *chatItem in arrData)
    {
        if ([chatItem.fromUserId rangeOfString:strResno].location != NSNotFound) {
            chatItem.displayName = [noti object];
        }
    }
    [tbv reloadData];
}
#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //当数据为0时候，展示界面
    if (arrData.count < 1) {
        vRecord.hidden = NO;
    }else
    {
        vRecord.hidden = YES;
    }
    return arrData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSGCELL"];
    GYChatItem *chatItem = arrData[indexPath.row];
    
    NSString *imgUrlTo = kSaftToNSString(chatItem.msgIcon);
    if (![imgUrlTo hasPrefix:@"http"]) {
        imgUrlTo = [NSString stringWithFormat:@"%@%@", [GlobalData shareInstance].tfsDomain, imgUrlTo];
    }
    if (self.msgType == 1)//处理图标
    {
        //即时消息默认图标
        if ([chatItem.msgType integerValue] == kMsg_Type_Immediate_Chat)
        {
            [cell.img sd_setImageWithURL:[NSURL URLWithString:imgUrlTo] placeholderImage:kLoadPng(@"defaultheadimg")];
            
        }
        //添加好友图标
        if ([chatItem.msgCode integerValue] == kMsg_Code_Command && [chatItem.subMsgCode integerValue] == kSub_Msg_Code_User_User_Add_Request)
        {
            [cell.img sd_setImageWithURL:[NSURL URLWithString:imgUrlTo] placeholderImage:kLoadPng(@"im_img_man")];
        }
        
        //互生消息图标
        if ([chatItem.msgCode integerValue] == kMsg_Code_Person && [chatItem.subMsgCode integerValue] == kSub_Msg_Code_Person_HS_Msg)
        {
            [cell.img sd_setImageWithURL:[NSURL URLWithString:imgUrlTo] placeholderImage:kLoadPng(@"p_hs_msg_push")];
        }
        
        //互生业务消息图标
        if ([chatItem.msgCode integerValue] == kMsg_Code_Person && [chatItem.subMsgCode hasPrefix:[@(kSub_Msg_Code_Person_Business_Msg) stringValue] ])
        {
            [cell.img sd_setImageWithURL:[NSURL URLWithString:imgUrlTo] placeholderImage:kLoadPng(@"p_hs_en_msg_push")];
        }
    }else
    {
        [cell.img sd_setImageWithURL:[NSURL URLWithString:imgUrlTo] placeholderImage:kLoadPng(@"msg_imgph")];
    }
    
    cell.lbTitle.text = chatItem.displayName;
    cell.lbMsg.text = chatItem.lastMsg;
    cell.lbRedPoint.text = [NSString stringWithFormat:@"%zi",chatItem.msgCount];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate  *date = [formatter dateFromString :chatItem.dateTimeSend ];
    cell.lbDate.text = [Utils dateToString:date dateFormat:@"HH:mm"];
    
    if (chatItem.msgCount == 0) {
        cell.lbRedPoint.hidden = YES;
        cell.imgRedPointBg.hidden = YES;
        
    }else{
        cell.lbRedPoint.hidden = NO;
        cell.imgRedPointBg.hidden = NO;
    }
    
    //根据实际数据调整条件
    if (cell.lbRedPoint.text.length > 1 && cell.lbRedPoint.text.length < 3) {
        cell.lbRedPoint.frame = CGRectMake(cell.lbRedPoint.frame.origin.x, cell.lbRedPoint.frame.origin.y, 25, cell.lbRedPoint.frame.size.height);
    }else if (cell.lbRedPoint.text.length >= 3) {
        
        cell.lbRedPoint.text = @"99+";
        cell.lbRedPoint.frame = CGRectMake(cell.lbRedPoint.frame.origin.x, cell.lbRedPoint.frame.origin.y, 33, cell.lbRedPoint.frame.size.height);
    }else{
        cell.lbRedPoint.frame = CGRectMake(cell.lbRedPoint.frame.origin.x, cell.lbRedPoint.frame.origin.y, 21, cell.lbRedPoint.frame.size.height);
    }
    
    cell.imgRedPointBg.frame = cell.lbRedPoint.frame;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GYChatItem *chatItem = arrData[indexPath.row];
    
    [tbv deselectRowAtIndexPath:indexPath animated:YES];
//    [tbv reloadData];
    
//    DDLogInfo(@"chatItem.msg_type == %@",chatItem.msgType);
//    DDLogInfo(@"chatItem.msg_Code == %@",chatItem.msgCode);
    
    UIViewController *_vc = nil;
    if ([chatItem.msgType integerValue] == kMsg_Type_Immediate_Chat ||
        ([chatItem.msgType integerValue] == kMsg_Type_System_Push && [chatItem.msgCode integerValue] == kMsg_Code_Command && [chatItem.subMsgCode integerValue] == kSub_Msg_Code_User_User_Add_Confirm))
    {
        GYChatViewController *vc = [[GYChatViewController alloc] init];
        if ([chatItem.msgType integerValue] == kMsg_Type_System_Push)//如果是同意添加为好友
        {
            chatItem.msgType = [@(kMsg_Type_Immediate_Chat) stringValue];
            chatItem.msgCode = [@(kMsg_Code_Text_Msg) stringValue];
            chatItem.subMsgCode = [@(kSub_Msg_Code_Person_HS_Msg) stringValue];
        }
        
        vc.chatItem = chatItem;
        vc.navigationItem.title = chatItem.displayName;
        vc.title = chatItem.displayName;
        DDLogInfo(@"vc.chatItem.displayName === %@   vc.chatItem.msgNote ==== %@",vc.chatItem.displayName,vc.chatItem.msgNote);
        vc.msgType = self.msgType;
        _vc = vc;
    }else if([chatItem.msgType integerValue] == kMsg_Type_System_Push)
    {
        if ([chatItem.msgCode integerValue] == kMsg_Code_Command && [chatItem.subMsgCode integerValue] == kSub_Msg_Code_User_User_Add_Request) {
            
            GYNewFriendViewController *vc = [[GYNewFriendViewController alloc] init];
            vc.chatItem = chatItem;
            _vc = vc;
            
        }else if([chatItem.msgCode integerValue] == kMsg_Code_Shops){
            
            GYChatViewController *vc = [[GYChatViewController alloc] init];
            vc.navigationItem.title = chatItem.displayName;
            vc.chatItem = chatItem;
            vc.msgType = self.msgType;
            _vc = vc;
            
        }else if([chatItem.msgCode integerValue] == kMsg_Code_Goods){
            
            GYGoodsMsgVC *vc = [[GYGoodsMsgVC alloc] init];
            vc.navigationItem.title = chatItem.displayName;
            vc.chatItem = chatItem;
            vc.msgType = self.msgType;
            _vc = vc;
        }
        
        BOOL isBusiness_Msg = [chatItem.subMsgCode hasPrefix:[@(kSub_Msg_Code_Person_Business_Msg) stringValue]];//业务消息
        if ([chatItem.msgCode integerValue] == kMsg_Code_Person &&
            ([chatItem.subMsgCode integerValue] == kSub_Msg_Code_Person_HS_Msg ||
             isBusiness_Msg
             )
            )
        {
            GYHSMsgVC *vc = kLoadVcFromClassStringName(NSStringFromClass([GYHSMsgVC class]));
            vc.chatItem = chatItem;
            vc.msgType = self.msgType;
            vc.navigationItem.title = chatItem.displayName;
            _vc = vc;

        }
    }
    
    if (_vc)
    {
        UIViewController *topVC = self.nc.topViewController;
        topVC.hidesBottomBarWhenPushed = YES;
        [self.nc pushViewController:_vc animated:YES];
        topVC.hidesBottomBarWhenPushed = NO;
    }
}

//获取本地数据库聊天记录
-(NSMutableArray *)selectFromDBWithKey:(NSInteger)msgType
{
    
    NSMutableArray *arr0 = [NSMutableArray array];//用于排序 互生消息 第一行
    NSMutableArray *arr1 = [NSMutableArray array];//用于排序 互生业务消息 第二行
    
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    NSMutableArray * mArr = [[NSMutableArray alloc] init];
    
    NSString *strMsgType;
    if (msgType == 1) {
        strMsgType = @"tb_list_person";
    }else if (msgType == 2){
        strMsgType = @"tb_list_shops";
    }else{
        strMsgType = @"tb_list_goods";
    }
    FMResultSet * set = [[GYXMPP sharedInstance].imFMDB executeQuery:[NSString stringWithFormat:@"select * from %@ order by datetimeSend asc",strMsgType]];//desc
    
    while ([set next]) {
        GYChatItem * m = [[GYChatItem alloc] init];
        m.fromUserId = [set stringForColumn:@"user_jid"];
        m.msgCode = [set stringForColumn:@"msg_code"];
        m.msgIcon = [set stringForColumn:@"msg_icon"];
        m.lastMsg = [set stringForColumn:@"last_msg"];
        m.msgCount = [set intForColumn:@"unread_msg_cnt"];
        m.dateTimeSend = [set stringForColumn:@"datetimeSend"];
        
        m.msgNote = m.displayName;
//        DDLogInfo(@"m.displayName === %@",m.displayName);
        if (msgType == 1) {
            m.msgType = [set stringForColumn:@"msg_type"];
            m.subMsgCode = [set stringForColumn:@"sub_msg_code"];
            m.displayName = [set stringForColumn:@"displayname"];
            if (m.displayName == nil || m.displayName.length==0)
            {
                m.displayName = [set stringForColumn:kMessageNote];
            }
            m.msgNote = m.displayName;
        }
        
        if (msgType == 2) {
            m.msgType = [set stringForColumn:@"msg_type"];
            m.subMsgCode = [set stringForColumn:@"sub_msg_code"];
            m.fromUserId = [set stringForColumn:@"fromUserId"];
            m.displayName = [set stringForColumn:@"displayname"];
            m.resNo = [set stringForColumn:@"user_jid"];
            m.vshopID = [set stringForColumn:@"shop_id"];
            
            
        }
        if (msgType == 3) {
            m.msgType = [set stringForColumn:@"msg_type"];
            m.itemName = [set stringForColumn:@"item_name"];
            m.selInfo = [set stringForColumn:@"sel_info"];
            m.vshopName = [set stringForColumn:@"vshop_name"];
            m.displayName = m.itemName;
            m.msgCode = [@(kMsg_Code_Goods) stringValue];
            m.msgNote = m.itemName;
            m.resNo = [set stringForColumn:@"res_no"];
            m.msgId = [set stringForColumn:@"user_jid"];
        }
        
        if (msgType == 1 && [m.msgCode integerValue] == kMsg_Code_Person && [m.subMsgCode integerValue] == kSub_Msg_Code_Person_HS_Msg)
        {
            [arr0 addObject:m];
        }else if (msgType == 1 && [m.msgCode integerValue] == kMsg_Code_Person && [m.subMsgCode hasPrefix:[@(kSub_Msg_Code_Person_Business_Msg) stringValue] ])
        {
            [arr1 addObject:m];
        }else
            [arr addObject:m];
    }
    
    if (arr0.count > 0)
    {
        [mArr addObjectsFromArray:arr0];
    }
    
    if (arr1.count > 0)
    {
        [mArr addObjectsFromArray:arr1];
    }

    NSEnumerator *enumerator = [arr reverseObjectEnumerator];
    id obj;
    while (obj = [enumerator nextObject]) {
        [mArr addObject:obj];
    }

    return mArr;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 屏蔽消息

//-(void)shieldMsg:(GYChatItem *)chatItem
//{
//    NSMutableDictionary *dicData = [[NSMutableDictionary alloc] init];
//    [dicData setValue:@"c_06186010007" forKey:@"accountId"];//自己的ID
//    [dicData setValue:friendJID forKey:@"friendId"];//要屏蔽的ID
//    [dicData setValue:@"1" forKey:@"isShield"];
//    
//    NSMutableDictionary *dicURL = [[NSMutableDictionary alloc] init];
//    [dicURL setValue:@"2" forKey:@"channel_type"];
//    [dicURL setValue:@"1.0" forKey:@"version"];
//    [dicURL setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
//    [dicURL setValue:[GlobalData shareInstance].midKey forKey:@"mid"];
//    [dicURL setValue:dicData forKey:@"data"];
//    
//    NSString * s = [NSString stringWithFormat:@"%@/hsim-bservice/shieldFriendMsg?",[GlobalData shareInstance].hdbizDomain];
//    
//    [Network HttpPostForImRequetURL:s parameters:dicURL requetResult:^(NSData *jsonData, NSError *error) {
//        
//        if (error) {
//            //网络请求错误
//            
//        }else{
//            NSDictionary *ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
//            DDLogInfo(@"ResponseDic === %@",ResponseDic);
//            
//            NSString * str =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
//            if ([str isEqualToString:@"200"]) {
//                DDLogInfo(@"屏蔽成功");
//
//                //返回正确数据，并进行解析
//            }else{
//                //返回数据不正确
//            }
//        }
//    }];
//}


//切割好友JID
//-(NSString *)cutFriendJID:(GYChatItem *)chatItem
//{
//    NSString *str = [XMPPJID jidWithString:chatItem.fromUserId].user;
//    NSString *subStr = @"c_";
//    NSRange range = [str rangeOfString:subStr];
//    NSInteger location = range.location;
//    NSString *cutStr;
//    if (location > 0 && location < 10) {
//        DDLogInfo(@"location == %i",location);
//        cutStr= [str substringFromIndex:location];
//    }
//    
//    return cutStr;
//}
//
//
////－－－－－－－－－－－－－－－－保留方法－－－－－－－－－－－－－－－－－－－－－－－－
//
////切割自己JID
//-(NSString *)cutUserJID:(GYChatItem *)chatItem
//{
//    NSString *str = [XMPPJID jidWithString:chatItem.toUserId].user;
//    NSString *subStr = @"c_";
//    NSRange range = [str rangeOfString:subStr];
//    NSInteger location = range.location;
//    NSString *cutStr;
//    
//    if (location > 0 && location < 10) {
//        DDLogInfo(@"location == %i",location);
//        cutStr= [str substringFromIndex:location];
//    }
//    
//    return cutStr;
//}

@end
