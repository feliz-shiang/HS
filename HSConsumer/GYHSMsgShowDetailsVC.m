//
//  GYHSMsgBindHSCardVC.m
//  HSConsumer
//
//  Created by apple on 14-10-23.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//


#import "GYHSMsgShowDetailsVC.h"
#import "RTLabel.h"
#import "UIButton+enLargedRect.h"
#import "UIAlertView+Blocks.h"

@interface GYHSMsgShowDetailsVC ()<UIWebViewDelegate>
{
    IBOutlet UIWebView *wbBrowser;
    IBOutlet UIView *viewForHSCardBind;
    IBOutlet UILabel *lbTitle;
    IBOutlet UILabel *lbDatetime;
    IBOutlet RTLabel *tlbContent;
    IBOutlet UIButton *btnCommit;
    MBProgressHUD *hud;
    NSDictionary *dicContent;
}

@end

@implementation GYHSMsgShowDetailsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //控制器背景色
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    [viewForHSCardBind setBackgroundColor:self.view.backgroundColor];
    wbBrowser.backgroundColor = self.view.backgroundColor;
    
    dicContent = [Utils stringToDictionary:self.chatItem.content];
    NSString *strSql = [NSString stringWithFormat:@"select msg_content from tb_msg where %@=%d and %@=%d and %@=%d and %@=%@",
                        kMessageType, self.chatItem.msg_Type,
                        kMessageCode, self.chatItem.msg_Code,
                        kMessageSubCode, self.chatItem.sub_Msg_Code,
                        kMessageID, self.chatItem.messageId
                        ];
    FMResultSet * set = [[GYXMPP sharedInstance].imFMDB executeQuery:strSql];
    while ([set next])
    {
        dicContent =  [Utils stringToDictionary:[set stringForColumn:@"msg_content"]];//取数据库最新状态
    }
    
    switch (self.chatItem.sub_Msg_Code)
    {
        case kSub_Msg_Code_Person_HS_Msg:
        {
            viewForHSCardBind.hidden = YES;
            wbBrowser.delegate = self;
            NSString *urlString = kSaftToNSString(dicContent[@"pageUrl"]);
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
            [wbBrowser loadRequest:request];
        }
            break;
        case kSub_Msg_Code_Person_Business_Bind_HSCard_Msg:
        {
            wbBrowser.hidden = YES;
            [lbTitle setTextColor:kCellItemTitleColor];
            [tlbContent setTextColor:kCellItemTitleColor];
            [lbDatetime setTextColor:kCellItemTextColor];
            [Utils setFontSizeToFitWidthWithLabel:lbTitle labelLines:1];

            lbTitle.text = self.chatItem.msgSubject;
            lbDatetime.text = self.chatItem.dateTimeReceive;
            tlbContent.text = kSaftToNSString(dicContent[@"summary"]);
            CGRect rect = tlbContent.frame;
            CGSize size = [tlbContent optimumSize];
            rect.size = size;
            tlbContent.frame = rect;
            
            CGRect btnRect = btnCommit.frame;
            btnRect.origin.y = CGRectGetMaxY(rect) + 30;
            btnCommit.frame = btnRect;
            
            UIColor *btColor = kNavigationBarColor;
            BOOL isCommitSuccess = [kSaftToNSString(dicContent[@"addiscommitflag"]) isEqualToString:@"1"];
            [btnCommit setTitle:@"同 意" forState:UIControlStateNormal];

            if (isCommitSuccess)
            {
                btColor = kCellItemTextColor;
                [btnCommit setTitle:@"已经绑定" forState:UIControlStateNormal];
                [btnCommit setUserInteractionEnabled:NO];
            }else
            {
                [btnCommit addTarget:self action:@selector(btnCommitClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [btnCommit setBorderWithWidth:1.0f andRadius:4.0f andColor:btColor];
            [btnCommit setBackgroundColor:btColor];

        }
            break;
            
        default:
            break;
    }
    
}

- (void)btnCommitClick:(id)sender
{
    [UIAlertView showWithTitle:nil message:@"是否绑定？" cancelButtonTitle:kLocalized(@"cancel") otherButtonTitles:@[kLocalized(@"confirm")] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex != 0)
        {
            NSString *companyType = [kSaftToNSString(dicContent[@"companyType"]) uppercaseString];
            //M 管理公司 S 服务公司 T 托管企业 B 成员企业
            if ([companyType isEqualToString:@"T"] || [companyType isEqualToString:@"B"])
            {
                [self btEnterpriseBindCommit];
            }else
            {
                [self msEnterpriseBindCommit];
            }
        }
    }];
}

#pragma mark - 网络数据交换
- (void)btEnterpriseBindCommit//托管,成员企业用户绑定
{
    GlobalData *data = [GlobalData shareInstance];
    NSDictionary *subP = dicContent[@"interfaceParams"];
    NSDictionary *allParas = @{@"key": data.ecKey,
                               @"mid": data.midKey,
                               @"from": @"hdbiz",
                               @"data.enterpriseResourceNo" : kSaftToNSString(subP[@"resourceNo"]),
                               @"data.accountNo" : kSaftToNSString(subP[@"loginId"]),
                               @"data.userResourceNo" : kSaftToNSString(subP[@"personResNo"]),
                               @"data.resourceType" : kSaftToNSString(dicContent[@"companyType"]),
                               @"data.isBind" : @"1"
                               };
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.dimBackground = YES;
    [self.view addSubview:hud];
    //    hud.labelText = nil;
    [hud show:YES];
    
    NSString *url = [data.hdImPersonInfoDomain stringByAppendingString:@"/userc/confirmBbindResourceNo"];
    [Network HttpPostRequetURL:url parameters:allParas requetResult:^(NSData *jsonData, NSError *error) {
        if (!error)
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:kNilOptions
                                                                  error:&error];
            if (!error)
            {
                NSInteger rCode = kSaftToNSInteger(dic[@"retCode"]);
                if (rCode == 200)//绑定确认成功
                {
                    [self upDateCommitSuccess];
                }else
                {
                    [Utils showMessgeWithTitle:nil message:@"绑定确认失败." isPopVC:nil];
                }
            }else
            {
                [Utils showMessgeWithTitle:nil message:@"绑定确认失败." isPopVC:nil];
            }
            
        }else
        {
            [Utils showMessgeWithTitle:@"提示" message:[error localizedDescription] isPopVC:nil];
        }
        if (hud)
            [hud removeFromSuperview];
    }];
}

#pragma mark - 网络数据交换
- (void)msEnterpriseBindCommit//服务公司，管理公司 用户绑定
{
    GlobalData *data = [GlobalData shareInstance];
    NSDictionary *subP = dicContent[@"interfaceParams"];
    NSDictionary *subParas = @{@"resource_no": kSaftToNSString(subP[@"resourceNo"]),
                               @"person_res_no": kSaftToNSString(subP[@"personResNo"]),
                               @"login_id": kSaftToNSString(subP[@"loginId"]),
                               @"is_agree": @"true"
                               };
    
    NSDictionary *allParas = @{@"system": @"apply",
                               @"cmd": @"bind_person_res_no_sure",
                               @"params": subParas,
                               @"uType": kuType,
                               @"mac": kHSMac,
                               @"mId": data.midKey,
                               @"key": data.hsKey
                               };
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.dimBackground = YES;
    [self.view addSubview:hud];
    //    hud.labelText = nil;
    [hud show:YES];
    
    [Network HttpGetForRequetURL:[data.hsDomain stringByAppendingString:kHSApiAppendUrl] parameters:allParas requetResult:^(NSData *jsonData, NSError *error) {
        if (!error)
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:kNilOptions
                                                                  error:&error];
            if (!error)
            {
                if ([kSaftToNSString(dic[@"code"]) isEqualToString:kHSRequestSucceedCode] &&
                    dic[@"data"] &&
                    ([kSaftToNSString(dic[@"data"][@"respCode"]) isEqualToString:@"0000"]))//返回成功数据
                {
                    [self upDateCommitSuccess];
                }else
                {
                    [Utils showMessgeWithTitle:nil message:@"绑定确认失败." isPopVC:nil];
                }
            }else
            {
                [Utils showMessgeWithTitle:nil message:@"绑定确认失败." isPopVC:nil];
            }
            
        }else
        {
            [Utils showMessgeWithTitle:@"提示" message:[error localizedDescription] isPopVC:nil];
        }
        if (hud)
            [hud removeFromSuperview];
    }];
}

- (void)upDateCommitSuccess
{
    NSMutableDictionary *newDicContent = [dicContent mutableCopy];
    [newDicContent setObject:@"1" forKey:@"addiscommitflag"];
//    NSLog(@"newContent:%@", newDicContent);
    NSString *strSql = [NSString stringWithFormat:@"update tb_msg set msg_content='%@' where %@=%d and %@=%d and %@=%d and %@=%@",
                        [Utils dictionaryToString:[NSDictionary dictionaryWithDictionary:newDicContent]],
                        kMessageType, self.chatItem.msg_Type,
                        kMessageCode, self.chatItem.msg_Code,
                        kMessageSubCode, self.chatItem.sub_Msg_Code,
                        kMessageID, self.chatItem.messageId
                        ];
    if ([[GYXMPP sharedInstance].imFMDB executeUpdate:strSql])
    {
        DDLogInfo(@"update db:%@", strSql);
        
        [btnCommit setTitle:@"已经绑定" forState:UIControlStateNormal];
        [btnCommit setUserInteractionEnabled:NO];
        [btnCommit setBorderWithWidth:1.0f andRadius:4.0f andColor:kCellItemTextColor];
        [btnCommit setBackgroundColor:kCellItemTextColor];
    }
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = [request.URL.absoluteString lowercaseString];//有时是电话或其它的
    if ([urlString hasPrefix:@"http"])
    {
        wbBrowser.delegate = self;
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        hud.removeFromSuperViewOnHide = YES;
        //    hud.dimBackground = YES;
        [self.view addSubview:hud];
        [hud show:YES];
        return YES;
    }
    return NO;
}

//- (void)webViewDidStartLoad:(UIWebView *)webView
//{
//    
//}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (hud)
        [hud removeFromSuperview];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (hud)
        [hud removeFromSuperview];
}

@end
