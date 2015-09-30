//
//  GYSecurityAuthViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-23.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYSecurityAuthViewController.h"
#import "CustomIOS7AlertView.h"
#import "UIView+CustomBorder.h"
#import "GlobalData.h"
#import "UIAlertView+Blocks.h"
#import "GYCardInfoBandViewController.h"
@interface GYSecurityAuthViewController ()
//zhangqy 验证码倒计时
@property (nonatomic,assign)int leftTime;
@end

@implementation GYSecurityAuthViewController
{
    __weak IBOutlet UILabel *lbTopInfo;//顶部 提示信息
    
    __weak IBOutlet UILabel *lbPassword;//密码
    
    __weak IBOutlet UITextField *tfInputPassword;//输入密码
    
    __weak IBOutlet UITextField *tfCodeInput;//输入验证码
    
    __weak IBOutlet UILabel *lbAuthCode;//LB 验证码
    
    __weak IBOutlet UIButton *btnGetCode;//btn获取验证码
    
    __weak IBOutlet UIButton *btnGoNext;//下一步
    
    __weak IBOutlet UIImageView *imgMidllerSeprator;//分割线
    
    __weak IBOutlet UIView *vTopBgView;//背景VIEW
    
}
- (IBAction)btnGoNext:(id)sender {
    
    
    [self loadDataFromNetwork];
    
    
    
}


-(void)showCustomAlertView
{
    // 创建控件
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    
    // 添加自定义控件到 alertView
    [alertView setContainerView:[self createUI]];
    
    // 添加按钮
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"中国大陆",nil]];
    //设置代理
    //    [alertView setDelegate:self];
    
    // 通过Block设置按钮回调事件 可用代理或者block
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        NSLog(@"＝＝＝＝＝Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    
    [alertView show];



}
//创建VIEW
-(UIView *)createUI
{
    
    UIView * vBackground =[[UIView alloc]initWithFrame:CGRectMake(0, 10, 300, 100)];
    vBackground.backgroundColor=kConfirmDialogBackgroundColor;
    UIImageView * imgView =[[UIImageView  alloc]initWithImage:[UIImage imageNamed:@"img_succeed.png"]];
    imgView.frame=CGRectMake(70, 32,25, 18);
    
    UILabel *lbAlertText =[[UILabel alloc]initWithFrame:CGRectMake(imgView.frame.origin.x+imgView.frame.size.width+10, imgView.frame.origin.y-6, 140, 30)];
    
    lbAlertText.backgroundColor=[UIColor clearColor];
    lbAlertText.textColor=kCellItemTitleColor;
    lbAlertText.text=kLocalized(@"cellphone_banding_succeed");
    [vBackground addSubview:imgView];
    [vBackground addSubview:lbAlertText];
    
    return vBackground;
    
    
}

//警告框按钮代理回调事件设置
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    NSLog(@"呵呵好: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
    [alertView close];
}

//获取验证码
//modify by zhangqy 5s计时器不走的问题
- (IBAction)btnGetCode:(id)sender {
    [self   GetCodeRequest];
    _leftTime = 121;
    //btnGetCode.enabled = NO;
    btnGetCode.userInteractionEnabled = NO;
    NSTimer *gcTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(gcTimerEvent:) userInfo:nil repeats:YES];
#if 0
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        leftTime--;
        [btnGetCode setTitle:[NSString stringWithFormat:@"%d",leftTime] forState:UIControlStateNormal];
        if (leftTime==0) {
            dispatch_source_cancel(timer);
            btnGetCode.enabled = YES;
            [btnGetCode setTitle:kLocalized(@"get_verification_code") forState:UIControlStateNormal];
            
        }
    });
    dispatch_resume(timer);
#endif 
    

}

- (void)gcTimerEvent:(NSTimer*)timer
{
    _leftTime--;
    [btnGetCode setTitle:[NSString stringWithFormat:@"%d",_leftTime] forState:UIControlStateNormal];
    if (_leftTime==0) {
        [timer invalidate];
        //btnGetCode.enabled = YES;
        btnGetCode.userInteractionEnabled = YES;
        [btnGetCode setTitle:kLocalized(@"get_verification_code") forState:UIControlStateNormal];
    }
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=kLocalized(@"safety_verification");
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor=kDefaultVCBackgroundColor;
    //设置分割线
    [self setSeprator];
    //设置国际化名称
    [self modifyName];
    //设置文本颜色
    [self setTextColor];
    
    
}

//设置文本颜色
-(void)setTextColor
{
    lbPassword.textColor=kCellItemTitleColor;
    lbTopInfo.textColor=kCellItemTextColor;
    lbAuthCode.textColor=kCellItemTitleColor;
    
}

//设置国际化名称
-(void)modifyName
{
    lbPassword.text=kLocalized(@"pwd");
    tfCodeInput.placeholder=kLocalized(@"input_received_authentication_code");
    
    btnGetCode.layer.borderWidth=1.0f;
    btnGetCode.layer.borderColor=kNavigationBarColor.CGColor;
    btnGetCode.layer.masksToBounds=YES;
    btnGetCode.layer.cornerRadius=2.0f;
    [btnGetCode setTitle:kLocalized(@"get_verification_code") forState:UIControlStateNormal];
    [btnGetCode setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    [btnGoNext setTitle:kLocalized(@"confirm") forState:UIControlStateNormal];
    [btnGoNext setBackgroundImage:[UIImage imageNamed:@"btn_confirm_bg.png"] forState:UIControlStateNormal];
    tfInputPassword.placeholder=kLocalized(@"input_points_card_pwd");
   
    lbAuthCode.text=kLocalized(@"verification_code");
//    lbTopInfo.text=kLocalized(@"security_verify_tip");
   
     lbTopInfo.text=[NSString stringWithFormat:@"请输入%@*******%@收到的短信验证码",[_phoneNum substringToIndex:3],[_phoneNum substringFromIndex:8]];
}

-(void)GetCodeRequest
{
    
    NSMutableDictionary * dictInside =[[NSMutableDictionary alloc]init];
    
    [dictInside setValue:[GlobalData shareInstance].user.cardNumber forKey:@"resource_no"];
    [dictInside setValue:_phoneNum forKey:@"mobile"];
   
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    
    [dict setValue:dictInside forKey:@"params"];
    
    [dict setValue:[GlobalData shareInstance].hsKey forKey:@"key"];
    
    [dict setValuesForKeysWithDictionary:@{@"system": @"person",@"uType": kuType,@"mac": kHSMac,@"mId": [GlobalData shareInstance].midKey}];
    
    [dict setValue:@"get_mobile_verification_code_for_bind_or_change_mobile" forKeyPath:@"cmd"];
    
  //  [Utils showMBProgressHud:self SuperView:self.view Msg:@"数据加载中...."];
    [Network HttpGetForRequetURL:[[GlobalData shareInstance].hsDomain stringByAppendingString:kHSApiAppendUrl] parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        
        
        if (error) {
            [Utils hideHudViewWithSuperView:self.view];
            NSLog(@"%@----",error);
        }else{
            
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
 //           [Utils hideHudViewWithSuperView:self.view];
            if ([[Utils GetResultCode:ResponseDic] isEqualToString:@"0"]) {
                NSLog(@"成功获取有效数据");
//                UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"验证码已发送" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [av show];
             
            }else
            {
                UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"获取验证码失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
                
            
            }
            
        }
        
    }];
    
}

-(void)loadDataFromNetwork
{
    
    if ([Utils isBlankString:tfCodeInput.text]) {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入验证码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return ;
    }else if ([Utils isBlankString:tfInputPassword.text])
    {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"请输入密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return ;
    
    }
        
    
    NSMutableDictionary * dictInside =[[NSMutableDictionary alloc]init];
    
    [dictInside setValue:[GlobalData shareInstance].user.cardNumber forKey:@"resource_no"];
    [dictInside setValue:_phoneNum forKey:@"mobile"];
    [dictInside setValue:tfCodeInput.text forKey:@"verification_code"];
    [dictInside setValue:tfInputPassword.text   forKey:@"pwd"];
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    
    [dict setValue:dictInside forKey:@"params"];
    
    [dict setValue:[GlobalData shareInstance].hsKey forKey:@"key"];
    
    [dict setValuesForKeysWithDictionary:@{@"system": @"person",@"uType": kuType,@"mac": kHSMac,@"mId": [GlobalData shareInstance].midKey}];
  
    [dict setValue:@"bind_or_change_mobile" forKeyPath:@"cmd"];
    [Utils showMBProgressHud:self SuperView:self.view.window Msg:@"数据加载中...."];
    [Network HttpGetForRequetURL:[[GlobalData shareInstance].hsDomain stringByAppendingString:kHSApiAppendUrl] parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        
        
        if (error) {
            NSLog(@"%@----",error);
        }else{
            
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            [Utils hideHudViewWithSuperView:self.view.window];
            if ([[Utils GetResultCode:ResponseDic] isEqualToString:@"0"]) {
                NSLog(@"成功获取有效数据");
                [GlobalData shareInstance].user.isPhoneBinding=YES;
                [GlobalData shareInstance].personInfo.phoneFlag=@"Y";
//                UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"操作成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                av.tag=300;
//                [av show];
                
                
                [UIAlertView showWithTitle:@"操作成功！" message:nil cancelButtonTitle:kLocalized(@"confirm") otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                
                    {
                        
                        UIViewController * vc;
                        
                        for (vc in self.navigationController.viewControllers) {
                            if ([vc isKindOfClass:[GYCardInfoBandViewController class]]) {
                                [self.navigationController popToViewController:vc animated:YES];
                            }
                        }
                        
                    }
                    
                }];
                
            }else
            {
                UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"操作失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            
            }
            
        }
        
    }];
    
}

#pragma mark action 代理方法。
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (actionSheet.tag==300) {
        [self.navigationController popToRootViewControllerAnimated:YES];
 
    }
    
   
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{



}

//设置分割线
-(void)setSeprator
{
    [vTopBgView addAllBorder];
    [self setBorderWithView:imgMidllerSeprator WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
    
}

-(void)setBorderWithView:(UIView *)view WithWidth:(CGFloat)width WithRadius:(CGFloat)radius WithColor:(UIColor *)color
{
    
    [view addTopBorder];
    view.layer.borderColor = color.CGColor;
    view.layer.cornerRadius = radius;
    
    
}
@end
