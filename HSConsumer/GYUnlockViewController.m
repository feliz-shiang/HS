//
//  GYUnlockViewController.m
//  HSConsumer
//
//  Created by 00 on 14-10-16.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYUnlockViewController.h"
#import "UIButton+GetSMSCode.h"
#import "UserData.h"
#import <unistd.h>
#import "UIView+CustomBorder.h"
#import "GlobalData.h"

@interface GYUnlockViewController ()<UIAlertViewDelegate, UITextFieldDelegate>
{
    __weak IBOutlet UIScrollView *scvUnlock;//scrillView
    __weak IBOutlet UIView *vSMS;//互生号行
    __weak IBOutlet UIButton *btnCommit;//确认按钮
   
    
    __weak IBOutlet UILabel *lbHSCardTitle;
    __weak IBOutlet UILabel *lbHSCard;
   
    
    __weak IBOutlet UIView *vPwd;//密码行
    __weak IBOutlet UILabel *lbPwd;//密码title
    __weak IBOutlet UITextField *tfPwd;//输入密码tf
    
    BOOL isCanCommit;
    id resultCode;
}
@end

@implementation GYUnlockViewController

//获取验证码点击事件

//确认提交 按钮点击事件
- (IBAction)btnCommitClick:(id)sender
{
    if (!isCanCommit)
    {
        [Utils showMessgeWithTitle:@"提示" message:@"该互生卡状态正常，不能进行此操作。" isPopVC:self.navigationController];
        return;
    }

    if (tfPwd.text.length != 6)
    {
        [Utils showMessgeWithTitle:@"提示" message:kLocalized(@"placeholder_verified_pwd") isPopVC:nil];
        return;
    }
    [self cancel_loss_card];
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
    self.title = kLocalized(@"unlock_points_card");
    isCanCommit = YES;
    
    //确认提交按钮设置
    btnCommit.layer.cornerRadius = 4.0f;
    btnCommit.titleLabel.text = kLocalized(@"confirm_to_submit");

    [vSMS addTopBorderAndBottomBorder];
    [vPwd addTopBorderAndBottomBorder];
    [tfPwd setSecureTextEntry:YES];
    [tfPwd setKeyboardType:UIKeyboardTypeNumberPad];
    tfPwd.delegate = self;

    lbHSCard.text = [Utils formatCardNo:[GlobalData shareInstance].user.cardNumber];
    [self get_person_card_infomation];
}

#pragma mark - 网络数据交换
- (void)get_person_card_infomation
{
    GlobalData *data = [GlobalData shareInstance];
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
                    if ([[kSaftToNSString(ResponseDic[@"cardStatus"]) uppercaseString] isEqualToString:@"Y"])//卡状态（Y-正常;N-已挂失）
                    {
                        isCanCommit = NO;
                    }
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


- (void)cancel_loss_card//提交
{
    GlobalData *data = [GlobalData shareInstance];
    
    NSDictionary *subParas = @{@"resource_no": data.user.cardNumber,
                               @"pwd": tfPwd.text
                               };
    
    NSDictionary *allParas = @{@"system": @"person",
                               @"cmd": @"cancel_loss_card",
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
    if (textField == tfPwd)
    {
        if(len > 6) return NO;
        
    }
    return YES;
}

@end
