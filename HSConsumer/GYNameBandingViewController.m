//
//  GYReSetPasswordViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-26.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYNameBandingViewController.h"
#import "InputCellStypeView.h"
#import  "GlobalData.h"
#import "UIAlertView+Blocks.h"
@interface GYNameBandingViewController ()

@end

@implementation GYNameBandingViewController
{

    __weak IBOutlet InputCellStypeView *InputHsNumberRow;
    
    __weak IBOutlet InputCellStypeView *InputRealNameRow;

    __weak IBOutlet InputCellStypeView *NameConfirmRow;
 
    __weak IBOutlet UIButton *btnConfirm;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         self.view.backgroundColor=kDefaultVCBackgroundColor;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self modifyName];
    
    
    if ([GlobalData shareInstance].user.userName.length>0) {
        
        int  count = [GlobalData shareInstance].user.userName.length-1;
     
        NSMutableString * appendSting ;
        appendSting =[NSMutableString string];
        for (int i=0; i<count; i++) {
            [appendSting appendString:@"*"];
        }
        NSString * strName = [NSString stringWithFormat:@"%@ %@ ",[[GlobalData shareInstance].user.userName  substringToIndex:1 ] ,appendSting];
        InputRealNameRow.tfRightTextField.text = strName;
    }else
    {
        
       
    
    }
    

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //有姓名的时候，就隐藏这两个控件
    if ([GlobalData shareInstance].user.userName) {
        
         NameConfirmRow.hidden=YES;
         btnConfirm.hidden=YES;
        
        
    }
    


}



-(void)modifyName
{
    self.title = @"实名绑定";
    InputHsNumberRow.lbLeftlabel.text=kLocalized(@"points_card_number");
    InputHsNumberRow.tfRightTextField.placeholder=kLocalized(@"input_points_card_number");
    InputRealNameRow.lbLeftlabel.text=kLocalized(@"real_name");
    InputRealNameRow.tfRightTextField.placeholder=kLocalized(@"input_realname");
    [btnConfirm setTitle:kLocalized(@"banding_rightnow") forState:UIControlStateNormal];
    [btnConfirm setBackgroundImage:[UIImage imageNamed:@"btn_confirm_bg"] forState:UIControlStateNormal];
    NameConfirmRow.lbLeftlabel.text=kLocalized(@"name_confirm");
    NameConfirmRow.tfRightTextField.placeholder=kLocalized(@"input_name_confirm_again");
    InputHsNumberRow.tfRightTextField.text=[GlobalData shareInstance].user.cardNumber;
    
}


-(void)loadDataFromNetworkRequest

{
    
    if (![InputRealNameRow.tfRightTextField.text isEqualToString:NameConfirmRow.tfRightTextField.text]) {
        UIAlertView * av = [[UIAlertView alloc] initWithTitle:nil message:@"输入信息错误，请重新输入" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [av show];
        return;
    }
    
    
    NSMutableDictionary * dictInside =[[NSMutableDictionary alloc]init];
    
    [dictInside setValue:[GlobalData shareInstance].user.cardNumber forKey:@"resource_no"];
   
    [dictInside setValue:NameConfirmRow.tfRightTextField.text forKey:@"real_name"];
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    
    [dict setValue:dictInside forKey:@"params"];
    
    [dict setValue:@"person" forKey:@"system"];
    
    [dict setValue:kuType forKey:@"uType"];
    
    [dict setValue:kHSMac forKey:@"mac"];
    
    [dict setValue:[GlobalData shareInstance].midKey forKey:@"mId"];
    
    [dict setValue:[GlobalData shareInstance].hsKey forKey:@"key"];
    
    [dict setValue:@"real_name_bind" forKeyPath:@"cmd"];
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"正在提交..."];
    
    [Network HttpGetForRequetURL:[[GlobalData shareInstance].hsDomain stringByAppendingString:@"/api"] parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        [Utils hideHudViewWithSuperView:self.view];
        
        if (error) {
            NSLog(@"%@----",error);
        }else{
            
            NSDictionary * ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            if ([[Utils GetResultCode:ResponseDic] isEqualToString:@"0"]) {
                
                [GlobalData shareInstance].user.userName=InputRealNameRow.tfRightTextField.text;
                [GlobalData shareInstance].personInfo.custName=InputRealNameRow.tfRightTextField.text;
                
                NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
                [notification postNotificationName:@"refreshPersonInfo" object:self];
                [UIAlertView showWithTitle:nil message:@"操作成功!" cancelButtonTitle:@"确认" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                 
                    if (_fromWhere==1) {
                        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
                    }else{
                        
                    [self.navigationController popViewControllerAnimated:YES];
                        
                    }
                    
                }];
                
            }else if ([[Utils GetResultCode:ResponseDic] isEqualToString:@"1"])
            {
                UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:ResponseDic[@"data"][@"resultMsg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            
            }
            
        }
    }];
    
    
}
- (IBAction)btnBanding:(id)sender {
    
    
    [self loadDataFromNetworkRequest];
    
}



@end
