//
//  GYMyInfoViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-16.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYMyInfoViewController.h"
#import "GYMyInfoTableViewCell.h"
#import "GYChangeLoginPwdViewController.h"

#import "GYGetGoodViewController.h"
//用户个人信息的model
#import "UserData.h"
#import "GYCardBandingViewController.h"
#import "GYCardBandingViewController3.h"
#import "GlobalData.h"
#import "GYSetupPasswdQuestionViewController.h"
#import "GYPhoneBandingViewController.h"
#import "GYEmailBandingViewController.h"

#import "GYSecurityVerifyViewController.h"
//实名注册认证
#import "GYRegisterAuthViewController.h"
//重要信息变更
#import "GYImportantChangeViewController.h"
//重要信息变更处理中
#import "GYImportantChangeWarmingViewController.h"

//测试
#import "GYQuitEmailBandingViewController.h"
#import "GYQuitPhoneBandingViewController.h"
#import "GYQuitPhoneBandingDetailViewController.h"
//个人信息
#import "GYPersonDetailInfoViewController.h"
//实名注册
#import "GYRealNameRegisterViewController.h"
//#import "GYModifyBandingPhoneDetailViewController.h"
//卡信息绑定
#import "GYCardInfoBandViewController.h"
//没有注册进入重要信息绑定的页面
#import "GYNoImportantChangeViewController.h"

//添加下拉刷新
#import "MJRefresh.h"

#import "GYNoAuthNoImportantChangeVC.h"
#define sectionNumber 4
@interface GYMyInfoViewController ()

@end

@implementation GYMyInfoViewController
{
    
    GlobalData *data;//获取单例对象调用通用方法
    BOOL already;
    UserData * UserDataModel;
    
}

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
    //设置标题
    self.title=kLocalized(@"my_profile");
    
    data = [GlobalData shareInstance];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadPersonDataRequest) name:@"refreshPersonInfo" object:nil];
    
    
    //cell title数组
    _titleArr =@[kLocalized(@"card_info_banding"),kLocalized(@"realname_register_auth"),kLocalized(@"important_informatiron_change"),kLocalized(@"my_receive_addresss"),kLocalized(@"pwd_change"),kLocalized(@"pwd_prompt_question")];
    //cell 图片数组
    _imgArr=@[@"cell_img_realname_register.png",@"cell_img_real_name_authentication.png",@"cell_img_change_important_info.png"
              ,@"cell_img_shipping_address_manage.png",@"cell_img_change_login_pwd.png",@"cell_question_answer.png"];
    
    //根据不同屏幕适配，对应的cell
    [_MyInfoTableView registerNib:[UINib nibWithNibName:data.currentDeviceScreenInch == kDeviceScreenInch_3_5 ?  @"GYMyInfoTableViewCell_35" : @"GYMyInfoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    UIView* bview = [[UIView alloc] init];
    bview.backgroundColor = kDefaultVCBackgroundColor;
    [_MyInfoTableView setBackgroundView:bview];
    
    UserDataModel = data.user;
    
    if ([GlobalData shareInstance].user.cardNumber.length>3) {
        
        [ self loadPersonDataRequest];
        
    }
    
    
}


//加载网络数据
-(void)loadPersonDataRequest
{
    if (![GlobalData shareInstance].isLogined) {
        return;
    }
    NSMutableDictionary * dictInside =[[NSMutableDictionary alloc]init];
    
    [dictInside setValue:[GlobalData shareInstance].user.cardNumber forKey:@"resource_no"];
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    
    [dict setValue:dictInside forKey:@"params"];
    
    [dict setValue:[GlobalData shareInstance].hsKey forKey:@"key"];
    
    
    [dict setValue:@"person" forKey:@"system"];
    
    [dict setValue:kuType forKey:@"uType"];
    
    [dict setValue:kHSMac forKey:@"mac"];
    
    [dict setValue:[GlobalData shareInstance].midKey forKey:@"mId"];
    
    [dict setValue:@"get_person_base_info" forKeyPath:@"cmd"];
    
    
    //测试get
    
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].hsDomain stringByAppendingString:@"/api"] parameters:(NSDictionary *)dict requetResult:^(NSData *jsonData, NSError *error) {
        
        
        if (!error) {
            
            
            NSDictionary *ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            
            
            if (!error) {
                
                NSString * code =[NSString  stringWithFormat:@"%@",ResponseDic[@"code"]];
                
                
                if ([[Utils GetResultCode:ResponseDic] isEqualToString:@"0"]&&[code isEqualToString:@"SVC0000"]&&[GlobalData shareInstance].isLogined) {
                    
                    
                    
                    [GlobalData shareInstance].personInfo.baseStatus=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"baseInfo"][@"baseStatus"]);
                    [GlobalData shareInstance].personInfo.cardRemakableStatus=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"baseInfo"][@"cardRemakableStatus"]);
                    [GlobalData shareInstance].personInfo.cardRemakeStatus=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"baseInfo"][@"cardRemakeStatus"]);
                    [GlobalData shareInstance].personInfo.custId=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"baseInfo"][@"custId"]);
                    data.personInfo.custName=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"baseInfo"][@"custName"]);
                    [GlobalData shareInstance].personInfo.emailFlag=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"baseInfo"][@"emailFlag"]);
                    [GlobalData shareInstance].personInfo.payStatus=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"baseInfo"][@"payStatus"]);
                    [GlobalData shareInstance].personInfo.phoneFlag=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"baseInfo"][@"phoneFlag"]);
                    [GlobalData shareInstance].personInfo.pvFlag=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"baseInfo"][@"pvFlag"]);
                    
                    [GlobalData shareInstance].personInfo.pvNotGetPeriod=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"baseInfo"][@"pvNotGetPeriod"]);
                    [GlobalData shareInstance].personInfo.regStatus=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"baseInfo"][@"regStatus"]);
                    [GlobalData shareInstance].personInfo.resNo=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"baseInfo"][@"resNo"]);
                    [GlobalData shareInstance].personInfo.statusDate=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"baseInfo"][@"statusDate"]);
                    [GlobalData shareInstance].personInfo.verifyStatus=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"baseInfo"][@"verifyStatus"]);
                    [GlobalData shareInstance].personInfo.birthAddress=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"birthAddress"]);
                    [GlobalData shareInstance].personInfo.country=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"country"]);
                    [GlobalData shareInstance].personInfo.creBackImg=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"creBackImg"]);
                    [GlobalData shareInstance].personInfo.creExpiryDate=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"creExpiryDate"]);
                    [GlobalData shareInstance].personInfo.creFaceImg=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"creFaceImg"]);
                    [GlobalData shareInstance].personInfo.creHoldImg=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"creHoldImg"]);
                    
                    [GlobalData shareInstance].personInfo.creNo=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"creNo"]);
                    [GlobalData shareInstance].personInfo.creType=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"creType"]);
                    [GlobalData shareInstance].personInfo.creVerifyOrg=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"creVerifyOrg"]);
                    [GlobalData shareInstance].personInfo.created=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"created"]);
                    [GlobalData shareInstance].personInfo.createdBy=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"createdBy"]);
                    [GlobalData shareInstance].personInfo.custId=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"custId"]);
                    [GlobalData shareInstance].personInfo.email=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"email"]);
                    [GlobalData shareInstance].personInfo.ensureInfo=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"ensureInfo"]);
                    [GlobalData shareInstance].personInfo.homeAddrPostcode=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"homeAddrPostcode"]);
                    
                    [GlobalData shareInstance].personInfo.homeAddress=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"homeAddress"]);
                    [GlobalData shareInstance].personInfo.homePhone=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"homePhone"]);
                    [GlobalData shareInstance].personInfo.isActive=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"isActive"]);
                    [GlobalData shareInstance].personInfo.mobile=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"mobile"]);
                    [GlobalData shareInstance].personInfo.nationality=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"nationality"]);
                    [GlobalData shareInstance].personInfo.profession=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"profession"]);
                    [GlobalData shareInstance].personInfo.pwdAnswer=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"pwdAnswer"]);
                    [GlobalData shareInstance].personInfo.pwdQuestNo=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"pwdQuestNo"]);
                    [GlobalData shareInstance].personInfo.sex=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"sex"]);
                    [GlobalData shareInstance].personInfo.updated=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"updated"]);
                    [GlobalData shareInstance].personInfo.updatedBy=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"updatedBy"]);
                    [GlobalData shareInstance].personInfo.verifyRemark=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"verifyRemark"]);
                    
                    [GlobalData shareInstance].personInfo.importantInfoStatus=kSaftToNSString(ResponseDic[@"data"][@"importantInfoStatus"]);
                           [GlobalData shareInstance].personInfo.verifyAppReason=kSaftToNSString(ResponseDic[@"data"][@"verifyAppReason"]);
                    
                    
                    //                        data.user.isRealName = ([[kSaftToNSString(dic[@"isAuth"]) lowercaseString] isEqualToString:@"y"] ? YES : NO);
                    //                        data.user.isBankBinding = ([[kSaftToNSString(dic[@"isBindBank"]) lowercaseString] isEqualToString:@"y"] ? YES : NO);
                    //                        data.user.isEmailBinding = ([[kSaftToNSString(dic[@"isBindEmail"]) lowercaseString] isEqualToString:@"y"] ? YES : NO);
                    //                        data.user.isPhoneBinding = ([[kSaftToNSString(dic[@"isBindMobile"]) lowercaseString] isEqualToString:@"y"] ? YES : NO);
                    //                        data.user.isRealNameRegistration = ([[kSaftToNSString(dic[@"isReg"]) lowercaseString] isEqualToString:@"y"] ? YES : NO);
                    //                        data.user.pointAccBal = [kSaftToNSString(dic[@"residualIntegral"]) doubleValue];
                    //
                }
                
                
                
            }
            
        }
        
    }];
    
    
}





#pragma mark TableViewDateSourceDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (data.currentDeviceScreenInch)
    {
        case kDeviceScreenInch_3_5:
            
            return kDefaultCellHeight3_5inch;//kDefaultCellHeight//kDefaultCellHeight3_5inch
            
            break;
        case kDeviceScreenInch_4_0:
        default:
            
            return kDefaultCellHeight;
            
            break;
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 4;
    }else{
        
        return 2;
    }
    
};

//组头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 16.0f;
    }else{
        return 1.0f;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 30.0f;
    }else{
        return 15.0f;
    }
    
}

//绘制每一个单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifer=@"cell";
    //从缓存队列中 弹出可用的cell
    GYMyInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell==nil) {
        //队列中没有可用cell 初始化一个
        cell=[[GYMyInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    //第一组中每个cell的内容，分别是图片和titile所对应的数组，根据行号来获取
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
  
            { [cell refreshWithImg:[_imgArr objectAtIndex:indexPath.row] WithTitle:[_titleArr objectAtIndex:indexPath.row]];
                
           if (data.user.isPhoneBinding&&data.user.isEmailBinding&&data.user.isBankBinding) {
                    
                    cell.vAccessoryView.text=@"已完成";
                    
                    
                }else{
                    
                    cell.vAccessoryView.text=@"未完成";
                    
                }
                
                
            }
                break;
            case 1:
            { [cell refreshWithImg:[_imgArr objectAtIndex:indexPath.row] WithTitle:[_titleArr objectAtIndex:indexPath.row]];
                
                
                if (UserDataModel.isRealNameRegistration&&UserDataModel.isRealName) {
                    
                    cell.vAccessoryView.text=@"已完成";
                    
                }else{
                    
                    cell.vAccessoryView.text=@"未完成";
                    
                }
            }
                break;
            case 2:
            {   [cell refreshWithImg:[_imgArr objectAtIndex:indexPath.row] WithTitle:[_titleArr objectAtIndex:indexPath.row]];
                cell.vAccessoryView.hidden=YES;
                
            }
                break;
            case 3:
            { [cell refreshWithImg:[_imgArr objectAtIndex:indexPath.row] WithTitle:[_titleArr objectAtIndex:indexPath.row]];
                cell.vAccessoryView.hidden=YES;
                
            }   break;
            case 4:
                
            default:
                break;
        }
    }else if (indexPath.section==1)
        //第一组中每个cell的内容，分别是图片和titile所对应的数组，根据行号来获取
    {
        switch (indexPath.row) {
            case 0:
            {  [cell refreshWithImg:[_imgArr objectAtIndex:indexPath.row+sectionNumber] WithTitle:[_titleArr objectAtIndex:indexPath.row+sectionNumber]];
                cell.vAccessoryView.hidden=YES;
            }   break;
            case 1:
            {   [cell refreshWithImg:[_imgArr objectAtIndex:indexPath.row+sectionNumber] WithTitle:[_titleArr objectAtIndex:indexPath.row+sectionNumber]];
                cell.vAccessoryView.hidden=YES;
                
            }   break;
                
                
            default:
                break;
        }
        
        
    }
    
    return cell;
};
#pragma mark tableviewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id sender = nil;
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
            {//卡信息绑定vc
                
                GYCardInfoBandViewController * vcInfoBanding =[[GYCardInfoBandViewController alloc]initWithNibName:@"GYCardInfoBandViewController" bundle:nil];
                vcInfoBanding.model=UserDataModel;
                vcInfoBanding.hidesBottomBarWhenPushed=YES;
                sender=vcInfoBanding;
                
                
                
            }
                
                break;
            case 1:
            {
                
                GYRegisterAuthViewController * vcRegisterAuth =[[GYRegisterAuthViewController alloc]initWithNibName:@"GYRegisterAuthViewController" bundle:nil];
                vcRegisterAuth.hidesBottomBarWhenPushed=YES;
                sender=vcRegisterAuth;
            }
                break;
            case 2:
                
            {//已经完成重要信息变更 出来的页面。
                if ([[GlobalData shareInstance].personInfo.importantInfoStatus isEqualToString:@"Y"]) {
                   
                    //重要信息更改
                    GYImportantChangeWarmingViewController * vcImportantChange =[[GYImportantChangeWarmingViewController alloc]initWithNibName:@"GYImportantChangeWarmingViewController" bundle:nil];
                    vcImportantChange.hidesBottomBarWhenPushed=YES;
                    sender=vcImportantChange;
                    
                }
                else
                {
                    //实名注册通过 实名认证通过 才能进行重要信息变更
                    if ([[GlobalData shareInstance].personInfo.regStatus isEqualToString:@"Y"]&&[[GlobalData shareInstance].personInfo.verifyStatus isEqualToString:@"Y"]&&([GlobalData shareInstance].user.userName && [GlobalData shareInstance].user.userName.length>0) ) {

                        //重要信息更改
                        GYImportantChangeViewController * vcImportChange =[[GYImportantChangeViewController alloc]initWithNibName:@"GYImportantChangeViewController" bundle:nil];
                        vcImportChange.title=@"重要信息变更";
                        vcImportChange.hidesBottomBarWhenPushed=YES;
                        sender=vcImportChange;
                        
                        
                        
                    }else
//                        //没有完成实名注册 出来的页面
//                        if ([[GlobalData shareInstance].personInfo.regStatus isEqualToString:@"N"])
//                        {
//                            
//                            
//                            GYNoImportantChangeViewController * vcNoPermit =[[GYNoImportantChangeViewController alloc]initWithNibName:@"GYNoImportantChangeViewController" bundle:nil];
//                            vcNoPermit.title=@"重要信息变更";
//                               vcNoPermit.strSource=@"   您尚未进行实名注册，请先进行实名注册后再办理此业务！";
//                            vcNoPermit.hidesBottomBarWhenPushed=YES;
//                            sender=vcNoPermit;
//                            
//                            
//                        }
                       //没有完成实名认证  来到这里。
                   if (![[GlobalData shareInstance].personInfo.verifyStatus isEqualToString:@"Y"])
                        {
                            
                            GYNoAuthNoImportantChangeVC * vcNoPermit =[[GYNoAuthNoImportantChangeVC alloc]initWithNibName:@"GYNoAuthNoImportantChangeVC" bundle:nil];
                            vcNoPermit.title=@"重要信息变更";
                        
                            vcNoPermit.hidesBottomBarWhenPushed=YES;
                            sender=vcNoPermit;
                        
                        
                        
                        }
                    
                    //没有完成实名绑定来到这里
//                        else if (![GlobalData shareInstance].personInfo.custName.length>0)
//                        {
//                            
//                            GYNoImportantChangeViewController * vcNoPermit =[[GYNoImportantChangeViewController alloc]initWithNibName:@"GYNoImportantChangeViewController" bundle:nil];
//                            vcNoPermit.title=@"重要信息变更";
//                            vcNoPermit.strSource=@"   您尚未进行实名绑定，请先进行实名绑定后再办理此业务！";
//                            vcNoPermit.hidesBottomBarWhenPushed=YES;
//                            sender=vcNoPermit;
//                            
//                            
//                        }
                        else//其他情况，都来到这里 提示完善个人信息
                            
                        {
                            
                            //重要信息更改
                            GYNoImportantChangeViewController * vcNoPermit =[[GYNoImportantChangeViewController alloc]initWithNibName:@"GYNoImportantChangeViewController" bundle:nil];
                            vcNoPermit.title=@"重要信息变更";
                            vcNoPermit.strSource=@"您个人信息不完整，请先完善个人信息。";
                            vcNoPermit.hidesBottomBarWhenPushed=YES;
                            sender=vcNoPermit;
                            
                            
                        }
                    
                    
                    
                    
                }
                
                
            }
                break;
            case 3:
                
            {
                GYGetGoodViewController * vcContactInfo =[[GYGetGoodViewController alloc]initWithNibName:@"GYGetGoodViewController" bundle:nil];
                vcContactInfo.hidesBottomBarWhenPushed=YES;
                sender=vcContactInfo;
            }
                break;
                
            default:
                break;
        }
    }else if (indexPath.section==1){
        switch (indexPath.row) {
            case 0:
            {
                //修改登录密码
                GYChangeLoginPwdViewController * vcChangePasswd =[[GYChangeLoginPwdViewController alloc]initWithNibName:@"GYChangeLoginPwdViewController" bundle:nil];
                vcChangePasswd.hidesBottomBarWhenPushed=YES;
                sender=vcChangePasswd;
                
                
            }
                break;
            case 1:
            {
                //问题密码找回。
                GYSetupPasswdQuestionViewController   * vcCardBanding     =[[GYSetupPasswdQuestionViewController alloc]initWithNibName:@"GYSetupPasswdQuestionViewController" bundle:nil];
                vcCardBanding.hidesBottomBarWhenPushed=YES;
                sender=vcCardBanding;
                
            }
                break;
                //            case 2:
                //            {
                //                //手机号码绑定
                //                //                GYPhoneBandingViewController * vcPhoneBanding =[[GYPhoneBandingViewController alloc]initWithNibName:@"GYPhoneBandingViewController" bundle:nil];
                //                //                vcPhoneBanding.hidesBottomBarWhenPushed=YES;
                //                //                sender=vcPhoneBanding;
                //
                //                // GYQuitPhoneBandingViewController
                //                GYQuitPhoneBandingViewController * vcPhoneBanding =[[GYQuitPhoneBandingViewController alloc]initWithNibName:@"GYQuitPhoneBandingViewController" bundle:nil];
                //                vcPhoneBanding.FromWhere=YES;
                //                vcPhoneBanding.hidesBottomBarWhenPushed=YES;
                //                sender=vcPhoneBanding;
                //
                //
                //            }
                //                break;
                //            case 3:
                //            {//邮箱绑定
                //                GYEmailBandingViewController * vcEmailBanding =[[GYEmailBandingViewController alloc]initWithNibName:@"GYEmailBandingViewController" bundle:nil];
                //                vcEmailBanding.hidesBottomBarWhenPushed=YES;
                //                sender=vcEmailBanding;
                //
                //            }
                //                break;
                //            case 4:
                //            {
                //                //密码提示问题
                //                GYSetupPasswdQuestionViewController * vcsetupQuestion =[[GYSetupPasswdQuestionViewController alloc]initWithNibName:@"GYSetupPasswdQuestionViewController" bundle:nil];
                //                vcsetupQuestion.hidesBottomBarWhenPushed=YES;
                //                sender=vcsetupQuestion;
                //                
                //            }
                //                break;
                
            default:
                break;
        }
        
        
        
    }
    //通过代理 将 controller 传到 navigation push
    if (sender && [_delegate respondsToSelector:@selector(pushVC:animated:)])
    {
        [_delegate pushVC:sender animated:YES];
    }
    
}

@end
