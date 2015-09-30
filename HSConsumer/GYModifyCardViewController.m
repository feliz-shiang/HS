//
//  GYCardBandingViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-21.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYModifyCardViewController.h"

//#import "GYTestTableViewController.h"

#import "GYDeleteCardViewController.h"

#import "CustomIOS7AlertView.h"

#import "UIView+CustomBorder.h"

#import "GYDeleteCardViewController.h"
@interface GYModifyCardViewController ()

@end

@implementation GYModifyCardViewController
{

    __weak IBOutlet UILabel *lbTrueName;//真实姓名
   
    __weak IBOutlet UITextField *tfInputRealName;//TF 输入真实姓名
   
    __weak IBOutlet UILabel *lbPayCurrency;//LB 结算币种

  
  
    __weak IBOutlet UILabel *lbOpenBank;//LB 开户银行
    
    __weak IBOutlet UILabel *lbOpenArea;//LB 开户地区
    
    __weak IBOutlet UILabel *lbOpenAreaFront;//LB 开户地区
    
    __weak IBOutlet UILabel *lbCardNumber;// 银行卡
  
  
    
    __weak IBOutlet UIButton *btnGoNext;// 去下一页BTN

    __weak IBOutlet UIButton *btnOpenCard;// 选择开户银行BTN

    __weak IBOutlet UIImageView *imgDownBankSeprate;// 银行卡下面的分割线
    
    __weak IBOutlet UIImageView *imgNameDownSeparate;// 用户名下面的分割线
    
    __weak IBOutlet UIView *vInputBackground;// 白色背景
    
    __weak IBOutlet UITextField *tfInputPayCurrency;// TF 输入结算币种
    
    __weak IBOutlet UITextField *tfOpenBank;//tf 输入开户银行
    
 
    
    __weak IBOutlet UIButton *btnChangeOpenArea;//BTN 改变开户地区的button
    
   
    
    __weak IBOutlet UITextField *tfInputBankNumber;//TF 输入卡号
    
    __weak IBOutlet UIImageView *imgLineUnderOpenBank;//分割线
    
    __weak IBOutlet UIImageView *imgLineUnderOpenArea;//分割线
    
    __weak IBOutlet UIImageView *imgLineUnderOpenBranch;//分割线

    
    __weak IBOutlet UIButton *btnDeleteCard;

    __weak IBOutlet UILabel *lbCardConfirm;

    __weak IBOutlet UITextField *InputCardConfimNumber;
    
    
    GYBankListModel * globelBankModel ;

}



//发起网络请求，请求成功后PUSH到下级页面
- (IBAction)btnGotoNext:(id)sender {

    [self   updateBankInfoRequest];
    
}

-(void)goToBankList
{


}

-(void)showAlertviewForUpdate
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
        
        [self goToBankList];
        
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];




}

-(void)updateBankInfoRequest
{
    NSMutableDictionary * dictInside =[[NSMutableDictionary alloc]init];
    
    [dictInside setValue:[GlobalData shareInstance].user.cardNumber forKey:@"resource_no"];
    [dictInside setValue:tfInputRealName.text forKey:@"bankAcctName"];
        [dictInside setValue:self.model.strBankAcctId forKey:@"bankAcctId"];
    NSString * provinceString =[[NSUserDefaults standardUserDefaults]objectForKey:@"province"];
    
    NSString * cityNoString =[[NSUserDefaults standardUserDefaults]objectForKey:@"cityNO"];
    
    NSString * cityName =[[NSUserDefaults standardUserDefaults]objectForKey:@"cityName"];
    
    [dictInside setValue:self.model.strBankCode forKey:@"bankCode"];

    [dictInside setValue:cityNoString forKey:@"bankAreaNo"];
    [dictInside setValue:tfInputBankNumber.text forKey:@"bankAccount"];
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
    
    [dict setValue:@"update_bind_bank" forKeyPath:@"cmd"];
    
    [Network HttpGetForRequetURL:[[GlobalData shareInstance].hsDomain stringByAppendingString:kHSApiAppendUrl] parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        
        
        if (error) {
            NSLog(@"%@----",error);
            [Utils showMBProgressHud:self SuperView:self.view Msg:@"数据加载出错！" ShowTime:3.0];
        }else{
            
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            if ([[Utils GetResultCode:ResponseDic] isEqualToString:@"0"]) {
                [Utils hideHudViewWithSuperView:self.view];
                NSLog(@"123578");

                
            }else{
                [Utils hideHudViewWithSuperView:self.view];
                UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"银行卡绑定失败，请重新绑定!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
                
                
                
            }
            
            
            
            
        }
    }];
    









}

-(UIView *)createUI
{
    //弹出的试图
    UIView * popView=[[UIView alloc]initWithFrame:CGRectMake(0, 5, 290, 135)];

    //开始添加弹出的view中的组件
    UIImageView * successImg =[[UIImageView alloc]initWithFrame:CGRectMake(30, 10, 25,18)];
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
    
    UILabel *  lbBandNumber =[[UILabel alloc]initWithFrame:CGRectMake(20,lbCardComment.frame.origin.y+lbCardComment.frame.size.height, 260, 30)];
    NSString * strBankNumber = @"6552 1145 2232 652";
    lbBandNumber.text=[NSString stringWithFormat:@"平安银行（%@）",strBankNumber];
    lbBandNumber.textColor=kCellItemTitleColor;
    lbBandNumber.font=[UIFont systemFontOfSize:15.0];
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


- (IBAction)btnChangeOpenArea:(id)sender {
    
    GYAddressCountryViewController * vcTest =[[GYAddressCountryViewController alloc]init];
    
    [self.navigationController pushViewController:vcTest animated:YES];
    
    
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=kLocalized(@"modify_bank_card");
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=kDefaultVCBackgroundColor;

       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAddress:) name:@"getAddress" object:nil];
    
    [btnOpenCard setBackgroundImage:[UIImage imageNamed:@"cell_btn_menu1.png"] forState:UIControlStateNormal];
    [btnGoNext setBackgroundImage:[UIImage imageNamed:@"btn_confirm_bg.png"] forState:UIControlStateNormal];
    [btnOpenCard setBackgroundImage:[UIImage imageNamed:@"img_bank_icon.png"] forState:UIControlStateNormal];
    [btnChangeOpenArea setBackgroundImage:[UIImage imageNamed:@"cell_btn_right_arrow.png"] forState:UIControlStateNormal];
    
    tfInputPayCurrency.enabled=YES;
    tfInputRealName.text=self.model.strBankAcctName;
    tfOpenBank.text=self.model.strBankCode;
    tfInputPayCurrency.text=[GlobalData shareInstance].user.settlementCurrencyName;
    tfInputBankNumber.text=self.model.strBankAccount;
    InputCardConfimNumber.text=self.model.strBankAccount;
    
   
    //设置分割线
    [self setSeprator];
    //修改控件名称，国际化
    [self modifyName];
    //设置字体颜色
    [self setTextColor];
    
}


-(void)getAddress:(NSNotification *)notification
{
    NSString * str =[notification object];
    
    NSLog(@"%@-----str",str);
    lbOpenArea.text=str;
    
    
}

//设置国际化名称
-(void)modifyName
{
    lbCardNumber.text=kLocalized(@"bank_card_number");
    lbTrueName.text=kLocalized(@"real_name");
    [btnGoNext setTitle:kLocalized(@"save_rightnow") forState:UIControlStateNormal];
    lbOpenArea.text=kLocalized(@"bank_open_area");
    lbOpenBank.text=kLocalized(@"bank");
    lbPayCurrency.text=kLocalized(@"settlement_currency");
    lbCardConfirm.text=kLocalized(@"comfirn_number");
    [btnDeleteCard setTitle:kLocalized(@"delete_card") forState:UIControlStateNormal];

}

//设置文本颜色
-(void)setTextColor
{
  
    lbTrueName.textColor=kCellItemTitleColor;
    lbCardNumber.textColor=kCellItemTitleColor;
    [btnDeleteCard setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    lbOpenAreaFront.textColor=kCellItemTitleColor;
    
    lbTrueName.textColor=kCellItemTitleColor;
    lbCardNumber.textColor=kCellItemTitleColor;
    lbPayCurrency.textColor=kCellItemTitleColor;
    lbOpenArea.textColor=kCellItemTitleColor;
    lbOpenAreaFront.textColor=kCellItemTitleColor;

    lbCardConfirm.textColor=kCellItemTitleColor;
    lbOpenBank.textColor=kCellItemTitleColor;
    
    tfInputRealName.textColor=kCellItemTitleColor;
    tfInputBankNumber.textColor=kCellItemTitleColor;
    InputCardConfimNumber.textColor=kCellItemTitleColor;
    tfInputPayCurrency.textColor=kCellItemTitleColor;
    tfOpenBank.textColor=kCellItemTitleColor;

}

//设置分割线
-(void)setSeprator
{
    [vInputBackground addAllBorder];
    [self setBorderWithView:imgNameDownSeparate WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
    [self setBorderWithView:imgDownBankSeprate WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];

    [self setBorderWithView:imgLineUnderOpenBank WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
    [self setBorderWithView:imgLineUnderOpenArea WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
    [self setBorderWithView:imgLineUnderOpenBranch WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
    [self setBorderWithView:imgLineUnderOpenBank WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
}

//设置分割线方法。
-(void)setBorderWithView:(UIView*)view WithWidth:(CGFloat)width WithRadius:(CGFloat)radius WithColor:(UIColor *)color
{
    
    [view addTopBorder];
    view.layer.borderColor = color.CGColor;
    view.layer.cornerRadius = radius;
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

//使用测试数据的代理方法。传回 选中Cell文本，显示在上级VC的LABEL中。
-(void)senderStr:  (NSString   *)str withTag:(int)tag
{
    if (tag==1) {
        tfOpenBank.text=str;
    }else if (tag ==2)
    {
        lbOpenArea.text=str;
    
    }


}

- (IBAction)btnToDeleteCard:(id)sender {
    
//    GYDeleteCardViewController * vcDeleteCard =[[GYDeleteCardViewController alloc]initWithNibName:@"GYDeleteCardViewController" bundle:nil];
//    [self.navigationController pushViewController:vcDeleteCard animated:YES];
  
    [self loadDataFromNetwork];
}


-(void)loadDataFromNetwork
{
    
    NSMutableDictionary * dictInside =[[NSMutableDictionary alloc]init];
    
    [dictInside setValue:[GlobalData shareInstance].user.cardNumber forKey:@"resource_no"];
    
    [dictInside setValue:self.model.strBankAcctId forKey:@"bank_id"];
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    
    [dict setValue:dictInside forKey:@"params"];
    
    [dict setValue:[GlobalData shareInstance].hsKey forKey:@"key"];
    
    [dict setValuesForKeysWithDictionary:@{@"system": @"person",@"uType": kuType,@"mac": kHSMac,@"mId": [GlobalData shareInstance].midKey}];
    
    
    [dict setValue:@"unbind_bank" forKeyPath:@"cmd"];
    [Utils showMBProgressHud:self SuperView:self.view.window Msg:@"数据加载中...."];
    [Network HttpGetForRequetURL:[[GlobalData shareInstance].hsDomain stringByAppendingString:@"/api"] parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        
        
        if (error) {
            NSLog(@"%@----",error);
        }else{
            
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            [Utils hideHudViewWithSuperView:self.view.window];
            if ([[Utils GetResultCode:ResponseDic] isEqualToString:@"0"]) {
                NSLog(@"123578");
                
          
            }
            
        }
        
    }];
    
}


//选择银行代理方法。
-(void)getSelectBank:(GYBankListModel *)model
{
    globelBankModel=model;
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"seletedBank.plist"];
    
    NSMutableData * Archiverdata =[[NSMutableData alloc]initWithContentsOfFile:path];
    
    //    NSKeyedUnarchiver * unArchiver =[[NSKeyedUnarchiver alloc]initForReadingWithData:Archiverdata];
    
    //    GYBankListModel * md= [unArchiver decodeObjectForKey:@"SelectBank"];
    _strOpenBank=globelBankModel.strBankName;
    tfOpenBank.text=_strOpenBank;

}

#pragma mark 选择国家的回调方法。

@end
