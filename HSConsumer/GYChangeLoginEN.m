//
//  GYChangeLoginEN.m
//  HSConsumer
//
//  Created by liangzm on 15-3-25.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYChangeLoginEN.h"
#import "GYEasyPurchaseMainViewController.h"

@interface GYChangeLoginEN ()
{
    NSDictionary *dicResutl;
    NSMutableArray *arr;

    LoginEn *ln;
    GlobalData *data;
    EMLoginEn lineTurns;
    NSString *version;

}
@end

@implementation GYChangeLoginEN

- (void)viewDidLoad
{
    [super viewDidLoad];
    version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    ln = [LoginEn sharedInstance];
    data = [GlobalData shareInstance];
    //设置顺序
    lineTurns = [LoginEn getInitLoginLine];
    
    switch (lineTurns)
    {
        case kLoginEn_dev_with_default_user_pwd:
            arr = [@[
                    @[@"开发环境(带默认用户和密码)", @(kLoginEn_dev_with_default_user_pwd)],
                    @[@"开发环境(空用户和密码)", @(kLoginEn_dev_no_default_user_pwd)],
                    @[@"测试环境(空用户和密码)", @(kLoginEn_test_no_default_user_pwd)],
                    @[@"测试环境(带默认用户和密码)", @(kLoginEn_test_with_default_user_pwd)],
                    @[@"演示环境(空用户和密码)", @(kLoginEn_demo_no_default_user_pwd)],
                    @[@"演示环境(带默认用户和密码)", @(kLoginEn_demo_with_default_user_pwd)],
                    @[@"预生产环境(空用户和密码)", @(kLoginEn_pre_release)],

                    ] mutableCopy];
            break;

        case kLoginEn_dev_no_default_user_pwd:
            arr = [@[
                    @[@"开发环境(空用户和密码)", @(kLoginEn_dev_no_default_user_pwd)],
                    @[@"开发环境(带默认用户和密码)", @(kLoginEn_dev_with_default_user_pwd)],
                    @[@"测试环境(空用户和密码)", @(kLoginEn_test_no_default_user_pwd)],
                    @[@"测试环境(带默认用户和密码)", @(kLoginEn_test_with_default_user_pwd)],
                    @[@"演示环境(空用户和密码)", @(kLoginEn_demo_no_default_user_pwd)],
                    @[@"演示环境(带默认用户和密码)", @(kLoginEn_demo_with_default_user_pwd)],
                    @[@"预生产环境(空用户和密码)", @(kLoginEn_pre_release)],

                    ] mutableCopy];
            break;
        case kLoginEn_test_with_default_user_pwd:
            arr = [@[
                    @[@"测试环境(带默认用户和密码)", @(kLoginEn_test_with_default_user_pwd)],
                    @[@"测试环境(空用户和密码)", @(kLoginEn_test_no_default_user_pwd)],
                    @[@"开发环境(空用户和密码)", @(kLoginEn_dev_no_default_user_pwd)],
                    @[@"开发环境(带默认用户和密码)", @(kLoginEn_dev_with_default_user_pwd)],
                    @[@"演示环境(空用户和密码)", @(kLoginEn_demo_no_default_user_pwd)],
                    @[@"演示环境(带默认用户和密码)", @(kLoginEn_demo_with_default_user_pwd)],
                    @[@"预生产环境(空用户和密码)", @(kLoginEn_pre_release)],

                    ] mutableCopy];
            break;
        case kLoginEn_test_no_default_user_pwd:
            arr = [@[
                    @[@"测试环境(空用户和密码)", @(kLoginEn_test_no_default_user_pwd)],
                    @[@"测试环境(带默认用户和密码)", @(kLoginEn_test_with_default_user_pwd)],
                    @[@"开发环境(空用户和密码)", @(kLoginEn_dev_no_default_user_pwd)],
                    @[@"开发环境(带默认用户和密码)", @(kLoginEn_dev_with_default_user_pwd)],
                    @[@"演示环境(空用户和密码)", @(kLoginEn_demo_no_default_user_pwd)],
                    @[@"演示环境(带默认用户和密码)", @(kLoginEn_demo_with_default_user_pwd)],
                    @[@"预生产环境(空用户和密码)", @(kLoginEn_pre_release)],

                    ] mutableCopy];
            break;
        case kLoginEn_demo_no_default_user_pwd:
            arr = [@[
                     @[@"演示环境(空用户和密码)", @(kLoginEn_demo_no_default_user_pwd)],
                     @[@"演示环境(带默认用户和密码)", @(kLoginEn_demo_with_default_user_pwd)],
                     @[@"测试环境(空用户和密码)", @(kLoginEn_test_no_default_user_pwd)],
                     @[@"测试环境(带默认用户和密码)", @(kLoginEn_test_with_default_user_pwd)],
                     @[@"开发环境(空用户和密码)", @(kLoginEn_dev_no_default_user_pwd)],
                     @[@"开发环境(带默认用户和密码)", @(kLoginEn_dev_with_default_user_pwd)],
                     @[@"预生产环境(空用户和密码)", @(kLoginEn_pre_release)],

                     ] mutableCopy];
            break;
        case kLoginEn_demo_with_default_user_pwd:
            arr = [@[
                     @[@"演示环境(带默认用户和密码)", @(kLoginEn_demo_with_default_user_pwd)],
                     @[@"演示环境(空用户和密码)", @(kLoginEn_demo_no_default_user_pwd)],
                     @[@"测试环境(空用户和密码)", @(kLoginEn_test_no_default_user_pwd)],
                     @[@"测试环境(带默认用户和密码)", @(kLoginEn_test_with_default_user_pwd)],
                     @[@"开发环境(空用户和密码)", @(kLoginEn_dev_no_default_user_pwd)],
                     @[@"开发环境(带默认用户和密码)", @(kLoginEn_dev_with_default_user_pwd)],
                     @[@"预生产环境(空用户和密码)", @(kLoginEn_pre_release)],

                     ] mutableCopy];
            break;

        default:
            break;
    }
    
    NSString *strCheckUpdate = [NSString stringWithFormat:@"检查新版本"];
    [arr addObject:@[strCheckUpdate, @(-1)]];
    [arr addObject:@[@"声明：本设置面板只限内部使用.", @(-2)]];
    //设置默认的电商
    data.ecDomain = [ln getDefaultEcDm];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //只有返回首页才隐藏NavigationBarHidden
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound)//用于电商
    {
        if ([self.navigationController.topViewController isKindOfClass:[GYEasyPurchaseMainViewController class]])
        {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];//用于电商
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    static NSString *cid = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cid];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cid];
    }
    NSString *text = arr[row][0];
    EMLoginEn l = [arr[row][1] integerValue];
    
    cell.textLabel.text = text;
    if ((NSInteger)l >= 0)
    {
        [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
        [cell.textLabel setTextColor:kCellItemTitleColor];
        if (ln.loginLine == l)
        {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }else
            [cell setAccessoryType:UITableViewCellAccessoryNone];

    }else
    {
        if ((NSInteger)l == -1)//更新
        {
            [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
            [cell.textLabel setTextColor:[UIColor blueColor]];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"ver：%@", version]];
            [cell.detailTextLabel setFont:[UIFont italicSystemFontOfSize:cell.detailTextLabel.font.pointSize]];

            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

//            [cell.textLabel setTextAlignment:UITextAlignmentCenter];

        }else
        {
            [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
            [cell.textLabel setTextColor:[UIColor orangeColor]];
            [cell.textLabel setTextAlignment:UITextAlignmentCenter];
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    EMLoginEn l = [arr[row][1] integerValue];
    if ((NSInteger)l < -1)
    {
        return;
    }else if ((NSInteger)l == -1)//更新
    {
        [self updateVer];
        return;
    }
    
    ln.loginLine = l;
    [self.navigationController popViewControllerAnimated:YES];
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
                    if (![version isEqualToString:sVer]&&![sVer isEqualToString:@"0"])//有更新
                    {
                        [UIAlertView showWithTitle:@"提示" message:@"检测到新版本,请及时更新！" cancelButtonTitle:@"取消" otherButtonTitles:@[@"更新"]tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                            if (buttonIndex != 0)//更新
                            {
                                NSURL *url = [NSURL URLWithString:kSaftToNSString(dic[@"url"])];
                                [[UIApplication sharedApplication] openURL:url];
                                
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
