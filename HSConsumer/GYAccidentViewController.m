//
//  GYAccidentViewController.m
//  HSConsumer
//
//  Created by 00 on 14-10-20.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYAccidentViewController.h"
#import "GYDieViewController.h"
#import "GYMedicalViewController.h"
#import "UIView+CustomBorder.h"
#import "Animations.h"
// 意外伤害保障条款
#import "GYAccidentInfoController.h"
@interface GYAccidentViewController ()
{
    NSInteger applyType;
    
    __weak IBOutlet UIScrollView *scvAccident;//scrollView

    __weak IBOutlet UIView *vContent;//保障内容底图
    __weak IBOutlet UILabel *lbContentTitle;//保障内容标题
    __weak IBOutlet UILabel *lbContent;//保障内容
    __weak IBOutlet UILabel *lbTimeTitle;//有效时间标题
    __weak IBOutlet UILabel *lbTime;//有效时间
    
    __weak IBOutlet UIView *vApply;//申请底图
    __weak IBOutlet UILabel *lbApplyTitle;//申请标题
    __weak IBOutlet UILabel *lbSafeguardTitle;//保障金标题
    __weak IBOutlet UILabel *lbDie;//身故保障金
    __weak IBOutlet UILabel *lbMedical;//医疗保障金
    
    __weak IBOutlet UILabel *lbExplainTitle; //说明标题
    __weak IBOutlet UILabel *lbExplainContent1;//保障内用第一点
    __weak IBOutlet UILabel *lbExplainContent2;//保障内容第二点
    
    
    __weak IBOutlet UIImageView *imgWarn;
    __weak IBOutlet UILabel *lbWarn;
    
    __weak IBOutlet UIButton *btnApply;
    BOOL isCanCommit;
    
    IBOutlet UILabel *lbLabelTip;
}

@property (weak, nonatomic) IBOutlet UIButton *btnDie;

@property (weak, nonatomic) IBOutlet UIButton *btnMedical;
@property (weak, nonatomic) IBOutlet UIView *vBack;
@property (assign,nonatomic) NSInteger reasonCode;
// add by songjk “互生意外伤害保障条款”链接
@property (weak, nonatomic) IBOutlet UIButton *btnAccidentInfoShow;

@end

@implementation GYAccidentViewController
//身故保障金
- (IBAction)btnDie:(id)sender {
    [self.btnDie setImage:[UIImage imageNamed:@"btn_round_click.png"] forState:UIControlStateNormal];
    
    [self.btnMedical setImage:[UIImage imageNamed:@"btn_round_noclick.png"] forState:UIControlStateNormal];
    applyType = 0;
    
}
//医疗保障金
- (IBAction)btnMedical:(id)sender {
    [self.btnMedical setImage:[UIImage imageNamed:@"btn_round_click.png"] forState:UIControlStateNormal];
    
    [self.btnDie setImage:[UIImage imageNamed:@"btn_round_noclick.png"] forState:UIControlStateNormal];
    applyType = 1;
}


- (IBAction)btnApplyClick:(id)sender
{
    if (![[GlobalData shareInstance].personInfo.phoneFlag isEqualToString:@"Y"]) {
        [Utils showMessgeWithTitle:@"提示" message:@"请先完成手机号码绑定." isPopVC:nil];
        return;
    }
    if (![[GlobalData shareInstance].personInfo.verifyStatus isEqualToString:@"Y"]) {
        [Utils showMessgeWithTitle:@"提示" message:@"请先完成实名认证." isPopVC:nil];
        return;
    }
    
    if (applyType > 2) { // 1为自己申请 0为待他人申请
        UIAlertView * av = [[UIAlertView alloc] initWithTitle:nil message:kLocalized(@"please_select_services") delegate:self cancelButtonTitle:kLocalized(@"confirm") otherButtonTitles:nil, nil];
        [av show];
        return;

    }else{
        switch (applyType) {
            case 0:
            {
                GYDieViewController *vcDie = [[GYDieViewController alloc] init];
                vcDie.title = lbDie.text;
                [self setHidesBottomBarWhenPushed:YES];
                
                [self.navigationController pushViewController:vcDie animated:YES];
            }
                break;
            case 1:
            {
                // add by songjk 实名注册成功后的消费积分才参与达成互生意外伤害条件的累计。
                if (![GlobalData shareInstance].user.isRealNameRegistration)
                {
                    [Utils showMessgeWithTitle:@"提示" message:@"请先完成实名注册." isPopVC:nil];
                    return;
                }
                if (!isCanCommit)
                {
                    if (self.reasonCode == 1)
                    {
                        [Utils showMessgeWithTitle:@"提示" message:@"你的积分累计未达300PV，暂不符合赠送保障条件。" isPopVC:nil];
                    }
                    else if (self.reasonCode == 200)
                    {
                        NSString *string;
                        if ([[GlobalData shareInstance].personInfo.creType isEqualToString:@"3"]) {////营业执照
                            string=@"互生卡注册身份类型为企业的，不享受平台提供给消费者的相关积分福利。";
                            
                        } else {
                            string = @"您未获得意外伤害保障资格！";
                            
                        }
                        [Utils showMessgeWithTitle:@"提示" message:string isPopVC:nil];
                    }
                    return;
                }
                GYMedicalViewController *vcMedica = [[GYMedicalViewController alloc] init];
                vcMedica.title = @"意外伤害保障金";
                [self setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:vcMedica animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        applyType = 100;
    }
    return self;
}
// add by songjk
- (IBAction)btnAccidentShowClick {
    NSLog(@"互生意外伤害保障条款");
    GYAccidentInfoController * vc = [[GYAccidentInfoController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // add by songjk
    [self.btnAccidentInfoShow setTitle:@"互生意外伤害保障条款" forState:UIControlStateNormal];
    //国际化
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    
    self.title = kLocalized(@"accident_harm_security");
    lbContentTitle.text = kLocalized(@"security_content");
    lbTimeTitle.text = kLocalized(@"valid_time");
    lbApplyTitle.text = kLocalized(@"apply_for_1");
    lbSafeguardTitle.text = kLocalized(@"security");
    lbDie.text = kLocalized(@"apply_for_death_benefits");
    lbMedical.text = kLocalized(@"apply_for_medical_insurance");
    lbExplainTitle.text = kLocalized(@"security_instruction");
    
    [btnApply setTitle:@"立即申请" forState:UIControlStateNormal];
    
    //添加边框
    [vContent addAllBorder];
    [vApply addAllBorder];
    btnApply.layer.cornerRadius = 4.0;
    
    [lbLabelTip setTextColor:kCellItemTitleColor];
    lbLabelTip.text = @"";
    isCanCommit = NO;
    [self get_person_welf_qualification];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)showResultView:(int)type andPv:(NSInteger )pv
{
    lbWarn.font = [UIFont systemFontOfSize:17];
    if (type == 1)//有资格  判断当前这个用户的积分消费有没有300
    {
//        if(pv<300)////未达到300PV
//        {
        isCanCommit = YES;
//        scvAccident.frame = CGRectMake(scvAccident.frame.origin.x, scvAccident.frame.origin.y - 41, scvAccident.frame.size.width, scvAccident.frame.size.height+41);
        lbWarn.text = @"1、您已获得平台赠送的意外伤害保障资格；\n2、互生卡实名注册成功次日零点起每年内累计积分总数达到300分以上获得本意外伤害保障；\n3、互生卡未实名注册期间产生的积分不作为本保障所参考的积分累计范畴；\n4、互生卡注册身份类型为企业的，不享受平台提供给消费者的相关积分福利；\n5、凡存在虚构交易恶意刷积分、利用慈善名义为持卡受益人募集积分等非正常积分行为，平台不予以保障；同时还将追究所有参与方（持卡人和提供积分企业）的一切法律责任。";
//        }else{
//         lbWarn.text = @"互生卡注册身份类型为企业的，不享受平台提供给消费者的相关积分福利。";
//        }
////
        CGSize warnSize = [Utils sizeForString:lbWarn.text font:[UIFont systemFontOfSize:17] width:lbWarn.frame.size.width];
        lbWarn.frame = CGRectMake(lbWarn.frame.origin.x, lbWarn.frame.origin.y, warnSize.width, warnSize.height);
        NSLog(@"%f",_vBack.frame.size.height);
        NSLog(@"%f",_vBack.frame.origin.y);
//        self.vBack.frame = CGRectMake(0, CGRectGetMaxY(lbWarn.frame)+16, kScreenWidth, self.vBack.frame.size.height);
//        scvAccident.contentSize = CGSizeMake(320, CGRectGetMaxY(self.vBack.frame));
    }else if (type == 2)//已经享受医疗补贴 没有资格
    {
        if ([[GlobalData shareInstance].personInfo.creType isEqualToString:@"3"]) {////营业执照
            lbWarn.text=@"互生卡注册身份类型为企业的，不享受平台提供给消费者的相关积分福利。";
            
        } else {
            lbWarn.text = @"您未获得意外伤害保障资格！";
            
        }
//        scvAccident.hidden = YES;
//        lbWarn.text = @"1、您未获得意外伤害保障资格！\n2、互生卡注册身份类型为企业的，不享受平台提供给消费者的相关积分福利。";
        CGSize warnSize = [Utils sizeForString:lbWarn.text font:[UIFont systemFontOfSize:17] width:lbWarn.frame.size.width];
        lbWarn.frame = CGRectMake(lbWarn.frame.origin.x, lbWarn.frame.origin.y, warnSize.width, warnSize.height);
//        self.vBack.frame = CGRectMake(0, CGRectGetMaxY(lbWarn.frame)+16, kScreenWidth, self.vBack.frame.size.height);
//         self.vBack.frame = CGRectMake(0, CGRectGetMaxY(lbWarn.frame)+16, kScreenWidth, self.vBack.frame.size.height);
    }
  scvAccident.contentSize = CGSizeMake(320, lbWarn.frame.origin.y+lbWarn.frame.size.height);
    NSLog(@"%f",scvAccident.contentSize.height);
}

//设置边框函数
-(void)setBorderWithView:(UIView*)view WithWidth:(CGFloat)width WithRadius:(CGFloat)radius WithColor:(CGColorRef)color
{
    view.layer.borderWidth = width;
    view.layer.borderColor = color;
    view.layer.cornerRadius = radius;
}
#pragma mark   网络请求
- (void)get_person_welf_qualification
{
    GlobalData *data = [GlobalData shareInstance];
    NSDictionary *subParas = @{@"resource_no": data.user.cardNumber
                               };
    
    NSDictionary *allParas = @{@"system": @"person",
                               @"cmd": @"get_person_welf_qualification",
                               @"params": subParas,
                               @"uType": kuType,
                               @"mac": kHSMac,
                               @"mId": data.midKey,
                               @"key": data.hsKey
                               };
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    [self.navigationController.view addSubview:hud];
    hud.labelText = @"初始化数据...";
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
                    (kSaftToNSInteger(dic[@"data"][@"resultCode"]) == kHSRequestSucceedSubCode))//返回成功数据
                {
                    dic =  dic[@"data"][@"welfQualification"];
                    NSString *welfCold = kSaftToNSString(dic[@"welfCode"]);
                    if ([welfCold isEqualToString:@"100"])
                    {
                        CGFloat i1 = kSaftToCGFloat(dic[@"startDate"]);
                        NSDate *startDate = [NSDate dateWithTimeIntervalSince1970: i1 / 1000];
                        i1 = kSaftToCGFloat(dic[@"expireDate"]);
                        NSString *endDateStr = @"  --";
                        if (i1 > 0)
                        {
                            NSDate *endDate = [NSDate dateWithTimeIntervalSince1970: i1 / 1000];
                            endDateStr = [Utils dateToString:endDate dateFormat:@"yyyy-MM-dd"];
                        }
                        [lbTime setText:[NSString stringWithFormat:@"%@至%@",
                                         [Utils dateToString:startDate dateFormat:@"yyyy-MM-dd"],
                                         endDateStr
                                         ]];
                        self.reasonCode = 100;
                        [self showResultView:1 andPv:[dic[@"accuPoints"]integerValue]];
                    }else if ([welfCold isEqualToString:@"200"])
                    {
                        self.reasonCode = 200;
                        [self showResultView:2 andPv:[dic[@"accuPoints"]integerValue]];
                    }
                }else//返回失败数据
                {
                    if (kSaftToNSInteger(dic[@"data"][@"resultCode"]) == 1) // 没有资格
                    {
                        self.reasonCode = 1;
                        [self showResultView:2 andPv:[dic[@"accuPoints"]integerValue]];
                    }
                    else
                        [Utils showMessgeWithTitle:nil message:@"查询资格信息失败。" isPopVC:self.navigationController];
                }
            }else
            {
                [Utils showMessgeWithTitle:nil message:@"查询资格信息失败。" isPopVC:self.navigationController];
            }
            
        }else
        {
            [Utils showMessgeWithTitle:@"提示" message:[error localizedDescription] isPopVC:self.navigationController];
        }
        if (hud.superview)
        {
            [hud removeFromSuperview];
        }
    }];
}
@end
