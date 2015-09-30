//
//  GYCardBandingViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-21.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYDeleteCardViewController.h"


//#import "GYTestTableViewController.h"
#import "GYCardBandingViewController3.h"


#import "CustomIOS7AlertView.h"
#import "UIView+CustomBorder.h"
#import "GlobalData.h"

@interface GYDeleteCardViewController ()

@end

@implementation GYDeleteCardViewController
{

    __weak IBOutlet UILabel *lbTrueName;//真实姓名
   
    __weak IBOutlet UITextField *tfInputRealName;//TF 输入真实姓名
  
    __weak IBOutlet UILabel *lbOpenBank;//LB 开户银行
    
    __weak IBOutlet UILabel *lbCardNumber;// 银行卡
  
    __weak IBOutlet UIButton *btnGoNext;// 去下一页BTN

    __weak IBOutlet UIButton *btnOpenCard;// 选择开户银行BTN

    __weak IBOutlet UIImageView *imgDownBankSeprate;// 银行卡下面的分割线
    
    __weak IBOutlet UIImageView *imgNameDownSeparate;// 用户名下面的分割线
    
    __weak IBOutlet UIView *vInputBackground;// 白色背景
    
    __weak IBOutlet UITextField *tfOpenBank;//tf 输入开户银行
    
    __weak IBOutlet UITextField *tfInputBankNumber;//TF 输入卡号
    
    
}



//发起网络请求，请求成功后PUSH到下级页面
- (IBAction)btnGotoNext:(id)sender {
    
    [self  loadDataFromNetwork];


    
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
                
                [self showCustomAlertView];
                
            }
            
        }
        
    }];
    
}

-(void)showCustomAlertView
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
              
             [self.navigationController popViewControllerAnimated:YES];
              
            }];
    
         [alertView setUseMotionEffects:true];
    
          // And launch the dialog
         [alertView show];



}

-(void)goToBankList
{
    GYCardBandingViewController3 * vcBankBanding =[[GYCardBandingViewController3 alloc]initWithNibName:@"GYCardBandingViewController3" bundle:nil];
    [self.navigationController pushViewController:vcBankBanding animated:YES];

}
-(UIView *)createUI
{
    //弹出的试图
    UIView * popView=[[UIView alloc]initWithFrame:CGRectMake(0, 5, 290, 135)];
    
    //开始添加弹出的view中的组件
    UIImageView * successImg =[[UIImageView alloc]initWithFrame:CGRectMake(30, 10, 25,18)];
    successImg.image=[UIImage imageNamed:@"img_succeed.png"];
    UILabel * lbTip =[[UILabel alloc]initWithFrame:CGRectMake(successImg.frame.origin.x+successImg.frame.size.width+10, 2, 200, 30)];
    lbTip.text=kLocalized(@"tip_your_card_is_release");
    lbTip.font=[UIFont systemFontOfSize:17.0];
    lbTip.backgroundColor=[UIColor clearColor];
    UILabel * lbCardComment =[[UILabel alloc]initWithFrame:CGRectMake(successImg.frame.origin.x, lbTip.frame.origin.y+lbTip.frame.size.height+15, 160, 30)];
    lbCardComment.text=@"您的银行卡信息为：";
    lbCardComment.textColor=kCellItemTitleColor;
    lbCardComment.font=[UIFont systemFontOfSize:17.0];
    lbCardComment.backgroundColor=[UIColor clearColor];
    
    UILabel *  lbBandNumber =[[UILabel alloc]initWithFrame:CGRectMake(successImg.frame.origin.x,lbCardComment.frame.origin.y+lbCardComment.frame.size.height, 230, 30)];
    NSString * strBankNumber = self.model.strBankAccount;
    lbBandNumber.text=[NSString stringWithFormat:@"%@",strBankNumber];
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
//    GYTestTableViewController * vcTest =[[GYTestTableViewController alloc]init];
//    vcTest.delegate=self;
//    vcTest.marrDataSource=[@[@"招商银行",@"建设银行",@"平安银行" ,@"农业银行"] mutableCopy];
//    [self.navigationController pushViewController:vcTest animated:YES];
//   
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=kLocalized(@"delete_card");
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=kDefaultVCBackgroundColor;

    [btnOpenCard setBackgroundImage:[UIImage imageNamed:@"cell_btn_menu1.png"] forState:UIControlStateNormal];
    [btnGoNext setBackgroundImage:[UIImage imageNamed:@"btn_confirm_bg.png"] forState:UIControlStateNormal];
    [btnOpenCard setBackgroundImage:[UIImage imageNamed:@"img_bank_icon.png"] forState:UIControlStateNormal];
   
    //设置分割线
    [self setSeprator];
    //修改控件名称，国际化
    [self modifyName];
    //设置字体颜色
    [self setTextColor];
    
}

//设置国际化名称
-(void)modifyName
{
    lbCardNumber.text=kLocalized(@"bank_card_number");
    lbTrueName.text=kLocalized(@"real_name");
    [btnGoNext setTitle:kLocalized(@"confirm_delete") forState:UIControlStateNormal];
    tfOpenBank.text=self.model.strBankName;
    tfInputRealName.text=self.model.strBankAcctName;
    tfInputBankNumber.text=self.model.strBankAccount;
    
  

}

//设置文本颜色
-(void)setTextColor
{
    lbTrueName.textColor=kCellItemTitleColor;
    lbCardNumber.textColor=kCellItemTitleColor;
    lbOpenBank.textColor=kCellItemTitleColor;
    tfInputBankNumber.textColor=kCellItemTextColor;
    tfInputRealName.textColor=kCellItemTextColor;
    tfOpenBank.textColor=kCellItemTextColor;
}

//设置分割线
-(void)setSeprator
{
    
    [self setBorderWithView:imgNameDownSeparate WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
    [self setBorderWithView:imgDownBankSeprate WithWidth:1 WithRadius:0 WithColor:kDefaultViewBorderColor];
    [vInputBackground addAllBorder];

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
    tfOpenBank.text=str;
    
}

@end
