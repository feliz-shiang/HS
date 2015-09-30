//
//  GYEPMyHEViewController.m
//  company
//
//  Created by apple on 14-12-12.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#define kKeyPowerName @"keyName"
#define kKeyPowerIcon @"keyIcon"
#define kKeyNextVcName @"keyNextVcName"

#import "GYEPMyHEViewController.h"
#import "GlobalData.h"
#import "RTLabel.h"
#import "UIView+CustomBorder.h"
#import "TestViewController.h"
#import "CellTypeImagelabel.h"
#import "MyHECellUserInfo.h"
#import "ViewCellForOrders.h"
#import "EasyPurchaseData.h"

#import "GYEasyPurchaseMainViewController.h"//上一个vc
#import "GYEPSaleAfterViewController.h"//售后
#import "GYEPMyAllOrdersViewController.h"//全部订单
#import "GYGetGoodViewController.h"//收货地址
#import "GYFeedbackViewController.h"//意见反馈
#import "GYMainEvaluationGoodsViewController.h" //评价商品
#import "UIButton+WebCache.h"
#import "GYBrowsingHistoryViewController.h"
#import "GYConcernsCollectViewController.h"
#import "GYMyHsHeader.h"
#import "UIButton+enLargedRect.h"
#import "GYARMainViewController.h"

#import "GYPersonDetailFileViewController.h"

@interface GYEPMyHEViewController ()<RTLabelDelegate, UITableViewDelegate, UITableViewDataSource>
{
    GlobalData *data;   //全局单例
    MyHECellUserInfo *cellUserInfo; //企业信息cell
    NSArray *arrPowers; //功能列表数组
    UIView *vPowers;
    NSDictionary *dicMyInfo;
    ViewCellForOrders *orders;
    GYMyHsHeader * userInfoHeader;
}
@property (strong, nonatomic)  UITableView *tableView;

@end

@implementation GYEPMyHEViewController

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
    
    cellUserInfo = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MyHECellUserInfo class]) owner:self options:nil] lastObject];
    
    userInfoHeader = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYMyHsHeader class]) owner:self options:nil]lastObject];
    userInfoHeader.frame = CGRectMake(0, 0, kScreenWidth, userInfoHeader.frame.size.height);
    userInfoHeader.btnBackToRoot.layer.masksToBounds = YES;
    userInfoHeader.btnBackToRoot.layer.cornerRadius = 6;
    [userInfoHeader.btnBackToRoot addTarget:self action:@selector(BackToRoot:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * vHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, userInfoHeader.frame.size.height)];
    [vHead addSubview:userInfoHeader];
    [self.view addSubview:vHead];
    userInfoHeader.userInteractionEnabled = YES;
    
    
    //初始化未登录的值
    dicMyInfo = @{
                  @"gcount": @(0),
                  @"lastLoginTime": @"--",
                  @"name": @"",
                  @"scount": @(0),
                  @"url": @"",
                  @"waitComCount": @(0),
                  @"waitPayCount": @(0),
                  @"waitPickUpCount": @(0),
                  @"waitRecCount": @(0)
                  };
    
    //控制器背景色
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];

    //初始化设置tableView
    CGFloat tableViewY = vHead.frame.size.height;
    CGFloat tableViewH = kScreenHeight - tableViewY;
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (kSystemVersionLessThan(@"6.9")) {
        tableViewH -=20;
    }
    self.tableView.frame = CGRectMake(0, tableViewY, kScreenWidth, tableViewH);
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = kDefaultVCBackgroundColor;
    //初始化全局单例
    data = [GlobalData shareInstance];
    
    //注册cell以复用
    [self.tableView registerNib:[UINib nibWithNibName:@"CellTypeImagelabel_35" bundle:kDefaultBundle]
         forCellReuseIdentifier:kCellTypeImagelabelIdentifier];//不作配置，只使用3.5inch的cell
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    cellUserInfo.btnUserPicture.layer.masksToBounds = YES;
    cellUserInfo.btnUserPicture.layer.cornerRadius = 6;
    cellUserInfo.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img_hsBackground.png"]];
    cellUserInfo.nav = self.navigationController;
    
   
    
//    NSArray *arr0 = @[@""];//占位 kKeyPowerName 也作 title
    NSArray *arr1 = @[@""];//占位
    NSArray *arr5 = @[
                     
                      
                      @{kKeyPowerIcon: @"icon_good_rate",
                        kKeyPowerName: kLocalized(@"ep_my_evaluate"),
                        kKeyNextVcName: NSStringFromClass([GYMainEvaluationGoodsViewController class])//待评价
                        },
                      
                      @{kKeyPowerIcon: @"ep_myhe_cell_img_after_sales_service",
                        kKeyPowerName: kLocalized(@"ep_myhe_after_sales_service"),
                        kKeyNextVcName: NSStringFromClass([GYEPSaleAfterViewController class])//售后服务
                        },
                      @{kKeyPowerIcon: @"ep_cell_browsing_history",
                        kKeyPowerName: kLocalized(@"ep_usual_browsing_history"),
                        kKeyNextVcName: NSStringFromClass([GYBrowsingHistoryViewController class])//浏览历史
                        },
                      
                      @{kKeyPowerIcon: @"ep_cell_concerns_collect",
                        kKeyPowerName: kLocalized(@"ep_usual_concerns_collect"),
                        kKeyNextVcName: NSStringFromClass([GYConcernsCollectViewController class])//我的关注
                        }

                      
                      ];
    NSArray * arr6 = @[ @{kKeyPowerIcon: @"ep_myhe_cell_img_opinion_feedback",
                          kKeyPowerName: kLocalized(@"ep_myhe_opinion_feedback"),
                          kKeyNextVcName: NSStringFromClass([GYFeedbackViewController class])//意见反馈
                          }];
    arrPowers = @[ arr1, arr5,arr6];

    //兼容IOS6设置背景色
    
//    self.tableView.tableHeaderView = vHead ;
    
    
//    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
//        // iOS 7
//        [self prefersStatusBarHidden];
//        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
//    }
    
}

//- (BOOL)prefersStatusBarHidden
//{
//    return NO;//隐藏yes，显示为NO
//}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self getMyBusiness];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    CGFloat sectionHeaderHeight = 100;
//    
//    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0)
//    {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//        
//    }
//    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//        
//    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

//    [UIApplication sharedApplication].statusBarHidden = NO;
    //只有返回首页才隐藏NavigationBarHidden
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound)//返回
    {
        if ([self.navigationController.topViewController isKindOfClass:[GYEasyPurchaseMainViewController class]]||[self.navigationController.topViewController isKindOfClass:[GYARMainViewController class]])
        {
            [self.navigationController setNavigationBarHidden:NO animated:NO];
        }
    }
}


//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//
//    return UIStatusBarStyleBlackTranslucent;
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrPowers.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrPowers[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section)
    {
        case 0:
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];

            if (!orders)
            {
                orders = [[ViewCellForOrders alloc] init];
                orders.nav = self.navigationController;
            }
            
            [orders setNumber:kSaftToNSInteger(dicMyInfo[@"waitPayCount"]) index:0];//待付款
            [orders setNumber:kSaftToNSInteger(dicMyInfo[@"waitDeliver"]) index:1];//待发货
            [orders setNumber:kSaftToNSInteger(dicMyInfo[@"waitPickUpCount"]) index:2];//待自提
            [orders setNumber:kSaftToNSInteger(dicMyInfo[@"waitRecCount"]) index:3]; //待收货
          //  [orders setNumber:kSaftToNSInteger(dicMyInfo[@"waitComCount"]) index:4]; //待评价

            [cell.contentView addSubview:orders];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
        }
            break;
        default:
        {
            CellTypeImagelabel *cl = [tableView dequeueReusableCellWithIdentifier:kCellTypeImagelabelIdentifier];
            cl.ivCellImage.image = kLoadPng([arrPowers[section][row] valueForKey:kKeyPowerIcon]);
            cl.lbCellLabel.text = [arrPowers[section][row] valueForKey:kKeyPowerName];
            cell = cl;
            [cell.contentView addTopBorderAndBottomBorder];
        }

            break;
    }
    if (kSystemVersionLessThan(@"7.0"))
    {
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cllh = kDefaultCellHeight;
    
    switch (indexPath.section)
    {
        case 0:
            cllh = 120;
            break;
        case 1:
        {
            cllh = kDefaultCellHeight3_5inch;
        }
            break;
        default:
            cllh = kDefaultCellHeight3_5inch;
            break;
    }
    
    return cllh;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section == 0)
//    {
//        return 0;
//    }else
//    {
//        return 6;//加上页脚＝16
//    }
//}
////如果不设置大小 默认为40个宽度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if (section == arrPowers.count - 1) return 0;
//    return kDefaultMarginToBounds - 6;
//}

//-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return [[UIView alloc] initWithFrame:CGRectZero];
//}
//
//-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
//{
//    return [[UIView alloc] initWithFrame:CGRectZero];
//}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section >= 1)//
    {
        UIViewController *vc = kLoadVcFromClassStringName([arrPowers[section][row] valueForKey:kKeyNextVcName]);
        vc.navigationItem.title = [arrPowers[section][row] valueForKey:kKeyPowerName];
        [self pushVC:vc animated:YES];
    }
}

//弹出新窗口
- (void)pushVC:(id)sender animated:(BOOL)ani
{
    if (!sender) return;
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:sender animated:ani];
//    [self presentViewController:sender animated:YES completion:^{
//        
//    }];
}

-(void) BackToRoot:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark - RTLabelDelegate
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL *)url
{
    //    UIViewController *vc = kLoadVcFromClassStringName(url.path);
    //    vc.hidesBottomBarWhenPushed=YES;
    //    [self pushVC:vc animated:YES];
}



#pragma - 获取我的互商
- (void)getMyBusiness
{
    data = [GlobalData shareInstance];
    NSDictionary *allParas = @{@"key": data.ecKey
                               };
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    [self.view addSubview:hud];
    [hud show:YES];
    
    [Network HttpGetForRequetURL:[data.ecDomain stringByAppendingString:@"/easybuy/getMyBusiness"] parameters:allParas requetResult:^(NSData *jsonData, NSError *error) {
        if (!error)
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:kNilOptions
                                                                  error:&error];
            if (!error)
            {
                if (kSaftToNSInteger(dic[@"retCode"]) == kEasyPurchaseRequestSucceedCode)//返回成功数据
                {
                    dicMyInfo = dic[@"data"];
                   
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self setviewValues];
                        
                        [self.tableView reloadData];
                    });

                }else//返回失败数据
                {
                    [Utils showMessgeWithTitle:nil message:@"同步信息失败." isPopVC:nil];
                }
            }else
            {
                [Utils showMessgeWithTitle:nil message:@"同步信息失败." isPopVC:nil];
            }
            
        }else
        {
            [Utils showMessgeWithTitle:@"提示" message:[error localizedDescription] isPopVC:nil];
        }
        if (hud.superview)
        {
            [hud removeFromSuperview];
        }
    }];
}

-(void)setviewValues
{

    NSString *imgUrl = kSaftToNSString(dicMyInfo[@"url"]);
    UIImageView *userPicture = [[UIImageView alloc] initWithImage:kLoadPng(@"cell_img_noneuserimg")];
    [userInfoHeader.btnHeadPic setImage:userPicture.image forState:UIControlStateNormal];
   
    [userInfoHeader.btnHeadPic sd_setImageWithURL:[NSURL URLWithString:imgUrl] forState:UIControlStateNormal placeholderImage:kLoadPng(@"cell_img_noneuserimg")];
   
    NSString *userName = kSaftToNSString(dicMyInfo[@"name"]);
    if (userName.length > 0)
        userInfoHeader.LbUserHello.text = [NSString stringWithFormat:@"%@, %@", kLocalized(@"您好"), userName];//国际化时注意称呼前后
    else
        userInfoHeader.LbUserHello.text = kLocalized(@"您好");//国际化时注意称呼前后
    long long t = [kSaftToNSString(dicMyInfo[@"lastLoginTime"]) doubleValue];
    if (t < 1262304000000)//"2010-01-01 08:00:00"
    {
        userInfoHeader.lbLastLoginTime.text = @"";
    }else
    {
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:t / 1000];
        userInfoHeader.lbLastLoginTime.text = [NSString stringWithFormat:@"%@：%@", kLocalized(@"上次登录时间"), [Utils dateToString:date]];
    }
   // add by songjk 点击头像进入个人设置
    [userInfoHeader.btnHeadPic addTarget:self action:@selector(toPersonSet) forControlEvents:UIControlEventTouchUpInside];
}
-(void)toPersonSet
{
    GYPersonDetailFileViewController *vc = kLoadVcFromClassStringName(NSStringFromClass([GYPersonDetailFileViewController class]));
    vc.hidesBottomBarWhenPushed=YES;
    [self pushVC:vc animated:YES];
}
@end
