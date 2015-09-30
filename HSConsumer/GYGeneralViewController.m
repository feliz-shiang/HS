//
//  GYGeneralViewController.m
//  HSConsumer
//
//  Created by 00 on 14-10-23.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYGeneralViewController.h"
#import "GYGeneralTableViewCell.h"
#import "GlobalData.h"
#import "JGActionSheet.h"
#import "GYInstructionViewController.h"
#import "AboutHS.h"
#import "GYHelpViewController.h"


@interface GYGeneralViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,JGActionSheetDelegate, UIAlertViewDelegate>
{

    __weak IBOutlet UITableView *tbvGeneral;

    NSArray *sourceData;
    GlobalData *data;
    NSString *phoneNumber;
    IBOutlet UIButton *btnLogout;
    NSString *version;
}

@end

@implementation GYGeneralViewController


//登出使用第三方UIActionSheet
- (IBAction)asLogout:(id)sender {
    JGActionSheetSection * ass = [JGActionSheetSection sectionWithTitle:kLocalized(@"confirm_to_log_out") message:@"  " buttonTitles:@[kLocalized(@"confirm")] buttonStyle:JGActionSheetButtonStyleHSDefaultRed];
    NSArray *asss = @[ass, [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[kLocalized(@"cancel")] buttonStyle:JGActionSheetButtonStyleHSDefaultyellow]];
    
    JGActionSheet *as = [[JGActionSheet alloc] initWithSections:asss];
    
    as.delegate = self;
    
    
    [as setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
        
        switch (indexPath.section) {
            case 0:
            {
                NSLog(@"确定");
                [self clearLocalData];// add by sonjk
                MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
                hud.removeFromSuperViewOnHide = YES;
                hud.labelText = @"正在退出...";
                hud.dimBackground = YES;
                [self.view addSubview:hud];
                //    hud.labelText = nil;
                [hud show:YES];
                [Network sharedInstance].httpClientTimeout = 5.0f;
                [Network logoutWithParameters:@{@"userName": data.user.cardNumber, @"mid": data.midKey, @"ecKey": data.ecKey} requetResult:^(NSData *jsonData, NSError *error) {
                    if (!error)
                    {
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                            options:kNilOptions
                                                                              error:&error];
                        if (!error)
                        {
                            if (kSaftToNSInteger(dic[@"retCode"]) == 805)//登出成功
                            {
                                hud.labelText = @"退出成功！";
                            }
                        }
                        
                    }else
                    {
                        DDLogInfo(@"network error：%@", error);
                    }
                    
                    //不管成不成功
                    [data clearLoginInfo];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeMsgCount" object:nil];//清空重新刷新聊天界面信息

                    [hud showAnimated:YES whileExecutingBlock:^{
                        sleep(1.0f);
                    } completionBlock:^{
                        [hud removeFromSuperview];
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                }];
            }
                break;
            case 1:
            {
                NSLog(@"取消");
            }
                break;
            default:
                break;
        }
        [sheet dismissAnimated:YES];
    }];
    
    [as setCenter:CGPointMake(100, 100)];
    
    [as showInView:self.tabBarController.view animated:YES];    
    
}
// add by songjk 登录失败清除数据
-(void)clearLocalData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserPasswordKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserNameKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        data = [GlobalData shareInstance];
        sourceData = [NSArray arrayWithObjects:kLocalized(@"help"),
                      kLocalized(@"about_HS"),
                      kLocalized(@"customer_service_telephone"),
                      kLocalized(@"version_check"),
                      kLocalized(@"hs_company_download"),
                      nil];
        phoneNumber = @"0755-83344111";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (kSystemVersionGreaterThan(@"7.0")) {
        //适配不同版本高度
        tbvGeneral.frame = CGRectMake(0, -15, 320, 400);
    }else{
        tbvGeneral.frame = CGRectMake(0, 10, 320, 400);
    }
    
    version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];

    tbvGeneral.delegate = self;
    tbvGeneral.dataSource = self;
    
    [tbvGeneral registerNib:[UINib nibWithNibName:@"GYGeneralTableViewCell" bundle:nil] forCellReuseIdentifier:@"GENERALCELL"];
    //设置6.0风格
    UIView* bview = [[UIView alloc] init];
    bview.backgroundColor = kDefaultVCBackgroundColor;
    [tbvGeneral setBackgroundView:bview];
    
    [btnLogout setTitle:kLocalized(@"log_out") forState:UIControlStateNormal];
    [btnLogout.titleLabel setFont:kButtonTitleDefaultFont];

    //未登录
    if (![GlobalData shareInstance].isLogined &&
        ![GlobalData shareInstance].isHdLogined &&
        ![GlobalData shareInstance].isEcLogined &&
        btnLogout.superview)
    {
        [btnLogout removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2)
        return 1;
    else
        return 2;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"GENERALCELL";
    GYGeneralTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    cell.lbTitle.text = sourceData[indexPath.section *2 + indexPath.row];
    cell.lbVersions.hidden = YES;
    
    //版本lable 显示
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.lbVersions.text = phoneNumber;//[NSString stringWithFormat:@"假设电话：%@", phoneNumber];
        [cell.lbVersions setTextColor:kCellItemTitleColor];
        cell.lbVersions.hidden = NO;
    }else if (indexPath.section == 1 && indexPath.row == 1)
    {
        cell.lbVersions.text = version;
    }
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        cell.lbVersions.hidden = NO;
        cell.imgRightArrow.hidden = YES;
       
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section*2 + indexPath.row) {
        case 0:
        {
            
            //帮助中心
            GYHelpViewController * vcHelp = [[GYHelpViewController alloc] init];
            vcHelp.navigationItem.title = sourceData[0];
            [self setHidesBottomBarWhenPushed:YES];

            [self.navigationController pushViewController:vcHelp animated:YES];
            NSLog(@"0099");
        }
            break;
        case 1:
        {
            AboutHS *vcInstruction = [[AboutHS alloc] init];
            vcInstruction.navigationItem.title = kLocalized(@"about_HS");
            [self setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:vcInstruction animated:YES];
        }
            break;
        case 2:
        {
            //客服电话
//            JGActionSheetSection * ass0 = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"呼叫号码",@"复制号码"] buttonStyle:JGActionSheetButtonStyleHSDefaultGray];
            JGActionSheetSection * ass0 = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"呼叫号码"] buttonStyle:JGActionSheetButtonStyleHSDefaultGray];
            JGActionSheetSection * ass1 = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"取消"] buttonStyle:JGActionSheetButtonStyleHSDefaultRed];
            NSArray *asss = @[ass0, ass1];
            JGActionSheet *as = [[JGActionSheet alloc] initWithSections:asss];
            as.delegate = self;
            
            [as setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
                
                switch (indexPath.section) {
                    case 0:
                    {
                        if (indexPath.row == 0)
                        {
                            NSLog(@"呼叫号码");
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", phoneNumber]]];
                        }else if (indexPath.row == 1)
                        {
                            NSLog(@"复制号码");
                        }
                    }
                        break;
                    case 1:
                    {
                        NSLog(@"取消");
                    }
                        break;
                        break;

                    default:
                        break;
                }
                
                [sheet dismissAnimated:YES];
            }];
            
            [as setCenter:CGPointMake(100, 100)];
            
            [as showInView:self.tabBarController.view animated:YES];
            
        }
            break;
        case 3:
        {
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
//            if (!kisReleaseEn)
//            {
//                [self updateVer];
//            }
        }
            break;
        case 4:
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否要前往下载？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往下载", nil];
            [alert show];

        }
            break;
       
        default:
            break;
    }
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex)// 取消
    {
        
    }else
    {
        //打开下载链接
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/hu-sheng-qi-ye/id882674478?mt=8&uo=4"]];
    }
}

//#warning 只内部使用，用于更新
- (void)updateVer//更新
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    [self.view addSubview:hud];
    //    hud.labelText = @"初始化数据...";
    [hud show:YES];
    
    [Network HttpGetForRequetURL:@"http://192.168.1.102:9003/update0" parameters:nil requetResult:^(NSData *jsonData, NSError *error) {
        if (!error)
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:kNilOptions
                                                                  error:&error];
            if (!error)
            {
                if ([kSaftToNSString(dic[@"code"]) isEqualToString:kHSRequestSucceedCode] &&
                    dic[@"data"] &&
                    (kSaftToNSInteger(dic[@"data"][@"resultCode"]) == kHSRequestSucceedSubCode))//返回成功数据
                {
                    dic = dic[@"data"];
                    NSString *sVer = kSaftToNSString(dic[@"ver"]);
                    if (![version isEqualToString:sVer])//有更新
                    {
                        [UIAlertView showWithTitle:@"提示" message:@"检测到新版本,请及时更新！" cancelButtonTitle:@"取消" otherButtonTitles:@[@"更新"]tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                            if (buttonIndex != 0)//更新
                            {
                                NSURL *url = [NSURL URLWithString:kSaftToNSString(dic[@"url"])];
                                [[UIApplication sharedApplication] openURL:url];
//#warning 这个是很危险的，只内部使用，用于更新
//                                [self performSelector:@selector(exitApp:) withObject:nil afterDelay:0.5];
                            }
                        }];
                    }else
                    {
                        [Utils showMessgeWithTitle:@"提示" message:@"当前版本已经是最新版." isPopVC:nil];
                    }
                }else//返回失败数据
                {
                    [Utils showMessgeWithTitle:nil message:@"查询服务器版本信息失败，请稍后再试." isPopVC:nil];
                }
            }else
            {
                [Utils showMessgeWithTitle:nil message:@"查询服务器版本信息失败，请稍后再试." isPopVC:nil];
            }
        }else
        {
            [Utils showMessgeWithTitle:@"提示" message:@"连接问题，请稍后再试." isPopVC:nil];
        }
        if (hud.superview)
        {
            [hud removeFromSuperview];
        }
    }];
}

//#warning 这个是很危险的，只内部使用，用于更新
//- (void)exitApp:(id)sender
//{
//#if TARGET_IPHONE_SIMULATOR
//    // 在模拟器的情况下
//    
//#else
//    dispatch_async(dispatch_get_main_queue(), ^{
//        exit(0);
//    });
//    // 在真机情况下
//#endif
//    
//}

@end
