//
//  GYPointInvestNextViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-27.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

//积分投资下一步页面

#import "GYPointInvestNextViewController.h"
#import "InputCellStypeView.h"
#import "GlobalData.h"
#import "CustomIOS7AlertView.h"
#import "ResultDialog.h"
#import "GYPointInvestViewController.h"

@interface GYPointInvestNextViewController ()<MBProgressHUDDelegate, UITextFieldDelegate>
{
    IBOutlet InputCellStypeView *viewRowInputPointInvestAmount;//本次投资行
    IBOutlet InputCellStypeView *viewRowToAmount;              //转入账户

    IBOutlet UILabel *lbNoteRow0;//投资说明
    IBOutlet UILabel *lbNoteRow1;//说明1
    IBOutlet UILabel *lbNoteRow2;//说明2
    IBOutlet UILabel *lbNoteRow3;//说明3
    IBOutlet InputCellStypeView *viewPWD;               //交易密码

    IBOutlet UIImageView *ivItem1;//投资说明各项前面的小图标
    IBOutlet UIImageView *ivItem2;
    IBOutlet UIImageView *ivItem3;
    
    GlobalData *data;         //全局单例
    IBOutlet UIButton *btnOK; //确认按钮

}

@end

@implementation GYPointInvestNextViewController

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
    //清除下一级页面返回按钮的文字
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    //实例化单例
    data = [GlobalData shareInstance];
    
    //设置控制器背景色
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    
    viewPWD.lbLeftlabel.text = kLocalized(@"trade_pwd");
    viewPWD.tfRightTextField.placeholder = kLocalized(@"input_trading_pwd");
    viewPWD.tfRightTextField.secureTextEntry = YES;
    [viewPWD.tfRightTextField setKeyboardType:UIKeyboardTypeNumberPad];
    viewPWD.tfRightTextField.delegate = self;

    //设置投资说明项前图标颜色
    ivItem1.image = nil;
    [ivItem1 setBackgroundColor:kCorlorFromHexcode(0xef4136)];
    ivItem2.image = nil;
    [ivItem2 setBackgroundColor:kCorlorFromHexcode(0xef4136)];
    ivItem3.image = nil;
    [ivItem3 setBackgroundColor:kCorlorFromHexcode(0xef4136)];
    
    [lbNoteRow0 setTextColor:kCellItemTextColor];
    lbNoteRow0.text = kLocalized(@"investment_instructions");
    [lbNoteRow1 setTextColor:kCellItemTextColor];
    lbNoteRow1.text = kLocalized(@"investment_instructions_1");
    [lbNoteRow2 setTextColor:kCellItemTextColor];
    lbNoteRow2.text = kLocalized(@"investment_instructions_2");
    [lbNoteRow3 setTextColor:kCellItemTextColor];
    lbNoteRow3.text = kLocalized(@"investment_instructions_3");

    
    viewRowInputPointInvestAmount.lbLeftlabel.text = kLocalized(@"investment_points");
    [viewRowInputPointInvestAmount.tfRightTextField setTextColor:kValueRedCorlor];
    viewRowInputPointInvestAmount.tfRightTextField.text = [NSString stringWithFormat:@"%.2f", self.inputValue];
    viewRowInputPointInvestAmount.tfRightTextField.font = kCellTitleBoldFont;
    
    viewRowToAmount.lbLeftlabel.text = kLocalized(@"tra_to_account");
    viewRowToAmount.tfRightTextField.text = kLocalized(@"investment_account");
    [viewRowToAmount.tfRightTextField setTextColor:kValueRedCorlor];

    //设置 确认按钮
    [btnOK setTitle:kLocalized(@"confirm_to_submit") forState:UIControlStateNormal];
    [btnOK.titleLabel setFont:kButtonTitleDefaultFont];
    [btnOK addTarget:self action:@selector(btnOKClick:) forControlEvents:UIControlEventTouchUpInside];

}

//确认操作
- (void)btnOKClick:(id)sender
{
    DDLogDebug(@"OK");
    
//    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//	[self.navigationController.view addSubview:hud];
//	hud.labelText = @"提交订单";
//	
//	[hud showAnimated:YES whileExecutingBlock:^{
//        sleep(1);
//	} completionBlock:^{
//        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//        [self.navigationController.view addSubview:HUD];
//        HUD.customView = [[UIImageView alloc] initWithImage:kLoadPng(@"img_succeed")];
//        HUD.mode = MBProgressHUDModeCustomView;
//        HUD.delegate = self;
//        HUD.labelText = @"投资成功";
//        [HUD show:YES];
//        [HUD hide:YES afterDelay:1];
//        
//		[hud removeFromSuperview];
//	}];
    
    if (viewPWD.tfRightTextField.text.length != 8)
    {
        [Utils showMessgeWithTitle:nil message:kLocalized(@"please_enter_pwd") isPopVC:nil];
        return;
    }
    [self integral_invest];
//    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//	[self.navigationController.view addSubview:hud];
//	hud.labelText = @"提交订单";
	
//	[hud showAnimated:YES whileExecutingBlock:^{
//        sleep(1);
//	} completionBlock:^{
//        [self showResult];
//		[hud removeFromSuperview];
//	}];
}


//- (void)showResult
//{
//    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
//    ResultDialogRows2 *dialog = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ResultDialogRows2 class]) owner:self options:nil] lastObject];
//    dialog.lbTitle.text = kLocalized(@"order_transfer_successfully");
//    
//    dialog.viewResultRow0.lbLeftlabel.text = kLocalized(@"trading_serial_number");
//    dialog.viewResultRow0.tfRightTextField.text = @"WJD12312789416";
//    
//    dialog.viewResultRow1.lbLeftlabel.text = viewRowInputPointInvestAmount.lbLeftlabel.text;
//    dialog.viewResultRow1.tfRightTextField.text = viewRowInputPointInvestAmount.tfRightTextField.text;
//    dialog.viewResultRow1.tfRightTextField.font = [UIFont boldSystemFontOfSize:dialog.viewResultRow1.tfRightTextField.font.pointSize];//设置粗体
//    
//    [alertView setContainerView:dialog];
//    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:kLocalized(@"confirm"),nil]];
//    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
//        //        NSLog(@"＝＝＝＝＝Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
//        NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
//        for (UIViewController *aViewController in allViewControllers) {
//            if ([aViewController isKindOfClass:[GYPointInvestViewController class]]) {
//                [self.navigationController popToViewController:aViewController animated:YES];
//            }
//        }        [alertView close];
//    }];
//    [alertView setUseMotionEffects:true];
//    [alertView show];
//}

#pragma mark - 网络数据交换
- (void)integral_invest//积分投资
{
    NSDictionary *subParas = @{@"resource_no": data.user.cardNumber,
                               @"integral_value": [@(self.inputValue) stringValue],
                               @"channel_code": @"MOBILE",
                               @"trade_pwd": viewPWD.tfRightTextField.text
                               };
    
    NSDictionary *allParas = @{@"system": @"person",
                               @"cmd": @"integral_invest",
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
            DDLogInfo(@"integral_invest dic:%@", dic);
            if (!error)
            {
                if ([kSaftToNSString(dic[@"code"]) isEqualToString:kHSRequestSucceedCode] &&
                    dic[@"data"] &&
                    (kSaftToNSInteger(dic[@"data"][@"resultCode"]) == kHSRequestSucceedSubCode))//返回成功数据
                {
                    data.user.isNeedRefresh = YES;
                    [self showResultTitle:kLocalized(@"points_to_invest_succeed") isSucceed:YES];
                    
                }else//返回失败数据
                {
                    [self showResultTitle:kLocalized(@"points_to_invest_failed") isSucceed:NO];
                }
            }else
            {
                [self showResultTitle:kLocalized(@"points_to_invest_failed") isSucceed:NO];
            }
            
        }else
        {
            [Utils alertViewOKbuttonWithTitle:@"提示" message:[error localizedDescription]];
        }
        if (hud.superview)
        {
            [hud removeFromSuperview];
        }
    }];
}

- (void)showResultTitle:(NSString *)title isSucceed:(BOOL)isSucceed;
{
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    ResultDialog *dialog = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ResultDialog class]) owner:self options:nil] lastObject];
    
    [dialog showWithTitle:title isSucceed:isSucceed];
    
    [alertView setContainerView:dialog];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:kLocalized(@"confirm"),nil]];
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        //        NSLog(@"＝＝＝＝＝Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        [self.navigationController popViewControllerAnimated:YES];
        [alertView close];
    }];
    [alertView setUseMotionEffects:true];
    [alertView show];
    alertView.lineView.hidden = YES;
    alertView.lineView1.hidden = YES;
    
}


#pragma mark - MBProgressHUD delegate

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // modify by songjk 计算长度修改
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    unsigned long len = toBeString.length;
    if (textField == viewPWD.tfRightTextField)
    {
        if(len > 8) return NO;
        
    }
    return YES;
}

@end
