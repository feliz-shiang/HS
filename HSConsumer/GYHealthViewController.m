//
//  GYHealthViewController.m
//  HSConsumer
//
//  Created by 00 on 14-10-20.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYHealthViewController.h"
#import "GYInstructionViewController.h"
#import "GYDatePiker.h"
#import "UIView+CustomBorder.h"
#import "GlobalData.h"
//#import "GYHealthUpLoadPICController.h"
#import "GYHealthUploadImgController.h"


@interface GYHealthViewController ()<UITextFieldDelegate,GYDatePikerDelegate>
{
    
    
    IBOutlet UIView *viewTipBkg;
    IBOutlet UIView *viewContentBkg;
    
    __weak IBOutlet UIScrollView *scvMedical;//scrollView


    __weak IBOutlet UIView *vMedical;//医保行
    __weak IBOutlet UILabel *lbMedical;//医保号标题
    __weak IBOutlet UITextField *tfInputMedical;//输入医保号
    
    __weak IBOutlet UIView *vMedicalStart;//医疗开始行
    __weak IBOutlet UILabel *lbMedicalStart;//医疗开始标题
    __weak IBOutlet UITextField *tfMedicalStartTime;//开始时间
     __weak IBOutlet UIButton *btnSeleSatrtTime;//选择开始时间按钮
    
    __weak IBOutlet UIView *vMedicalStop;//医疗结束行
    __weak IBOutlet UILabel *lbMedicalStop;//医疗结束标题
    __weak IBOutlet UITextField *tfMedicalStopTime;//结束时间
    __weak IBOutlet UIButton *btnSeleStopTime;//选择结束时间按钮

    
    __weak IBOutlet UIView *vCity;//所在城市行
    __weak IBOutlet UILabel *lbCity;//所在城市标题
    __weak IBOutlet UITextField *tfInputCity;//输入所在城市
    
    
    __weak IBOutlet UIView *vHospital;//所在医院行
    __weak IBOutlet UILabel *lbHospital;//所在医院标题
    __weak IBOutlet UITextField *tfInputHospital;//输入所在医院
    
    __weak IBOutlet UIButton *btnInstruction;//说明按钮
    __weak IBOutlet UIButton *btnCommit;//确认按钮

    GYDatePiker *datePicker;//日期选择器
    int btnType;//按钮类型

    
    
    __weak IBOutlet UIImageView *imgWarn;//警告图标
    
    __weak IBOutlet UILabel *lbWarn;//警告文字
    
    MBProgressHUD *hud; // 网络等待弹窗
    
    BOOL isCanCommit;
    
    NSDate * startDate;
    
    NSDate * selectedDate;
}
@end

@implementation GYHealthViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //初始化
        btnType = 100;
    }
    return self;
}

//日期选择按钮，两个btn共用一个按钮
- (IBAction)dataPickerClick:(UIButton *)sender {
    if (sender == btnSeleSatrtTime) {
        btnType = 0;
    }else{
        btnType = 1;
    }
    if (!datePicker) {
        datePicker = [[GYDatePiker alloc] init];
        //[datePicker addAllBorder];
        datePicker.delegate = self;
        [self.view addSubview:datePicker];
        datePicker = nil;
    }
}


//免费医疗计划说明按钮
- (IBAction)btnInstructionClick:(UIButton *)sender {
    GYInstructionViewController *vcInstruction = [[GYInstructionViewController alloc] init];
    vcInstruction.title = kLocalized(@"free_medical");

    vcInstruction.strTitle = kLocalized(@"free_medical_treatment_subsidy_program_instructions");
//    vcInstruction.strContent = @"       消费者积分投资达到1万分以后 , 将享受平台给出的免费医疗补贴计划 ; 免费医疗补贴计划是依托在原个人医保基础上自费部分进行补贴的一种方式。\n\n        平台将消费积分投资收益中提取一定比例的医疗基金 , 建立医疗基金池 , 对有需要的人群进行医疗补贴的方式来过渡 ;随着时间的推移和医疗基金池资金的不断增加 , 平台将全力配合国家的医疗体制改革 , 逐步实现全民的免费医疗计划。\n\n                                        [互生系统平台]\n                                        2013－07－22";
//    vcInstruction.strContent = @"       消费者积分投资达到1万分以后，将享受平台给出的免费医疗补贴计划（不含门诊医疗）。免费医疗补贴计划是依托在原个人医保基础上对自费部分进行补贴的一种方式。平台将消费积分投资收益中提取一定比例的医疗基金，建立医疗基金池，对有需要的人群进行医疗补贴的方式来过渡。随着时间的推移和医疗基金池资金的不断增加，平台将全力配合国家的医疗体制改革，逐步实现全民的免费医疗计划。\n注：凡存在虚构交易恶意刷积分、利用慈善名义为持卡受益人募集积分等非正常积分行为，平台不予以补贴，同时还将追究所有参与方（持卡人和提供积分企业）的一切法律责任。";//20150717修改
    
//    vcInstruction.strContent = @"       消费者积分投资达到1万分以后，将享受平台给出的免费医疗补贴计划（不含门诊医疗）；免费医疗补贴计划是依托在原个人医保基础上对自费部分进行补贴的一种方式。\n       平台将消费积分投资收益中提取一定比例的医疗基金，建立医疗基金池，对有需要的人群进行医疗补贴的方式来过渡；随着时间的推移和医疗基金池资金的不断增加，平台将全力配合国家的医疗体制改革，逐步实现全民的免费医疗计划。\n       注：凡存在虚构交易恶意刷积分、利用慈善名义为持卡受益人募集积分等非正常积分行为，平台不予以补贴，同时还将追究所有参与方（持卡人和提供积分企业）的一切法律责任。";//20150717修改
    vcInstruction.strContent = @"        消费者身份实名注册成功次日零点起，产生的积分投资达到1万分以后，将享受平台给出的免费医疗补贴计划（不含门诊医疗）。免费医疗补贴计划是依托在原个人医保基础上对自费部分进行补贴的一种方式。平台将消费积分投资收益中提取一定比例的医疗基金，建立医疗基金池，对有需要的人群进行医疗补贴的方式来过渡。随着时间的推移和医疗基金池资金的不断增加，平台将全力配合国家的医疗体制改革，逐步实现全民的免费医疗计划。\n       注：凡存在虚构交易恶意刷积分、利用慈善名义为持卡受益人募集积分等非正常积分行为，平台不予以补贴，同时还将追究所有参与方（持卡人和提供积分企业）的一切法律责任。";//20150911 lss修改
   
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vcInstruction animated:YES];
}

//确认提交按钮 点击事件
- (IBAction)btnCommitClick:(id)sender {
    if ([[GlobalData shareInstance].personInfo.creType  isEqualToString:@"3"]) {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:@"提示" message:@"注册证件类型为营业执照，不享受医疗补贴计划!" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [av show];
        return;
    }
    // add by songjk 实名注册成功后的消费积分才参与达成互生意外伤害条件的累计。
    if (![GlobalData shareInstance].user.isRealNameRegistration)
    {
        [Utils showMessgeWithTitle:@"提示" message:@"请先完成实名注册." isPopVC:nil];
        return;
    }
    if (!isCanCommit)
    {
        [Utils showMessgeWithTitle:@"提示" message:@"你的积分投资未达1万PV，暂不符合申请条件。" isPopVC:nil];
        return;
    }
    
    if (![[GlobalData shareInstance].personInfo.phoneFlag isEqualToString:@"Y"])
    {
        
        [Utils showMessgeWithTitle:@"提示" message:@"请先完成手机号码绑定！" isPopVC:nil];
         return ;
    }
    
    if (![[GlobalData shareInstance].personInfo.verifyStatus   isEqualToString:@"Y"])
    {
        
        [Utils showMessgeWithTitle:@"提示" message:@"请先完成实名认证！" isPopVC:nil];
         return ;
    }
    
//    // 校验医保卡号
//    if (!tfInputMedical.text || tfInputMedical.text.length > 10 || tfInputMedical.text.length <6) {
//        UIAlertView * av =[[UIAlertView alloc]initWithTitle:@"提示" message:@"医保号码输入错误！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//        [av show];
//        return;
//        
//    }
    // 校验医保卡号
    if ((tfInputMedical.text && tfInputMedical.text.length>0) && (tfInputMedical.text.length > 10 || tfInputMedical.text.length <6)) {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:@"提示" message:@"医保号码输入错误！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [av show];
        return;
        
    }
    else if(!tfInputMedical.text || tfInputMedical.text.length == 0)
    {
        tfInputMedical.text = @"";
    }
    int  a  =  [self compareOneDay:selectedDate withAnotherDay:startDate];
    NSLog(@"%d======a",a);
    if (a==1) {
        NSLog(@"-----选中的时间，是在返回的开始时间之后 OK");
    }else
    {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:@"提示" message:@"诊疗起始时间错误！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [av show];
        return;
    }
    
    if (tfInputCity.text.length == 0 || tfInputHospital.text.length == 0 ) {
        [self setAlertViewWithMessage:kLocalized(@"please_enter_the_complete_information")];
  
    }else if([tfMedicalStartTime.text compare:tfMedicalStopTime.text] == NSOrderedDescending){
        [self setAlertViewWithMessage:kLocalized(@"input_correct_date")];
    
    }else
    {
        NSDictionary * dictInfo =@{@"healthCardNo":tfInputMedical.text,@"startDate":tfMedicalStartTime.text
                                   ,@"endDate":tfMedicalStopTime.text,@"hospital":tfInputHospital.text
                                   ,@"city":tfInputCity.text};
        GYHealthUploadImgController * vcDetial = [[GYHealthUploadImgController alloc] init];
        vcDetial.dictBaseInfo = dictInfo;
        vcDetial.title = self.title;
        self.navigationController.topViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vcDetial animated:YES];
        self.navigationController.topViewController.hidesBottomBarWhenPushed = NO;
    }

}



//创建警告框
-(void)setAlertViewWithMessage:(NSString *)message
{
    UIAlertView * avCode = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:kLocalized(@"confirm") otherButtonTitles:nil, nil];
    [avCode show];

}

//scrollView内容页面大小
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    startDate = [[NSDate alloc]init];
    //国际化
    self.title = kLocalized(@"health_benefits");
    lbMedical.text = kLocalized(@"medicare_number");
    tfInputMedical.placeholder = kLocalized(@"input_health_number");
    lbMedicalStart.text = kLocalized(@"medical_start_date");
    
    lbMedicalStop.text = kLocalized(@"medical_end_date");
    lbCity.text = kLocalized(@"local_city");
    tfInputCity.placeholder = kLocalized(@"input_city");
    lbHospital.text = kLocalized(@"local_hospital");
    tfInputHospital.placeholder = kLocalized(@"input_hospital");
    [btnInstruction setTitle:[NSString stringWithFormat:@"%@?",kLocalized(@"free_medical_treatment_subsidy_program_instructions")] forState:UIControlStateNormal];
    ////现在页面改变了！这些在获取数据的时候重新要给设置位置的！
//    NSString * strWarning = @" ";//////
//    CGFloat height =[Utils heightForString:strWarning fontSize:13 andWidth:280];
//    
//    CGRect topViewRect =viewTipBkg.frame;
//    topViewRect.size.height=height;
//    viewTipBkg.frame=topViewRect;
//    lbWarn.text = strWarning;
    
//    CGRect bottomViewRect =viewContentBkg.frame;
////    bottomViewRect.origin.y=topViewRect.origin.y+height;
//      bottomViewRect.origin.y=topViewRect.origin.y;
//    viewContentBkg.frame=bottomViewRect;
    //确认提交按钮设置
    btnCommit.layer.cornerRadius = 4.0f;
    btnCommit.titleLabel.text = kLocalized(@"confirm_to_submit");
    [btnCommit setTitle:@"下一步" forState:UIControlStateNormal];
    
    [vMedical addTopBorder];
    [vMedicalStart addTopBorder];
    [vMedicalStart addBottomBorder];
    [vMedicalStop addBottomBorder];
    [vCity addTopBorder];
    [vCity addBottomBorder];
    [vHospital addBottomBorder];
    
    
    tfMedicalStartTime.delegate = self;
    tfMedicalStopTime.delegate = self;
    
    isCanCommit = NO;
    viewTipBkg.hidden = YES;
    viewTipBkg.backgroundColor = kDefaultVCBackgroundColor;
    [self get_person_welf_qualification];
    //add by zhangqy
    [tfInputMedical addTarget:self action:@selector(tfInputMedicalEditingChanged:) forControlEvents:UIControlEventEditingChanged];
}



#pragma mark - GYDatePikerDelegate
//回调函数
-(void)getDate:(NSString *)date WithDate:(NSDate *)date1
{
    if (btnType) {
        tfMedicalStopTime.text = date;
        
    }else{
        tfMedicalStartTime.text = date;
    
        NSString * bbb = [Utils dateToString:date1 dateFormat:@"yyyy-MM-dd"];
        
        NSLog(@"---%@----bbbbbbb",bbb);
        selectedDate = date1;
        
    }
    
    
   
}

//- (void)commit//
//{
//    NSMutableDictionary * dictInside =[[NSMutableDictionary alloc]init];
//    //URL上传的参数
//    [dictInside setValue:[GlobalData shareInstance].user.cardNumber forKey:@"resource_no"];
//    
//    [dictInside setValue:tfInputMedical.text forKey:@"healthCardNo"];
//    [dictInside setValue:tfMedicalStartTime.text forKey:@"startDate"];
//    [dictInside setValue:tfMedicalStopTime.text forKey:@"endDate"];
//    [dictInside setValue:tfInputHospital.text forKey:@"hospital"];
//    [dictInside setValue:tfInputCity.text forKey:@"city"];
//    
//    
//    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
//    //请求对应url的运行cmd
//    
//    [dict setValue:@"person" forKey:@"system"];
//    [dict setValue:@"apply_free_medical" forKey:@"cmd"];
//    [dict setValue:dictInside forKey:@"params"];
//    [dict setValue:kuType forKey:@"uType"];
//    [dict setValue:kHSMac forKey:@"mac"];
//    [dict setValue:[GlobalData shareInstance].midKey forKey:@"mId"];
//    [dict setValue:[GlobalData shareInstance].hsKey forKey:@"key"];
//    
//    hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//    hud.removeFromSuperViewOnHide = YES;
//    hud.dimBackground = YES;
//    [self.navigationController.view addSubview:hud];
//    [hud show:YES];
//    
//    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].hsDomain stringByAppendingString:kHSApiAppendUrl] parameters:(NSDictionary *)dict requetResult:^(NSData *jsonData, NSError *error) {
//        if (!error)
//        {
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                                options:kNilOptions
//                                                                  error:&error];
//            if (!error)
//            {
//                if ([kSaftToNSString(dic[@"code"]) isEqualToString:kHSRequestSucceedCode] &&
//                    dic[@"data"] &&
//                    (kSaftToNSInteger(dic[@"data"][@"resultCode"]) == kHSRequestSucceedSubCode))//返回成功数据
//                {
//                    [Utils showMessgeWithTitle:nil message:@"提交申请成功." isPopVC:self.navigationController];
//
//                }else//返回失败数据
//                {
//                    [Utils showMessgeWithTitle:nil message:@"提交申请失败." isPopVC:self.navigationController];
//                }
//            }else
//            {
//                [Utils showMessgeWithTitle:nil message:@"提交申请失败." isPopVC:self.navigationController];
//            }
//            
//        }else
//        {
//            [Utils showMessgeWithTitle:@"提示" message:[error localizedDescription] isPopVC:nil];
//        }
//        if (hud.superview)
//        {
//            [hud removeFromSuperview];
//        }
//    }];
//}

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
    
    hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
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
//                if ([kSaftToNSString(dic[@"code"]) isEqualToString:kHSRequestSucceedCode] &&
//                    dic[@"data"] &&
//                    (kSaftToNSInteger(dic[@"data"][@"resultCode"]) == kHSRequestSucceedSubCode))//返回成功数据
//                {
                /////更改最新的返回内容
                if ([kSaftToNSString(dic[@"code"]) isEqualToString:kHSRequestSucceedCode] &&
                    dic[@"data"])//返回成功数据
                {
                    dic =  dic[@"data"][@"welfQualification"];
                    NSString *welfCold = kSaftToNSString(dic[@"welfCode"]);
//                    if ([welfCold isEqualToString:@"200"])
//                    {
                        isCanCommit = YES;
                        viewTipBkg.hidden = NO;
                        NSTimeInterval ti = [kSaftToNSString(dic[@"startDate"]) doubleValue] / 1000;
                        startDate = [NSDate dateWithTimeIntervalSince1970:ti];
                        NSLog(@"%@-----bbbb",startDate);
                        NSString * strWarningTip ;
                        
                        if ([welfCold isEqualToString:@"200"]) {////有资格
                            strWarningTip = @"1、您已获得平台赠送的免费医疗补贴计划资格;\n2、互生卡实名注册成功次日零点起累计投资积分总数达到10000分以上获得本医疗补贴(不含门诊医疗);\n3、互生卡未实名注册期间产生的积分投资不作为本保障所参考的积分投资累计范畴;\n4、互生卡注册身份类型为企业的，不享受平台提供给消费者的相关积分福利;\n5、凡存在虚构交易恶意刷积分、利用慈善名义为持卡受益人募集积分等非正常积分行为，平台不予以补贴，同时还将追究所有参与方(持卡人和提供积分企业)的一切法律责任。";
                        } else if ([welfCold isEqualToString:@"100"]) {///没资格
                            btnCommit.hidden=YES;
                            strWarningTip =@"1、您未获得平台赠送的免费医疗补贴计划资格;\n2、互生卡实名注册成功次日零点起累计投资积分总数达到10000分以上获得本医疗补贴(不含门诊医疗);\n3、互生卡未实名注册期间产生的积分投资不作为本保障所参考的积分投资累计范畴;\n4、互生卡注册身份类型为企业的，不享受平台提供给消费者的相关积分福利;\n5、凡存在虚构交易恶意刷积分、利用慈善名义为持卡受益人募集积分等非正常积分行为，平台不予以补贴，同时还将追究所有参与方(持卡人和提供积分企业)的一切法律责任。";
                        }
                       else if([[GlobalData shareInstance].personInfo.creType isEqualToString:@"3"])
                        {
                             strWarningTip =@"互生卡注册身份类型为企业的，不享受平台提供给消费者的相关积分福利。";
                        }
                       else{//////先这么写  担心又有要改游戏规则！！liss
                           btnCommit.hidden=YES;
                           strWarningTip =@"1、您未获得平台赠送的免费医疗补贴计划资格;\n2、互生卡实名注册成功次日零点起累计投资积分总数达到10000分以上获得本医疗补贴(不含门诊医疗);\n3、互生卡未实名注册期间产生的积分投资不作为本保障所参考的积分投资累计范畴;\n4、互生卡注册身份类型为企业的，不享受平台提供给消费者的相关积分福利;\n5、凡存在虚构交易恶意刷积分、利用慈善名义为持卡受益人募集积分等非正常积分行为，平台不予以补贴，同时还将追究所有参与方(持卡人和提供积分企业)的一切法律责任。";
                       
                       }
                        lbWarn.frame=CGRectMake(37, 345, self.view.bounds.size.width-37-10, 20);
                        CGFloat height =[Utils heightForString:strWarningTip fontSize:13 andWidth:280];
                        CGRect lbFrame = lbWarn.frame;
                        lbFrame.size.height = height+10;////
                        lbWarn.frame = lbFrame;
                        lbWarn.text = strWarningTip;
                        
                        CGRect topViewRect =viewTipBkg.frame;
                        topViewRect.size.height=44;
                        viewTipBkg.frame=topViewRect;
                        CGRect bottomViewRect =viewContentBkg.frame;
                        bottomViewRect.origin.y=topViewRect.origin.y+50;
                        viewContentBkg.frame=bottomViewRect;
                        scvMedical.contentSize = CGSizeMake(320, lbWarn.frame.size.height+lbWarn.frame.origin.y);
                        
//                    }else
//                    {
//                        [viewContentBkg moveX:0 moveY:44 - 16];
//                         viewTipBkg.hidden = NO;
//                    }
                }else//返回失败数据
                {
                    if (kSaftToNSInteger(dic[@"data"][@"resultCode"]) == 1)
                    {
                        [viewContentBkg moveX:0 moveY:44 - 16];
                        viewTipBkg.hidden = NO;
                        imgWarn.hidden=YES;

                    }else
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




-(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
    
}

//add by zhangqy  医保卡号长度校验
- (void)tfInputMedicalEditingChanged:(UITextField*)textField
{
    if (textField.text.length>10) {
        textField.text = [textField.text substringToIndex:10];
    }
}



@end
