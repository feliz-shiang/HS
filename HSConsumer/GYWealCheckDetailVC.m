//
//  GYWealCheckDetailVC.m
//  HSConsumer
//
//  Created by 00 on 15-3-16.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYWealCheckDetailVC.h"
#import "WealCheckDetailCell.h"
#import "CheckModel.h"
#import "UIView+CustomBorder.h"


@interface GYWealCheckDetailVC ()<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UITableView *tbv;
    GlobalData *data;   //全局单例

    NSMutableArray *mArrData;
}

@end

@implementation GYWealCheckDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    mArrData = [[NSMutableArray alloc] init];
    
    //实例化单例
    data = [GlobalData shareInstance];
    
    tbv.delegate = self;
    tbv.dataSource = self;
    tbv.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tbv addAllBorder];
    [self tbvHeight];
    
    [tbv registerNib:[UINib nibWithNibName:@"WealCheckDetailCell" bundle:nil] forCellReuseIdentifier:@"CELL"];
    
    if (self.detailType == 0) {
        
        [self getNetDataCheckMedical:self.medicalId];
        
    }
    if (self.detailType == 1) {
        
        [self getNetDataCheckAccident:self.applyId];
        
    }
    if (self.detailType == 2) {
        [self getNetDataCheckAccident:self.applyId];
        
    }

}

//-(void)viewDidAppear:(BOOL)animated
//{
//    
//    if (self.detailType == 0) {
//        
//        [self getNetDataCheckMedical:self.medicalId];
//        
//    }
//    if (self.detailType == 1) {
//        
//        [self getNetDataCheckAccident:self.applyId];
//        
//    }
//    if (self.detailType == 2) {
//        [self getNetDataCheckAccident:self.applyId];
//        
//    }
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mArrData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20.0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WealCheckDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    
    CheckItem *item = mArrData[indexPath.row];
    cell.lbTitle.text = item.itemName;
    cell.lbContent.text = item.itemValue;
    cell.nc = self.navigationController;
    if (item.imgUrl) {
        cell.btn.hidden = NO;
        cell.lbContent.hidden = YES;
        cell.imgUrl = item.imgUrl;
    }else{
        cell.btn.hidden = YES;
        cell.lbContent.hidden = NO;
    }

    if (indexPath.row == mArrData.count - 3) {
        cell.lbContent.textColor = [UIColor redColor];
    }
    
    
    
    
    return cell;
}

//192.168.229.21:9092/gy/api?system=person&cmd=get_integral_welfare_for_free_medical_detail&params={resource_no=06186010001,medicalId=0f733ff1-97e1-454a-92a0-d56b7a17349a}&uType=web&mac=00-00-00-00-00-00&mId=99999&key=00s7Agbv2bKH4e5tML7RRsR6ebIlsCOPs7yxKwtpOLR36WeLgH9fZM%2F17lPw0D0%2F

-(void)getNetDataCheckMedical:(NSString *)medicalId
{
    [Utils showMBProgressHud:self SuperView:self.navigationController.view Msg:@"网络请求中"];
    NSMutableDictionary * dictInside =[[NSMutableDictionary alloc]init];
    //URL上传的参数
    [dictInside setValue:[GlobalData shareInstance].user.cardNumber forKey:@"resource_no"];
    [dictInside setValue:medicalId forKey:@"medicalId"];

    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    [dict setValue:dictInside forKey:@"params"];
    [dict setValue:[GlobalData shareInstance].hsKey forKey:@"key"];
    [dict setValue:kuType forKey:@"uType"];
    [dict setValue:kHSMac forKey:@"mac"];
    [dict setValue:@"person" forKey:@"system"];
    [dict setValue:[GlobalData shareInstance].midKey forKey:@"mId"];
    
    //请求对应url的运行cmd
    [dict setValue:@"get_integral_welfare_for_free_medical_detail" forKeyPath:@"cmd"];
    
    
    //测试get
    [Network  HttpGetForRequetURL:[[GlobalData shareInstance].hsDomain stringByAppendingString:kHSApiAppendUrl] parameters:(NSDictionary *)dict requetResult:^(NSData *jsonData, NSError *error) {
        
        if (error) {
            NSLog(@"错误");
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"网络故障" message:@"请稍后再尝试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
            
        }else{
            
            NSDictionary *ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            NSLog(@"ResponseDic === %@",ResponseDic);
            
            
            if ([ResponseDic[@"code"] isEqualToString:@"SVC0000"]) {
              
                [mArrData removeAllObjects];
                
                [self addItem:@"申请单号" : [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"medical"][@"applyNo"]] :nil ];
                [self addItem:@"申请时间" :[NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"medical"][@"created"]] :nil ];
                [self addItem:@"申请福利类型" :@"互生医疗补贴计划" :nil ];
                [self addItem:@"医保卡号" :[NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"medical"][@"healthCardNo"]] :nil ];
                [self addItem:@"诊疗起始日期" :[NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"medical"][@"startDate"]] :nil ];
                [self addItem:@"诊疗终止日期" :[NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"medical"][@"endDate"]] :nil ];
                [self addItem:@"所在城市" :[NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"medical"][@"city"]] :nil ];
                [self addItem:@"所在医院" :[NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"medical"][@"hospital"]] :nil ];
                [self addItem:@"申请操作人" :[NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"medical"][@"createdBy"]] :nil ];
                
               
                NSString *status = ResponseDic[@"data"][@"medicalApprove"][@"status"];
                if ([status isEqualToString:@"W"]) {
                    status = @"受理中";
                }
                if ([status isEqualToString:@"Y"]) {
                    status = @"受理成功";
                }
                if ([status isEqualToString:@"N"]) {
                    status = @"驳回";
                }
                
                [self addItem:@"审核结果" :status :nil ];
                [self addItem:@"批复金额" :[NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"medicalApprove"][@"amount"]] :nil ];
                [self addItem:@"审核信息" :[NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"medicalApprove"][@"appReason"]] :nil ];
                [self addItem:@"审核时间" :[NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"medicalApprove"][@"updated"]] :nil ];
                
                
                
                [tbv reloadData];
                [self tbvHeight];
                
            }else{
                
                
            }
            //网络请求回调后弹窗
            
            [Utils hideHudViewWithSuperView:self.view.window];
            
            
            
        }
    }];
    
    
}

-(void)getNetDataCheckAccident:(NSString *)applyId
{
    
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"网络请求中"];
    NSMutableDictionary * dictInside =[[NSMutableDictionary alloc]init];
    //URL上传的参数
    [dictInside setValue:[GlobalData shareInstance].user.cardNumber forKey:@"resource_no"];
    [dictInside setValue:applyId forKey:@"applyId"];
    
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    [dict setValue:dictInside forKey:@"params"];
    [dict setValue:[GlobalData shareInstance].hsKey forKey:@"key"];
    [dict setValue:kuType forKey:@"uType"];
    [dict setValue:kHSMac forKey:@"mac"];
    [dict setValue:@"person" forKey:@"system"];
    [dict setValue:[GlobalData shareInstance].midKey forKey:@"mId"];
    
    //请求对应url的运行cmd
    [dict setValue:@"get_integral_welfare_for_free_accident_insurance_and_dead_insurance_detail" forKeyPath:@"cmd"];
    
    
    //测试get
    [Network  HttpGetForRequetURL:[data.hsDomain stringByAppendingString:kHSApiAppendUrl]  parameters:(NSDictionary *)dict requetResult:^(NSData *jsonData, NSError *error) {
        
        if (error) {
            NSLog(@"错误");
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"网络故障" message:@"请稍后再尝试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
        }else{
            
            NSDictionary *ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            NSLog(@"ResponseDic === %@",ResponseDic);
            
            
            if ([ResponseDic[@"code"] isEqualToString:@"SVC0000"]) {
                
                [mArrData removeAllObjects];
                
                
                NSString *temp = [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"welfare"][@"applyType"]];
                if ([temp isEqualToString:@"2"]) {
                    [self addItem:@"申请单号" : [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"welfare"][@"applyNo"]] :nil ];
                    [self addItem:@"申请时间" :[NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"welfare"][@"created"]] :nil ];
                    [self addItem:@"申请福利类型" :@"互生意外伤害保障" :nil ];
                    [self addItem:@"医保卡号" :[NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"welfare"][@"healthCardNo"]] :nil ];
                    [self addItem:@"申请操作人" :[NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"welfare"][@"createdBy"]] :nil ];
                    [self addItem:@"互生卡正面" :nil :[NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"welfare"][@"pointCardFacePic"]]];
                    [self addItem:@"互生卡背面" :nil :[NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"welfare"][@"pointCardBackPic"]]];
                    [self addItem:@"身份证正面" :nil :[NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"welfare"][@"lrcCardFacePic"]]];
                    [self addItem:@"身份证背面" :nil :[NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"welfare"][@"lrcCardBackPic"]]];
                    [self addItem:@"医疗证明" :nil :[NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"welfare"][@"medicalCer"]]];
                    [self addItem:@"其他证明" :nil :[NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"welfare"][@"elseCer"]]];
                    
                    
                    NSString *status = ResponseDic[@"data"][@"welfareApprove"][@"status"];
                    if ([status isEqualToString:@"W"]) {
                        status = @"受理中";
                    }
                    if ([status isEqualToString:@"Y"]) {
                        status = @"受理成功";
                    }
                    if ([status isEqualToString:@"N"]) {
                        status = @"驳回";
                    }
                    
                    [self addItem:@"审核结果" :status :nil ];
                    [self addItem:@"批复金额" :[NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"welfareApprove"][@"appAmount"]] :nil ];
                    [self addItem:@"审核信息" :[NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"welfareApprove"][@"appReason"]] :nil ];
                    [self addItem:@"审核时间" :[NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"welfareApprove"][@"updated"]] :nil ];
                    
                }
                if ([temp isEqualToString:@"1"]) {
                    [self addItem:@"申请单号" : [NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"welfare"][@"applyNo"]] :nil ];
                    [self addItem:@"申请时间" :[NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"welfare"][@"created"]] :nil ];
                    [self addItem:@"申请福利类型" :@"互生意外伤害保障" :nil ];
                    [self addItem:@"身故人互生号" :[NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"welfare"][@"deathResNo"]] :nil ];
                    [self addItem:@"申请操作人" :[NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"welfare"][@"createdBy"]] :nil ];
                    [self addItem:@"身故死亡证明附件" :nil :[NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"welfare"][@"deathCer"]]];
                    [self addItem:@"户籍注销证明" :nil :[NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"welfare"][@"idLogoutCer"]]];
                    [self addItem:@"代理人授权委托书" :nil :[NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"welfare"][@"agentAccreditPic"]]];
                    [self addItem:@"代理人法定身份证明" :nil :[NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"welfare"][@"trusteeIdCardPic"]]];
                    [self addItem:@"其他证明材料" :nil :[NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"welfare"][@"elseCer"]]];
                    
                    
                    NSString *status = ResponseDic[@"data"][@"welfareApprove"][@"status"];
                    if ([status isEqualToString:@"W"]) {
                        status = @"受理中";
                    }
                    if ([status isEqualToString:@"Y"]) {
                        status = @"受理成功";
                    }
                    if ([status isEqualToString:@"N"]) {
                        status = @"驳回";
                    }
                    
                    [self addItem:@"审核结果" :status :nil ];
                    [self addItem:@"批复金额" :[NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"welfareApprove"][@"appAmount"]] :nil ];
                    [self addItem:@"审核信息" :[NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"welfareApprove"][@"appReason"]] :nil ];
                    [self addItem:@"审核时间" :[NSString stringWithFormat:@"%@",ResponseDic[@"data"][@"welfareApprove"][@"updated"]] :nil ];
                
                }
                
                [tbv reloadData];
                [self tbvHeight];
                
            }else{
                
                
            }
            //网络请求回调后弹窗
            
            [Utils hideHudViewWithSuperView:self.view];
            
            
            
        }
    }];
    
    
}



-(void)addItem:(NSString *)itemName :(NSString *)itemValue :(NSString *)url
{
    CheckItem *item = [[CheckItem alloc] init];
    item.itemName = itemName;
    
    
    if ([itemValue isEqualToString:@"(null)"]) {
        itemValue = @"";
        NSLog(@"itemValue == %@",itemValue);
    }
    item.itemValue = itemValue;
    if (url)
    {
        if ([[url lowercaseString] hasPrefix:@"http"])
        {
            item.imgUrl = url;
        }else
        {
            item.imgUrl = [[GlobalData shareInstance].tfsDomain stringByAppendingString:url];
        }
    }
    [mArrData addObject:item];
}

-(void)tbvHeight
{
    
    CGFloat tbvHeight = mArrData.count * 20;
    if (tbvHeight > kScreenHeight - 64 - 16) {
        tbvHeight = kScreenHeight - 64 - 16;
        tbv.scrollEnabled = YES;
    }
    tbv.scrollEnabled = NO;
    tbv.frame = CGRectMake(0, 16, kScreenWidth, tbvHeight);
    
}


@end
