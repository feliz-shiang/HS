//
//  GYSMSViewController.m
//  HSConsumer
//
//  Created by 00 on 14-10-16.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYSMSViewController.h"
#import "GYSMSTableViewCell.h"
#import "GlobalData.h"
#import "UIView+CustomBorder.h"
#import "Network.h"


@interface GYSMSViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    __weak IBOutlet UITableView *tbvSMS;
    GlobalData *data;//公共数据
    
    NSMutableArray *arrTitle;//标题数组
    
    
    __weak IBOutlet UIView *vAgreement;//协议行
    
    __weak IBOutlet UIButton *btnAgreement;////协议点击按钮
  
    
}

@end

@implementation GYSMSViewController

//协议点击事件
- (IBAction)btnAgreementClick:(id)sender {
    
    
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //初始化数组
        
        arrTitle = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.title = kLocalized(@"SMS_notification_manage");
    
    [vAgreement addTopBorder];
    
    //tableview 代理设置、组册cell
    tbvSMS.delegate = self;
    tbvSMS.dataSource = self;
    
    [tbvSMS registerNib:[UINib nibWithNibName:@"GYSMSTableViewCell" bundle:nil] forCellReuseIdentifier:@"SMSCELL"];

    //确定按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:kLocalized(@"开通") style:UIBarButtonItemStylePlain target:self action:@selector(confirmClick)];
}

-(void)viewDidAppear:(BOOL)animated
{
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"网络请求中"];
    
    [self getNetDataSMS];
}






// 确定按钮点击事件
-(void)confirmClick
{
    [Utils showMBProgressHud:self SuperView:self.view.window Msg:@"网络请求中"];
    [self getNetDataManage];
    
}

#pragma mark - UITableViewDataSource



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrTitle.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (data.currentDeviceScreenInch == kDeviceScreenInch_3_5) {
        return kDefaultCellHeight3_5inch;
    }
    return kDefaultCellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"SMSCELL";
    GYSMSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    cell.lbSMSTitle.text = kLocalized(arrTitle[indexPath.row]);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //适配3.5英寸
    if (data.currentDeviceScreenInch == kDeviceScreenInch_3_5) {
        cell.imgSMSCell.frame = CGRectMake(15, 7, 36, 36);
    }
    cell.tag = 100000+indexPath.row;
    return cell;

}
//Cell设置代码
-(void)setCell:(GYSMSTableViewCell*)cell WithImg:(NSString *)imgName withTitle:(NSString *)title
{
    cell.imgSMSCell.image = [UIImage imageNamed:imgName];
    cell.lbSMSTitle.text = title;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


-(void)getNetDataSMS
{
    //拼接请求参数
    NSMutableDictionary * dictInside =[[NSMutableDictionary alloc]init];
    //里面的字典
    [dictInside setValue:[GlobalData shareInstance].user.cardNumber forKey:@"resource_no"];
    //外面的字典
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    [dict setValue:@"person" forKey:@"system"];
    [dict setValue:@"get_msg_notice_service_list" forKey:@"cmd"];
    [dict setValue:dictInside forKey:@"params"];
    [dict setValue:kuType forKey:@"uType"];
    [dict setValue:kHSMac forKey:@"mac"];
    [dict setValue:[GlobalData shareInstance].midKey forKey:@"mId"];
    [dict setValue:[GlobalData shareInstance].hsKey forKey:@"key"];
   
    //测试get
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].hsDomain stringByAppendingString:kHSApiAppendUrl] parameters:(NSDictionary *)dict requetResult:^(NSData *jsonData, NSError *error) {
        
        if (error) {
            //网络请求错误
            
        }else{
            
            NSDictionary *ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            if ([[Utils GetResultCode:ResponseDic] isEqualToString:@"0"]) {
                NSLog(@"0000");
                for (NSDictionary *dic in ResponseDic[@"data"][@"noticeServices"]) {
                    [arrTitle addObject:dic[@"item"]];
                }
                
                [self getNetDataOpened];
                
            }else{
                //返回数据不正确
            }
        }
    }];
}


-(void)getNetDataManage
{
    NSMutableDictionary * dictInside =[[NSMutableDictionary alloc]init];
    
    [dictInside setValue:[GlobalData shareInstance].user.cardNumber forKey:@"resource_no"];
    
    //选中什么业务就添加参数
    [dictInside setValue:@"1" forKey:@"items"];
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    [dict setValue:@"person" forKey:@"system"];
    [dict setValue:@"subscribe_msg_notice_service" forKey:@"cmd"];
    [dict setValue:dictInside forKey:@"params"];
    [dict setValue:kuType forKey:@"uType"];
    [dict setValue:kHSMac forKey:@"mac"];
    [dict setValue:[GlobalData shareInstance].midKey forKey:@"mId"];
    [dict setValue:[GlobalData shareInstance].hsKey forKey:@"key"];
    
    //测试get
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].hsDomain stringByAppendingString:kHSApiAppendUrl] parameters:(NSDictionary *)dict requetResult:^(NSData *jsonData, NSError *error) {
        
        if (error) {
            NSLog(@"错误");
            
        }else{
            
            NSDictionary *ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            NSLog(@"%@",ResponseDic);
            
            if ([ResponseDic[@"data"][@"resultCode"] isEqualToString:@"0"]) {
                
                NSLog(@"%@",ResponseDic[@"data"][@"resultMsg"]);
                
                
            }else{
                
            }

            [Utils hideHudViewWithSuperView:self.view.window];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:ResponseDic[@"data"][@"resultMsg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
        }
    }];
}



-(void)getNetDataOpened
{
    NSMutableDictionary * dictInside =[[NSMutableDictionary alloc]init];
    
    [dictInside setValue:[GlobalData shareInstance].user.cardNumber forKey:@"resource_no"];
    
    //选中什么业务就添加参数
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    [dict setValue:@"person" forKey:@"system"];
    [dict setValue:@"get_user_subscribed_msg_notice_service_list" forKey:@"cmd"];
    [dict setValue:dictInside forKey:@"params"];
    [dict setValue:kuType forKey:@"uType"];
    [dict setValue:kHSMac forKey:@"mac"];
    [dict setValue:[GlobalData shareInstance].midKey forKey:@"mId"];
    [dict setValue:[GlobalData shareInstance].hsKey forKey:@"key"];
    
    //测试get
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].hsDomain stringByAppendingString:kHSApiAppendUrl] parameters:(NSDictionary *)dict requetResult:^(NSData *jsonData, NSError *error) {
        
        if (error) {
            NSLog(@"错误");
            
        }else{
            
            NSDictionary *ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            NSLog(@"ResponseDic ============= %@",ResponseDic);
            
            
            
            if ([ResponseDic[@"data"][@"resultCode"] isEqualToString:@"0"]) {
                
                NSLog(@"remindInfoList === %@",ResponseDic[@"data"][@"remindInfoList"]);
                
                
                
                [Utils hideHudViewWithSuperView:self.view];
                [tbvSMS reloadData];

            }else{
                
            }
            
            
        }
    }];
}


@end
