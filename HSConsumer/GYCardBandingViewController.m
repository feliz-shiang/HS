//
//  GYCardBandingViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-21.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYCardBandingViewController.h"
#import "GYCardBandingViewController3.h"
#import "CustomIOS7AlertView.h"
#import "UIView+CustomBorder.h"
//全局数据
#import  "GlobalData.h"
#import  "GYBankListModel.h"

#import "GYNavigationController.h"
//选国家
#import "GYAddressCountryViewController.h"
#import "UIButton+enLargedRect.h"
@interface GYCardBandingViewController ()

@end

@implementation GYCardBandingViewController
{
    
    __weak IBOutlet UILabel *lbTrueName;//真实姓名
    
    __weak IBOutlet UITextField *tfInputRealName;//TF 输入真实姓名
    
    __weak IBOutlet UILabel *lbPayCurrency;//LB 结算币种

    __weak IBOutlet UILabel *lbOpenBank;//LB 开户银行
    
    __weak IBOutlet UITextField *tfInputOpenArea;
    
    __weak IBOutlet UILabel *lbOpenAreaFront;
    
    __weak IBOutlet UILabel *lbCardNumber;// 银行卡
    
    __weak IBOutlet UILabel *lbComfirnNumber;// LB 确认卡号
    
    __weak IBOutlet UIButton *btnGoNext;// 去下一页BTN
    
    __weak IBOutlet UIButton *btnOpenCard;// 选择开户银行BTN
    
    __weak IBOutlet UIImageView *imgDownBankSeprate;// 银行卡下面的分割线
    
    __weak IBOutlet UIImageView *imgNameDownSeparate;// 用户名下面的分割线
    
    __weak IBOutlet UIView *vInputBackground;// 白色背景
    
    __weak IBOutlet UITextField *tfInputPayCurrency;// TF 输入结算币种
    
    __weak IBOutlet UITextField *tfOpenBank;//tf 输入开户银行
    
    __weak IBOutlet UIButton *btnChangeOpenArea;//BTN 改变开户地区的button
    
    __weak IBOutlet UITextField *tfInputComfirnNumber;// TF  输入确认卡号
    
    __weak IBOutlet UITextField *tfInputBankNumber;//TF 输入卡号
    
    __weak IBOutlet UIImageView *imgLineUnderOpenBank;//分割线
    
    __weak IBOutlet UIImageView *imgLineUnderOpenArea;//分割线
    
    __weak IBOutlet UIImageView *imgLineUnderBankNumber;//分割线
    
    GlobalData * data;
    
    GYBankListModel * globelBankModel ;

}

//发起网络请求，请求成功后PUSH到下级页面
- (IBAction)btnGotoNext:(id)sender {
    
    [self loadDataFromNetwork];

}

-(void)goToBankList
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)showAlertview
{
        // 创建控件
        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    
        // 添加自定义控件到 alertView
        [alertView setContainerView:[self createUI]];
    
        // 添加按钮
        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:kLocalized(@"confirm"),nil]];
        //设置代理
        //    [alertView setDelegate:self];
    
        // 通过Block设置按钮回调事件 可用代理或者block
        [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
            NSLog(@"＝＝＝＝＝Block: Button at position %d is clicked on alertView %d.",
                  buttonIndex, (int)[alertView tag]);
    
            [alertView close];
            
            [self goToBankList];
    
            
        }];
    
        [alertView setUseMotionEffects:true];
        
        // And launch the dialog
        [alertView show];


}

-(UIView *)createUI
{
    //弹出的试图
    UIView * popView=[[UIView alloc]initWithFrame:CGRectMake(0, 5, 290, 135)];
    //开始添加弹出的view中的组件
    UIImageView * successImg =[[UIImageView alloc]initWithFrame:CGRectMake(30, 7, 30,30)];
    successImg.image=[UIImage imageNamed:@"img_succeed.png"];
    UILabel * lbTip =[[UILabel alloc]initWithFrame:CGRectMake(successImg.frame.origin.x+successImg.frame.size.width+10, 2, 200, 30)];
    lbTip.text=kLocalized(@"tip_your_card_is_banding");
    lbTip.font=[UIFont systemFontOfSize:17.0];
    lbTip.backgroundColor=[UIColor clearColor];
    UILabel * lbCardComment =[[UILabel alloc]initWithFrame:CGRectMake(20, lbTip.frame.origin.y+lbTip.frame.size.height+15, 160, 30)];
    lbCardComment.text=@"您的银行卡信息为：";
    lbCardComment.textColor=kCellItemTitleColor;
    lbCardComment.font=[UIFont systemFontOfSize:17.0];
    lbCardComment.backgroundColor=[UIColor clearColor];
    
    UILabel *  lbBandNumber =[[UILabel alloc]initWithFrame:CGRectMake(20,lbCardComment.frame.origin.y+lbCardComment.frame.size.height, 250, 30)];
    NSString * strBankNumber = tfInputComfirnNumber.text;
    lbBandNumber.text=[NSString stringWithFormat:@"%@",strBankNumber];
    lbBandNumber.textColor=kCellItemTitleColor;
    lbBandNumber.font=[UIFont systemFontOfSize:16.0];
    lbBandNumber.backgroundColor=[UIColor clearColor];
    [popView addSubview:successImg];
    [popView addSubview:lbTip];
    [popView addSubview:lbCardComment];
    [popView addSubview:lbBandNumber];
    return popView;
}

//点击BTN 使用测试数据
- (IBAction)btnSelectBank:(id)sender {
    
    GYBankListViewController * vcSelectBank =[[GYBankListViewController alloc]init];
    vcSelectBank.delegate=self;
    [self.navigationController pushViewController:vcSelectBank animated:YES];
    
}


- (IBAction)btnChangeOpenArea:(id)sender
{
    GYAddressCountryViewController * vcTest =[[GYAddressCountryViewController alloc]init];
    vcTest.addressType=noLocationfunction;
    vcTest.fromBandingCard=1;
    [self.navigationController pushViewController:vcTest animated:YES];
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=kLocalized(@"bank_card_binding");
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=kDefaultVCBackgroundColor;
    _marrBankList=[NSMutableArray array];

    [btnGoNext setBackgroundImage:[UIImage imageNamed:@"btn_confirm_bg.png"] forState:UIControlStateNormal];
    [btnOpenCard setBackgroundImage:[UIImage imageNamed:@"img_bank_icon.png"] forState:UIControlStateNormal];
    [btnChangeOpenArea setBackgroundImage:[UIImage imageNamed:@"cell_btn_right_arrow.png"] forState:UIControlStateNormal];
    
    [self modifyName];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAddress:) name:@"getAddress" object:nil];
    //设置分割线
    [self setSeprator];
    //修改控件名称，国际化
  
    //设置字体颜色
    [self setTextColor];
    
    //add by zhangqy
    [tfInputBankNumber addTarget:self action:@selector(tfBankNumChanged:) forControlEvents:UIControlEventEditingChanged];
    tfInputBankNumber.keyboardType = UIKeyboardTypeNumberPad;
    [tfInputComfirnNumber addTarget:self action:@selector(tfBankNumChanged:) forControlEvents:UIControlEventEditingChanged];
    tfInputComfirnNumber.keyboardType = UIKeyboardTypeNumberPad;
    
      
}

-(void)tfBankNumChanged:(UITextField*)textField
{
    NSString *inputText = textField.text;
    if (inputText.length>=19) {
        textField.text = [inputText substringToIndex:19];
    }
}

-(void)getAddress:(NSNotification *)notification
{
    NSString * str =[notification object];
    
    _strOpenArea=str;
    tfInputOpenArea.text=_strOpenArea;


}
-(void)loadDataFromNetwork
{
    if ([Utils isBlankString:tfInputRealName.text]) {
        UIAlertView * av = [[UIAlertView alloc] initWithTitle:nil message:@"请输入真实姓名！" delegate:self cancelButtonTitle:kLocalized(@"confirm") otherButtonTitles:nil, nil];
        [av show];
          return ;
    }
   
    else if (![Utils isBankCardNo:tfInputBankNumber.text])
    {
        UIAlertView * av = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确银行账号！" delegate:self cancelButtonTitle:kLocalized(@"confirm") otherButtonTitles:nil, nil];
        [av show];
          return ;
    }
    else if(![tfInputBankNumber.text isEqualToString:tfInputComfirnNumber.text] )
    {
        UIAlertView * av = [[UIAlertView alloc] initWithTitle:nil message:@"请输入确认账号！" delegate:self cancelButtonTitle:kLocalized(@"confirm") otherButtonTitles:nil, nil];
        [av show];
          return ;
    }
    [self loadDataFromNetworkRequest];
    
}
#pragma mark textfieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 10:
        {
            _strRealName=textField.text;
            
        }
            break;
        case 11:
        {
            _strBalanceCurrency=textField.text;
            
        }
            break;
        case 12:
        {
            _strOpenBank=textField.text;
            
        }
            break;
        case 13:
        {
            _strOpenArea=textField.text;

        }
            break;
           
        case 14:
        {
            _strBankNumber=textField.text;
            
        }
            break;
        case 15:
        {
            _strBankNumberAgain=textField.text;
            
        }
            break;
 
        default:
            break;
    }
}


-(void)loadDataFromNetworkRequest
{
    
    if ([Utils isBlankString:tfInputRealName.text]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"请输入真实姓名" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return ;
    }else if ([Utils isBlankString:tfInputPayCurrency.text])
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"请输入结算货币" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return ;
        
    }else if ([Utils isBlankString:_strOpenBank])
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"请输入开户银行" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return ;
    }else if ([Utils isBlankString:_strOpenArea])
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"请输入开户地区" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return ;
    }
  
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"数据加载中..."];
    
    NSMutableDictionary * dictInside =[[NSMutableDictionary alloc]init];
    
    [dictInside setValue:[GlobalData shareInstance].user.cardNumber forKey:@"resource_no"];
    [dictInside setValue:tfInputRealName.text forKey:@"bankAcctName"];
     NSString * provinceString =[[NSUserDefaults standardUserDefaults]objectForKey:@"province"];
    
    
    NSString * cityNoString =[[NSUserDefaults standardUserDefaults]objectForKey:@"cityNO"];
    
    NSString * cityName =[[NSUserDefaults standardUserDefaults]objectForKey:@"cityName"];
    
    [dictInside setValue:globelBankModel.strBankCode forKey:@"bankCode"];

    [dictInside setValue:cityNoString forKey:@"bankAreaNo"];
    [dictInside setValue:_strBankNumber forKey:@"bankAccount"];
    [dictInside setValue:@"DR_CARD" forKey:@"acctType"];
    [dictInside setValue:provinceString forKey:@"provinceCode"];
    [dictInside setValue:cityName forKey:@"cityName"];
   

    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    
    [dict setValue:dictInside forKey:@"params"];
    
    [dict setValue:@"person" forKey:@"system"];
    
    [dict setValue:kuType forKey:@"uType"];
    
    [dict setValue:kHSMac forKey:@"mac"]; 
    
    [dict setValue:[GlobalData shareInstance].midKey forKey:@"mId"];
    
    [dict setValue:[GlobalData shareInstance].hsKey forKey:@"key"];
    
    [dict setValue:@"bind_bank" forKeyPath:@"cmd"];
    
    [Network HttpGetForRequetURL:[[GlobalData shareInstance].hsDomain stringByAppendingString:kHSApiAppendUrl] parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
              [Utils hideHudViewWithSuperView:self.view];
        
        if (error) {
           
            [Utils showMBProgressHud:self SuperView:self.view Msg:@"数据加载出错！" ShowTime:3.0];
        }else{
           
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
 
            if ([[Utils GetResultCode:ResponseDic] isEqualToString:@"0"]) {
                [GlobalData shareInstance].user.isBankBinding=YES;
                [GlobalData shareInstance].personInfo.emailFlag=@"Y";
                
            
                [self showAlertview];
                
            }else{
                     [Utils hideHudViewWithSuperView:self.view];
                UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"银行卡绑定失败，请重新绑定!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show]; 
            }
        }
    }];
    
    
}

//设置国际化名称
-(void)modifyName
{
    lbCardNumber.text=kLocalized(@"bank_card_number");
    lbTrueName.text=kLocalized(@"real_name");
    [btnGoNext setTitle:kLocalized(@"banding_rightnow") forState:UIControlStateNormal];
    lbOpenAreaFront.textColor=kCellItemTitleColor;
    lbPayCurrency.text=@"结算货币";
    lbComfirnNumber.text=@"确认卡号";
    tfInputBankNumber.placeholder=@"输入银行账号";
    tfInputComfirnNumber.placeholder=@"再次输入银行账号";
    tfInputPayCurrency.text=[GlobalData shareInstance].user.settlementCurrencyName;
    tfInputRealName.text=[GlobalData shareInstance].personInfo.custName;
    tfOpenBank.placeholder=@"输入开户银行";
    tfInputOpenArea.placeholder=@"输入开户地区";
     [btnChangeOpenArea setEnlargEdgeWithTop:20.0f right:20.0f bottom:20.0f left:10.0f];
    

}

//设置文本颜色
-(void)setTextColor
{
    
    lbOpenAreaFront.textColor=kCellItemTitleColor;
    lbTrueName.textColor=kCellItemTitleColor;
    lbCardNumber.textColor=kCellItemTitleColor;
    lbPayCurrency.textColor=kCellItemTitleColor;
    lbComfirnNumber.textColor=kCellItemTitleColor;
    lbOpenBank.textColor=kCellItemTitleColor;
    tfInputRealName.textColor=kCellItemTitleColor;
    tfInputBankNumber.textColor=kCellItemTitleColor;
    tfInputComfirnNumber.textColor=kCellItemTitleColor;
    tfInputPayCurrency.textColor=kCellItemTitleColor;
    tfOpenBank.textColor=kCellItemTitleColor;
    tfInputOpenArea.textColor=kCellItemTitleColor;
    
}

//设置分割线
-(void)setSeprator
{
    
    [self setBorderWithView:imgNameDownSeparate WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
    [self setBorderWithView:imgDownBankSeprate WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
    [vInputBackground addAllBorder];
    [self setBorderWithView:imgLineUnderBankNumber WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
    [self setBorderWithView:imgLineUnderOpenArea WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
    //    [self setBorderWithView:imgLineUnderOpenBranch WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
    [self setBorderWithView:imgLineUnderOpenBank WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
}

//设置分割线方法。
-(void)setBorderWithView:(UIView*)view WithWidth:(CGFloat)width WithRadius:(CGFloat)radius WithColor:(UIColor *)color
{
    
    [view addTopBorder];
    view.layer.borderColor = color.CGColor;
    view.layer.cornerRadius = radius;
    
}

//使用测试数据的代理方法。传回 选中Cell文本，显示在上级VC的LABEL中。
-(void)senderStr:  (NSString   *)str
{
    
    _strOpenArea=str;
    tfOpenBank.text=_strOpenArea;
    
}




#pragma mark 获取选中的银行 model
-(void)getSelectBank:(GYBankListModel *)model
{
   
    globelBankModel=model;
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"seletedBank.plist"];
    
    NSMutableData * Archiverdata =[[NSMutableData alloc]initWithContentsOfFile:path];

    _strOpenBank=globelBankModel.strBankName;
    tfOpenBank.text=_strOpenBank;
    

}

@end
