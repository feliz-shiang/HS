//
//  GYCardBandingViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-21.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYDefaultCardViewController.h"


//#import "GYTestTableViewController.h"
#import "GYCardBandingViewController3.h"
//修改银行卡
#import "GYModifyCardViewController.h"
#import "CustomIOS7AlertView.h"
#import "UIView+CustomBorder.h"
@interface GYDefaultCardViewController ()

@end

@implementation GYDefaultCardViewController
{

    __weak IBOutlet UILabel *lbTrueName;//真实姓名
   
    __weak IBOutlet UITextField *tfInputRealName;//TF 输入真实姓名
   
    __weak IBOutlet UILabel *lbPayCurrency;//LB 结算币种

    __weak IBOutlet UILabel *lbOpenBank;//LB 开户银行
    
    __weak IBOutlet UILabel *lbOpenArea;//LB 开户地区
    
    __weak IBOutlet UILabel *lbCardNumber;// 银行卡
  
    __weak IBOutlet UIButton *btnGoNext;// 去下一页BTN

    __weak IBOutlet UIButton *btnOpenCard;// 选择开户银行BTN

    __weak IBOutlet UIImageView *imgDownBankSeprate;// 银行卡下面的分割线
    
    __weak IBOutlet UIImageView *imgNameDownSeparate;// 用户名下面的分割线
    
    __weak IBOutlet UIView *vInputBackground;// 白色背景
    
    __weak IBOutlet UITextField *tfInputPayCurrency;// TF 输入结算币种
    
    __weak IBOutlet UITextField *tfOpenBank;//tf 输入开户银行
    
    __weak IBOutlet UILabel *lbOpenAreaFront;

    __weak IBOutlet UIButton *btnChangeOpenArea;//BTN 改变开户地区的button
    
    __weak IBOutlet UITextField *tfInputBankNumber;//TF 输入卡号
    
    __weak IBOutlet UIImageView *imgLineUnderOpenBank;//分割线
    
    __weak IBOutlet UIImageView *imgLineUnderOpenArea;//分割线
    



    
    
}



//发起网络请求，请求成功后PUSH到下级页面
- (IBAction)btnGotoNext:(id)sender {

    [self LoadDataFromNetwork];
    
}


-(void)LoadDataFromNetwork
{
    NSMutableDictionary * dictInside =[[NSMutableDictionary alloc]init];
    
    [dictInside setValue:[GlobalData shareInstance].user.cardNumber forKey:@"resource_no"];
    
    [dictInside setValue:self.model.strBankAcctId  forKey:@"bank_id"];
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    
    [dict setValue:dictInside forKey:@"params"];
    
    [dict setValue:@"person" forKey:@"system"];
    
    [dict setValue:kuType forKey:@"uType"];
    
    [dict setValue:kHSMac forKey:@"mac"];
    
    [dict setValue:[GlobalData shareInstance].midKey forKey:@"mId"];
    
    [dict setValue:[GlobalData shareInstance].hsKey forKey:@"key"];
    
    [dict setValue:@"set_default_bank" forKeyPath:@"cmd"];
    
    [Network HttpGetForRequetURL:[[GlobalData shareInstance].hsDomain stringByAppendingString:@"/api"] parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        
        
        if (error) {
            NSLog(@"%@----",error);
            [Utils showMBProgressHud:self SuperView:self.view Msg:@"数据加载出错！" ShowTime:3.0];
        }else{
            
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            if ([[Utils GetResultCode:ResponseDic] isEqualToString:@"0"]) {
                [Utils hideHudViewWithSuperView:self.view];
                NSLog(@"123578");
                [self showAlertView];
            
                
            }else{
                UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"设置失败，请重试！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                
                [av show];
                
            }
            
        }
    }];
    

}


-(void)showAlertView
{
    // 创建控件
    CustomIOS7AlertView * alertView = [[CustomIOS7AlertView alloc] init];
    
    // 添加自定义控件到 alertView
    alertView.lineView1.hidden=YES;
    
    [alertView setContainerView:[self createUI]];
    
    // 添加按钮
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:kLocalized(@"confirm"),nil]];
    //设置代理
    //    [alertView setDelegate:self];
    
    // 通过Block设置按钮回调事件 可用代理或者block
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        NSLog(@"＝＝＝＝＝Block: Button at position %d is clicked on alertView %d.",
              buttonIndex, (int)[alertView tag]);
        
        //  [self goToBankList];
        
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];


}

-(void)goToBankList
{
   

}

-(UIView *)createUI
{
    //弹出的试图
    UIView * popView=[[UIView alloc]initWithFrame:CGRectMake(0, 5, 290, 48)];
    

  popView.backgroundColor=kConfirmDialogBackgroundColor;
    
    //开始添加弹出的view中的组件
    UIImageView * successImg =[[UIImageView alloc]initWithFrame:CGRectMake(30, 10, 30,30)];
    successImg.image=[UIImage imageNamed:@"img_succeed.png"];
    UILabel * lbTip =[[UILabel alloc]initWithFrame:CGRectMake(successImg.frame.origin.x+successImg.frame.size.width+10, 5, 200, 40)];
    lbTip.text=@"设置默认银行卡成功";
    lbTip.font=[UIFont systemFontOfSize:17.0];
    lbTip.backgroundColor=[UIColor clearColor];

    
    [popView addSubview:successImg];
    [popView addSubview:lbTip];

    return popView;
}

- (IBAction)btnChangeOpenArea:(id)sender {
//    GYTestTableViewController * vcTest =[[GYTestTableViewController alloc]init];
//    vcTest.delegate=self;
//    vcTest.tag=2;
//    vcTest.marrDataSource=[@[@"上海市",@"北京市",@"广东省深圳市罗湖区"] mutableCopy];
//    [self.navigationController pushViewController:vcTest animated:YES];
//    
    
}

//点击BTN 使用测试数据
- (IBAction)btnSelectBank:(id)sender {
//    GYTestTableViewController * vcTest =[[GYTestTableViewController alloc]init];
//    vcTest.delegate=self;
//    [self.navigationController pushViewController:vcTest animated:YES];
//   
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
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:kLocalized(@"modify") style: UIBarButtonItemStyleBordered target:self action:@selector(ToModifyCard)];
    tfInputBankNumber.enabled=NO;
    tfInputPayCurrency.enabled=NO;
    tfInputRealName.enabled=NO;
    tfOpenBank.enabled=NO;

    tfInputBankNumber.text=self.model.strBankAccount;
    tfInputPayCurrency.text=[GlobalData shareInstance].user.settlementCurrencyName;
    tfOpenBank.text=self.model.strBankName;
    tfInputRealName.text=self.model.strBankAcctName;
    lbOpenArea.text=self.model.strCityName;
    
    
    [btnOpenCard setBackgroundImage:[UIImage imageNamed:@"cell_btn_menu1.png"] forState:UIControlStateNormal];
    [btnGoNext setBackgroundImage:[UIImage imageNamed:@"btn_confirm_bg.png"] forState:UIControlStateNormal];
    [btnOpenCard setBackgroundImage:[UIImage imageNamed:@"img_bank_icon.png"] forState:UIControlStateNormal];
    [btnChangeOpenArea setBackgroundImage:[UIImage imageNamed:@"cell_btn_right_arrow.png"] forState:UIControlStateNormal];
    
    
    if (self.model.strDefaultFlag) {
        btnGoNext.hidden=YES;
    }else
    {
        btnGoNext.hidden=NO;
    }
   
    //设置分割线
    [self setSeprator];
    //修改控件名称，国际化
    [self modifyName];
    //设置字体颜色
    [self setTextColor];
    
}

//-(void)ToModifyCard
//{
//    DDLogInfo(@"修改，修改");
//
//    GYModifyCardViewController * vcBankBanding =[[GYModifyCardViewController alloc]initWithNibName:@"GYModifyCardViewController" bundle:nil];
//    vcBankBanding.model=self.model;
//    [self.navigationController pushViewController:vcBankBanding animated:YES];
//}

//设置国际化名称
-(void)modifyName
{
    lbCardNumber.text=kLocalized(@"bank_card_number");
    lbTrueName.text=kLocalized(@"real_name");
    [btnGoNext setTitle:kLocalized(@"default_card") forState:UIControlStateNormal];
    lbOpenBank.text=kLocalized(@"bank");
    lbPayCurrency.text=@"结算币种";


}

//设置文本颜色
-(void)setTextColor
{

    lbTrueName.textColor=kCellItemTitleColor;
    lbCardNumber.textColor=kCellItemTitleColor;
    lbOpenAreaFront.textColor=kCellItemTitleColor;
    lbTrueName.textColor=kCellItemTitleColor;
    lbCardNumber.textColor=kCellItemTitleColor;
    lbPayCurrency.textColor=kCellItemTitleColor;
    lbOpenArea.textColor=kCellItemTitleColor;
    lbOpenArea.textColor=kCellItemTitleColor;
    lbOpenBank.textColor=kCellItemTitleColor;
    tfInputRealName.textColor=kCellItemTitleColor;
    tfInputBankNumber.textColor=kCellItemTitleColor;
    tfInputPayCurrency.textColor=kCellItemTitleColor;
    tfOpenBank.textColor=kCellItemTitleColor;

}

//设置分割线
-(void)setSeprator
{
    
    [self setBorderWithView:imgNameDownSeparate WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
    [self setBorderWithView:imgDownBankSeprate WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
    [vInputBackground addAllBorder];
    [self setBorderWithView:imgLineUnderOpenArea WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
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
-(void)senderStr:  (NSString   *)str withTag:(int)tag
{
//    if (tag==2) {
//        tfOpenBank.text=str;
//    }
    
}

@end
