//
//  GYHSAccountViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#define kKeyAccName @"accName"
#define kKeyAccBal  @"accBal"
#define kKeyAccIcon @"accIcon"
#define kKeyNextVcName @"accNextVc"

#import "GYHSAccountViewController.h"
#import "CellMyAccountCell.h"
#import "CellUserInfo.h"
#import "GlobalData.h"
#import "RTLabel.h"

#import "GYBusinessProcessVC.h"
#import "GYAccountOperatingViewController.h"
#import "GYMyInfoViewController.h"

#import "GYPointAccoutViewController.h"
#import "GYInvestAccoutViewController.h"
#import "GYHSDConAccountViewController.h"
#import "GYHSDToCashAccoutViewController.h"
#import "GYCashAccountViewController.h"
#import "GYGeneralViewController.h"
#import "GYCardBandingViewController3.h"
#import "GYPhoneBandingViewController.h"
#import "GYEmailBandingViewController.h"
#import "GYRealNameAuthViewController.h"
#import "GYRealNameRegisterViewController.h"
#import "GYPersonDetailFileViewController.h"
#import "GYEPMyCouponsMainViewController.h"
#import "TestViewController.h"

//#import "GYLoginView.h"
#import "GYRealNameAuthViewController.h"
#import "GYGuestLoginViewController.h"
#import "UIAlertView+Blocks.h"
#import "UIButton+WebCache.h"
#import "GYChangeLoginPwdViewController.h"
#import "GYGetGoodViewController.h"
#import "IQKeyboardManager.h"

#import "GYNameBandingViewController.h"
//提示框
#import "CustomIOS7AlertView.h"
#import "CustomIOS7AlertView.h"

#import "GYLoginController.h"
#import "GYUserInfoTool.h"
// 修改登录  GYLoginViewDelegate
@interface GYHSAccountViewController ()<UITableViewDataSource,
UITableViewDelegate, GYViewControllerDelegate, MenuTabViewDelegate, RTLabelDelegate, GYLoginControllerDelegate>
{
    GlobalData *data;   //全局单例
    CellUserInfo *cellUserInfo; //个人信息cell
    GYMyInfoViewController *vcMyProfile;//我的个人资料VC
    GYBusinessProcessVC *vcBusiness;//业务办理vc
    GYAccountOperatingViewController *vcAccOperating;//账户操作vc
    MenuTabView *menu;      //菜单视图
    NSArray *menuTitles;    //菜单标题数组
    UIView *transitionView; //当前有效的可显示的视图
    UIScrollView *_scrollV; //滚动视图，用于装载各vc view
    MBProgressHUD *hud;
    NSString *syncUserInfo;//用于同步用户信息，全局信息
    BOOL firstGetUserInfo;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrResult;

@end

@implementation GYHSAccountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIImage* image= kLoadPng(@"btn_set");
        CGRect backframe= CGRectMake(0, 0, image.size.width * 0.5, image.size.height * 0.5);
        UIButton* backButton= [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = backframe;
        [backButton setBackgroundImage:image forState:UIControlStateNormal];
        [backButton setTitle:@"" forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(openGeneral:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *btnSetting= [[UIBarButtonItem alloc] initWithCustomView:backButton];
        
        self.navigationItem.rightBarButtonItem = btnSetting;
    }
    return self;
}

#pragma mark - 打开系统通用页面
- (void)openGeneral:(id)sender
{
    GYGeneralViewController *general = kLoadVcFromClassStringName(NSStringFromClass([GYGeneralViewController class]));
    general.navigationItem.title = kLocalized(@"general_settings");
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:general animated:YES];
    [self setHidesBottomBarWhenPushed:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    syncUserInfo = @"";
    
    //自定义返回，手势失效的问题
    if (kSystemVersionGreaterThanOrEqualTo(@"7.0"))
    {
        self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    }

    //对必要视图数据进行初始化
    transitionView = [[[self.tabBarController.view.subviews reverseObjectEnumerator] allObjects] lastObject];
    self.navigationItem.title = kLocalized(@"my_account");
    
    //实例化单例
    data = [GlobalData shareInstance];
    
    NSArray *arrAcc = @[@{kKeyAccIcon: @"cell_img_points_account",
                          kKeyAccName: kLocalized(@"points_account"),
                          kKeyAccBal: [NSNumber numberWithDouble:data.user.pointAccBal],
                          kKeyNextVcName:NSStringFromClass([GYPointAccoutViewController class])
                          },
                        @{kKeyAccIcon: @"cell_img_HSC_to_cash_acc",
                          kKeyAccName: kLocalized(@"HS_accounts"),
                          kKeyAccBal: [NSNumber numberWithDouble:data.user.HSDToCashAccBal],
                          kKeyNextVcName:NSStringFromClass([GYHSDToCashAccoutViewController class])
                          },
                        @{kKeyAccIcon: @"cell_img_cash_account",
                          kKeyAccName: kLocalized(@"cash_account"),
                          kKeyAccBal: [NSNumber numberWithDouble:data.user.cashAccBal],
                          kKeyNextVcName:NSStringFromClass([GYCashAccountViewController class])
                          },
                         @{kKeyAccIcon: @"img_investment_account_big",
                           kKeyAccName: kLocalized(@"investment_account"),
                           kKeyAccBal: [NSNumber numberWithDouble:data.user.investAccTotal],
                           kKeyNextVcName:NSStringFromClass([GYInvestAccoutViewController class])
                          }
                        ,
                        @{kKeyAccIcon: @"ep_cell_order_center_coupons",
                          kKeyAccName: kLocalized(@"ar_send_ticket"),
                          kKeyAccBal: [NSNumber numberWithDouble:data.user.investAccTotal],
                          kKeyNextVcName:NSStringFromClass([GYEPMyCouponsMainViewController class])
                          }
                       ];
    
    menuTitles = @[kLocalized(@"my_account"),
                   kLocalized(@"account_operating"),
                   kLocalized(@"operation"),
                   kLocalized(@"my_profile")];

    self.arrResult = [NSMutableArray array];
    
    [self.arrResult addObject:@[@""]];//第一行个人信息预留
    [self.arrResult addObject:arrAcc];
    
    menu = [[MenuTabView alloc] initMenuWithTitles:menuTitles];
    menu.delegate = self;
    [self.view addSubview:menu];
    
    CGFloat statusH = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    //加载滚动视图
    CGRect scrollVFrame = self.view.bounds;
    scrollVFrame.origin.y = CGRectGetMaxY(menu.frame);
    
    scrollVFrame.size.height = transitionView.frame.size.height
    - CGRectGetHeight(self.tabBarController.tabBar.frame)
    - CGRectGetHeight(self.navigationController.navigationBar.frame)
    - statusH
    - menu.frame.size.height + 2;
    
    if (kSystemVersionLessThan(@"7.0"))
    {
        scrollVFrame.size.height = transitionView.frame.size.height
        - CGRectGetHeight(self.navigationController.navigationBar.frame)
        - statusH
        - menu.frame.size.height + 2;
    }
    
    _scrollV = [[UIScrollView alloc] initWithFrame:scrollVFrame];
    [_scrollV setPagingEnabled:YES];
    [_scrollV setBounces:NO];
    [_scrollV setShowsHorizontalScrollIndicator:NO];
    _scrollV.delegate = self;
    
    [_scrollV setContentSize:CGSizeMake(scrollVFrame.size.width * menuTitles.count, scrollVFrame.size.height)];
    [self.view addSubview:_scrollV];
    
    //初始化tableView
    CGRect tableViewFrame = _scrollV.bounds;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(tableViewFrame.origin.x,
                                                                   tableViewFrame.origin.y-2,
                                                                   tableViewFrame.size.width,
                                                                   tableViewFrame.size.height)
                                                  style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [_scrollV addSubview:self.tableView];
    
    //添加 账户操作，业务办理，我的资料
    vcAccOperating = [[GYAccountOperatingViewController alloc] init];
    vcAccOperating.delegate = self;
    tableViewFrame.origin.x += tableViewFrame.size.width;
    vcAccOperating.view.frame = tableViewFrame;
    [_scrollV addSubview:vcAccOperating.view];
    
    vcBusiness = [[GYBusinessProcessVC alloc] init];
    vcBusiness.delegate = self;
    tableViewFrame.origin.x += tableViewFrame.size.width;
    vcBusiness.view.frame = tableViewFrame;
    [_scrollV addSubview:vcBusiness.view];
    
    vcMyProfile = [[GYMyInfoViewController alloc] init];
    vcMyProfile.delegate = self;
    tableViewFrame.origin.x += tableViewFrame.size.width;
    vcMyProfile.view.frame = tableViewFrame;
    [_scrollV addSubview:vcMyProfile.view];
    
    //注册自定义cell，并绑定方法
    [self.tableView registerNib:[UINib nibWithNibName:data.currentDeviceScreenInch == kDeviceScreenInch_3_5 ?  @"CellMyAccountCell_35" : @"CellMyAccountCell" bundle:kDefaultBundle] forCellReuseIdentifier:kCellMyAccountCellIdentifier];
    
    //兼容IOS6设置背景色
    self.tableView.backgroundView = [[UIView alloc]init];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    [_scrollV setBackgroundColor:kDefaultVCBackgroundColor];
    
//    pushVCAfterLogin = nil;
    firstGetUserInfo = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];

    //设置菜单及滑动的可用情况
    //刷新数据
    [self.tableView reloadData];
    
    if (!firstGetUserInfo && data.isLogined)
    {
        [self get_user_info];
    }
    
    if (data.isLogined && ![syncUserInfo isEqualToString:kSaftToNSString(data.user.cardNumber)])
    {
        [self reloadData];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //测试，自动弹出登录
//    [self tipUseLogin];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//未登录用户提示先登录
- (void)tipUseLogin
{
    
    if (!data.isCardUser && data.isEcLogined)
    {
        [data.loginView closeAndRemoveSelf:nil];
        DDLogDebug(@"提示 抱歉,您无权使用该业务,请使用互生卡登录.");
        [UIAlertView showWithTitle:@"提示" message:@"抱歉,您无权使用该业务,请使用互生卡登录。" cancelButtonTitle: kLocalized(@"cancel")otherButtonTitles:@[kLocalized(@"use_hs_card_to_login")] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex != 0)
            {
                [data showLoginInView:self.navigationController.view withDelegate:self isStay:NO];
            }
        }];
    }else
    {
        if (!data.isLogined)
        {
            [data showLoginInView:self.navigationController.view withDelegate:self isStay:NO];
            DDLogDebug(@"提示 请先登录。");
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrResult.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrResult[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSString *labelStr = nil;
    double bal = 0;
    UIImage *img = nil;
    
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if (section == 0)
    {
        //未登录 不显示 个人信息栏
        if (!data.isLogined || !data.isCardUser)
        {
            cellUserInfo = nil;
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NllCellId"];
            [cell setHidden:YES];
        }else
        {
            cellUserInfo = [[[NSBundle mainBundle] loadNibNamed:data.currentDeviceScreenInch == kDeviceScreenInch_3_5 ? @"CellUserInfo_35" : @"CellUserInfo" owner:self options:nil] lastObject];
            //zhangqy  只判断一个条件：实名注册，如果未实名注册，弹出提示框，且在界面提示注册提示语
            if (!(data.user.userName && data.user.userName.length>0))
//            if ([data.personInfo.regStatus isEqualToString:@"N"])
            {
                cellUserInfo.btnRealName.hidden = YES;
                cellUserInfo.btnPhoneYes.hidden = YES;
                cellUserInfo.btnEmailYes.hidden = YES;
                cellUserInfo.btnBankYes.hidden = YES;
                cellUserInfo.lbLastLoginInfo.hidden = YES;
                cellUserInfo.vTipToInputInfo.hidden = NO;
                // modify by songjk
                //                cellUserInfo.vTipToInputInfo.text = [NSString stringWithFormat:@"<font size=12 color='#00A2E9'>%@<font size=12 color=red><a href='%@'>%@</a></font>!</font>",
                //                                                     kLocalized(@"tip_to_perfect_info_pre"),
                //                                                     NSStringFromClass([GYRealNameRegisterViewController class]),
                //                                                     kLocalized(@"tip_to_perfect_info_suf")];
                //                cellUserInfo.vTipToInputInfo.lineSpacing = 10.f;
                cellUserInfo.vTipToInputInfo.text = [NSString stringWithFormat:@"<font size=12 color='#00A2E9'>%@<font size=12 color=red><a href='%@'>%@</a></font></font>",
                                                     kLocalized(@"您尚未进行实名注册，为保障您在平台的权益，请尽快完善!"),
                                                     NSStringFromClass([GYNameBandingViewController class]),
                                                     kLocalized(@"点我进行实名注册。")];
                cellUserInfo.vTipToInputInfo.delegate = self;
                NSString *strHH = kLocalized(@"您好");
                if (data.user.userName && data.user.userName.length>0)
                {
                    cellUserInfo.lbLabelHello.text = [NSString stringWithFormat:@"%@，%@", data.user.userName, strHH];
                }else
                {
                    cellUserInfo.lbLabelHello.text = strHH;
                }
                
                cellUserInfo.lbLabelCardNo.text = [NSString stringWithFormat:@"%@  %@",
                                                   kLocalized(@"points_card_number"), [Utils formatCardNo:data.user.cardNumber]];
                [Utils setFontSizeToFitWidthWithLabel:cellUserInfo.lbLabelHello labelLines:1];
                [Utils setFontSizeToFitWidthWithLabel:cellUserInfo.lbLastLoginInfo labelLines:1];
                [Utils setFontSizeToFitWidthWithLabel:cellUserInfo.lbLabelCardNo labelLines:1];
                //加载头像
                NSString *imgUrl = data.IMUser.strHeadPic;
                if (![imgUrl hasPrefix:@"http"]) {
                    imgUrl = [NSString stringWithFormat:@"%@%@", [GlobalData shareInstance].tfsDomain, imgUrl];
                }
                [cellUserInfo.btnUserPicture sd_setImageWithURL:[NSURL URLWithString:imgUrl] forState:UIControlStateNormal placeholderImage:kLoadPng(@"cell_img_noneuserimg")];
                [cellUserInfo.btnUserPicture addTarget:self action:@selector(pushPersonInfo:) forControlEvents:UIControlEventTouchUpInside];
                
                [cellUserInfo setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell = cellUserInfo;
            }
            else
            {
                //zhangqy 只判断一个条件：实名注册，如果未实名注册，弹出提示框，且在界面提示注册提示语
//                if ([data.personInfo.regStatus isEqualToString:@"Y"])
                //if (data.user.isRealNameRegistration)//已经实名绑定
                if ((data.user.userName && data.user.userName.length>0))
                {
                    cellUserInfo.btnRealName.hidden = NO;
                    cellUserInfo.btnPhoneYes.hidden = NO;
                    cellUserInfo.btnEmailYes.hidden = NO;
                    cellUserInfo.btnBankYes.hidden = NO;
                    cellUserInfo.lbLastLoginInfo.hidden = NO;
                    cellUserInfo.vTipToInputInfo.hidden = YES;
                    
                    [cellUserInfo.btnRealName addTarget:self action:@selector(pushRealNameVC:) forControlEvents:UIControlEventTouchUpInside];
                    [cellUserInfo.btnPhoneYes addTarget:self action:@selector(pushPhoneBinding:) forControlEvents:UIControlEventTouchUpInside];
                    [cellUserInfo.btnEmailYes addTarget:self action:@selector(pushEmailBinding:) forControlEvents:UIControlEventTouchUpInside];
                    [cellUserInfo.btnBankYes addTarget:self action:@selector(pushBankBinding:) forControlEvents:UIControlEventTouchUpInside];
                    
                    cellUserInfo.lbLastLoginInfo.text = [NSString stringWithFormat:@"%@: %@", kLocalized(@"label_lastlogin_time"), data.user.lastLoginTime ];
                    
                    [cellUserInfo.btnRealName setBackgroundImage:kLoadPng(data.user.isRealName ? @"icon_real_name_yes" : @"icon_real_name_no")
                                                        forState:UIControlStateNormal];
                    [cellUserInfo.btnPhoneYes setBackgroundImage:kLoadPng(data.user.isPhoneBinding ? @"icon_phone_yes" : @"icon_phone_no")
                                                        forState:UIControlStateNormal];
                    [cellUserInfo.btnEmailYes setBackgroundImage:kLoadPng(data.user.isEmailBinding ? @"icon_email_yes" : @"icon_email_no")
                                                        forState:UIControlStateNormal];
                    [cellUserInfo.btnBankYes setBackgroundImage:kLoadPng(data.user.isBankBinding ? @"icon_bank_yes" : @"icon_bank_no")
                                                       forState:UIControlStateNormal];
                    
                }else
                {
                    cellUserInfo.btnRealName.hidden = YES;
                    cellUserInfo.btnPhoneYes.hidden = YES;
                    cellUserInfo.btnEmailYes.hidden = YES;
                    cellUserInfo.btnBankYes.hidden = YES;
                    cellUserInfo.lbLastLoginInfo.hidden = YES;
                    cellUserInfo.vTipToInputInfo.hidden = NO;
                    // modify by songjk
                    //                cellUserInfo.vTipToInputInfo.text = [NSString stringWithFormat:@"<font size=12 color='#00A2E9'>%@<font size=12 color=red><a href='%@'>%@</a></font>!</font>",
                    //                                                     kLocalized(@"tip_to_perfect_info_pre"),
                    //                                                     NSStringFromClass([GYRealNameRegisterViewController class]),
                    //                                                     kLocalized(@"tip_to_perfect_info_suf")];
                    //                cellUserInfo.vTipToInputInfo.lineSpacing = 10.f;
                    //modify by zhangqy 只判断一个条件：实名注册，如果未实名注册，弹出提示框，且在界面提示注册提示语
                    cellUserInfo.vTipToInputInfo.text = [NSString stringWithFormat:@"<font size=12 color='#00A2E9'>%@<font size=12 color=red><a href='%@'>%@</a></font></font>",
                                                         kLocalized(@"尚未进行实名注册，为保障您在平台的权益，请尽快完善!"),
                                                         NSStringFromClass([GYRealNameRegisterViewController class]),
                                                         kLocalized(@"点我进行实名注册")];
                    cellUserInfo.vTipToInputInfo.delegate = self;
                    
                }
                NSString *strHH = kLocalized(@"您好");
                if (data.user.userName && data.user.userName.length>0)
                {
                    cellUserInfo.lbLabelHello.text = [NSString stringWithFormat:@"%@，%@", data.user.userName, strHH];
                }else
                {
                    cellUserInfo.lbLabelHello.text = strHH;
                }
                
                cellUserInfo.lbLabelCardNo.text = [NSString stringWithFormat:@"%@  %@",
                                                   kLocalized(@"points_card_number"), [Utils formatCardNo:data.user.cardNumber]];
                [Utils setFontSizeToFitWidthWithLabel:cellUserInfo.lbLabelHello labelLines:1];
                [Utils setFontSizeToFitWidthWithLabel:cellUserInfo.lbLastLoginInfo labelLines:1];
                [Utils setFontSizeToFitWidthWithLabel:cellUserInfo.lbLabelCardNo labelLines:1];
                //加载头像
                NSString *imgUrl = data.IMUser.strHeadPic;
                if (![imgUrl hasPrefix:@"http"]) {
                    imgUrl = [NSString stringWithFormat:@"%@%@", [GlobalData shareInstance].tfsDomain, imgUrl];
                }
                [cellUserInfo.btnUserPicture sd_setImageWithURL:[NSURL URLWithString:imgUrl] forState:UIControlStateNormal placeholderImage:kLoadPng(@"cell_img_noneuserimg")];
                [cellUserInfo.btnUserPicture addTarget:self action:@selector(pushPersonInfo:) forControlEvents:UIControlEventTouchUpInside];
                
                [cellUserInfo setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell = cellUserInfo;
            }
        }
    }
    else
    {
        CellMyAccountCell *cl = [tableView dequeueReusableCellWithIdentifier:kCellMyAccountCellIdentifier];
        if (!cl)
        {
            cl = [[CellMyAccountCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellMyAccountCellIdentifier];
        }
        NSArray *arrAcc = self.arrResult[section];
        
        labelStr = [arrAcc[row] valueForKey:kKeyAccName];
        img = kLoadPng([arrAcc[row] valueForKey:kKeyAccIcon]);
        bal = [[arrAcc[row] valueForKey:kKeyAccBal] doubleValue];
        
        cl.lbAccounName.text = labelStr;

        CGRect imgFrame = cl.ivTitle.frame;
        imgFrame.size = kDefaultIconSize;
        
        if (data.currentDeviceScreenInch == kDeviceScreenInch_3_5)
        {
            imgFrame.size = kDefaultIconSize3_5inch;
        }
        
        imgFrame.origin.x = 15;
        imgFrame.origin.y = (cl.contentView.frame.size.height - imgFrame.size.height) / 2;
        
        cl.ivTitle.frame = imgFrame;
        cl.ivTitle.image = img;
        cell = cl;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (data.currentDeviceScreenInch)
    {
        case kDeviceScreenInch_3_5:
            if (indexPath.section == 0)
            {
                if (!data.isLogined || !data.isCardUser)
                {
                    return 1.5;//设置与右滚动页的高持平
                }
                return 88;
            }else
            {
                return kDefaultCellHeight3_5inch;
            }
            break;
        case kDeviceScreenInch_4_0:
        default:
            if (indexPath.section == 0)
            {
                if (!data.isLogined || !data.isCardUser)
                {
                    return 1.5;//设置与右滚动页的高持平
                }
                return 110;
            }else
            {
                return kDefaultCellHeight;
            }
            break;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        if (kSystemVersionLessThan(@"7.0"))
            return 16;
        else
            return 1;//第一栏位设1
        //        return 35;//第一栏位设
    }else
    {
        return 6;//加上页脚＝16
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.arrResult.count - 1)
    {
        return 30;
    }
    return 10;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (!data.isCardUser)
//    {
//        [self tipUseLogin];
//        return;
//    }

    if (indexPath.section == 0) return;
    
    NSArray *arrAcc = self.arrResult[indexPath.section];
    NSString *nextVCName = arrAcc[indexPath.row][kKeyNextVcName];
    NSString *nextVCTitle = arrAcc[indexPath.row][kKeyAccName];
    UIViewController *vc = kLoadVcFromClassStringName(nextVCName);
    vc.navigationItem.title = nextVCTitle;
    if (vc)
    {
        [self pushVC:vc animated:YES];
    }
}


#pragma mark - 用户信息绑定按钮
//实名认证
- (void)pushRealNameVC:(id)sender
{
//    GYRealNameAuthViewController *vc = kLoadVcFromClassStringName(NSStringFromClass([GYRealNameAuthViewController class]));
//    vc.hidesBottomBarWhenPushed=YES;
//    [self pushVC:vc animated:YES];

}

//手机绑定
- (void)pushPhoneBinding:(id)sender
{
//    GYPhoneBandingViewController *vc = kLoadVcFromClassStringName(NSStringFromClass([GYPhoneBandingViewController class]));
//    vc.hidesBottomBarWhenPushed=YES;
//    [self pushVC:vc animated:YES];

}

//油箱绑定
- (void)pushEmailBinding:(id)sender
{
//    GYEmailBandingViewController *vc = kLoadVcFromClassStringName(NSStringFromClass([GYEmailBandingViewController class]));
//    vc.hidesBottomBarWhenPushed=YES;
//    [self pushVC:vc animated:YES];
}

//银行卡绑定
- (void)pushBankBinding:(id)sender
{
//    GYCardBandingViewController3 *vc = kLoadVcFromClassStringName(NSStringFromClass([GYCardBandingViewController3 class]));
//    vc.hidesBottomBarWhenPushed=YES;
//    [self pushVC:vc animated:YES];
}

//修改人个信息资料
- (void)pushPersonInfo:(id)sender
{
    GYPersonDetailFileViewController *vc = kLoadVcFromClassStringName(NSStringFromClass([GYPersonDetailFileViewController class]));
    vc.hidesBottomBarWhenPushed=YES;
    [self pushVC:vc animated:YES];
}

#pragma mark - GYViewControllerDelegate

- (void)pushVC:(id)vc animated:(BOOL)ani
{
    if (data.isEcLogined && !data.isCardUser)//非持卡人可以改密码和管理地址
    {
        if ([vc isKindOfClass:[GYChangeLoginPwdViewController class]] ||
            [vc isKindOfClass:[GYGetGoodViewController class]]
            )
        {
        }else
        {
            [self tipUseLogin];
            return;
        }
    }else if (!data.isLogined || !data.isCardUser)
    {
        [self tipUseLogin];
        return;
    }
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:ani];
    [self setHidesBottomBarWhenPushed:NO];

}

#pragma mark - MenuTabViewDelegate
- (void)changeViewController:(NSInteger)index
{
    
    CGFloat contentOffsetX = _scrollV.contentOffset.x;
    NSInteger viewIndex = (NSInteger)(contentOffsetX / self.view.frame.size.width);
    if (viewIndex == index ) return;
    
    CGFloat _x = _scrollV.frame.size.width * index;
    [_scrollV scrollRectToVisible:CGRectMake(_x,
                                             _scrollV.frame.origin.y,
                                             _scrollV.frame.size.width,
                                             _scrollV.frame.size.height)
                         animated:NO];
    //设置当前导航条标题
    [self.navigationItem setTitle:menuTitles[index]];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _scrollV)//因为tableview 中的scrollView 也使用同一代理，所以要判断，否则取得x值不是预期的
    {
        CGFloat _x = scrollView.contentOffset.x;//滑动的即时位置x坐标值
        NSInteger index = (NSInteger)(_x / self.view.frame.size.width);//所偶数当前视图
        
        //设置滑动过渡位置
        if (index < menu.selectedIndex)
        {
            if (_x < menu.selectedIndex * self.view.frame.size.width - 0.5 * self.view.frame.size.width)
            {
                [menu updateMenu:index];
                [self.navigationItem setTitle:menuTitles[index]];
            }
        }else if (index == menu.selectedIndex)
        {
            if (_x > menu.selectedIndex * self.view.frame.size.width + 0.5 * self.view.frame.size.width)
            {
                [menu updateMenu:index + 1];
                [self.navigationItem setTitle:menuTitles[index + 1]];
            }
        }else
        {
            [menu updateMenu:index];
            [self.navigationItem setTitle:menuTitles[index]];
        }
    }
}

#pragma mark - RTLabel delegate

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
    //add by zhangqy 只判断一个条件：实名注册，如果未实名注册，弹出提示框，且在界面提示注册提示语
    UIViewController *vc = kLoadVcFromClassStringName(@"GYRealNameRegisterViewController");
    vc.hidesBottomBarWhenPushed=YES;
    [self pushVC:vc animated:YES];
}

#pragma mark - GYLoginViewDelegate
- (void)loginDidSuccess:(NSDictionary *)response sender:(id)sender
{
    firstGetUserInfo = YES;
    [self reloadData];
}

- (void)reloadData
{
    if (hud) {
        [hud removeFromSuperview];
    }
    hud = nil;
    hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    
    [self.navigationController.view addSubview:hud];
    hud.labelText = @"初始化数据...";
    [hud show:YES];

    [self get_user_info];
}

#pragma mark - 获取个人的账户信息
- (void)get_user_info
{
    
    
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification postNotificationName:@"refreshPersonInfo" object:self];
    
    NSDictionary *subParas = @{@"resource_no": data.user.cardNumber};
    NSDictionary *allParas = @{@"system": @"person",
                               @"cmd": @"get_user_info",
                               @"params": subParas,
                               @"uType": kuType,
                               @"mac": kHSMac,
                               @"mId": data.midKey,
                               @"key": data.hsKey
                               };
    
    [Network HttpGetForRequetURL:[data.hsDomain stringByAppendingString:kHSApiAppendUrl] parameters:allParas requetResult:^(NSData *jsonData, NSError *error) {
        if (!error)
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:kNilOptions
                                                                  error:&error];
//            DDLogInfo(@"get_user_info dic:%@", dic);
            if (!error)
            {
                if ([kSaftToNSString(dic[@"code"]) isEqualToString:kHSRequestSucceedCode] &&
                    dic[@"data"] &&
                    (kSaftToNSInteger(dic[@"data"][@"resultCode"]) == kHSRequestSucceedSubCode))//返回成功数据
                {
                    dic = dic[@"data"];
                    data.user.cardNumber = kSaftToNSString(dic[@"resNo"]);
                    data.user.custId = kSaftToNSString(dic[@"custId"]);
                    data.user.cashAccBal = [kSaftToNSString(dic[@"cash"]) doubleValue];
                    NSString *userName = dic[@"custName"];//该键值是动态返回，已经实名绑定就有返回
                    if (userName)
                    {
                        data.user.userName = kSaftToNSString(dic[@"custName"]);
                    }else
                    {
                        data.user.userName = userName;
                    }
                    data.user.HSDToCashAccBal = [kSaftToNSString(dic[@"hsbTransferCash"]) doubleValue];
                    data.user.HSDConAccBal = [kSaftToNSString(dic[@"hsbTransferConsume"]) doubleValue];
                    data.user.investAccTotal = [kSaftToNSString(dic[@"invest"]) doubleValue];
                    data.user.isRealName = ([[kSaftToNSString(dic[@"isAuth"]) lowercaseString] isEqualToString:@"y"] ? YES : NO);
                    data.user.isBankBinding = ([[kSaftToNSString(dic[@"isBindBank"]) lowercaseString] isEqualToString:@"y"] ? YES : NO);
                    data.user.isEmailBinding = ([[kSaftToNSString(dic[@"isBindEmail"]) lowercaseString] isEqualToString:@"y"] ? YES : NO);
                    data.user.isPhoneBinding = ([[kSaftToNSString(dic[@"isBindMobile"]) lowercaseString] isEqualToString:@"y"] ? YES : NO);
                    data.user.isRealNameRegistration = ([[kSaftToNSString(dic[@"isReg"]) lowercaseString] isEqualToString:@"y"] ? YES : NO);
                    data.user.pointAccBal = [kSaftToNSString(dic[@"residualIntegral"]) doubleValue];
                    data.user.availablePointAmount = [kSaftToNSString(dic[@"usableIntegral"]) doubleValue];
                    data.user.todayPointAmount = [kSaftToNSString(dic[@"todayNewIntegral"]) doubleValue];
                    [vcMyProfile.MyInfoTableView reloadData];
                    
                    if (firstGetUserInfo)
                    {
                        firstGetUserInfo = NO;
                        [self get_global_params];
                    }else
                    {
                        [self.tableView reloadData];
                    
                    }
                    [self checkInfo];
                    
                }else//返回失败数据
                {
                    if (firstGetUserInfo) [self showErrAndLoginWithTitle:nil message:@"返回数据失败。"];
                }
            }else
            {
                if (firstGetUserInfo) [self showErrAndLoginWithTitle:nil message:@"数据结构错误。"];
            }
            
        }else
        {
            if (firstGetUserInfo) [self showErrAndLoginWithTitle:@"提示" message:[error localizedDescription]];
        }
        if (hud)
        {
            [hud hide:YES afterDelay:1.0f];
        }
    }];
}
// add by songjk
//zhangqy 只判断一个条件：实名注册，如果未实名注册，弹出提示框，且在界面提示注册提示语
-(void)checkInfo
{
#if 0
    if (!([GlobalData shareInstance].user.userName && [GlobalData shareInstance].user.userName.length>0))
    {
        if (data.isLoing)
        {
            data.isLoing = NO;

            //[self gotoNameBanding];
            [self gotoNameReg];
            //                UIAlertView *alert = [UIAlertView showWithTitle:nil message:@"温馨提示：\n您尚未进行实名绑定，为保障您在平台的权益，请尽快完善！" cancelButtonTitle:kLocalized(@"cancel") otherButtonTitles:@[kLocalized(@"点我绑定")] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            //                    if (buttonIndex != 0)
            //                    {
            //                        [self gotoNameBanding];
            //                    }
            //                }];
            //                alert.backgroundColor = [UIColor colorWithRed:255/225.0 green:244/225.0 blue:224/225.0 alpha:1];
            //                [alert show];
        }
    }
#endif
    if (![GlobalData shareInstance].user.isRealNameRegistration)
    {
        if (data.isLoing)
        {
            data.isLoing = NO;
            [self gotoNameReg];
            //                UIAlertView *alert = [UIAlertView showWithTitle:nil message:@"温馨提示：\n您尚未进行实名注册，为保障您在平台的权益，请尽快完善！" cancelButtonTitle:kLocalized(@"cancel") otherButtonTitles:@[kLocalized(@"点我注册")] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            //                    if (buttonIndex != 0)
            //                    {
            //                        [self gotoNameReg];
            //                    }
            //                }];
            //                alert.backgroundColor = [UIColor colorWithRed:255/225.0 green:244/225.0 blue:224/225.0 alpha:1];
            //                [alert show];
        }
    }
}
// add by songjk 实名绑定
//modify by zhangqy 只判断一个条件：实名注册，如果未实名注册，弹出提示框，且在界面提示注册提示语
#if 0
-(void)gotoNameBanding
{
    // 创建控件
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    
    // 添加自定义控件到 alertView
    [alertView setContainerView:[self createUIWithType:1]];
    
    // 添加按钮
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:kLocalized(@"cancel"),kLocalized(@"点我注册"),nil]];
    //设置代理
    //    [alertView setDelegate:self];
    // 通过Block设置按钮回调事件 可用代理或者block
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        NSLog(@"＝＝＝＝＝Block: Button at position %d is clicked on alertView %d.",
              buttonIndex, (int)[alertView tag]);
        
        [alertView close];
        if (buttonIndex == 1)
        {
            GYNameBandingViewController *vcNameAuth = [[GYNameBandingViewController alloc]initWithNibName:@"GYNameBandingViewController" bundle:nil];
            vcNameAuth.title=@"实名注册";
            vcNameAuth.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vcNameAuth animated:YES];
        }
        
    }];
    
    [alertView setUseMotionEffects:true];
    alertView.arrIndesx = @[@"0"];
    alertView.arrBtnBackColor = @[[UIColor grayColor]];
    // And launch the dialog
    [alertView show];
    
    alertView.lineView.hidden = YES;
    alertView.lineView.alpha = 0;
    alertView.lineView1.hidden = YES;
    alertView.lineView1.alpha = 0;
}
#endif
//zhangqy 只判断一个条件：实名注册，如果未实名注册，弹出提示框，且在界面提示注册提示语
-(UIView *)createUIWithType:(NSInteger)type
{
    //弹出的试图
    UIView * popView=[[UIView alloc]initWithFrame:CGRectMake(0, 5, 290, 100 )];
    //开始添加弹出的view中的组件
    UILabel * lbTip =[[UILabel alloc]initWithFrame:CGRectMake(30, 2, 200, 30)];
    lbTip.text=kLocalized(@"温馨提示");
    lbTip.font=[UIFont systemFontOfSize:17.0];
    lbTip.backgroundColor=[UIColor clearColor];
    UILabel * lbCardComment =[[UILabel alloc]initWithFrame:CGRectMake(30,CGRectGetMaxY(lbTip.frame)+5, 230, 30)];
    lbCardComment.numberOfLines = 0;
    if(type==1)
    {
        lbCardComment.text=@"您尚未进行实名注册，为保障您在平台的权益，请尽快完善！";
    }
    else
    {
        lbCardComment.text=@"您尚未进行实名注册，为保障您在平台的权益，请尽快完善！";
    }
    CGSize commentSize = [Utils sizeForString:lbCardComment.text font:[UIFont systemFontOfSize:17.0] width:lbCardComment.frame.size.width];
    lbCardComment.frame = CGRectMake(lbCardComment.frame.origin.x, lbCardComment.frame.origin.y,commentSize.width , commentSize.height);
    lbCardComment.textColor=kCellItemTitleColor;
    lbCardComment.font=[UIFont systemFontOfSize:17.0];
    lbCardComment.backgroundColor=[UIColor clearColor];
    
    [popView addSubview:lbTip];
    [popView addSubview:lbCardComment];
    return popView;
}
// add by songjk 实名注册
-(void)gotoNameReg
{
    // 创建控件
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    
    // 添加自定义控件到 alertView
    [alertView setContainerView:[self createUIWithType:1]];
    
    // 添加按钮
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:kLocalized(@"cancel"),kLocalized(@"点我注册"),nil]];
    //设置代理
    //    [alertView setDelegate:self];
    // 通过Block设置按钮回调事件 可用代理或者block
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        NSLog(@"＝＝＝＝＝Block: Button at position %d is clicked on alertView %d.",
              buttonIndex, (int)[alertView tag]);
        
        [alertView close];
        if (buttonIndex == 1)
        {
            GYRealNameRegisterViewController *vcNameAuth = [[GYRealNameRegisterViewController alloc]initWithNibName:@"GYRealNameRegisterViewController" bundle:nil];
            [self.navigationController pushViewController:vcNameAuth animated:YES];
        }
        
    }];
    
    [alertView setUseMotionEffects:true];
    alertView.arrIndesx = @[@"0"];
    alertView.arrBtnBackColor = @[[UIColor grayColor]];
    [alertView show];
    alertView.lineView.hidden = YES;
    alertView.lineView.alpha = 0;
    alertView.lineView1.hidden = YES;
    alertView.lineView1.alpha = 0;
}
#pragma mark - 获取全局参数信息
- (void)get_global_params
{
    NSDictionary *subParas = @{@"resource_no": data.user.cardNumber};
    
    NSDictionary *allParas = @{@"system": @"person",
                               @"cmd": @"get_global_params",
                               @"params": subParas,
                               @"uType": kuType,
                               @"mac": kHSMac,
                               @"mId": data.midKey,
                               @"key": data.hsKey
                               };
    
    [Network HttpGetForRequetURL:[data.hsDomain stringByAppendingString:kHSApiAppendUrl] parameters:allParas requetResult:^(NSData *jsonData, NSError *error) {
        if (!error)
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:kNilOptions
                                                                  error:&error];
//            DDLogInfo(@"get_global_params dic:%@", dic);
            if (!error)
            {
                if ([kSaftToNSString(dic[@"code"]) isEqualToString:kHSRequestSucceedCode] &&
                    dic[@"data"] &&
                    (kSaftToNSInteger(dic[@"data"][@"resultCode"]) == kHSRequestSucceedSubCode))//返回成功数据
                {
                    dic = dic[@"data"];
                    data.user.currencyCode = kSaftToNSString(dic[@"currencyCode"]);
                    data.user.currencyShortName = kSaftToNSString(dic[@"currencyEnName"]);
                    data.user.settlementCurrencyName = kSaftToNSString(dic[@"currencyName"]);
                    
                    NSString *_fileHttpUrl = [kSaftToNSString(dic[@"fileHttpUrl"]) lowercaseString];
                    if ([_fileHttpUrl hasPrefix:@"http"]) {
                        data.user.fileHttpUrl = kSaftToNSString(dic[@"fileHttpUrl"]);
                    }else
                    {
                        data.user.fileHttpUrl = [@"http://" stringByAppendingString:kSaftToNSString(dic[@"fileHttpUrl"])];
                    }
                    
                    data.user.minPointToInvest = [kSaftToNSString(dic[@"integralToInvestMinimum"]) doubleValue];
                    data.user.minHSDTransferToCash = [kSaftToNSString(dic[@"hsbTransferToCashMinimum"]) doubleValue];
                    data.user.minHSDTransferToConsume = [kSaftToNSString(dic[@"hsbTransferToConsumeMinimum"]) doubleValue];
                    data.user.minPointToCashAmount = [kSaftToNSString(dic[@"integralToCashMinimum"]) doubleValue];
                    data.user.minCashTransferToBank = [kSaftToNSString(dic[@"cashTransferToBank"]) doubleValue];
                    
                    data.user.pointToCashRate = [kSaftToNSString(dic[@"integralToCashRate"]) doubleValue];
                    data.user.pointToHSDRate = [kSaftToNSString(dic[@"integralTransferToHsbRate"]) doubleValue];
                    data.user.hsdToCashRate = [kSaftToNSString(dic[@"hsbTransferToCashRate"]) doubleValue];
                    data.user.hsdToCashCurrencyConversionFee = [kSaftToNSString(dic[@"currencyConversionFee"]) doubleValue];
                    
                    data.user.dailyBuyHsbMaxmum = [kSaftToNSString(dic[@"dailyBuyHsbMaxmum"]) doubleValue];
                    data.user.notRegisteredBuyHsbMaxmum = [kSaftToNSString(dic[@"notRegisteredBuyHsbMaxmum"]) doubleValue];
                    data.user.notRegisteredBuyHsbMinimum = [kSaftToNSString(dic[@"notRegisteredBuyHsbMinimum"]) doubleValue];
                    data.user.registeredBuyHsbMaxmum = [kSaftToNSString(dic[@"registeredBuyHsbMaxmum"]) doubleValue];
                    data.user.registeredBuyHsbMinimum = [kSaftToNSString(dic[@"registeredBuyHsbMinimum"]) doubleValue];
                    
                    DDLogInfo(@"数据加载完成 reloadData");
                    [self.tableView reloadData];
                    syncUserInfo = data.user.cardNumber;
                    
                    [self performSelector:@selector(ayncDictionaryOfBank:) withObject:nil afterDelay:0.7f];
                    // 保存用户登录数据
                    GYUserInfoTool * tool = [GYUserInfoTool shareInstance];
                    NSString *imgUrl = kSaftToNSString(data.IMUser.strHeadPic);
                    if (![imgUrl hasPrefix:@"http"]) {
                        imgUrl = [NSString stringWithFormat:@"%@%@", data.tfsDomain, imgUrl];
                    }
                    [tool updataUserHeadPic:imgUrl userID:data.user.cardNumber];
//                    if (pushVCAfterLogin)
//                    {
//                        [self pushVC:pushVCAfterLogin animated:YES];
//                    }
                }else//返回失败数据
                {
                    [self showErrAndLoginWithTitle:nil message:@"返回数据失败。"];
                }
            }else
            {
                [self showErrAndLoginWithTitle:nil message:@"数据结构错误。"];
            }
        }else
        {
            [self showErrAndLoginWithTitle:@"提示" message:[error localizedDescription]];
        }
        if (hud)
        {
            [hud hide:YES afterDelay:1.0f];
        }
    }];
}

- (void)showErrAndLoginWithTitle:(NSString *)title message:(NSString *)message
{
    if (hud)
    {
        [hud removeFromSuperview];
    }
    [UIAlertView showWithTitle:title message:message cancelButtonTitle:kLocalized(@"confirm") otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        data.isLogined = NO;
        [data showLoginInView:self.navigationController.view withDelegate:self isStay:NO];
        [self.tableView reloadData];
    }];
}

- (void)ayncDictionaryOfBank:(id)obj
{
    [data ayncDictionaryOfBank];
}

@end