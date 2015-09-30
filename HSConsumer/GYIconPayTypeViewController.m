//
//  GYIconPayTypeViewController.m
//  HSConsumer
//
//  Created by apple on 15-4-1.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYIconPayTypeViewController.h"
#import "InputCellStypeView.h"
#import "GYEPMyAllOrdersViewController.h"
#import "GYencryption.h"
#import "UIButton+enLargedRect.h"
#import "GYPayoffViewController.h"
// add by songjk
#import "GYResultView.h"
@interface GYIconPayTypeViewController ()<GYResultViewDelegate>

@end

@implementation GYIconPayTypeViewController
{

    __weak IBOutlet InputCellStypeView *InputOrderAmountRow;//支付方式

    __weak IBOutlet InputCellStypeView *InputIconAmountRow;//订单编号

    __weak IBOutlet InputCellStypeView *InputTradePwdRow;//订单时间
    
    

    __weak IBOutlet UIButton *btnConfirm;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=kDefaultVCBackgroundColor;
    self.title=@"互生币支付确认";
    
    self.navigationItem.leftBarButtonItem= [self createBackButton];
    
    [self modifyName];
    

}

-(UIBarButtonItem*) createBackButton
{
    UIImage* image= kLoadPng(@"nav_btn_back");
    //    CGRect backframe= CGRectMake(0, 0, 44, 44);
    CGRect backframe= CGRectMake(0, 0, image.size.width * 0.5, image.size.height * 0.5);
    //    NSLog(@"nav_btn_back size:%@", NSStringFromCGRect(backframe));
    UIButton* backButton= [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = backframe;
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    
    [backButton setTitle:@"" forState:UIControlStateNormal];
    [backButton setEnlargEdgeWithTop:10 right:10 bottom:10 left:25];
    
    [backButton addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* someBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:backButton];
    return someBarButtonItem;
}

-(void)popself
{

    
    //避免返回到提交订单页面
    if ([self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2] isKindOfClass:[GYPayoffViewController class]]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    
    }

}


- (void)modifyName
{
    InputOrderAmountRow.tfRightTextField.textColor = [UIColor redColor];
    InputOrderAmountRow.lbLeftlabel.text=@"订单金额";
    InputOrderAmountRow.tfRightTextField.text= [Utils formatCurrencyStyle:[self.strPriceAmount doubleValue]];
    
    InputIconAmountRow.tfRightTextField.textColor = [UIColor redColor];
    InputIconAmountRow.lbLeftlabel.text=@"互生币支付金额";
    InputIconAmountRow.tfRightTextField.text=[Utils formatCurrencyStyle:[self.strPriceAmount doubleValue]];
    
    InputTradePwdRow.lbLeftlabel.text=@"交易密码";
    InputTradePwdRow.tfRightTextField.placeholder=@"输入交易密码";
    
    
    
    
    [btnConfirm setTitle:@"确认" forState:UIControlStateNormal];
    [btnConfirm setBackgroundImage:[UIImage imageNamed:@"btn_confirm_bg.png"] forState:UIControlStateNormal];
    
    
    NSLog(@"%@-=-bbbbbbb",self.strOrderId);


}


-(void)loadDataFromNetwork
{
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    [dict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
    [dict setValue:self.strOrderId forKey:@"orderId"];
    
    NSString *pwd = [GYencryption l:InputTradePwdRow.tfRightTextField.text k:[GlobalData shareInstance].user.cardNumber];
    [dict setValue:pwd forKey:@"payPwd"];
    [dict setValue:self.strPriceAmount forKey:@"amount"];
    // modify by songjk 互生币改为000
//    [dict setValue:[GlobalData shareInstance].user.currencyCode forKey:@"coinCode"];
    [dict setValue:@"000" forKey:@"coinCode"];
    [dict setValue:@"ios" forKey:@"osType"];
    
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"加载中..."];
    
    // modify by songjk 改变提示方式
    GYResultView* vReslut = [[GYResultView alloc] init];
    vReslut.delegate = self;
    //测试get
    [Network  HttpGetForRequetURL:[NSString stringWithFormat:@"%@/easybuy/payHsbOnline",[GlobalData shareInstance].ecDomain] parameters:(NSDictionary *)dict requetResult:^(NSData *jsonData, NSError *error) {
        [Utils hideHudViewWithSuperView:self.view];
        if (error) {
            //网络请求错误
            
        }else{
            
            [Utils hideHudViewWithSuperView:self.view];
            
            NSDictionary *ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            NSString * str =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
            
            if ([str isEqualToString:@"200"])
            {
                //返回正确数据，并进行解析
                InputTradePwdRow.tfRightTextField.text=@"";
                [vReslut showWithView:self.view status:YES message:@"支付成功！"];
                
//                [UIAlertView showWithTitle:nil message:@"支付成功！" cancelButtonTitle:kLocalized(@"confirm") otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
//                    GYEPMyAllOrdersViewController * epMyOrderVc = [[GYEPMyAllOrdersViewController alloc]initWithNibName:@"GYEPMyAllOrdersViewController" bundle:nil];
//                    epMyOrderVc.title=kLocalized(@"ep_myorder_all_order"); // modify by songjk 改成全部订单
//                    [self setHidesBottomBarWhenPushed:YES];
//                    [self.navigationController pushViewController:epMyOrderVc animated:YES];
//                }];
            
                
#import "UIAlertView+Blocks.h"
                
                
                
            }else if ([str isEqualToString:@"590"])
            {
                [vReslut showWithView:self.view status:NO message:@"互生币支付余额不足！"];
//                UIAlertView * av  = [[UIAlertView alloc]initWithTitle:nil message:@"互生币支付余额不足！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//                [av show];
    
            }else if ([str isEqualToString:@"783"])
            {
                [vReslut showWithView:self.view status:NO message:@"该用户交易密码未设置！"];
//                UIAlertView * av  = [[UIAlertView alloc]initWithTitle:nil message:@"该用户交易密码未设置!" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//                [av show];
            
            }
            else if ([str isEqualToString:@"792"])// add by songjk
            {
                [vReslut showWithView:self.view status:NO message:@"支付密码校验失败！"];
//                UIAlertView * av  = [[UIAlertView alloc]initWithTitle:nil message:@"支付密码校验失败!" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//                [av show];
                
            }
            else{
                [vReslut showWithView:self.view status:NO message:@"支付失败！"];
//                UIAlertView * av  = [[UIAlertView alloc]initWithTitle:nil message:@"支付失败！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//                [av show];
            }
        }
    }];




}


- (IBAction)btnConfirmAction:(id)sender {
    // add by songjk 校验密码
    if (!InputTradePwdRow.tfRightTextField.text || InputTradePwdRow.tfRightTextField.text.length !=8)
    {
        [Utils showMBProgressHud:self SuperView:self.view Msg:@"请输入8位支付密码" ShowTime:0.5];
        return;
    }
    [self loadDataFromNetwork];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // modify by songjk 计算长度修改
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    unsigned long len = toBeString.length;
    if (textField.tag==10)
    {
        if(len > 8) return NO;
        
    }
    return YES;
}
#pragma mark GYResultViewDelegate
-(void)ResultViewConfrimButtonClicked:(GYResultView *)ResultView success:(BOOL)success
{
    if (success)
    {
        GYEPMyAllOrdersViewController * epMyOrderVc = [[GYEPMyAllOrdersViewController alloc]initWithNibName:@"GYEPMyAllOrdersViewController" bundle:nil];
        epMyOrderVc.title=kLocalized(@"ep_myorder_all_order"); // modify by songjk 改成全部订单
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:epMyOrderVc animated:YES];
    }
}
@end
