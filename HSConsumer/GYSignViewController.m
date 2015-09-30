//
//  GYSignViewController.m
//  HSConsumer
//
//  Created by apple on 15-2-10.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYSignViewController.h"

@interface GYSignViewController ()

@end

@implementation GYSignViewController
{

    __weak IBOutlet UITextView *tvInputTextView;

    __weak IBOutlet UIView *vBackground;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.view.backgroundColor=kDefaultVCBackgroundColor;
    
    tvInputTextView.text=self.strSign;
    
    UIButton * leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(0, 0, 11  , 18);
    [leftBtn setBackgroundImage:kLoadPng(@"nav_btn_back") forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backToIndex) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UIButton * rightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(saveRequest) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
   
}



-(void)saveRequest
{
    if ([Utils isBlankString:tvInputTextView.text]) {
        UIAlertView * av = [[UIAlertView alloc]initWithTitle:nil message:@"输入内容不能为空！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return ;
    }
    
    
    if (self.useType==1) {
        [self changeHobRequest];
    }else
    {
        GlobalData * data =[GlobalData shareInstance];
        NSMutableDictionary * dict =[NSMutableDictionary dictionary];
        [dict setValue:data.ecKey forKey:@"key"];
        [dict setValue:data.midKey forKey:@"mid"];
        NSMutableDictionary * insideDict =[NSMutableDictionary dictionary];
        [insideDict setValue:tvInputTextView.text forKey:@"sign"];
        [insideDict setValue:data.IMUser.strUserId forKey:@"userId"];
        NSString * accountId =[NSString stringWithFormat:@"%@_%@",data.IMUser.strCard,data.IMUser.strAccountNo];
        
        [insideDict setValue:accountId forKey:@"accountId"];
        [dict setValue:insideDict forKey:@"data"];
        
        [Network HttpPostForImRequetURL:[data.hdImPersonInfoDomain  stringByAppendingString:@"/userc/updatePersonInfo"] parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
            
            NSDictionary * responseDic =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            NSString * retCode =[NSString stringWithFormat:@"%@",responseDic[@"retCode"]];
         
            if ([retCode isEqualToString:@"200"]) {
                UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            }else if([retCode isEqualToString:@"206"])
            {
                NSArray * arrSensitiveWord = responseDic[@"data"];
                
                UIAlertView * av =[[UIAlertView alloc]initWithTitle:@"修改失败" message:[NSString stringWithFormat:@"含敏感词 [%@]",[arrSensitiveWord componentsJoinedByString:@","]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
                
            }else{
                
                UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"修改失败，请重试。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
                
            }
            
            
            
            
        }];

    
    
    }
    
    
    
    
    
}

-(void)changeHobRequest
{
    GlobalData * data =[GlobalData shareInstance];
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    [dict setValue:data.ecKey forKey:@"key"];
    [dict setValue:data.midKey forKey:@"mid"];
    NSMutableDictionary * insideDict =[NSMutableDictionary dictionary];

    [insideDict setValue:tvInputTextView.text forKey:@"interest"];

    [insideDict setValue:data.IMUser.strUserId forKey:@"userId"];
    
    NSString * accountId =[NSString stringWithFormat:@"%@_%@",data.IMUser.strCard,data.IMUser.strAccountNo];
    
    [insideDict setValue:accountId forKey:@"accountId"];
    
    [dict setValue:insideDict forKey:@"data"];
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"提交中..."];
    [Network HttpPostForImRequetURL:[data.hdImPersonInfoDomain  stringByAppendingString:@"/userc/updatePersonInfo"] parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        [Utils hideHudViewWithSuperView:self.view];
        NSDictionary * responseDic =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
        
        NSString * retCode =[NSString stringWithFormat:@"%@",responseDic[@"retCode"]];
        
        if ([retCode isEqualToString:@"200"]) {
            UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
        }else if([retCode isEqualToString:@"206"])
        {
            NSArray * arrSensitiveWord = responseDic[@"data"];
            
            UIAlertView * av =[[UIAlertView alloc]initWithTitle:@"修改失败" message:[NSString stringWithFormat:@"含敏感词 [%@]",[arrSensitiveWord componentsJoinedByString:@","]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
            
        }
        
        else
        {
            [Utils showMBProgressHud:self SuperView:self.view Msg:@"修改失败！" ShowTime:3.0f];
            
        }
     
    }];


}

-(void)viewDidAppear:(BOOL)animated
{
   [super viewDidAppear:animated];
   [tvInputTextView becomeFirstResponder];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    _strText=textView.text;


}


#pragma mark alertview 代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:^{
//        nil;
//    }];
    
}


-(void)backToIndex
{
    if (_delegate && [_delegate respondsToSelector:@selector(sendSignTextString:)])
    {
        [self.navigationController popViewControllerAnimated:YES];
        [_delegate sendSignTextString:_strText];
        
    }
    
}

@end
