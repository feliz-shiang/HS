//
//  GYReportLossViewController.m
//  HSConsumer
//
//  Created by 00 on 14-10-15.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYReportLossViewController.h"
#import "UIButton+GetSMSCode.h"
#import "Network.h"
#import "UserData.h"
#import <unistd.h>
#import "UIView+CustomBorder.h"
#import "GlobalData.h"
#import "InputCellStypeView.h"
#import "UIAlertView+Blocks.h"

@interface GYReportLossViewController ()<UITextViewDelegate, UITextFieldDelegate>
{
    IBOutlet InputCellStypeView *viewRow0;
    IBOutlet InputCellStypeView *viewRow1;
    IBOutlet InputCellStypeView *viewPwd;
    
    IBOutlet UIScrollView *scvReport; //scrollView

    IBOutlet UIButton *btnCommit;//确认按钮
    IBOutlet UIView *viewResonBkg;
    IBOutlet UITextView *tvReportReason;//输入挂失原因
    IBOutlet UILabel *lbReportReason;//挂失原因标
    IBOutlet UILabel *lbPlaceholder;//textView 自定义占位符
    
    GlobalData *data;
    BOOL isCanCommit;//默认为no
}

@end

@implementation GYReportLossViewController


//确认提交 按钮点击事件
- (IBAction)btnCommitClick:(id)sender
{
    if (!isCanCommit)
    {
        [Utils showMessgeWithTitle:@"提示" message:@"该互生卡当前状态不允许挂失。" isPopVC:self.navigationController];
        return;
    }
    
    if (tvReportReason.text.length < 1)
    {
        [Utils showMessgeWithTitle:@"提示" message:@"请填写挂失原因。" isPopVC:nil];
        return;
    }
    
    if (tvReportReason.text.length > 30)
    {
        [Utils showMessgeWithTitle:@"提示" message:@"填写挂失原因不应超过30字。" isPopVC:nil];
        return;
    }

    if (viewPwd.tfRightTextField.text.length != 6)
    {
        [Utils showMessgeWithTitle:@"提示" message:kLocalized(@"placeholder_verified_pwd") isPopVC:nil];
        return;
    }
    
    [self commit];
}

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
    //国际化
    self.title = kLocalized(@"report_the_loss_of_points_card");

    data = [GlobalData shareInstance];
    viewRow0.lbLeftlabel.text = kLocalized(@"points_card_number");
    viewRow0.tfRightTextField.text = [Utils formatCardNo:data.user.cardNumber];
    
    viewRow1.lbLeftlabel.text = kLocalized(@"points_card_number_state");
    viewRow1.tfRightTextField.text = @"--";

    viewPwd.lbLeftlabel.text = kLocalized(@"verified_pwd");
    viewPwd.tfRightTextField.placeholder = kLocalized(@"placeholder_verified_pwd");
    [viewPwd.tfRightTextField setSecureTextEntry:YES];
    [viewPwd.tfRightTextField setKeyboardType:UIKeyboardTypeNumberPad];
    viewPwd.tfRightTextField.delegate = self;

    lbReportReason.text = kLocalized(@"report_the_loss_of_reason");
    [lbReportReason setTextColor:kCellItemTextColor];
    
    //确认提交按钮设置
    btnCommit.layer.cornerRadius = 4.0f;
    btnCommit.titleLabel.text = kLocalized(@"confirm_to_submit");
    
    [viewResonBkg addTopBorderAndBottomBorder];
    
    //获取验证码
    
    //textView delegate
    lbPlaceholder.text = kLocalized(@"input_report_loss_of_reason");
    lbPlaceholder.enabled = NO;
    tvReportReason.delegate = self;

    scvReport.contentSize = CGSizeMake(0, CGRectGetMaxY(btnCommit.frame) + 80);
    isCanCommit = NO;
    
    [self get_person_card_infomation];
}

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        lbPlaceholder.text = kLocalized(@"input_report_loss_of_reason");
    }else{
        lbPlaceholder.text = @"";
    }
}

//#pragma mark - 网络数据交换
//- (void)get_person_base_info
//{
//    NSDictionary *subParas = @{@"resource_no": data.user.cardNumber
//                               };
//    
//    NSDictionary *allParas = @{@"system": @"person",
//                               @"cmd": @"get_person_base_info",
//                               @"params": subParas,
//                               @"uType": kuType,
//                               @"mac": kHSMac,
//                               @"mId": data.midKey,
//                               @"key": data.hsKey
//                               };
//    
//    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//    hud.removeFromSuperViewOnHide = YES;
//    hud.dimBackground = YES;
//    [self.navigationController.view addSubview:hud];
//    //    hud.labelText = @"初始化数据...";
//    [hud show:YES];
//    
//    [Network HttpGetForRequetURL:[data.hsDomain stringByAppendingString:kHSApiAppendUrl] parameters:allParas requetResult:^(NSData *jsonData, NSError *error) {
//        if (!error)
//        {
//            NSDictionary *ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                                options:kNilOptions
//                                                                  error:&error];
//            if (!error)
//            {
//                if ([kSaftToNSString(ResponseDic[@"code"]) isEqualToString:kHSRequestSucceedCode] &&
//                    ResponseDic[@"data"] &&
//                    (kSaftToNSInteger(ResponseDic[@"data"][@"resultCode"]) == kHSRequestSucceedSubCode))//返回成功数据
//                {
//                    [GlobalData shareInstance].personInfo.baseStatus=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"baseInfo"][@"baseStatus"]);
//                    [GlobalData shareInstance].personInfo.cardRemakableStatus=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"baseInfo"][@"cardRemakableStatus"]);
//                    [GlobalData shareInstance].personInfo.cardRemakeStatus=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"baseInfo"][@"cardRemakeStatus"]);
//                    [GlobalData shareInstance].personInfo.custId=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"baseInfo"][@"custId"]);
//                    data.personInfo.custName=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"baseInfo"][@"custName"]);
//                    [GlobalData shareInstance].personInfo.emailFlag=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"baseInfo"][@"emailFlag"]);
//                    [GlobalData shareInstance].personInfo.payStatus=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"baseInfo"][@"payStatus"]);
//                    [GlobalData shareInstance].personInfo.phoneFlag=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"baseInfo"][@"phoneFlag"]);
//                    [GlobalData shareInstance].personInfo.pvFlag=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"baseInfo"][@"pvFlag"]);
//                    
//                    [GlobalData shareInstance].personInfo.pvNotGetPeriod=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"baseInfo"][@"pvNotGetPeriod"]);
//                    [GlobalData shareInstance].personInfo.regStatus=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"baseInfo"][@"regStatus"]);
//                    [GlobalData shareInstance].personInfo.resNo=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"baseInfo"][@"resNo"]);
//                    [GlobalData shareInstance].personInfo.statusDate=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"baseInfo"][@"statusDate"]);
//                    [GlobalData shareInstance].personInfo.verifyStatus=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"baseInfo"][@"verifyStatus"]);
//                    [GlobalData shareInstance].personInfo.birthAddress=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"birthAddress"]);
//                    [GlobalData shareInstance].personInfo.country=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"country"]);
//                    [GlobalData shareInstance].personInfo.creBackImg=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"creBackImg"]);
//                    [GlobalData shareInstance].personInfo.creExpiryDate=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"creExpiryDate"]);
//                    [GlobalData shareInstance].personInfo.creFaceImg=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"creFaceImg"]);
//                    [GlobalData shareInstance].personInfo.creHoldImg=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"creHoldImg"]);
//                    
//                    [GlobalData shareInstance].personInfo.creNo=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"creNo"]);
//                    [GlobalData shareInstance].personInfo.creType=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"creType"]);
//                    [GlobalData shareInstance].personInfo.creVerifyOrg=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"creVerifyOrg"]);
//                    [GlobalData shareInstance].personInfo.created=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"created"]);
//                    [GlobalData shareInstance].personInfo.createdBy=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"createdBy"]);
//                    [GlobalData shareInstance].personInfo.custId=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"custId"]);
//                    [GlobalData shareInstance].personInfo.email=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"email"]);
//                    [GlobalData shareInstance].personInfo.ensureInfo=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"ensureInfo"]);
//                    [GlobalData shareInstance].personInfo.homeAddrPostcode=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"homeAddrPostcode"]);
//                    
//                    [GlobalData shareInstance].personInfo.homeAddress=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"homeAddress"]);
//                    [GlobalData shareInstance].personInfo.homePhone=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"homePhone"]);
//                    [GlobalData shareInstance].personInfo.isActive=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"isActive"]);
//                    [GlobalData shareInstance].personInfo.mobile=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"mobile"]);
//                    [GlobalData shareInstance].personInfo.nationality=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"nationality"]);
//                    [GlobalData shareInstance].personInfo.profession=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"profession"]);
//                    [GlobalData shareInstance].personInfo.pwdAnswer=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"pwdAnswer"]);
//                    [GlobalData shareInstance].personInfo.pwdQuestNo=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"pwdQuestNo"]);
//                    [GlobalData shareInstance].personInfo.sex=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"sex"]);
//                    [GlobalData shareInstance].personInfo.updated=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"updated"]);
//                    [GlobalData shareInstance].personInfo.updatedBy=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"updatedBy"]);
//                    [GlobalData shareInstance].personInfo.verifyRemark=kSaftToNSString(ResponseDic[@"data"][@"personInfo"][@"extInfo"][@"verifyRemark"]);
//                    
//                    [GlobalData shareInstance].personInfo.importantInfoStatus=kSaftToNSString(ResponseDic[@"data"][@"importantInfoStatus"]);
//                
//                    NSString *cardStateCode = [data.personInfo.baseStatus uppercaseString];
//                    NSString *cardStateStr = @"";
//                    
////                    卡基本状态  正常(NORMAL)冻结(FREEZE)死亡预处理(NOTICE_DIE)死亡确认(DEAD_SURE)锁定(LOCK)
//                    if ([cardStateCode isEqualToString:@"NORMAL"])
//                    {
//                        cardStateStr = @"正常";
//                        isCanCommit = YES;
//                    }else if ([cardStateCode isEqualToString:@"FREEZE"])
//                    {
//                        cardStateStr = @"冻结";
//                        isCanCommit = YES;
//                    }else if ([cardStateCode isEqualToString:@"NOTICE_DIE"])
//                    {
//                        cardStateStr = @"死亡预处理";
//                    }else if ([cardStateCode isEqualToString:@"DEAD_SURE"])
//                    {
//                        cardStateStr = @"死亡确认";
//                    }else if ([cardStateCode isEqualToString:@"LOCK"])
//                    {
//                        cardStateStr = @"锁定";
//                    }
//                    viewRow1.tfRightTextField.text = cardStateStr;
//                
//                }else//返回失败数据
//                {
////                    [Utils showMessgeWithTitle:nil message:@"提交失败." isPopVC:nil];
//                }
//            }else
//            {
////                [Utils showMessgeWithTitle:nil message:@"提交失败." isPopVC:nil];
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

#pragma mark - 网络数据交换
- (void)get_person_card_infomation
{
    NSDictionary *subParas = @{@"resource_no": data.user.cardNumber
                               };
    
    NSDictionary *allParas = @{@"system": @"person",
                               @"cmd": @"get_person_card_infomation",
                               @"params": subParas,
                               @"uType": kuType,
                               @"mac": kHSMac,
                               @"mId": data.midKey,
                               @"key": data.hsKey
                               };
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    [self.view addSubview:hud];
    //    hud.labelText = @"初始化数据...";
    [hud show:YES];
    
    [Network HttpGetForRequetURL:[data.hsDomain stringByAppendingString:kHSApiAppendUrl] parameters:allParas requetResult:^(NSData *jsonData, NSError *error) {
        if (!error)
        {
            NSDictionary *ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                        options:kNilOptions
                                                                          error:&error];
            if (!error)
            {
                if ([kSaftToNSString(ResponseDic[@"code"]) isEqualToString:kHSRequestSucceedCode] &&
                    ResponseDic[@"data"] &&
                    (kSaftToNSInteger(ResponseDic[@"data"][@"resultCode"]) == kHSRequestSucceedSubCode))//返回成功数据
                {
                    ResponseDic = ResponseDic[@"data"][@"PersonCardInfo"];
                    NSString *cardStateStr = @"已挂失";
                    if ([[kSaftToNSString(ResponseDic[@"cardStatus"]) uppercaseString] isEqualToString:@"Y"])//卡状态（Y-正常;N-已挂失）
                    {
                        cardStateStr = @"正常";
                        isCanCommit = YES;
                    }
                    viewRow1.tfRightTextField.text = cardStateStr;
                }else//返回失败数据
                {
                    //                    [Utils showMessgeWithTitle:nil message:@"提交失败." isPopVC:nil];
                }
            }else
            {
                //                [Utils showMessgeWithTitle:nil message:@"提交失败." isPopVC:nil];
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

#pragma mark - 网络数据交换
- (void)commit//提交
{
    NSDictionary *subParas = @{@"resource_no": data.user.cardNumber,
                               @"loss_reason": tvReportReason.text,
                               @"pwd": viewPwd.tfRightTextField.text
                               };
    
    NSDictionary *allParas = @{@"system": @"person",
                               @"cmd": @"loss_card",
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
    //    hud.labelText = @"初始化数据...";
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
//                    dic = dic[@"data"];
                    
                    [UIAlertView showWithTitle:nil message:@"提交成功." cancelButtonTitle:kLocalized(@"confirm")  otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                }else//返回失败数据
                {
                    [Utils showMessgeWithTitle:@"提交失败." message:kSaftToNSString(dic[@"data"][@"resultMsg"]) isPopVC:nil];
                }
            }else
            {
                [Utils showMessgeWithTitle:nil message:@"提交失败." isPopVC:nil];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // modify by songjk 计算长度修改
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    unsigned long len = toBeString.length;
    if (textField == viewPwd.tfRightTextField)
    {
        if(len > 6) return NO;
        
    }
    return YES;
}

@end
