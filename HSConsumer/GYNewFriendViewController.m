//
//  GYNewFriendViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-29.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYNewFriendViewController.h"
#import "GYNewFriendTableViewCell.h"
#import "GYNewFiendModel.h"
//个人资料信息
#import "GYPersonDetailInfoViewController.h"
#import "GYChatItem.h"

#import "GYChatViewController.h"
@interface GYNewFriendViewController ()

@end

@implementation GYNewFriendViewController

{
    __weak IBOutlet UITableView *tvNewFriend;
    
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor=kDefaultVCBackgroundColor;
        self.title=kLocalized(@"my_new_friend");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.marrDatasource=[NSMutableArray array];
    // Do any additional setup after loading the view from its nib.
    tvNewFriend.delegate=self;
    tvNewFriend.dataSource=self;
    
    //注册cell
    [tvNewFriend registerNib:[UINib nibWithNibName:@"GYNewFriendTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    tvNewFriend.tableFooterView=[[UIView alloc]init];
    
    
    [self  loadDataFromNetwork];
    
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //清空小红圈数字
    [self.chatItem updateIsReadToZeroWithKey:self.chatItem.fromUserId WithMsgType:1];
}


-(void)loadDataFromNetwork
{
    GlobalData *data = [GlobalData shareInstance];
    NSMutableDictionary * insideDict =[NSMutableDictionary dictionary];
    [insideDict setValue:data.IMUser.strIMSubUser forKey:@"accountId"];
    
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    [dict setValue:@"2" forKey:@"channel_type"];
    [dict setValue:@"1.0" forKey:@"version"];
    [dict setValue:data.ecKey forKey:@"key"];
    [dict setValue:data.midKey forKey:@"mid"];
    [dict setValue:insideDict forKey:@"data"];
   
 
   [Network HttpPostForImRequetURL:[[GlobalData shareInstance].hdbizDomain stringByAppendingString:@"/hsim-bservice/queryWhoAddMeList"] parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        
        if (!error) {
            NSDictionary * ResonpseDict =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            if (!error) {
                NSLog(@"%@--------dict",ResonpseDict);
                
                NSString * retCode =[NSString stringWithFormat:@"%@",ResonpseDict[@"retCode"]];
              if ([retCode isEqualToString:@"200"]) {
                  
                   tvNewFriend.backgroundView.hidden=YES;
                    for (NSDictionary * tempDict in ResonpseDict[@"rows"]) {
                        GYNewFiendModel * model =[[GYNewFiendModel alloc]init];
                        model.strFriendID=tempDict[@"accountId"];
      
                        if ([model.strFriendID hasPrefix:@"c_"]) {
                            model.strAccountNo= [model.strFriendID substringFromIndex:2];
                        }else
                        {
                          model.strAccountNo= [model.strFriendID substringFromIndex:3];
                        }
                        
                        if ([tempDict[@"friendStatus"]  isEqualToString:@"1"]) {
                            model.friendStatus=kAskForAdd;
                            
                        }else if([tempDict[@"friendStatus"]  isEqualToString:@"2"]){
                            
                            model.friendStatus=kAgreeForAdd;
                            
                        }else if ([tempDict[@"friendStatus"]  isEqualToString:@"3"])
                        {
                            
                            model.friendStatus=kRefuseForAdd;
                            
                        }else if ([tempDict[@"friendStatus"]  isEqualToString:@"4"])
                        {
                            model.friendStatus=kDeleteFriend;
                            
                            
                        }else if ([tempDict[@"friendStatus"]  isEqualToString:@"5"])
                        {
                            model.friendStatus=kAskForAuth;
                            
                        }
                        
                        model.strFriendIconURL=tempDict[@"headPic"];
                        model.isShield=tempDict[@"isShield"];
                        model.strFriendName=tempDict[@"nickname"];
                        
                        [self.marrDatasource addObject:model];
                    }
                    
                    [tvNewFriend reloadData];
                    
                    
                }else if ([retCode isEqualToString:@"204"])
                {
                    UIView * background =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, tvNewFriend.frame.size.height)];
                    UILabel * label =[[UILabel alloc]init];
                    CGPoint  p =CGPointMake(kScreenWidth/2, 130);
                    label.bounds=CGRectMake(0, 0, 160, 40);
                    label.center=p;
                    label.text=@"您还没有新朋友哦~";
                    label.textColor=kCellItemTitleColor;
                    UIImageView * imgvNoResult =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_no_result.png"]];
                    imgvNoResult.center=CGPointMake(kScreenWidth/2, 70);
                    imgvNoResult.bounds=CGRectMake(0, 0, 52, 59);
                     [background addSubview:imgvNoResult];
                    [background addSubview:label];
                   
                    tvNewFriend.backgroundView=background;
                     tvNewFriend.backgroundView.hidden=NO;
                    
                }
           }
        }
    }];  
}


#pragma mark DataSourceDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.marrDatasource.count;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifer =@"cell";
    GYNewFriendTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell==nil) {
        cell=[[GYNewFriendTableViewCell alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleBlue;
    [cell.btnAdd addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    GYNewFiendModel * model =self.marrDatasource[indexPath.row];
    cell.btnAdd.tag=indexPath.row;
    [cell refreshUIWith:model];
    return cell;
}


-(void)btnClicked:(UIButton *)sender
{
    GYNewFiendModel * model = self.marrDatasource[sender.tag];
    
    GlobalData *data = [GlobalData shareInstance];
    NSMutableDictionary * insideDict =[NSMutableDictionary dictionary];
    [insideDict setValue:data.IMUser.strIMSubUser forKey:@"accountId"];
    NSString * strNickName;
    if (data.IMUser.strNickName.length>0) {
        strNickName = data.IMUser.strNickName;
        
    }else
    {
      strNickName = data.IMUser.strAccountNo;
        
    }
    [insideDict setValue:strNickName forKey:@"accountNickname"];
    [insideDict setValue:data.user.useHeadPictureURL forKey:@"accountHeadPic"];
    
    [insideDict setValue:model.strFriendID forKey:@"friendId"];
    [insideDict setValue:model.strFriendName forKey:@"friendNickname"];
    [insideDict setValue:model.strFriendIconURL forKey:@"friendHeadPic"];
    [insideDict setValue:@"2" forKey:@"friendStatus"];
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    [dict setValue:@"2" forKey:@"channel_type"];
    [dict setValue:@"1.0" forKey:@"version"];
    [dict setValue:data.ecKey forKey:@"key"];
    [dict setValue:data.midKey forKey:@"mid"];
    [dict setValue:insideDict forKey:@"data"];
   
    
    [Network HttpPostForImRequetURL: [[GlobalData shareInstance].hdbizDomain  stringByAppendingString:@"/hsim-bservice/addFriend"] parameters:dict requetResult:^(NSData *jsonData, NSError *error) {
        
        if (!error) {
            
            NSDictionary * ResonpseDict =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            NSLog(@"%@   resopsedict",ResonpseDict);
            
            NSString * retCode =[NSString stringWithFormat:@"%@",ResonpseDict[@"retCode"]];
            if ([retCode isEqualToString:@"200"]) {
                UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"添加成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            }
            
            
        }
        
        
    }];
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GYNewFiendModel * model =self.marrDatasource[indexPath.row];
    if (model.friendStatus==kAgreeForAdd)
    {
        GYChatViewController * vcChat =[[GYChatViewController alloc]initWithNibName:@"GYChatViewController" bundle:nil];
        vcChat.model=model;
        vcChat.title=model.strFriendName;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vcChat animated:YES];
    }
    else
    {
        
        GYPersonDetailInfoViewController * vcPersonDetail =[[GYPersonDetailInfoViewController alloc]initWithNibName:@"GYPersonDetailInfoViewController" bundle:nil];
        vcPersonDetail.useType = KPersonInfoFromCheck;
        vcPersonDetail.model = model;
        vcPersonDetail.isAdded = NO;
        vcPersonDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vcPersonDetail animated:YES];
    }
    
    
}


#pragma mark alertview 代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
    if (self.marrDatasource.count>0) {
        [self.marrDatasource removeAllObjects];
    }
    [self  loadDataFromNetwork];
    

}

@end
