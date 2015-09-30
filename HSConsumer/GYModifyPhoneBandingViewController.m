//
//  GYPhoneBandingViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-23.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYModifyPhoneBandingViewController.h"
#import "GYSecurityAuthViewController.h"
//#import "GYTestTableViewController.h"
//扩大button 点击范围的方法。
#import "UIButton+enLargedRect.h"

#import "UIView+CustomBorder.h"
//#import "GYModifyBandingPhoneDetailViewController.h"
#import "GlobalData.h"
#import "InputCellStypeView.h"
@interface GYModifyPhoneBandingViewController ()
//zhangqy 验证码倒计时时间
@property (nonatomic,assign) int leftTime;
@end

@implementation GYModifyPhoneBandingViewController
{
    
    
    
    __weak IBOutlet UILabel *lbOrigeinPhone;// 原手机号码
    
    __weak IBOutlet UILabel *lbOriginPhoneDetail;//详细手机号码
    
    __weak IBOutlet UILabel *lbCode;//lb 验证码
    
    __weak IBOutlet UITextField *tfInputCode;//TF 输入验证码
    
    __weak IBOutlet UIButton *btnGoNext;//下一步 btn
    
    __weak IBOutlet UIImageView *imgMiddleSeprator;//分割线
    
    __weak IBOutlet UIView *vTopBgView;//背景View
    
    __weak IBOutlet UIButton *btnGetCode;//获取验证码btn
    
    __weak IBOutlet InputCellStypeView *InputNewPhoneRow;
    
    __weak IBOutlet InputCellStypeView *InputPasswordRow;
    
}



- (IBAction)btnGoNext:(id)sender {
//    GYModifyBandingPhoneDetailViewController * vcSecurity =[[GYModifyBandingPhoneDetailViewController alloc]initWithNibName:@"GYModifyBandingPhoneDetailViewController" bundle:nil];
//    [self.navigationController pushViewController:vcSecurity animated:YES];
//
//
    [self modifyPhoneRequest];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=kLocalized(@"modify_banded_phone");
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=kDefaultVCBackgroundColor;
    // Do any additional setup after loading the view from its nib.
    //设置分割线
    [self setSeprator];

    [self initUI];
    
    [btnGoNext setTitle:@"立即修改" forState:UIControlStateNormal];
    [btnGoNext setBackgroundImage:[UIImage imageNamed:@"btn_confirm_bg.png"] forState:UIControlStateNormal];
    tfInputCode.placeholder=kLocalized(@"input_validation_code");
   
    [btnGetCode setTitle:kLocalized(@"get_verification_code") forState:UIControlStateNormal];
    [InputNewPhoneRow.tfRightTextField addTarget:self action:@selector(tfPhoneNumberEditingChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)tfPhoneNumberEditingChanged:(UITextField*)textField
{
    NSString *str = textField.text;
    if (str.length>=11) {
        textField.text = [str substringToIndex:11];
    }
}

//设置文本颜色
-(void)initUI
{
    lbCode.text=kLocalized(@"verification_code");
    lbOrigeinPhone.text=kLocalized(@"original_phone_number");
    lbOriginPhoneDetail.text=self.model.strPhoneNo;
    InputNewPhoneRow.lbLeftlabel.text=@"新手机号码";
    InputNewPhoneRow.tfRightTextField.placeholder=@"输入新手机号码";
    InputPasswordRow.lbLeftlabel.text=@"密码";
    InputPasswordRow.tfRightTextField.placeholder=@"输入登录密码";
    
    lbOrigeinPhone.textColor=kCellItemTitleColor;
    lbCode.textColor=kCellItemTitleColor;
    lbOriginPhoneDetail.textColor=kCellItemTitleColor;
    
    [btnGetCode setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    
    btnGetCode.layer.masksToBounds=YES;
    btnGetCode.layer.cornerRadius=3;
    btnGetCode.layer.borderWidth=1.0f;
    btnGetCode.layer.borderColor=kNavigationBarColor.CGColor;
    
}

//设置分割线
-(void)setSeprator
{
    [vTopBgView addAllBorder];
    [self setBorderWithView:imgMiddleSeprator WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];

}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // modify by songjk 计算长度修改
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    unsigned long len = toBeString.length;
    if (textField == InputNewPhoneRow.tfRightTextField)
    {
        if(len > 11) return NO;
        
    }
    return YES;

}

-(void)loadDataFromNetwork
{
    
    NSMutableDictionary * dictInside =[[NSMutableDictionary alloc]init];
    
    [dictInside setValue:[GlobalData shareInstance].user.cardNumber forKey:@"resource_no"];
    [dictInside setValue:InputNewPhoneRow.tfRightTextField.text forKey:@"mobile"];
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    
    [dict setValue:dictInside forKey:@"params"];
    
   
    
    [dict setValue:[GlobalData shareInstance].hsKey forKey:@"key"];
    
   
    
    [dict setValue:@"person" forKey:@"system"];
    
    [dict setValue:kuType forKey:@"uType"];
    
    [dict setValue:kHSMac forKey:@"mac"];
    
    [dict setValue:[GlobalData shareInstance].midKey forKey:@"mId"];
    
    [dict setValue:[GlobalData shareInstance].hsKey forKey:@"key"];
    
    [dict setValue:@"get_mobile_verification_code_for_bind_or_change_mobile" forKeyPath:@"cmd"];
 //   [Utils showMBProgressHud:self SuperView:self.view.window Msg:@"数据加载中...."];
    [Network HttpGetForRequetURL:[[GlobalData shareInstance].hsDomain stringByAppendingString:@"/api"] parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        
        
        if (error) {
            NSLog(@"%@----",error);
            UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"网络出错，请重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
        }else{
            
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
 //           [Utils hideHudViewWithSuperView:self.view.window];
            if ([[Utils GetResultCode:ResponseDic] isEqualToString:@"0"]) {
//                UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"验证码已经发送至%@",InputNewPhoneRow.tfRightTextField.text] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [av show];
                
            }else
            {
            
                UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"网络出错，请重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            
            }
            
        }
        
    }];
    
}


-(void)modifyPhoneRequest
{


    NSMutableDictionary * dictInside =[[NSMutableDictionary alloc]init];
    
    [dictInside setValue:[GlobalData shareInstance].user.cardNumber forKey:@"resource_no"];
    [dictInside setValue:InputNewPhoneRow.tfRightTextField.text forKey:@"mobile"];
    [dictInside setValue:tfInputCode.text forKey:@"verification_code"];
    [dictInside setValue:InputPasswordRow.tfRightTextField.text forKey:@"pwd"];
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    
    [dict setValue:dictInside forKey:@"params"];
    
    
    
    [dict setValue:[GlobalData shareInstance].hsKey forKey:@"key"];
    
    
    
    [dict setValue:@"person" forKey:@"system"];
    
    [dict setValue:kuType forKey:@"uType"];
    
    [dict setValue:kHSMac forKey:@"mac"];
    
    [dict setValue:[GlobalData shareInstance].midKey forKey:@"mId"];
    
    [dict setValue:[GlobalData shareInstance].hsKey forKey:@"key"];
    
    [dict setValue:@"bind_or_change_mobile" forKeyPath:@"cmd"];
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"数据加载中...."];
    [Network HttpGetForRequetURL:[[GlobalData shareInstance].hsDomain stringByAppendingString:@"/api"] parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
          [Utils hideHudViewWithSuperView:self.view];
        
        if (error) {
            NSLog(@"%@----",error);
        }else{
            
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
          
            if ([[Utils GetResultCode:ResponseDic] isEqualToString:@"0"]) {
                NSLog(@"123578");
                UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"修改手机号码成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                av.tag=11;
                [av show];
                
            }
            
        }
        
    }];





}



//获取验证码方法
- (IBAction)btnGetCode:(id)sender
{
    NSString *str =InputNewPhoneRow.tfRightTextField.text;
    if([Utils isMobileNumber:str]){
    
    [self loadDataFromNetwork];
    _leftTime = 121;
   // btnGetCode.enabled = NO;
        btnGetCode.userInteractionEnabled = NO;
        //modify by zhangqy  5s定时器不走的bug
    NSTimer *gcTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(gcTimerEvent:) userInfo:nil repeats:YES];
#if 0
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        _leftTime--;
        [btnGetCode setTitle:[NSString stringWithFormat:@"%d",_leftTime] forState:UIControlStateNormal];
        if (_leftTime==0) {
            dispatch_source_cancel(timer);
            btnGetCode.enabled = YES;
            [btnGetCode setTitle:kLocalized(@"get_verification_code") forState:UIControlStateNormal];
            
        }
    });
    dispatch_resume(timer);
#endif

}
    else
    {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:nil message:@"请输入正确的手机号码！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
    }

}
//zhangqy 5s定时器不走的bug
- (void)gcTimerEvent:(NSTimer*)timer
{
    _leftTime--;
    [btnGetCode setTitle:[NSString stringWithFormat:@"%d",_leftTime] forState:UIControlStateNormal];
    if (_leftTime==0) {
        [timer invalidate];
       // btnGetCode.enabled = YES;
        btnGetCode.userInteractionEnabled = YES;
        [btnGetCode setTitle:kLocalized(@"get_verification_code") forState:UIControlStateNormal];
    }

}


#pragma mark textfield delegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag==10) {
        _strCode=textField.text;
    }
    
}




-(void)setBorderWithView:(UIView*)view WithWidth:(CGFloat)width WithRadius:(CGFloat)radius WithColor:(UIColor *)color
{
    
    [view addTopBorder];
    view.layer.borderColor = color.CGColor;
    view.layer.cornerRadius = radius;
    
}

#pragma mark Alterview 代理方法

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (alertView.tag==11) {
        [self.navigationController popViewControllerAnimated:YES];
    }



}


@end
