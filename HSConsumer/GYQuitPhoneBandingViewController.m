//
//  GYQuitPhoneBandingViewController.m
//  HSConsumer
//
//  Created by apple on 14-11-3.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYQuitPhoneBandingViewController.h"
#import "GYQuitPhoneBandingModel.h"
#import "GYQuitPhoneBandingTableViewCell.h"
#import "GYQuitPhoneBandingDetailViewController.h"
#import "GYQuitEmailBanding.h"
#import "Network.h"
//修改手机
#import "GYModifyPhoneBandingViewController.h"
//修改邮箱
#import "GYModifyEmailBandingViewController.h"
#import "GlobalData.h"
@interface GYQuitPhoneBandingViewController ()

@end

@implementation GYQuitPhoneBandingViewController
{
    
    __weak IBOutlet UITableView *tvQuitPhoneBanding;
    
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=kLocalized(@"cell_phone_number_binding");

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=kDefaultVCBackgroundColor;
    _marrDataSoure=[NSMutableArray array];
    
    // Do any additional setup after loading the view from its nib.
    [tvQuitPhoneBanding  registerNib:[UINib nibWithNibName:@"GYQuitPhoneBandingTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    tvQuitPhoneBanding.separatorStyle=UITableViewCellSeparatorStyleNone;
    tvQuitPhoneBanding.backgroundView=nil;
    tvQuitPhoneBanding.backgroundColor=kDefaultVCBackgroundColor;

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_marrDataSoure.count>0) {
        [_marrDataSoure removeAllObjects];
    }
     [self loadDataFromNetwork];

}

-(void)loadDataFromNetwork
{
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    
    NSMutableDictionary * dictInside =[[NSMutableDictionary alloc]init];
    
    [dictInside setValue:[GlobalData shareInstance].user.cardNumber forKey:@"resource_no"];
    
    [dict setValue:@"person" forKey:@"system"];
    
    [dict setValue:kuType forKey:@"uType"];
    
    [dict setValue:kHSMac forKey:@"mac"];
    
    [dict setValue:[GlobalData shareInstance].midKey forKey:@"mId"];
    
    [dict setValue:[GlobalData shareInstance].hsKey forKey:@"key"];

    [dict setValue:dictInside forKey:@"params"];

    if (_FromWhere) {
        
        [dict setValue:@"get_bind_mobile" forKeyPath:@"cmd"];
    }else{
        
       [dict setValue:@"get_bind_email" forKeyPath:@"cmd"];
    
    }
 
 
    //测试get
   [Network  HttpGetForRequetURL:[[GlobalData shareInstance].hsDomain stringByAppendingString:@"/api"] parameters:(NSDictionary *)dict requetResult:^(NSData *jsonData, NSError *error){
        
        
   NSDictionary *ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
       
        if ([[Utils GetResultCode:ResponseDic] isEqualToString:@"0"]) {
            
            if (_FromWhere) {
                GYQuitPhoneBandingModel * model =[[ GYQuitPhoneBandingModel alloc]init];
                model.strBtnTitle=@"修改手机";
                model.strBandingSuccess=@"绑定成功";
                model.strPhoneNo=[[ResponseDic objectForKey:@"data"] objectForKey:@"bindMobile"];
                model.strIconUrl=@"cell_img_phone_binding.png";
                [_marrDataSoure addObject:model];
                
            }else
            {
                
                GYQuitEmailBanding * model =[[GYQuitEmailBanding alloc]init];
                model.strEmail=[[ResponseDic objectForKey:@"data"] objectForKey:@"bindEmail"];
                model.strBtnTitle=@"修改邮箱";
                model.strBandingSuccess=@"绑定成功";
                model.strIconUrl=@"cell_img_SMS.png";
                
                [_marrDataSoure addObject:model];
            
            
            }
            
           
        }else if ([[Utils GetResultCode:ResponseDic] isEqualToString:@"1"])
        {
            [Utils showMBProgressHud:self SuperView:self.view Msg:@"您还未输入绑定信息" ShowTime:0.3];
        
        }
        [tvQuitPhoneBanding reloadData];
        
    }];
    
    
    
    
}



#pragma mark TableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _marrDataSoure.count ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 79.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * identifier =@"cell";
    GYQuitPhoneBandingTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[GYQuitPhoneBandingTableViewCell alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    //从手机绑定  push过来时，设置fromwhere 为yes 传入GYQuitPhoneBandingModel数据，否则传入邮箱绑定的GYQuitEmailBanding
    if (_FromWhere) {
        GYQuitPhoneBandingModel * model =_marrDataSoure[indexPath.row];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.btnQuitBanding.tag=indexPath.row;
        [cell.btnQuitBanding addTarget:self action:@selector(gotoQuitBanding:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [cell refreshUIWith:model];
        
        
        
    }else{
        GYQuitEmailBanding * model =_marrDataSoure[indexPath.row];
        cell.btnQuitBanding.tag=indexPath.row;
        [cell.btnQuitBanding addTarget:self action:@selector(gotoQuitBanding:) forControlEvents:UIControlEventTouchUpInside];
        [cell refreshUIWithEmail:model];
        
    }
    return cell;
    
}


-(void)gotoQuitBanding:(UIButton *)sender
{
    if (_FromWhere) {
        
        GYQuitPhoneBandingModel * model=  _marrDataSoure[sender.tag];
        GYModifyPhoneBandingViewController * vcQuitBanding =[[GYModifyPhoneBandingViewController alloc]initWithNibName:@"GYModifyPhoneBandingViewController" bundle:nil];
        vcQuitBanding.model=model;
        [self.navigationController pushViewController:vcQuitBanding animated:YES];
    }
    else {
    
    
        GYModifyEmailBandingViewController * vcModifyEmail =[[GYModifyEmailBandingViewController alloc]initWithNibName:@"GYModifyEmailBandingViewController" bundle:nil];
        [self.navigationController pushViewController:vcModifyEmail animated:YES];
    
    
    
    
    }
    
    
    
    
    
    
    
    
//    switch (sender.tag) {
//        case 0:
//        
//        {
//            
//            
//            
//        }
//            break;
//        case 200:
//        {
//            GYModifyPhoneBandingViewController * vcQuitBanding =[[GYModifyPhoneBandingViewController alloc]initWithNibName:@"GYModifyPhoneBandingViewController" bundle:nil];
//            [self.navigationController pushViewController:vcQuitBanding animated:YES];
//            
//            
//        }
//            break;
//        default:
//            break;
//    }
    
    
}
@end
