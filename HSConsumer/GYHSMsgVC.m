//
//  GYConcernsCollectShopsViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-23.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#define kMessagePageSize 20 //每页查询记录条数

#import "GYHSMsgVC.h"
#import "CellHSMsgCell.h"
#import "UIView+CustomBorder.h"
#import "GYHSMsgShowDetailsVC.h"

@interface GYHSMsgVC ()<UITableViewDataSource, UITableViewDelegate>
{
    MBProgressHUD *hud;
}
@end

@implementation GYHSMsgVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];

    //兼容IOS6设置背景色
    self.tableView.backgroundView = [[UIView alloc]init];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CellHSMsgCell class]) bundle:kDefaultBundle]
          forCellReuseIdentifier:kCellHSMsgCellIdentifier];

    if (kSystemVersionGreaterThanOrEqualTo(@"7.0"))
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    CGRect hfFrame = self.tableView.bounds;
    hfFrame.size.height = 30;
    UIView *vFooter = [[UIView alloc] initWithFrame:hfFrame];
    [vFooter setBackgroundColor:self.view.backgroundColor];
    self.tableView.tableFooterView = vFooter;
    
    //系统推送 业务消息通知
    NSString *no = [NSString stringWithFormat:@"%@_%@_%@_%@",
                    kNotificationNameForSystemPushPersonMsg,
                    self.chatItem.msgType,
                    self.chatItem.msgCode,
                    [@(kSub_Msg_Code_Person_Business_Msg) stringValue]
//                    self.chatItem.subMsgCode
                    ];
    DDLogInfo(@"create notificationCenter:%@", no);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateIsReadToZero:) name:no object:nil];
    
    hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    hud.removeFromSuperViewOnHide = YES;
    //    hud.dimBackground = YES;
    [self.navigationController.view addSubview:hud];
    [hud show:YES];
    [self updateIsReadToZero:nil];
}

- (void)updateIsReadToZero:(NSNotification *)noti
{
    DDLogInfo(@"收到通知:%@", noti);
    self.arrResult = [NSMutableArray array];
    [self loadRecords];
    NSString *strSql = [NSString stringWithFormat:@"update tb_list_person set unread_msg_cnt = 0 where %@=%d and %@=%@ and %@=%@",
                        kMessageType, kMsg_Type_System_Push,
                        kMessageCode, self.chatItem.msgCode,
                        kMessageSubCode, self.chatItem.subMsgCode
                        ];
    if ([[GYXMPP sharedInstance].imFMDB executeUpdate:strSql])
    {
        DDLogInfo(@"update db:%@", strSql);
        NSString *notificationName = @"ChangeMsgCount";
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrResult count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    CellHSMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellHSMsgCellIdentifier];
    if (!cell)
    {
        cell = [[CellHSMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellHSMsgCellIdentifier];
    }
    cell.nav = self.navigationController;//传nav
    cell.nav.navigationItem.title = self.navigationItem.title;//传title
    
    GYChatItem *m = self.arrResult[row];
    cell.chatItem = m;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:m.dateTimeReceive];
//    cell.lbDatetime.text = [Utils dateToString:destDate dateFormat:@"yyyy-MM-dd HH:mm"];
    
    cell.lbDatetime.text = m.dateTimeReceive;
    NSString *title = m.msgSubject;
    NSString *content = @"";
    if (m.sub_Msg_Code == kSub_Msg_Code_Person_Business_Bind_HSCard_Msg)
    {
        NSDictionary *dicContent = [Utils stringToDictionary:m.content];
        content = kSaftToNSString(dicContent[@"summary"]);
    }else if (m.sub_Msg_Code == kSub_Msg_Code_Person_HS_Msg)
    {
        content = @"";
        [cell.lbTitle moveX:0 moveY:10];
    }else
    {
        content = m.content;
    }
    cell.lbTitle.text = title;
    cell.lbContent.text = content;
//    cell.lbDatetime.hidden = [@(indexPath.row % 2) boolValue];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYChatItem *m = self.arrResult[indexPath.row];
    return [CellHSMsgCell getHeightIsShowDatetime:m.isRead];

//    return [CellHSMsgCell getHeightIsShowDatetime:![@(indexPath.row % 2) boolValue]];
//    return [CellHSMsgCell getHeightIsShowDatetime:YES];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    CellHSMsgCell *cell = (CellHSMsgCell *)[tableView cellForRowAtIndexPath:indexPath];
//    [cell.viewContentBkg sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)loadRecords
{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{

        [self updateIsReadWithKey];
        NSMutableArray * arr = [[NSMutableArray alloc] init];
    
//     到这里
    
#warning 暂时取完所有的消息，暂时不分页
    
//    select * from tb_msg where msg_type=1 and msg_code=101 and sub_msg_code LIKE '10102%' order by datetimeReceive desc
    
//    NSString *strSql = [NSString stringWithFormat:@"select * from tb_msg where %@=%d and %@=%@ and %@=%@ order by datetimeReceive desc",
//                        kMessageType, kMsg_Type_System_Push,
//                        kMessageCode, self.chatItem.msgCode,
//                        kMessageSubCode, self.chatItem.subMsgCode
//                        ];
    EMSub_Msg_Code dSub_Msg_Code = kSub_Msg_Code_Person_Business_Msg;
    if ([self.chatItem.subMsgCode isEqualToString:[@(kSub_Msg_Code_Person_HS_Msg) stringValue]])
    {
        dSub_Msg_Code = kSub_Msg_Code_Person_HS_Msg;
    }
    NSString *strSql = [NSString stringWithFormat:@"select * from tb_msg where %@=%d and %@=%@ and %@ LIKE '%@' order by datetimeReceive desc",
                        kMessageType, kMsg_Type_System_Push,
                        kMessageCode, self.chatItem.msgCode,
                        kMessageSubCode, [NSString stringWithFormat:@"%d%%", dSub_Msg_Code]//   self.chatItem.subMsgCode
                        ];
        //分页取
//        NSString *strSql = [NSString stringWithFormat:@"select * from tb_msg where %@=%d and %@=%@ and %@=%@ order by messageTurnID desc Limit %d Offset %d",
//                            kMessageType, kMsg_Type_System_Push,
//                            kMessageCode, self.chatItem.msgCode,
//                            kMessageSubCode, self.chatItem.subMsgCode,
//                            kMessagePageSize,
//                            self.arrResult.count
//                            ];
        DDLogInfo(@"loadRecords:%@", strSql);
        
        FMResultSet * set = [[GYXMPP sharedInstance].imFMDB executeQuery:strSql];
        while ([set next])
        {
            GYChatItem * m = [[GYChatItem alloc] init];
            m.messageId = [set stringForColumn:@"messageId"];
            m.msg_Type = [set intForColumn:@"msg_type"];
            m.msg_Code = [set intForColumn:@"msg_code"];
            m.sub_Msg_Code = [set intForColumn:@"sub_msg_code"];
            m.fromUserId = [set stringForColumn:@"fromUserId"];
            m.toUserId = [set stringForColumn:@"toUserId"];
            m.msgSubject = [set stringForColumn:kMsgSubject];
            m.content = [set stringForColumn:@"msg_content"];
            m.msgId = [set stringForColumn:@"msg_id"];
            m.msgNote = [set stringForColumn:@"msg_note"];
            m.msgIcon = [set stringForColumn:@"msg_icon"];
            m.dateTimeSend = [set stringForColumn:@"datetimeSend"];
            m.dateTimeReceive = [set stringForColumn:@"datetimeReceive"];
            m.pictureRUL = [set stringForColumn:@"picture_url"];
            m.pictureName = [set stringForColumn:@"picture_local_fullname"];
            m.msgSendState = [set intForColumn:@"msg_send_state"];
//            m.isRead = [set boolForColumn:@"receive_isread"];
            m.resNo = [set stringForColumn:@"res_no"];
            m.isSelf = NO;
            
            //以下使用 isRead用来归类时间，yes为显示
            if (arr.count > 0)
            {
                GYChatItem* beforeChatItem = arr[arr.count -1];
                NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
                
                NSDate  *date1 = [formatter dateFromString :beforeChatItem.dateTimeReceive ];
                NSDate  *date2 = [formatter dateFromString :m.dateTimeReceive ];
                if (date1 && date2)
                {
                    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                    NSDateComponents *comps = [gregorian components:NSCalendarUnitMinute fromDate:date2  toDate:date1  options:NSCalendarWrapComponents];
                    NSInteger minute = [comps minute];
                    
                    if (minute < 60 * 5)//5个小时归类
                    {
                        m.isRead = NO;
                    }else
                    {
                        m.isRead = YES;
                    }
                }else
                {
                    m.isRead = YES;
                }

            }else
            {
                m.isRead = YES;// isRead暂时用来显示时间，yes为显示
            }
            
            [arr addObject:m];
            
        }
        [self.arrResult addObjectsFromArray:arr];
    //    [self.arrResult addObjectsFromArray:[[arr reverseObjectEnumerator] allObjects]];
        
        if (hud) {
            [hud removeFromSuperview];
        }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        if (self.arrResult.count > 0)
        {
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        
    });
//    });
}

-(void)updateIsReadWithKey
{
    NSString *strSql = [NSString stringWithFormat:@"update tb_msg set receive_isread = %d where %@=%d and %@=%@ and %@=%@",
                       YES,
                       kMessageType, kMsg_Type_System_Push,
                       kMessageCode, self.chatItem.msgCode,
                       kMessageSubCode, self.chatItem.subMsgCode
                       ];
    if ([[GYXMPP sharedInstance].imFMDB executeUpdate:strSql])
    {
        DDLogInfo(@"update db:%@", strSql);
    }
}

#pragma mark - pushVC
- (void)pushVC:(id)vc animated:(BOOL)ani
{
    if (vc)
    {
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:ani];
    }
}

@end
