//
//  GYupdateNicknameViewController.m
//  HSConsumer
//
//  Created by apple on 15/6/18.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYupdateNicknameViewController.h"
#import "GYChatItem.h"

@interface GYupdateNicknameViewController ()

@end

@implementation GYupdateNicknameViewController
{



    __weak IBOutlet UITextField *tfInputNickName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"修改备注";
    self.view.backgroundColor=kDefaultVCBackgroundColor;
  
    tfInputNickName.placeholder=@"请输入备注";
    
    UIButton * btnLeft =[UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame=CGRectMake(0, 0, 44, 44);
    [btnLeft setTitle:@"返回" forState:UIControlStateNormal ];
    
    btnLeft.titleLabel.font=[UIFont boldSystemFontOfSize:19.0];
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnLeft setBackgroundColor:[UIColor clearColor]];
    [btnLeft addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnLeft];
    
    UIButton * btnRight =[UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame=CGRectMake(0, 0, 40, 40);
    [btnRight setTitle:@"保存" forState:UIControlStateNormal];
    
    [btnRight addTarget:self action:@selector(saveRequest) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnRight];
    
}

-(void)goback
{
    [self.navigationController dismissModalViewControllerAnimated:YES];

}

-(void)saveRequest
{
    GlobalData * data =[GlobalData shareInstance];
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    [dict setValue:data.ecKey forKey:@"key"];
    [dict setValue:data.midKey forKey:@"mid"];
    [dict setValue:@"1.0" forKey:@"version"];
    [dict setValue:@"1" forKey:@"channel_type"];
    NSMutableDictionary * insideDict =[NSMutableDictionary dictionary];
    
    if ([Utils isBlankString:tfInputNickName.text]) {
        UIAlertView * av = [[UIAlertView alloc]initWithTitle:nil message:@"备注不能为空！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return;
    }
    [insideDict setValue:data.IMUser.strIMSubUser forKey:@"accountId"];
    [insideDict setValue:self.friendId   forKey:@"friendId"];
    [insideDict setValue:tfInputNickName.text forKey:@"friendNickname"];
    [dict setValue:insideDict forKey:@"data"];
    
    [Network HttpPostForImRequetURL:[data.hdbizDomain  stringByAppendingString:@"/hsim-bservice/updateFriendNickName"] parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        
        
        if (!error) {
            NSDictionary * responseDic =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            NSString * retCode =[NSString stringWithFormat:@"%@",responseDic[@"retCode"]];
            
            if ([retCode isEqualToString:@"200"]) {
                [self saveRemark];
                
                [UIAlertView showWithTitle:nil message:@"设置备注成功！" cancelButtonTitle:kLocalized(@"confirm") otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    
                    if (_delegate && [_delegate respondsToSelector:@selector(getUserRemark:)]) {
                        [_delegate getUserRemark:tfInputNickName.text];
                    }
                    
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                    
                }];
                
                
            }
        }
        
        
        
    }];
}
-(void)saveRemark
{
    NSString * myID = [GlobalData shareInstance].IMUser.strAccountNo;
    NSString *resNO = [Utils getResNO:self.friendId];
    NSDictionary * dict = @{@"friend_id":resNO,@"my_id":myID,@"msg_type":@"1",@"res_no":resNO};
    [GYChatItem setRemark:tfInputNickName.text dictData:dict];
}
@end
