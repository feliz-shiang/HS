//
//  GYAgainConfirmViewController.m
//  HSConsumer
//
//  Created by 00 on 14-10-16.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYAgainConfirmViewController.h"
#import "GYSelectPayWayViewController.h"
#import "MBProgressHUD.h"
#import <unistd.h>
#import "UIView+CustomBorder.h"
#import "UIAlertView+Blocks.h"
#import "UPPayPlugin.h"

@interface GYAgainConfirmViewController ()<GYSelectPayWayDelegate, MBProgressHUDDelegate, UPPayPluginDelegate, UITextFieldDelegate>
{
    __weak IBOutlet UIScrollView *scvAgainConfirm;//ScrollView
    
    __weak IBOutlet UIView *vOrder;  //点单控件
    __weak IBOutlet UILabel *lbOrder;//订单标题
    __weak IBOutlet UILabel *lbOrderNum;//订单号
    
    __weak IBOutlet UIView *vPay; //支付金额控件
    __weak IBOutlet UILabel *lbPayTitle;//支付金额标题
    __weak IBOutlet UILabel *lbPay;//支付金额
    
    __weak IBOutlet UIView *vPayWay; //支付金额控件
    __weak IBOutlet UILabel *lbPayWayTitle;//支付金额标题
    __weak IBOutlet UILabel *lbPayWay;//支付金额
    __weak IBOutlet UIButton *btnSelectPayWay;//选择支付方式 按钮
    
    __weak IBOutlet UIView *vPWD;  //点单控件
    __weak IBOutlet UILabel *lbPWDTitle;//订单标题
    __weak IBOutlet UITextField *tfPWD;//订单
    
    __weak IBOutlet UIButton *btnCommit;//确认提交 按钮
    int payType;
    NSArray *arrPayTypes;
    MBProgressHUD *hud;
}
@end

@implementation GYAgainConfirmViewController
//选择支付方法 点击事件

- (IBAction)btnSeleWayClick:(id)sender
{
    [Utils hideKeyboard];
    GYSelectPayWayViewController *vcSelPayWay = [[GYSelectPayWayViewController alloc] init];
    vcSelPayWay.selectIndex = payType;
    vcSelPayWay.navigationItem.title = kLocalized(@"pay_methods");
    vcSelPayWay.arrData = arrPayTypes;
    vcSelPayWay.delegate = self;
    [self.navigationController pushViewController:vcSelPayWay animated:YES];
}

//确认提交点击事件
- (IBAction)btnCommitClick:(id)sender
{
    if (payType == 0)//互生币支付
    {
        if (tfPWD.text.length != 8)
        {
            [Utils showMessgeWithTitle:@"提示" message:kLocalized(@"please_enter_pwd") isPopVC:nil];
            return;
        }
        [self hsbTopay];
    }else//网银支付
    {
        [self getPayInfo];
    }
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
    self.title = kLocalized(@"points_card_rehandle");
   
    arrPayTypes = @[kLocalized(@"hsb_account_to_pay"),
                    kLocalized(@"pay_method_uppay")];
    //国际化
    lbOrder.text = kLocalized(@"order_num");
    lbPayTitle.text = kLocalized(@"pay_amount");
    lbPayWayTitle.text = kLocalized(@"payment_method");
    lbPWDTitle.text = kLocalized(@"trade_pwd");
    
    //边框
    [vOrder addTopBorderAndBottomBorder];
    [vPay addTopBorderAndBottomBorder];
    [vPayWay addTopBorderAndBottomBorder];
    [vPWD addTopBorderAndBottomBorder];
    [tfPWD setPlaceholder:kLocalized(@"please_enter_pwd")];
    [tfPWD setKeyboardType:UIKeyboardTypeNumberPad];
    tfPWD.delegate = self;

    //确认提交按钮设置
    btnCommit.layer.cornerRadius = 4.0f;
    btnCommit.titleLabel.text = kLocalized(@"confirm_to_submit");
    
    payType = 0;
    lbPayWay.text = arrPayTypes[payType];

    lbOrderNum.text = kSaftToNSString(self.dicOrderInfo[@"orderNo"]);
    lbPay.text = [Utils formatCurrencyStyle:kSaftToCGFloat(self.dicOrderInfo[@"orderAmount"])];
    [Utils setFontSizeToFitWidthWithLabel:lbOrderNum labelLines:1];
    
    NSLog(@"self.dicOrderInfo:%@", self.dicOrderInfo);
    CGRect btnRect = [btnCommit frame];
    btnRect.origin.y = CGRectGetMaxY(vPWD.frame) + 20;
    btnCommit.frame =btnRect;
    
    scvAgainConfirm.contentSize = CGSizeMake(0, CGRectGetMaxY(btnCommit.frame) + 80);
}

#pragma mark - GYSelectPayWayDelegate
-(void)getBackPayWay:(int)p
{
    payType = p;
    lbPayWay.text = arrPayTypes[payType];
    
    CGRect btnRect = [btnCommit frame];
    if (payType == 0)
    {
        vPWD.hidden = NO;
        btnRect.origin.y = CGRectGetMaxY(vPWD.frame) + 20;
    }else
    {
        vPWD.hidden = YES;
        btnRect.origin.y = vPWD.center.y;

    }
    btnCommit.frame = btnRect;
}

- (void)hsbTopay
{
    GlobalData *data = [GlobalData shareInstance];
    
    NSDictionary *subParas = @{@"resource_no": data.user.cardNumber,
                               @"order_no": lbOrderNum.text,
                               @"amount": kSaftToNSString(self.dicOrderInfo[@"orderAmount"]),
                               @"channel_code": @"MOBILE",
                               @"pay_method": @"1",
                               @"trade_pwd": tfPWD.text
                               };
    
    NSDictionary *allParas = @{@"system": @"person",
                               @"cmd": @"remake_card_pay",
                               @"params": subParas,
                               @"uType": kuType,
                               @"mac": kHSMac,
                               @"mId": data.midKey,
                               @"key": data.hsKey
                               };
    
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    }
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    [self.view addSubview:hud];
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
                    dic = dic[@"data"];
//                    [Utils showMessgeWithTitle:nil message:@"互生币支付补卡订单成功." isPopVC:nil];
                    [UIAlertView showWithTitle:nil message:@"互生卡补办申请提交成功." cancelButtonTitle:kLocalized(@"confirm") otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        //        [self.navigationController popViewControllerAnimated:YES];
                    }];

                }else//返回失败数据
                {
                    if (kSaftToNSInteger(dic[@"data"][@"resultCode"]) == 501008)//交易密码验证失败
                    {
                        [Utils showMessgeWithTitle:nil message:@"交易密码验证失败." isPopVC:nil];
                    }else
                        [Utils showMessgeWithTitle:nil message:@"互生币支付失败." isPopVC:nil];
                }
            }else
            {
                [Utils showMessgeWithTitle:nil message:@"互生币支付失败." isPopVC:nil];
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

- (void)getPayInfo//取得订单支付信息
{
    GlobalData *data = [GlobalData shareInstance];
    NSDictionary *subParas = @{@"resource_no": data.user.cardNumber,
                               @"order_no": lbOrderNum.text,
                               @"channel_code": @"MOBILE",
                               @"amount": kSaftToNSString(self.dicOrderInfo[@"orderAmount"])
                               };
    
    NSDictionary *allParas = @{@"system": @"person",
                               @"cmd": @"get_person_remake_card_ebank_pay_params",
                               @"params": subParas,
                               @"uType": kuType,
                               @"mac": kHSMac,
                               @"mId": data.midKey,
                               @"key": data.hsKey
                               };
    
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    }
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    [self.view addSubview:hud];
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
                    dic = dic[@"data"];
                    
                    NSString *tn = kSaftToNSString(dic[@"tnCode"]);
                    if (tn.length > 0)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [UPPayPlugin startPay:tn mode:kUPPayPluginMode viewController:self delegate:self];
                        });

                    }
                    
//                    NSDictionary *allParameters = dic[@"ebankPayParams"][@"allParameters"];
//                    if (allParameters && [allParameters isKindOfClass:[NSDictionary class]])
//                    {
////                        [self uppayToPay:allParameters];
////                        return ;
//                    }else
//                    {
//                        [Utils showMessgeWithTitle:nil message:@"获取订单支付信息失败." isPopVC:nil];
//                    }
                }else//返回失败数据
                {
                    [Utils showMessgeWithTitle:nil message:@"获取订单支付信息失败." isPopVC:nil];
                }
            }else
            {
                [Utils showMessgeWithTitle:nil message:@"获取订单支付信息失败." isPopVC:nil];
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

- (void)uppayToPay:(NSDictionary *)allParameters//网银支付
{
    NSDictionary *passDic = @{@"partnerId": kSaftToNSString(allParameters[@"partnerId"]),
                              @"reqOrderNo": kSaftToNSString(allParameters[@"reqOrderNo"]),
                              @"currency": kSaftToNSString(allParameters[@"currency"]),
                              @"transDate": kSaftToNSString(allParameters[@"transDate"]),
                              @"outResNo": kSaftToNSString(allParameters[@"outResNo"]),
                              @"amount": kSaftToNSString(allParameters[@"amount"]),
                              @"fee": kSaftToNSString(allParameters[@"fee"]),
                              @"flag": kSaftToNSString(allParameters[@"flag"]),
                              @"remark": kSaftToNSString(allParameters[@"remark"]),
                              @"signType": kSaftToNSString(allParameters[@"signType"]),
                              @"returnUrl": kSaftToNSString(allParameters[@"returnUrl"]),
                              @"notifyUrl": kSaftToNSString(allParameters[@"notifyUrl"]),
                              @"sign": kSaftToNSString(allParameters[@"sign"])
                              };
    
    GlobalData *data = [GlobalData shareInstance];

    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    }
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    [self.navigationController.view addSubview:hud];
    [hud show:YES];
    
    [Network HttpPostRequetURL:data.hsPayDomain parameters:passDic requetResult:^(NSData *jsonData, NSError *error) {
        if (!error)
        {
            NSString *tn = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            if (tn.length > 0)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UPPayPlugin startPay:tn mode:kUPPayPluginMode viewController:self delegate:self];
                });
            }else
            {
                [Utils showMessgeWithTitle:nil message:kLocalized(@"获取订单支付信息失败。") isPopVC:nil];
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

#pragma mark - UPPayPluginDelegate
- (void)UPPayPluginResult:(NSString *)result
{
    NSString *message = kLocalized(@"网银支付互生卡补卡订单失败。");
    if ([result isEqualToString:@"success"])
    {
        message = kLocalized(@"互生卡补办申请提交成功.");
    }
    [UIAlertView showWithTitle:nil message:message cancelButtonTitle:kLocalized(@"confirm") otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        [self.navigationController popToRootViewControllerAnimated:YES];
//        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // modify by songjk 计算长度修改
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    unsigned long len = toBeString.length;
    if (textField == tfPWD)
    {
        if(len > 8) return NO;
        
    }
    return YES;
}

@end
