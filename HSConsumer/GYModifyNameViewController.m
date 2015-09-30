//
//  GYModifyNameViewController.m
//  HSConsumer
//
//  Created by apple on 15-1-23.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYModifyNameViewController.h"
#import "GlobalData.h"
@interface GYModifyNameViewController ()

@end

@implementation GYModifyNameViewController
{
    
    __weak IBOutlet UIView *vBackground;
    
    __weak IBOutlet UITextField *tfInputName;
    
    __weak IBOutlet UIButton *btnClearText;
    
    __weak IBOutlet UILabel *lbTips;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.view.backgroundColor=kDefaultVCBackgroundColor;
        
        vBackground.backgroundColor=[UIColor whiteColor];
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton * btnLeft =[UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame=CGRectMake(0, 0, 13, 19);
//    [btnLeft setTitle:@"返回" forState:UIControlStateNormal ];kLoadPng(@"nav_btn_back")
    [btnLeft setImage:[UIImage imageNamed:@"nav_btn_back"] forState:UIControlStateNormal];
    
    btnLeft.titleLabel.font=[UIFont boldSystemFontOfSize:19.0];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnLeft setBackgroundColor:[UIColor clearColor]];
    [btnLeft addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    tfInputName.text=self.strPlaceHolder;
    
    switch (self.indexPath.row) {
        case 0:
        {
            lbTips.text=@"好名字可以让你的朋友更容易记住你。";
            tfInputName.textColor=kCellItemTitleColor;
            lbTips.textColor=kCellItemTextColor;
            
        }
            
        case 1:
        {
            lbTips.text=@"好名字可以让你的朋友更容易记住你。";
            tfInputName.textColor=kCellItemTitleColor;
            lbTips.textColor=kCellItemTextColor;
            
        }
            break;
            
        default:
        {
            [lbTips removeFromSuperview];
            
        }
            break;
    }
    
    
    UIButton * btnRight =[UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame=CGRectMake(0, 0, 44, 44);
    [btnRight setTitle:@"保存" forState:UIControlStateNormal ];
    
    btnRight.titleLabel.font=[UIFont boldSystemFontOfSize:19.0];
    [btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnRight setBackgroundColor:[UIColor clearColor]];
    btnRight.tag=self.indexPath.row;
    [btnRight addTarget:self action:@selector(saveModifyName:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnRight];
    
    
}


-(void)saveModifyName:(UIButton *) sender
{
    
    GlobalData * data =[GlobalData shareInstance];
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    [dict setValue:data.ecKey forKey:@"key"];
    [dict setValue:data.midKey forKey:@"mid"];
    NSMutableDictionary * insideDict =[NSMutableDictionary dictionary];

    if ([Utils isBlankString:tfInputName.text]) {
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"输入内容不能为空！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil   , nil];
        [av show];
        return ;
    }
    
    switch (sender.tag) {
        case 0:
        {
            [insideDict setValue:tfInputName.text forKey:@"name"];
            
            
        }
            break;
        case 1:
            
        {
            [insideDict setValue:tfInputName.text forKey:@"nickName"];
            
        }
            break;
        case 3:
        {
            [insideDict setValue:tfInputName.text forKey:@"interest"];
        }
            break;
        case 4:
        {
            [insideDict setValue:tfInputName.text forKey:@"occupation"];

            
        }
            break;
        case 5:
        {
            [insideDict setValue:tfInputName.text forKey:@"mobile"];
            
        }
            break;
        default:
            break;
    }
    
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





- (IBAction)btnClearText:(id)sender {
    
    tfInputName.text=@"";
    
}

-(void)goback
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    if (_delegate && [_delegate respondsToSelector:@selector(getInputedText:WithIndexPath:)]) {
        [_delegate getInputedText:_strText WithIndexPath:self.indexPath];
    }
}



#pragma mark textfieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _strText=textField.text;
    
}



#pragma mark alertview 代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
    
}

- (void)alertViewCancel:(UIAlertView *)alertView
{

  [self.navigationController popViewControllerAnimated:YES];

}

@end
