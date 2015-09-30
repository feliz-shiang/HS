//
//  GYHSViewController.m
//  company
//
//  Created by apple on 14-12-12.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#define kKeyPowerName @"keyName"
#define kKeyPowerIcon @"keyIcon"
#define kKeyNextVcName @"keyNextVcName"

#import "GYHSViewController.h"
#import "GlobalData.h"
#import "RTLabel.h"
#import "UIView+CustomBorder.h"
#import "TestViewController.h"

#import "CellTypeImagelabel.h"
#import "CellUserInfo.h"
#import "CellHScrollCell.h"
#import "ViewPower.h"

#import "GYHSAccountsViewController.h"//企业账户
#import "GYAccountOperatingViewController.h"//账户操作
#import "GYCompanyManageViewController.h"//企业信息管理
#import "GYCompanyApplyViewController.h"//企业申报管理
#import "GYCompanyResoureViewController.h"//资源管理

#import "CellTypeImagelabel.h"
#import "CellUserInfo.h"
#import "CellHScrollCell.h"


@interface GYHSViewController ()<RTLabelDelegate, UITableViewDelegate, UITableViewDataSource>
{
    GlobalData *data;   //全局单例
    CellUserInfo *cellUserInfo; //企业信息cell
//    NSArray *arrPowers; //功能列表数组
    CellHScrollCell *cellConvenientEntry;//快捷入口cell
    UIView *vPowers;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GYHSViewController

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
    
    //控制器背景色
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];

    //初始化设置tableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    //自定义返回，手势失效的问题
    if (kSystemVersionGreaterThanOrEqualTo(@"7.0"))
    {
        self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    }
    
    //初始化全局单例
    data = [GlobalData shareInstance];
    
    //注册cell以复用
    [self.tableView registerNib:[UINib nibWithNibName:data.currentDeviceScreenInch == kDeviceScreenInch_3_5 ?  @"CellTypeImagelabel_35" : @"CellTypeImagelabel" bundle:kDefaultBundle]
         forCellReuseIdentifier:kCellTypeImagelabelIdentifier];
    cellUserInfo = [[[NSBundle mainBundle] loadNibNamed:data.currentDeviceScreenInch == kDeviceScreenInch_3_5 ? @"CellUserInfo_35" : @"CellUserInfo" owner:self options:nil] lastObject];
    cellConvenientEntry = [[[NSBundle mainBundle] loadNibNamed:@"CellHScrollCell" owner:self options:nil] lastObject];
    
    NSMutableArray *mPowers = [@[@{kKeyPowerIcon: @"cell_image_company_info",
                   kKeyPowerName: kLocalized(@"company_information_manage"),
                   kKeyNextVcName: NSStringFromClass([GYCompanyManageViewController class])
                   },
                 @{kKeyPowerIcon: @"cell_image_company_accouts",
                   kKeyPowerName: kLocalized(@"company_account"),
                   kKeyNextVcName: NSStringFromClass([GYHSAccountsViewController class])
                   },
                 @{kKeyPowerIcon: @"cell_image_company_accout_operation",
                   kKeyPowerName: kLocalized(@"account_operating"),
                   kKeyNextVcName: NSStringFromClass([GYAccountOperatingViewController class])
                   }
                   ] mutableCopy];
    
    switch (data.user.companyType)
    {
        case kCompanyType_Trustcom:
            [mPowers addObjectsFromArray:@[@{kKeyPowerIcon: @"cell_image_company_opration",
                                            kKeyPowerName: kLocalized(@"operation"),
                                            kKeyNextVcName: NSStringFromClass([TestViewController class])
                                            },
                                          @{kKeyPowerIcon: @"cell_image_company_resource_manage",
                                            kKeyPowerName: kLocalized(@"resource_manage"),
                                            kKeyNextVcName: NSStringFromClass([GYCompanyResoureViewController class])
                                            }
                                           ]];
            break;
        case kCompanyType_Membercom:
            
            break;
        case kCompanyType_Servicecom:
            [mPowers addObjectsFromArray:@[@{kKeyPowerIcon: @"cell_image_company_opration",
                                             kKeyPowerName: kLocalized(@"operation"),
                                             kKeyNextVcName: NSStringFromClass([TestViewController class])
                                             },
                                           @{kKeyPowerIcon: @"cell_image_company_resource_manage",
                                             kKeyPowerName: kLocalized(@"resource_manage"),
                                             kKeyNextVcName: NSStringFromClass([GYCompanyResoureViewController class])
                                             },
                                           @{kKeyPowerIcon: @"cellTempimage",
                                             kKeyPowerName: kLocalized(@"report_type"),
                                             kKeyNextVcName: NSStringFromClass([GYCompanyApplyViewController class])
                                             }
                                           ]];
            break;
        default:
            break;
    }
    
    vPowers = [self createPowersView:[NSArray arrayWithArray:mPowers]];
    //兼容IOS6设置背景色
    self.tableView.backgroundView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //设置VC背景色
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    [mPowers removeAllObjects];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    switch (section)
    {
        case 0:
            cellUserInfo = [[[NSBundle mainBundle] loadNibNamed:data.currentDeviceScreenInch == kDeviceScreenInch_3_5 ? @"CellUserInfo_35" : @"CellUserInfo" owner:self options:nil] lastObject];
            
            if (data.user.isRealName &&
                data.user.isPhoneBinding &&
                data.user.isEmailBinding &&
                data.user.isBankBinding
                )//目前不确定资料何为完整
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
                
                cellUserInfo.lbLastLoginInfo.text = kLocalized(@"上次登录时间: 2014-05-25 18:30");
                
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
                cellUserInfo.vTipToInputInfo.text = [NSString stringWithFormat:@"<font size=12 color='#00A2E9'>%@<font size=12 color=red><a href='%@'>%@</a></font>!</font>",
                                                     kLocalized(@"tip_to_perfect_info_pre"),
                                                     NSStringFromClass([TestViewController class]),
                                                     kLocalized(@"tip_to_perfect_info_suf")];
                
                //                cellUserInfo.vTipToInputInfo.lineSpacing = 10.f;
                cellUserInfo.vTipToInputInfo.delegate = self;
            }
            
            cellUserInfo.lbLabelCardNo.text = [NSString stringWithFormat:@"%@  %@",
                                               kLocalized(@"enterprise_manage_number"), [Utils formatCardNo:data.user.resourceNumber]];
            cellUserInfo.lbLabelHello.text = [NSString stringWithFormat:@"%@%@", data.user.cardUserName, kLocalized(@",下午好")];//国际化时注意称呼前后
            
            //加载头像
            //             if (data.user.isNetRegistration)
            //             {
            //                 //                获取用户头像
            //                 //                UIImage *netImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://picURL"]]];
            //                 UIImage *localImage = kLoadPng(@"cell_img_net_user_picture");
            //                 [cellUserInfo.btnUserPicture setImage:localImage
            //                                              forState:UIControlStateNormal];//之后可使用缓存方式处理访问
            //             }else
            //             {
            //                 [cellUserInfo.btnUserPicture setImage:kLoadPng(@"cell_img_noneuserimg")
            //                                              forState:UIControlStateNormal];
            //             }
            
            [cellUserInfo.btnUserPicture setImage:kLoadPng(@"cell_img_noneuserimg")
                                         forState:UIControlStateNormal];
            
            
            //修改头像
            [cellUserInfo.btnUserPicture addTarget:self action:@selector(pushPersonInfo:) forControlEvents:UIControlEventTouchUpInside];
            
            [cellUserInfo addTopBorderAndBottomBorder];
            cell = cellUserInfo;
            break;
            
        case 1:
            [cellConvenientEntry addTopBorderAndBottomBorder];
            cell = cellConvenientEntry;
            break;
            
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:@"cellPowersID"];
            if (!cell)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellPowersID"];
            }
            [vPowers addTopBorderAndBottomBorder];
            [cell.contentView addSubview:vPowers];
            break;
            
        default:
            break;
    }
    if (kSystemVersionLessThan(@"7.0"))
    {
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cllh = kDefaultCellHeight;
    
    switch (indexPath.section)
    {
        case 0:
            if (data.currentDeviceScreenInch == kDeviceScreenInch_3_5)
                cllh = 88;
            else
                cllh = 110;
            
            break;
        case 1:
            cllh = 60;
            break;
            
        case 2:
            cllh = vPowers.frame.size.height;
            break;
        default:
            break;
    }
    
    return cllh;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return kDefaultMarginToBounds;
    }else
    {
        return 6;//加上页脚＝16
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) return 30;
    return kDefaultMarginToBounds - 6;
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Table view delegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

//弹出新窗口
- (void)pushVC:(id)sender animated:(BOOL)ani
{
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:sender animated:ani];
    [self setHidesBottomBarWhenPushed:NO];
}

#pragma mark - 用户信息绑定按钮
//实名认证
- (void)pushRealNameVC:(id)sender
{
    //    GYRealNameViewController *vc = kLoadVcFromClassStringName(NSStringFromClass([GYRealNameViewController class]));
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
    //    GYPersonInfoViewController *vc = kLoadVcFromClassStringName(NSStringFromClass([GYPersonInfoViewController class]));
    //    vc.hidesBottomBarWhenPushed=YES;
    //    [self pushVC:vc animated:YES];
}

//创建功能菜单
- (UIView *)createPowersView:(NSArray *)arr
{
    //排除非法情况
    if (!arr) return nil;
    NSUInteger arrCount = arr.count;
    if (arr.count < 1) return nil;
    
    //实例化一个功能图标 用于取得宽度与高度
    ViewPower *vp = [[ViewPower alloc] init];
    CGFloat vpW = CGRectGetWidth(vp.frame);
    CGFloat vpH = CGRectGetHeight(vp.frame);
    CGFloat _vpW = (CGRectGetWidth(self.tableView.frame) - 3 * vpW - 2 * kDefaultMarginToBounds) / 2.0f;//左右图标间距
    
    //3个图标为一行，计算有几行
    NSUInteger rows = 0;
    if (arrCount % 3 > 0)
    {
        rows = arrCount / 3 + 1;
    }else
    {
        rows = arrCount / 3;
    }
    UIView *pView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                            CGRectGetWidth(self.tableView.frame),
                                                            rows * vpH)];
    [pView setBackgroundColor:[UIColor whiteColor]];
    
    //创建所有的功能图标
    NSDictionary *dic = nil;
    for (int r = 0; r < rows; r++)
    {
        for (int i = 0; i < 3; i++)
        {
            int index = r * 3 + i;
            if (index >= arrCount) break;
            dic = arr[index];
            vp = [[ViewPower alloc] init];
            vp.ivPower.image = kLoadPng(dic[kKeyPowerIcon]);
            vp.lbPowerName.text = dic[kKeyPowerName];
            vp.strNextVcName = dic[kKeyNextVcName];
            
            [vp setFrame:CGRectMake(kDefaultMarginToBounds + i * _vpW + vpW * i,
                                    r * vpH,
                                    vpW,
                                    vpH)];
            [vp.lbPowerName setTextColor:kCellItemTitleColor];
            [vp addTarget:self action:@selector(powerOnClick:) forControlEvents:UIControlEventTouchUpInside];
            [pView addSubview:vp];
        }
    }
    return pView;
}

- (void)powerOnClick:(id)sender
{
    ViewPower *power = sender;
    UIViewController *vc = kLoadVcFromClassStringName(power.strNextVcName);
    vc.navigationItem.title = power.lbPowerName.text;
    [self pushVC:vc animated:YES];
}

#pragma mark - RTLabelDelegate
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL *)url
{
    //    UIViewController *vc = kLoadVcFromClassStringName(url.path);
    //    vc.hidesBottomBarWhenPushed=YES;
    //    [self pushVC:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
