//
//  Root.m
//  Chat
//
//  Created by 00 on 15-1-9.
//  Copyright (c) 2015年 00. All rights reserved.
//


#define FaceBoardHeight 165
#define BEGIN_FLAG @"["
#define END_FLAG @"]"

#import "GYChatViewController.h"
#import "GYChatCell.h"
#import "GYChatItem.h"
#import "GYChatTap.h"
#import "GYXMPP.h"
#import "GYChatItem.h"
#import "GYDBCenter.h"
#import "IQKeyboardManager.h"
#import "FMDatabase.h"
#import "GYBuildMsgView.h"
#import "GYLoadImg.h"
#import "UIImageView+WebCache.h"
#import "GYPersonDetailInfoViewController.h"

// add by songjk 多张图片
#import "QBImagePickerController.h"
#import "MJRefresh.h"
#import "UIButton+enLargedRect.h"
#import "GYShopDetailViewController.h"
#import "MWPhotoBrowser.h"
#import "GYStoreDetailViewController.h"
#import "GYFriendManageViewController.h"

#define KFacialSizeWidth  18
#define KFacialSizeHeight 18
#define MAX_WIDTH 162
#define Kitems 5// 一次只加载的数据



@interface GYChatViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,GYLoadImgDelegat,QBImagePickerControllerDelegate, GYChatCellDelegate, MWPhotoBrowserDelegate>{
    
    __weak IBOutlet UITableView *tbv;//tbv
    
    __weak IBOutlet UIScrollView *scvFace;//表情键盘
    BOOL isScvFaceShow;

    
    NSMutableArray* arrData;//消息数组
    NSMutableArray* marrDataView;
    NSMutableArray* arrTime;//时间数组
    
    __weak IBOutlet UIView *vChat;//输入行
//    __weak IBOutlet UITextField *tfChat;//输入框 // modify by songjk
    __weak IBOutlet UIButton *btnSend;//发送按钮
    __weak IBOutlet UIButton *btnMore;//图片按钮
    __weak IBOutlet UIButton *btnFace;//表情按钮
    
    CGRect screen ;//屏幕大小
    
    UIScrollView * scvImg;//图片放大SCV
    NSMutableArray *mArrBtn;
 
    NSMutableArray *arrTemp;
    
//获取table停靠模式下大小
    CGRect frameTbv;
    CGRect frameVChat;
    CGFloat iOS5Height;
    
//xmpp
    NSString *toUserJID;
    GYXMPP *xmp;
    
//重发用消息体
    GYChatItem *reSendChatItem;
    UIView *reSendView;
    NSInteger delIndex;
    BOOL isDelByFriend; //正在聊天，被对方删除了
    GYBuildMsgView *msgView;//生成消息View用对象
    UIImage *showImage;//查看图片
    NSMutableArray *marrUploadImages;
    NSString *lastMessageTime;
}
@property (nonatomic, strong) NSMutableArray *photos;//查看图片

@property (strong, nonatomic) NSMutableArray *arrData1;
// 刷新数据
@property (nonatomic,strong) NSMutableArray * arrRefreshData;
// 是否是刷新
@property (nonatomic,assign)BOOL isHeadRefresh;
@end

@implementation GYChatViewController

//发送消息
- (IBAction)btnSendClick:(id)sender {
    [self sendMsg];return;
    if (isScvFaceShow) {
        [self hideFaceBoard];
        
    }else{
//        [tfChat resignFirstResponder];
        [self.tvChat resignFirstResponder];
    }
    
//    if (tfChat.text.length == 0) {
//        
//    }
    if (self.tvChat.text.length == 0) {
        
    }
    else
    {
        //发送消息
        [self sendMsg];
    }
    
}

//重发消息
-(void)reSendMsg:(UIButton *)btnR
{
    delIndex = btnR.tag - 10000;
    reSendChatItem = arrData[delIndex];
    reSendView = marrDataView[delIndex];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"重发该消息吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重发", nil];
    av.delegate = self;
    [av show];
}

#pragma mark -UIAlertViewDelegate

//modify by zhanglei:2015.09.24 IOS消费者 Android消费者删除好友后，IOS消费者在聊天页面发送消息，消息一直在转
//实现提示之后跳转到消息主页面
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//
//    if (buttonIndex == 0) {
//     
//        [self.navigationController popToRootViewControllerAnimated:YES];
//
//    }
//
//}


-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{

    
    if (buttonIndex == 1) {
     
        if ([reSendChatItem deleteMsgWithID:reSendChatItem.messageId]) {
            DDLogInfo(@"数据库中删除信息成功");
        }
        [arrData removeObjectAtIndex:delIndex];
        [marrDataView removeObjectAtIndex:delIndex];
        
        [arrData addObject:reSendChatItem];
        [marrDataView addObject:reSendView];
   
        [tbv reloadData];
        
        if (!isDelByFriend)
        {
            //构造消息转发器, 设置消息类型
            reSendChatItem.messageId = [GYChatItem createMessageID];
            IMMessageCenter *dbc = [[IMMessageCenter alloc] initWithSendMessage:reSendChatItem];
            //发送
            [dbc sendMessageToUserIsRequest_Receipts:YES];
        }
        //插入一行
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:arrData.count-1 inSection:0];
        
        //滚动到最后一行
        [tbv scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
    }
}


//发送消息方法封装，可用于重发
-(void)sendMsg
{
    if (![GlobalData shareInstance].isHdLogined)
    {
        if (![GlobalData shareInstance].isEcLogined)
        {
            [UIAlertView showWithTitle:@"提示" message:@"请您先登录!" cancelButtonTitle:@"取消" otherButtonTitles:@[@"登录"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex != 0)
                {
                    [[GlobalData shareInstance] showLoginInView:self.navigationController.view withDelegate:nil isStay:NO];
                }
            }];
        }else
        {
            [Utils showMessgeWithTitle:nil message:@"连接消息服务器失败." isPopVC:nil];
        }
        return;
    }
    
//    NSString *content = tfChat.text;
    NSString * str = [self.tvChat.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (str.length < 1)
    {
        [Utils showMessgeWithTitle:@"提示" message:@"不可以发送空消息." isPopVC:nil];
        self.tvChat.text = @"";
        return;
    }

    NSString *content= self.tvChat.text;
    if (content.length > 500)
    {
        [Utils showMessgeWithTitle:@"提示" message:@"发送内容太长." isPopVC:nil];
        return;
    }
    
    NSString *mid = [GYChatItem createMessageID];
    if ([mid doubleValue] - [lastMessageTime doubleValue] < 200)//发信息时间限制为 200ms
    {
        [Utils showMessgeWithTitle:@"提示" message:@"您发送消息太快，歇一会..." isPopVC:nil];
        return;
    }
    lastMessageTime = mid;
    
    //创建消息体
    GYChatItem* chatItem = [[GYChatItem alloc] init];
//    chatItem.content = tfChat.text;
    chatItem.content = self.tvChat.text;
    chatItem.toUserId = toUserJID;
    chatItem.fromUserId = [xmp.xmppStream.myJID bare];
    chatItem.msg_Type = kMsg_Type_Immediate_Chat;
    chatItem.msg_Code = kMsg_Code_Text_Msg;
    chatItem.msgSendState = kMessagSentState_Sending;
    chatItem.isSelf = YES;
    chatItem.isPic = NO;
    chatItem.msgNote = [GlobalData shareInstance].IMUser.strNickName;
    chatItem.msgIcon = [GlobalData shareInstance].IMUser.strHeadPic;
    chatItem.msgtype = self.msgType;
    
    if (self.chatItem.resNo.length > 10) {
        chatItem.resNo = self.chatItem.resNo;
    }else{
        chatItem.resNo = @"0000";
    }
    
    if (self.msgType == 1) {
        
        if (self.model) {
            chatItem.friendId = self.model.strFriendID;
            chatItem.friendName = self.model.strFriendName;
            chatItem.friendIcon = self.model.strFriendIconURL;
            
        }else{
//            chatItem.friendId = chatItem.toUserId;
            chatItem.friendName = self.chatItem.displayName;
            chatItem.friendIcon = self.chatItem.msgIcon;
        }
        
        chatItem.msgId = @"";
        chatItem.resNo = @"";
        chatItem.sub_Msg_Code = 0;
        
    }
    
    if (self.msgType == 2) {
        NSString *str = self.chatItem.fromUserId;
        NSString *subStr = self.chatItem.resNo;
        NSRange range = [str rangeOfString:subStr];
        NSInteger location = range.location;
        
        if (location > 0 && location < 10) {
        
        }else{
            chatItem.toUserId = [NSString stringWithFormat:@"%@@im.gy.com",self.chatItem.resNo];
            chatItem.resNo = self.chatItem.resNo;
        }
    }
    
    
    //添加消息到数组中
    [arrData addObject:chatItem];
    self.arrData1 = arrData;
    
    UIView *view = [msgView assembleMessageAtIndex:chatItem.content];
    [marrDataView addObject:view];
    
    if (!isDelByFriend)//没有
    {
        //构造消息转发器, 设置消息类型
        chatItem.messageId = mid;
        IMMessageCenter *dbc = [[IMMessageCenter alloc] initWithSendMessage:chatItem];
        //发送
        [dbc sendMessageToUserIsRequest_Receipts:NO];
    }

    self.tvChat.text = @"";
    
    //插入一行
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:arrData.count-1 inSection:0];
    
    [tbv insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    //滚动到最后一行
    [tbv scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

//发送图片
- (IBAction)btnPicClick:(id)sender {
    if (isScvFaceShow) {
        [self hideFaceBoard];
        isScvFaceShow = NO;
    }
   // [tfChat resignFirstResponder];
    //图片选择器
    // modify by songjk
    
//    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
//    imagePickerController.delegate = self;
//    imagePickerController.allowsMultipleSelection = YES;
//    imagePickerController.maximumNumberOfSelection = 6;
//    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:imagePickerController animated:YES];
//    UIImagePickerController* ipc = [[UIImagePickerController alloc] init];
//    //图片来源 相册 相机
//    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    ipc.delegate = self;
//    [self presentViewController:ipc animated:YES completion:nil];
    
      [self  addButtonImg];
}



-(void)addButtonImg
{
    if (![GlobalData shareInstance].isHdLogined)
    {
        //        [UIAlertView showWithTitle:@"提示" message:@"请先登录!" cancelButtonTitle:@"取消" otherButtonTitles:@[@"登录"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        //            if (buttonIndex != 0)
        //            {
        //                [[GlobalData shareInstance] showLoginInView:self.navigationController.view withDelegate:self isStay:YES];
        //            }
        //        }];
        if (![GlobalData shareInstance].isEcLogined)
        {
            [UIAlertView showWithTitle:@"提示" message:@"请您先登录!" cancelButtonTitle:@"取消" otherButtonTitles:@[@"登录"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex != 0)
                {
                    [[GlobalData shareInstance] showLoginInView:self.navigationController.view withDelegate:self isStay:YES];
                }
            }];
        }else
        {
            [Utils showMessgeWithTitle:nil message:@"连接消息服务器失败." isPopVC:nil];
        }
        return;
    }
    
    UIActionSheet *HeaderIconSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:kLocalized(@"cancel") destructiveButtonTitle:nil otherButtonTitles:kLocalized(@"take_photos"),kLocalized(@"my_ablum"), nil];
    HeaderIconSheet.destructiveButtonIndex=2;
    
    [HeaderIconSheet showInView:self.tabBarController.view.window];
    
}

#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex

{
    if (buttonIndex == 0) {
        
        [self photocamera];
    }
    
    else if(buttonIndex == 1){
        
        NSLog(@"zxcvb");
        [self photoalbumr];
        
    }else if (buttonIndex==2){
        
        NSLog(@"wsxcde");
        
    }
    
}

//进入相册

-(void)photoalbumr{
    
    
    
    if ([UIImagePickerController isSourceTypeAvailable:
         
         
         
         UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        
        
        UIImagePickerController *picker =
        
        
        
        [[UIImagePickerController alloc] init];
        
        
        
        picker.delegate = self;
        
        
        
//        picker.allowsEditing = YES;
        
        
        
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        
        
        [self presentViewController:picker animated:YES completion:nil];
        
        
        
    }
    
    
    
    else {
        
        
        
        UIAlertView *alert = [[UIAlertView alloc]
                              
                              
                              
                              initWithTitle:@"Error accessing photo library"
                              
                              
                              
                              message:@"Device does not support a photo library"
                              
                              
                              
                              delegate:nil
                              
                              
                              
                              cancelButtonTitle:@"Drat!"
                              
                              
                              
                              otherButtonTitles:nil];
        
        
        
        [alert show];
        
        
        
    }
    
    
    
    
    
}



//进入拍照

-(void)photocamera{
    
    
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        
        
        UIImagePickerController* imagepicker = [[UIImagePickerController alloc] init];
        
        
        
        imagepicker.delegate = self;
        
        //        imagepicker.showsCameraControls=YES;
        
        imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        
        
        imagepicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        
        
//        imagepicker.allowsEditing = NO;
        
        
        
        [self presentViewController:imagepicker animated:YES completion:nil];
        
        
        
    }
    
    
    
    else {
        
        
        
        UIAlertView *alert = [[UIAlertView alloc]
                              
                              
                              
                              initWithTitle:@"Sorry"
                              
                              
                              
                              message:@"设备不支持拍照功能"
                              
                              
                              
                              delegate:nil
                              
                              
                              
                              cancelButtonTitle:@"确定"
                              
                              
                              
                              otherButtonTitles:nil];
        
        
        
        [alert show];
        
        
        
    }
    
    
    
    
    
}



//此方法用于模态 消除actionsheet

- (void)actionSheetCancel:(UIActionSheet *)actionSheet

{
    
    [actionSheet dismissWithClickedButtonIndex:2 animated:YES];
    
}



//表情按钮
- (IBAction)btnFaceClick:(id)sender {
    if (isScvFaceShow) {
        [self hideFaceBoard];
    }else{
        [self showFaceBoard];
    }
}

-(void)showFaceBoard
{
//    [tfChat resignFirstResponder];
    [self.tvChat resignFirstResponder];
    //键盘size
    CGSize size = CGSizeMake(scvFace.frame.size.width, scvFace.frame.size.height);
    //键盘出现动画
    [UIView animateWithDuration:0.25 animations:^{
        tbv.frame = CGRectMake(0, 0, screen.size.width, screen.size.height - size.height - 44 -64);
        vChat.frame = CGRectMake(0, screen.size.height - size.height - 44 -64, screen.size.width, 44);
        
        scvFace.frame = CGRectMake(0, screen.size.height - size.height -64, screen.size.width, size.height);
    }];
    isScvFaceShow = YES;
    
}


-(void)hideFaceBoard
{
    //键盘消失动画
    [UIView animateWithDuration:0.25 animations:^{
        
        tbv.frame = CGRectMake(0, 0, screen.size.width, screen.size.height - 44 - 64);
        vChat.frame = CGRectMake(0, screen.size.height - 44 -64, screen.size.width, 44);
        scvFace.frame = CGRectMake(0, screen.size.height -64, screen.size.width, FaceBoardHeight);
        
    }];
    isScvFaceShow = NO;

}

//表情键盘，键位不布局
-(void)setFaceButton
{
    NSInteger index;
    NSInteger addIndex;
    addIndex = 0;
    index = 1;
    for (NSInteger i = 0; i < 3; i++) {
        for (NSInteger j = 0; j < 3; j++) {
            for (NSInteger z = 0; z < 7; z++) {
                UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
                b.frame = CGRectMake(25 + i*screen.size.width + z * 40, 25+ j * 40, 30, 30);
                if (index %21 == 0) {
                    addIndex ++;
                    [b setImage:[UIImage imageNamed:[NSString stringWithFormat:@"del.png"]] forState:UIControlStateNormal];
                }else{
                    [b setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%03d.png",index - addIndex]] forState:UIControlStateNormal];
                }
                b.tag = 1000 + index ++;
                [scvFace addSubview:b];
                [b addTarget:self action:@selector(bFaceClick:) forControlEvents:UIControlEventTouchUpInside];
                [mArrBtn addObject:b];
            }
            }
        }
}


//表情键盘点击逻辑
-(void)bFaceClick:(UIButton *)btn
{
    // modify by songjk
    //删除键
    if (btn.tag == 1021 ||btn.tag == 1042 || btn.tag == 1063) {
        NSMutableString *mStr = [[NSMutableString alloc]initWithString:self.tvChat.text];
        if (mStr.length > 0) {
            self.tvChat.text = [mStr substringToIndex:([mStr length]-1)];
        }else{
            
        }
    }else{
        //表情键
        // modify by songjk
        int iIndex = 0;
        if (btn.tag<1021)
        {
            iIndex = btn.tag-1000;
        }
        else if (btn.tag>1021 && btn.tag<1042)
        {
            iIndex = btn.tag-1000 - 1;
        }
        else if (btn.tag>1042 && btn.tag<1063)
        {
            iIndex = btn.tag-1000 - 2;
        }
        NSString *str = [NSString stringWithFormat:@"[%03d]",iIndex];
        self.tvChat.text = [NSString stringWithFormat:@"%@%@",self.tvChat.text,str];
    }
    
//        NSMutableString *mStr = [[NSMutableString alloc]initWithString:tfChat.text];
//        if (mStr.length > 0) {
//            tfChat.text = [mStr substringToIndex:([mStr length]-1)];
//        }else{
//        
//        }
//    }else{
//        //表情键
//        NSString *str = [NSString stringWithFormat:@"[%03d]",btn.tag-1000];
//        tfChat.text = [NSString stringWithFormat:@"%@%@",tfChat.text,str];
//    }
}


-(void)viewWillAppear:(BOOL)animated
{
    //设置表情键盘
    scvFace.frame = CGRectMake(0, screen.size.height, screen.size.width, FaceBoardHeight);
    scvFace.pagingEnabled = YES;
    
    isScvFaceShow = NO;
    scvFace.contentSize = CGSizeMake(screen.size.width * 3, scvFace.frame.size.height);
    [IQKeyboardManager sharedManager].enable = NO;

//    [self addObservers];
    
    DDLogInfo(@"self.model.strFriendID ==== %@",self.model.strFriendID);

    if (!self.chatItem.fromUserId) {
        self.chatItem.fromUserId = self.model.strFriendID;
    }
    [tbv reloadData];
   
    
    if (self.msgType ==1)
    {
        NSString * resNO = @"";
        if (self.chatItem.fromUserId.length>0)
        {
            NSRange range = [self.chatItem.fromUserId rangeOfString:@"@"];
            if (range.location != NSNotFound) {
                resNO = [self.chatItem.fromUserId substringToIndex:range.location];
                resNO = [Utils getResNO:resNO];
            }
        }
        resNO = [GYChatItem getRemarkWithFriendId:resNO myID:[GlobalData shareInstance].IMUser.strAccountNo];
        if (resNO.length>0)
        {
            self.title = resNO;
        }
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [[GlobalData shareInstance] getTimeDifference:YES];//获取时间差
    lastMessageTime = [GYChatItem createMessageID];
    self.tvChat.layer.cornerRadius = 4;

    msgView = [[GYBuildMsgView alloc] init];
    
//xmpp 相关
     xmp = [GYXMPP sharedInstance];
    //添加初始化的通知

    
//－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
    
    CGFloat version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    
    if (version < 7.0f) {
        
        iOS5Height = 20;
    }else{
        iOS5Height = 0;
    }
//获取屏幕大小
    screen = CGRectMake([UIScreen mainScreen].bounds.origin.x, [UIScreen mainScreen].bounds.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - iOS5Height);
    
    frameTbv = tbv.frame;
    frameVChat = vChat.frame;
 
//表情键盘
    
    mArrBtn = [[NSMutableArray alloc] init];
  
//初始化消息数组
    arrData = [[NSMutableArray alloc] init];
    
//初始化View消息数组
    marrDataView = [[NSMutableArray alloc] init];
    for (GYChatItem *chatItem in arrData) {
        UIView *view = [msgView assembleMessageAtIndex:chatItem.content];
        [marrDataView addObject:view];
    }
    
//初始化时间数组
    arrTime = [[NSMutableArray alloc] init];
    
//设置tableView
    tbv.delegate = self;
    tbv.dataSource = self;
    tbv.frame = CGRectMake(0, 0, 320, screen.size.height - 44 - 40 - 20);
    [tbv registerNib:[UINib nibWithNibName:@"GYChatCell" bundle:nil] forCellReuseIdentifier:@"CELL"];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupRefresh];
    });
    
    [self setFaceButton];
    
    if (self.model) {
        toUserJID = [NSString stringWithFormat:@"m_%@",[[self reGetJID:self.model.strFriendID] bare]];
        self.msgType = 1;
        
    }else
    {
        toUserJID = [[self reGetJID:self.chatItem.fromUserId] bare];
    }
  
//    [self refreshMessageFromDB];
    
    if ([toUserJID hasPrefix:@"m_c_"] || [toUserJID hasPrefix:@"m_nc_"])//只有消费者才显示
    {
        UIBarButtonItem *rb = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ms_check_friend_info"] style:UIBarButtonItemStylePlain target:self action:@selector(checkInfo)];
        
        self.navigationItem.rightBarButtonItem = rb;
    }else
    if (self.msgType == 2)
    {
        if (self.chatItem.vshopID.length > 0)
        {
            UIBarButtonItem *rb = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ms_check_shop_info"] style:UIBarButtonItemStylePlain target:self action:@selector(checkInfo)];
            self.navigationItem.rightBarButtonItem = rb;

        }else
            self.navigationItem.rightBarButtonItem = nil;
    }
    
    [self addObservers];

    // add by songjk
//    if (![QBImagePickerController isAccessible]) {
//        NSLog(@"Error: Source is not accessible.");
//    }
    
    
//    CGRect hfFrame = tbv.bounds;
//    hfFrame.size.height = 30;
//    UIView *vFooter = [[UIView alloc] initWithFrame:hfFrame];
//    [vFooter setBackgroundColor:self.view.backgroundColor];
//    tbv.tableFooterView = vFooter;

}
/**
 *  集成刷新控件 by songjk
 */
-(NSMutableArray *)arrRefreshData
{
    if (_arrRefreshData == nil)
    {
        _arrRefreshData = [NSMutableArray array];
    }
    return _arrRefreshData;
}
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [tbv addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    
    [tbv.header beginRefreshing];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    self.isHeadRefresh = YES;
    
    if (self.msgType == 1) {
        self.arrRefreshData = [self selectFromPersonWithKey:toUserJID];
    }
    if (self.msgType == 2) {
        DDLogInfo(@"chatItem.resNo === %@",self.chatItem.resNo);
        self.arrRefreshData = [self selectFromShopWithResNo:self.chatItem.resNo];
    }
    if (self.msgType == 3) {
        DDLogInfo(@"chatItem.resNo === %@",self.chatItem.resNo);
        self.arrRefreshData = [self selectFromGoodsWithResNo:self.chatItem.resNo];
    }
    
    for (NSInteger i = self.arrRefreshData.count-1 ;i>=0; i--) {
        GYChatItem * msgObj = self.arrRefreshData[i];
        UIView *view = [msgView assembleMessageAtIndex:msgObj.content];
        [marrDataView insertObject:view atIndex:0];
        [arrData insertObject:msgObj atIndex:0];
    }
    [tbv reloadData];
//    if (arrData.count > 0)
//    {
//        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:arrData.count-1 inSection:0];
//        [tbv scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//    }
    [tbv.header endRefreshing];
}

#pragma mark 多选图片方法
//- (void)dismissImagePickerController
//{
//    if (self.presentedViewController) {
//        [self dismissViewControllerAnimated:YES completion:NULL];
//    } else {
//        [self.navigationController popToViewController:self animated:YES];
//    }
//}

// add by songjk
//#pragma mark - QBImagePickerControllerDelegate
//- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
//{
//    NSLog(@"*** imagePickerController:didSelectAssets:");
//    NSLog(@"%@", assets);
//    
//    [self dismissImagePickerController];
//    for (int i = 0; i<assets.count; i++) {
//        ALAsset * set = assets[i];
//        UIImage * image = [UIImage imageWithCGImage:[set thumbnail]];
//        [self saveImage:image withName:@"imgChat.png"];
//    }
//    tbv.frame = CGRectMake(0, 0, 320, screen.size.height - 64 - 44);
//}

//- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
//{
//    NSLog(@"*** imagePickerControllerDidCancel:");
//    
//    [self dismissImagePickerController];
//}

-(void)checkInfo
{
    if (self.msgType == 2)
    {
        // mdify by songjk 点击头像跳转
        if (self.isFromShopDetails)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            GYStoreDetailViewController * vc = [[GYStoreDetailViewController alloc] init];
            ShopModel  * model = [[ShopModel alloc] init];
            model.strVshopId = self.chatItem.vshopID;
            vc.shopModel = model;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else
    {
        if (!self.model && self.chatItem)
        {
            NSString *_accountID = [toUserJID substringToIndex:[toUserJID rangeOfString:@"@"].location];
            _accountID = [_accountID substringFromIndex:[_accountID rangeOfString:@"m_"].location + 2];
            GYNewFiendModel *m =[[GYNewFiendModel alloc]init];
            m.strAccountID = _accountID;
            m.strFriendID = _accountID;
            m.strFriendName = self.chatItem.displayName;
            GYPersonDetailInfoViewController * vcPersonInfo =[[GYPersonDetailInfoViewController alloc]initWithNibName:@"GYPersonDetailInfoViewController" bundle:nil];
            vcPersonInfo.model=m;
            vcPersonInfo.useType=kPersonInfoFromChat;
            [self setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:vcPersonInfo animated:YES];
        }
        else
        {
            GYPersonDetailInfoViewController * vcPersonInfo =[[GYPersonDetailInfoViewController alloc]initWithNibName:@"GYPersonDetailInfoViewController" bundle:nil];
            vcPersonInfo.model=self.model;
            vcPersonInfo.useType=kPersonInfoFromChat;
            [self setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:vcPersonInfo animated:YES];
        }
    }
}

//从数据库获取聊天记录
-(void)refreshMessageFromDB
{
    [arrData removeAllObjects];
    [marrDataView removeAllObjects];
    
    if (self.msgType == 1) {
        arrData = [self selectFromPersonWithKey:toUserJID];
    }
    if (self.msgType == 2) {
        DDLogInfo(@"chatItem.resNo === %@",self.chatItem.resNo);
        arrData = [self selectFromShopWithResNo:self.chatItem.resNo];
    }
    if (self.msgType == 3) {
        DDLogInfo(@"chatItem.resNo === %@",self.chatItem.resNo);
        arrData = [self selectFromGoodsWithResNo:self.chatItem.resNo];
    }
    
    
    if (arrData.count > 0) {
        for (GYChatItem * chatItem in arrData) {
            
            if (self.msgType == 1) {
                
                if ([chatItem.toUserId isEqualToString:toUserJID]) {
                    chatItem.isSelf = YES;
                }else{
                    chatItem.isSelf = NO;
                }
                
                if (chatItem.pictureRUL.length > 5) {
                    chatItem.isPic = YES;
                }else{
                    chatItem.isPic = NO;
                }
            }
            
            if (self.msgType == 2) {
                
                
            }
            
            
            UIView *view = [msgView assembleMessageAtIndex:chatItem.content];
            [marrDataView addObject:view];
        }

        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:arrData.count-1 inSection:0];
        //滚动到最后一行
        [tbv scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
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

//db查找
-(NSMutableArray *)selectFromPersonWithKey:(NSString *)UserId
{
    [self updateIsReadWithKey:UserId];
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    NSMutableArray * mArr = [[NSMutableArray alloc] init];
    
    // modify by songjk
    FMResultSet * set = [[GYXMPP sharedInstance].imFMDB executeQuery:@"select * from tb_msg where (fromUserId = ? or toUserId = ?) order by messageTurnID desc limit ?,?",UserId,UserId,[NSNumber numberWithInteger:arrData.count],[NSNumber numberWithInt:Kitems]];
    
       while ([set next])
       {
        
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
           
           if ([m.toUserId isEqualToString:toUserJID])
           {
               m.isSelf = YES;
           }else
           {
               m.isSelf = NO;
               if (arrData.count > 0)//头像同步
               {
                   GYChatItem *it = arrData[arrData.count - 1];
                   m.msgIcon = it.msgIcon;
               }else
               {
                   if (arr.count > 0)
                   {
                       GYChatItem *it = arr[0];
                       if (!it.isSelf)
                       {
                           m.msgIcon = it.msgIcon;
                       }
                   }
               }
           }
           
           if (m.pictureRUL.length > 5) {
               m.isPic = YES;
           }else{
               m.isPic = NO;
           }
           
           
           
           if (m.resNo.length > 10) {
               //如果资源号存在，就不加入到聊天记录中
           }else{
            [arr addObject:m];
           }
       }
    //逆向排序
    NSEnumerator *enumerator = [arr reverseObjectEnumerator];
    id obj;
    while (obj = [enumerator nextObject]) {
        [mArr addObject:obj];
    }
    return mArr;
}


-(NSMutableArray *)selectFromShopWithResNo:(NSString *)resNo
{
    
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    NSMutableArray * mArr = [[NSMutableArray alloc] init];
    BOOL isFirstContact = YES;//企业第一次聊天

    // modify by songjk
    FMResultSet * set = [[GYXMPP sharedInstance].imFMDB executeQuery:@"select * from tb_msg where res_no = ? and msg_code != 102 order by messageTurnID desc limit ?,?",resNo,[NSNumber numberWithInteger:arrData.count],[NSNumber numberWithInt:Kitems]];

    while ([set next])
    {
        isFirstContact = NO;//有记录
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
        
        NSString *str = m.toUserId;
        NSString *subStr = m.resNo;
        NSRange range = [str rangeOfString:subStr];
        NSInteger location = range.location;
        
        if (location >= 0 && location < 10) {
            m.isSelf = YES;
        }else{
            m.isSelf = NO;
        }

        if (m.pictureRUL.length > 5) {
            m.isPic = YES;
        }else{
            m.isPic = NO;
        }
        
        [arr addObject:m];
    }
    //逆向排序
    NSEnumerator *enumerator = [arr reverseObjectEnumerator];
    id obj;
    while (obj = [enumerator nextObject]) {
        [mArr addObject:obj];
    }
    
    if (isFirstContact &&
        arrData.count < 1 &&
        self.dicShopInfo &&
        [self.dicShopInfo isKindOfClass:[NSDictionary class]])//企业第一次连接，添加欢迎消息
    {
        NSString *mid = [GYChatItem createMessageID];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[mid doubleValue] / 1000];
        GYChatItem *mObj = [[GYChatItem alloc] init];
        mObj.resNo = resNo;
        mObj.msg_Type = kMsg_Type_Immediate_Chat;
        mObj.msg_Code = kMsg_Code_Text_Msg;
        mObj.sub_Msg_Code = kSub_Msg_Code_Person_HS_Msg;
        mObj.dateTimeSend = [Utils dateToString:date];
        mObj.dateTimeReceive = [Utils dateToString:date];
        
        NSMutableString *contentStr = [NSMutableString stringWithFormat:@"%@\n", self.dicShopInfo[@"vShopName"]];
        [contentStr appendFormat:@"互生号：%@\n", resNo];
//        [contentStr appendFormat:@"地址：%@\n", self.dicShopInfo[@"addr"]];
//        [contentStr appendFormat:@"电话：%@\n", self.dicShopInfo[@"tel"]];
        [contentStr appendString:@"欢迎咨询"];
        
        mObj.content = contentStr;
        mObj.fromUserId = resNo;
        mObj.toUserId = [xmp.xmppStream.myJID bare];
        mObj.messageId = mid;
        mObj.pictureRUL = @"";
        mObj.pictureName = @"";
        mObj.msgSendState = kMessagSentState_Sending;
        mObj.isRead = YES;
        mObj.msgNote = resNo;
        mObj.msgIcon = self.chatItem.msgIcon;
        mObj.friendName = mObj.msgNote;
        mObj.friendIcon = mObj.msgIcon;
        mObj.isSelf = NO;
        
        if([mObj saveMessageToDB])
        {
            [mArr addObject:mObj];
        }
    }
    
    return mArr;
}

-(NSMutableArray *)selectFromGoodsWithResNo:(NSString *)resNo
{
    
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    NSMutableArray * mArr = [[NSMutableArray alloc] init];
    
    
#warning 暂时取完所有的消息，暂时不分页
    // modify by songjk
//    FMResultSet * set = [[GYXMPP sharedInstance].imFMDB executeQuery:@"select * from tb_msg where res_no = ? and msg_code = 102 order by messageTurnID desc limit ?,?",resNo,[NSNumber numberWithInteger:count],[NSNumber numberWithInt:Kitems]];

    FMResultSet * set = [[GYXMPP sharedInstance].imFMDB executeQuery:@"select * from tb_msg where res_no = ? and msg_code = 102 order by datetimeSend desc",resNo];
    while ([set next])
    {
        
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
        
        NSString *str = m.toUserId;
        NSString *subStr = m.resNo;
        NSRange range = [str rangeOfString:subStr];
        NSInteger location = range.location;
        
        if (location >= 0 && location < 10) {
            m.isSelf = YES;
        }else{
            m.isSelf = NO;
        }
        
        if (m.pictureRUL.length > 5) {
            m.isPic = YES;
        }else{
            m.isPic = NO;
        }
        
        [arr addObject:m];
    }
    //逆向排序
    NSEnumerator *enumerator = [arr reverseObjectEnumerator];
    id obj;
    while (obj = [enumerator nextObject]) {
        [mArr addObject:obj];
    }
    return mArr;
}


//更新已经读状态
-(void)updateIsReadWithKey:(NSString *)UserId
{
    if (![[GYXMPP sharedInstance].imFMDB executeUpdate:@"update tb_msg set receive_isread = 1 where fromUserId = ?",UserId])
    {
        DDLogInfo(@"update db error");
    }
//    if (![[GYXMPP sharedInstance].imFMDB executeUpdate:@"update tb_msg set receive_isread = 1 where datetimeSend in (select datetimeSend from tb_msg where (fromUserId = ? or toUserId = ?) and res_no ='' order by messageTurnID desc limit ?,?)",UserId,UserId,[NSNumber numberWithInteger:count],[NSNumber numberWithInt:Kitems]])
//    {
//        DDLogInfo(@"update db error");
//    }
   
}

//xmpp 消息通知中心
- (void)addObservers
{
    //通知中心 监听键盘
    //监听object发来的名字叫做name的消息，监听到后调用observer的selector方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSendMessageState:) name:kNotificationNameSendResult object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshMessage:)
                                                 name:[kNotificationNameFromJIDPrefix stringByAppendingString:toUserJID]
                                               object:nil];
    
    if (self.chatItem.resNo.length > 10) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshMessage:)
                                                     name:[kNotificationNameFromJIDPrefix stringByAppendingString:self.chatItem.resNo]
                                                   object:nil];
    }
    
    // add by songjk
    NSString * resNO = @"";
    if (self.chatItem.fromUserId.length>0)
    {
        NSRange range = [self.chatItem.fromUserId rangeOfString:@"@"];
        if (range.location != NSNotFound) {
            resNO = [self.chatItem.fromUserId substringToIndex:range.location];
            resNO = [Utils getResNO:resNO];
        }
    }
    NSString *notificationName = [NSString stringWithFormat:@"setRemark%@%@",resNO,[GlobalData shareInstance].IMUser.strAccountNo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTitle:) name:notificationName object:nil];
    
    
    DDLogInfo(@"%@",[kNotificationNameFromJIDPrefix stringByAppendingString:toUserJID]);
    
}
-(void)refreshTitle:(NSNotification*)noti
{
    NSString *title = [noti object];
    self.title = title;
}

-(void)refreshSendMessageState:(NSNotification*)noti{
    
    DDLogInfo(@"状态改变");
    NSString *nameString = [noti name];
    NSDictionary *dic = [noti object];
    DDLogInfo(@"name = %@,object = %@",nameString,dic);
    
    for (NSInteger i = arrData.count - 1; i >= 0; i--)
    {
        GYChatItem *chatItem = arrData[i];
        if ([chatItem.messageId isEqualToString:dic[@"msgID"]])
        {
            chatItem.msgSendState = [dic[@"State"] integerValue];
            chatItem.messageId = dic[@"msgID"];
            [tbv reloadData];
            break;
        }
    }
}


//接收到通知 刷新收到的信息
- (void)refreshMessage:(NSNotification*)noti
{
    NSString *nameString = [noti name];
    GYChatItem *msgObj = [noti object];
    
    if (msgObj.sub_Msg_Code == kSub_Msg_Code_User_User_Del_Friend)
    {
        isDelByFriend = YES;
    }
    if (isDelByFriend)
    {
        
        //modify by zhanglei:2015.09.24 IOS消费者 Android消费者删除好友后，IOS消费者在聊天页面发送消息，消息一直在转
        //好友被删之后，增加提示。
        //好友删除之后，去掉提示，只跳转页面 2015.09.28 by 张雷
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            

      
        });

        return;
    }
    
    if (![self.navigationItem.title isEqual:msgObj.msgNote])//昵称改变
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationItem setTitle:msgObj.msgNote];
        });
    }
    //    [msgObj updateIsReadToZeroWithKey:toUserJID];
    if (self.msgType == 1) {
        [msgObj updateIsReadToZeroWithKey:toUserJID WithMsgType:1];
    }
    if (self.msgType == 2) {
        DDLogInfo(@"有接收信息");
        [msgObj updateIsReadToZeroWithKey:self.chatItem.resNo WithMsgType:2];
    }
    if (self.msgType == 3) {
        DDLogInfo(@"有接收信息");
        [msgObj updateIsReadToZeroWithKey:self.chatItem.resNo WithMsgType:3];
    }
        
    
    msgObj.isSelf = NO;
    
    if (msgObj.pictureRUL.length > 5) {
        msgObj.isPic = YES;
    }else{
        msgObj.isPic = NO;
    }
    
    NSDictionary *dictionary = [noti userInfo];
    DDLogInfo(@"name = %@,object = %@,userInfo = %@",nameString,msgObj.content,[dictionary objectForKey:@"key"]);

    if (arrData.count > 0)//同步最新的头像
    {
        GYChatItem *firstItem = arrData[0];
        DDLogInfo(@"firstItem.head:%@", firstItem.msgIcon);
        if (![firstItem.msgIcon isEqualToString:msgObj.msgIcon])
        {
            NSString *updateHeaderPicSql = [NSString stringWithFormat:@"update tb_msg set %@='%@' where %@='%@'",kMessageIcon,msgObj.msgIcon,kMessageFrom,msgObj.fromUserId];
            DDLogInfo(@"更新好友数据库头像:%@", updateHeaderPicSql);
            if ([[GYXMPP sharedInstance].imFMDB executeUpdate:updateHeaderPicSql])
            {
                for (GYChatItem *item in arrData)
                {
                    item.msgIcon = msgObj.msgIcon;
                }
            }
        }
    }
    
//获取消息
    dispatch_async(dispatch_get_main_queue(), ^{
       
        DDLogInfo(@"URL****%@",msgObj.pictureRUL);
        
        [arrData addObject:msgObj];
        UIView *view = [msgView assembleMessageAtIndex:msgObj.content];
        [marrDataView addObject:view];
        
        [tbv reloadData];
        //插入一行
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:arrData.count-1 inSection:0];
        //滚动到最后一行
        [tbv scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    });
}

- (void)dealloc
{
    DDLogInfo(@"dealloc");
    //离开页面，移除所有的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    for (GYLoadImg *uploadImg in marrUploadImages) {
        uploadImg.delegate = nil;
    }
    [marrUploadImages removeAllObjects];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    GYChatItem * m1 = [[GYChatItem alloc] init];
    if (self.msgType == 1) {
        [m1 updateIsReadToZeroWithKey:toUserJID WithMsgType:1];
    }
    if (self.msgType == 2) {
        [m1 updateIsReadToZeroWithKey:self.chatItem.resNo WithMsgType:2];
    }
}

-(void)viewWillUnload
{
    [super viewWillUnload];
    DDLogInfo(@"super viewWillUnload");
    GYChatItem * m1 = [[GYChatItem alloc] init];
    if (self.msgType == 1) {
        [m1 updateIsReadToZeroWithKey:toUserJID WithMsgType:1];
    }
    if (self.msgType == 2) {
        [m1 updateIsReadToZeroWithKey:self.chatItem.resNo WithMsgType:2];
    }
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    [tbv reloadData];
//}

//键盘出现
- (void)keyboardWillShow:(NSNotification*)noti{
    if (isScvFaceShow) {
        [self hideFaceBoard];
        isScvFaceShow = NO;
    }
    //键盘size
    CGSize size = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
//键盘出现动画
    [UIView animateWithDuration:0.25 animations:^{
        tbv.frame = CGRectMake(0, 0, screen.size.width, screen.size.height - size.height - 44 -64);
        vChat.frame = CGRectMake(0, tbv.frame.size.height , screen.size.width, 44);
    }];
    
}

- (void)keyboardDidShow:(NSNotification*)noti
{
    if (arrData.count < 1) return;
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:arrData.count-1 inSection:0];
    //滚动到最后一行
    [tbv scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    [tbv reloadData];
}


//键盘消失
- (void)keyboardWillHide:(NSNotification*)noti{
//键盘消息动画
    [UIView animateWithDuration:0.25 animations:^{
        tbv.frame = CGRectMake(0, 0, screen.size.width, screen.size.height - 44 - 64);
        vChat.frame = CGRectMake(0, screen.size.height - 44 -64, screen.size.width, 44);
    }];
}

//键盘消失
- (void)keyboardDidHide:(NSNotification*)noti
{
    if (arrData.count < 1) return;
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:arrData.count-1 inSection:0];
    //滚动到最后一行
    [tbv scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    [tbv reloadData];
}

#pragma mark -UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//创建消息体，获取消息类型
    GYChatItem* chatItem = [arrData objectAtIndex:indexPath.row];
    NSLog(@"%zi",indexPath.row);
//图片信息，返回固定高度
    if (chatItem.isPic) {
        return 100 +32 +20;
    }else{
        UIView *view = marrDataView[indexPath.row];
        return view.frame.size.height +32 +3;
    }
}

//返回消息数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrData.count;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GYChatCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    cell.btnR.tag = indexPath.row +10000;
    
//创建数据体、判断消息类型，设置不同UI界面
    GYChatItem* chatItem = arrData[indexPath.row];
    cell.isSelf = chatItem.isSelf;
    cell.isPic = chatItem.isPic;
    if (!cell.isPic)
        [cell.btnR addTarget:self action:@selector(reSendMsg:) forControlEvents:UIControlEventTouchUpInside];

    cell.lbTime.text = chatItem.dateTimeSend;
    cell.indexPath = indexPath;
    cell.chatItem = chatItem;
    
    cell.arrData = arrData;
    
    [cell.imgPicBubbleL removeGestureRecognizer:cell.tap];
    [cell.imgPicBubbleR removeGestureRecognizer:cell.tap];
    
    GYChatTap *tap = [[GYChatTap alloc] initWithTarget:self action:@selector(tapCilck:)];
    tap.selIndex = indexPath.row;
    
    cell.tap = tap;
    
    
    if (cell.vRight !=nil ) {
        [cell.vRight removeFromSuperview];
        cell.vRight = nil;
    }
    if (cell.vLeft !=nil ) {
        [cell.vLeft removeFromSuperview];
        cell.vLeft = nil;
    }
    
    if (chatItem.isSelf) {
        cell.vRight = marrDataView[indexPath.row];
        [cell.imgPicBubbleR addGestureRecognizer:cell.tap];
    }else{
        cell.vLeft = marrDataView[indexPath.row];
        [cell.imgPicBubbleL addGestureRecognizer:cell.tap];
    }
    NSLog(@"%@：%@", (chatItem.isSelf?@"自己":@"对方"), chatItem.content);

    [cell setHiddenCell];
    cell.userInteractionEnabled = YES;
    cell.chatDelegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // DDLogInfo(@"%@",indexPath);
    // modify by songjk
//    [tfChat resignFirstResponder];
    [self.tvChat resignFirstResponder];
    
    if (isScvFaceShow) {
        [self hideFaceBoard];
    }
}


#pragma mark - UIImagePickerControllerDelegate
 //modify by songjk
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //取得图片
    [picker dismissViewControllerAnimated:YES completion:^{

    }];
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self saveImage:image withName:@"imgChat.png"];
    tbv.frame = CGRectMake(0, 0, 320, screen.size.height - 64 - 44);
}

 //modify by songjk
//点击取消按钮调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//保存图片至沙盒
#pragma mark - save
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
    
    
    GYChatItem* chatItem = [[GYChatItem alloc] init];
    chatItem.isSelf = YES;
    chatItem.isPic = YES;
    chatItem.content = @"[图片]";
    chatItem.img = currentImage;
    chatItem.pictureRUL = @"图片";//－－－－－－－－－－－－－－－－－－
    chatItem.toUserId = toUserJID;
    chatItem.fromUserId = [xmp.xmppStream.myJID bare];
    chatItem.msg_Type = kMsg_Type_Immediate_Chat;
    chatItem.msg_Code = kMsg_Code_Picture_Msg;
    chatItem.msgSendState = kMessagSentState_Sending;
    chatItem.msgtype = self.msgType;
   
    chatItem.msgNote = [GlobalData shareInstance].IMUser.strNickName;
    chatItem.msgIcon = [GlobalData shareInstance].IMUser.strHeadPic;
    if (self.chatItem.resNo.length > 10) {
        chatItem.resNo = self.chatItem.resNo;
    }else{
        chatItem.resNo = @"0000";
    }
    
    if (self.msgType == 1) {
        if (self.model) {
            chatItem.friendId = self.model.strFriendID;
            chatItem.friendName = self.model.strFriendName;
            chatItem.friendIcon = self.model.strFriendIconURL;
            
        }else{
            //            chatItem.friendId = chatItem.toUserId;
            chatItem.friendName = self.chatItem.displayName;
            chatItem.friendIcon = self.chatItem.msgIcon;
        }
    
    
    }
    if (self.msgType == 2) {
        NSString *str = self.chatItem.fromUserId;
        NSString *subStr = self.chatItem.resNo;
        NSRange range = [str rangeOfString:subStr];
        NSInteger location = range.location;
        
        if (location > 0 && location < 10) {
            
        }else{
            chatItem.toUserId = [NSString stringWithFormat:@"%@@im.gy.com",self.chatItem.resNo];
            chatItem.resNo = self.chatItem.resNo;
        }
        
    }
    
    [arrData addObject:chatItem];
    UIView *view = [msgView assembleMessageAtIndex:chatItem.content];
    [marrDataView addObject:view];
    
    //插入一行
    [tbv reloadData];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:arrData.count-1 inSection:0];
    //滚动到最后一行
    [tbv scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    
    GYLoadImg *uploadImg = [[GYLoadImg alloc] init];
    [uploadImg uploadImg:currentImage WithIndexPath:indexPath];
    uploadImg.delegate = self;
    if (!marrUploadImages)
    {
        marrUploadImages = [NSMutableArray array];
    }
    [marrUploadImages addObject:uploadImg];
}

#pragma mark - GYLoadImgDelegate
//获取上传后的图片URL 发送图片消息体
-(void)didFinishUploadImg:(NSURL *)url WithIndexPath:(NSIndexPath *)indexPath
{
    DDLogInfo(@"url========%@",url);
    GYChatItem* chatItem = arrData[indexPath.row];
    chatItem.pictureRUL = [NSString stringWithFormat:@"%@",url];
    //构造消息转发器, 设置消息类型
    chatItem.messageId = [GYChatItem createMessageID];
    IMMessageCenter *dbc = [[IMMessageCenter alloc] initWithSendMessage:chatItem];
    
    DDLogInfo(@"%@",chatItem);
    
    //发送
    [dbc sendMessageToUserIsRequest_Receipts:NO];
}

- (void)didFailUploadImg:(NSError *)error WithIndexPath:(NSIndexPath *)indexPath
{
    GYChatItem* chatItem = arrData[indexPath.row];
    chatItem.msgSendState = kMessagSentState_Send_Failed;
    [tbv reloadData];
}

//图片点击手势
-(void)tapCilck:(GYChatTap *)tap
{
#if 0
    
//    [tfChat resignFirstResponder];
    [self.tvChat resignFirstResponder];
    if (isScvFaceShow) {
        [self hideFaceBoard];
    }
    
    GYChatItem * chatItem = arrData[tap.selIndex];
    UIImageView *imgView1 = [[UIImageView alloc] init];
    
    [imgView1 sd_setImageWithURL:[NSURL URLWithString:chatItem.pictureRUL] placeholderImage:[UIImage imageNamed:@"msg_imgph@2x.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       //设置下载图片逻辑
        
    }];
    
    UIImage *image = imgView1.image;
    showImage = image;
    CGSize size = CGSizeZero;
    
    CGFloat rect;
    rect = image.size.width/image.size.height;
    size.width = screen.size.width;
    size.height = screen.size.width/rect;
   
    scvImg = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screen.size.width, screen.size.height)];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, screen.size.height/2 - size.height/2 - 44, size.width, size.height)];
    imgView.image = image;
    UITapGestureRecognizer *tapScv = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideScv)];
    scvImg.backgroundColor = [UIColor blackColor];
    [scvImg addSubview:imgView];
    [scvImg addGestureRecognizer:tapScv];
//    if(image)
//    {
//        UIButton *btnSaveImg = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btnSaveImg setFrame:CGRectMake(scvImg.frame.size.width - 60, 10, 50, 34)];
//        [btnSaveImg setTitle:@"保存" forState:UIControlStateNormal];
//        [btnSaveImg setBorderWithWidth:1.0 andRadius:2.0 andColor:[UIColor blueColor]];
//        [btnSaveImg setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//        [btnSaveImg addTarget:self action:@selector(saveImageToPhotos:) forControlEvents:UIControlEventTouchUpInside];
//        [scvImg addSubview:btnSaveImg];
//    }
    [self.view addSubview:scvImg];
#endif
    
    [self.tvChat resignFirstResponder];
    if (isScvFaceShow) {
        [self hideFaceBoard];
    }
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated: YES];

    GYChatItem * chatItem = arrData[tap.selIndex];
    
    if (chatItem.isSelf && chatItem.msgSendState == kMessagSentState_Send_Failed)//发送失败的图片不查看
    {
        return;
    }
    
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    BOOL displayActionButton = NO;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = NO;

//    photo = [MWPhoto photoWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"photo2" ofType:@"jpg"]]];
    [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:chatItem.pictureRUL]]];

//    photo.caption = @"The London Eye is a giant Ferris wheel situated on the banks of the River Thames, in London, England.";
//    [photos addObject:photo];
    // Options
    enableGrid = NO;
    self.photos = photos;
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.customRigthButton = YES;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    browser.wantsFullScreenLayout = YES;
#endif
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = YES;
    [browser setCurrentPhotoIndex:0];
    
    // Reset selections
//    if (displaySelectionButtons) {
//        _selections = [NSMutableArray new];
//        for (int i = 0; i < photos.count; i++) {
//            [_selections addObject:[NSNumber numberWithBool:NO]];
//        }
//    }
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:browser animated:YES];
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    if(error)
    {
        [Utils showMessgeWithTitle:nil message:@"图片保存失败." isPopVC:nil];
    }else
    {
        [Utils showMessgeWithTitle:nil message:@"图片已存入手机相册." isPopVC:nil];
    }
}


-(void)hideScv
{
    [scvImg removeFromSuperview];
}

#pragma mark - GYChatCellDelegate
- (void)deleteMessage:(id)sender
{
    GYChatCell *cell = sender;
    GYChatItem * chatItem = cell.chatItem;
    if ([chatItem deleteMsgWithID:chatItem.messageId])
    {
        [arrData removeObject:chatItem];
        [marrDataView removeObjectAtIndex:cell.indexPath.row];
        [tbv beginUpdates];
        [tbv deleteRowsAtIndexPaths:[NSArray arrayWithObject:cell.indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tbv endUpdates];
        dispatch_async(dispatch_get_main_queue(), ^{
            [tbv reloadData];
        });
    }
}
-(void)ChatCellShowFriendInfo:(GYChatCell *)ChatCell
{
    [self checkInfo];
}
- (void)saveImageToPhotos:(id)sender
{
    GYChatCell *cell = sender;
    GYChatItem * chatItem = cell.chatItem;
    UIImageView *imgView1 = [[UIImageView alloc] init];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    [self.view addSubview:hud];
    //    hud.labelText = @"初始化数据...";
    [hud show:YES];

    [imgView1 sd_setImageWithURL:[NSURL URLWithString:chatItem.pictureRUL] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image)
        {
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        }
        if (hud.superview)
        {
            [hud removeFromSuperview];
        }
    }];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

//- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
//    if (index < _thumbs.count)
//        return [_thumbs objectAtIndex:index];
//    return nil;
//}

//- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
//    MWPhoto *photo = [self.photos objectAtIndex:index];
//    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
//    return [captionView autorelease];
//}

//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
//    NSLog(@"ACTION!");
//}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

//- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
//    return [[_selections objectAtIndex:index] boolValue];
//}

//- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
//    return [NSString stringWithFormat:@"Photo %lu", (unsigned long)index+1];
//}

//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
//    [_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
//    NSLog(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
//}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated: YES];
}

@end
