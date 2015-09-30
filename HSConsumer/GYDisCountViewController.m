//
//  GYDisCountViewController.m
//  HSConsumer
//
//  Created by apple on 15-4-18.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYDisCountViewController.h"


@interface GYDisCountViewController ()<UITableViewDataSource,UITableViewDelegate,sendSelectDiscountDelegate>

@end

@implementation GYDisCountViewController

{

    __weak IBOutlet UITableView *tvDiscount;
    NSMutableArray * mArrData;
    
    UIButton * btnTemp;
    DiscountModel *   globalDiscountMod ;



}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    mArrData = [NSMutableArray array];
    self.view.backgroundColor=kDefaultVCBackgroundColor;
    
    UIView * backgroundView = [[UIView alloc]initWithFrame:tvDiscount.frame];
    backgroundView.backgroundColor=kDefaultVCBackgroundColor;
    tvDiscount.backgroundView=backgroundView;
    tvDiscount.delegate=self;
    tvDiscount.dataSource=self;
    tvDiscount.tableFooterView=[[UIView alloc]init];
    
    [tvDiscount registerNib:[UINib nibWithNibName:@"DiscountCell" bundle:nil] forCellReuseIdentifier:@"CELL"];
    UIView  * footerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    UIButton * btnConfirm = [UIButton buttonWithType:0];
    btnConfirm.frame=CGRectMake(16, 16, 286, 30);
    [btnConfirm setTitle:@"确认" forState:UIControlStateNormal];
    [btnConfirm setBackgroundImage:[UIImage imageNamed:@"btn_confirm_bg.png"] forState:UIControlStateNormal];
    [btnConfirm addTarget:self action:@selector(btnConfirm:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:btnConfirm];
    
    tvDiscount.tableFooterView = footerView;
    tvDiscount.tableFooterView.hidden=YES;
    
    [self getNetData];
}

-(void)btnConfirm : (UIButton *)sender
{
    if (globalDiscountMod) {
        if (_delegateDisCount &&  [_delegateDisCount respondsToSelector:@selector(returnDiscount:WithIndex:)]) {
            [_delegateDisCount returnDiscount:globalDiscountMod WithIndex:self.index];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else
    {
    
        [Utils showMessgeWithTitle:nil message:@"请选择消费券" isPopVC:nil];
    }
    
    
    

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mArrData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return 79.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    

    cell.delegate=self;
    DiscountModel *model = mArrData[indexPath.row];
    
    [cell refreshUiWithModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     DiscountModel *model = mArrData[indexPath.row];
    globalDiscountMod=model;
    if (globalDiscountMod) {
        if (_delegateDisCount &&  [_delegateDisCount respondsToSelector:@selector(returnDiscount:WithIndex:)]) {
            [_delegateDisCount returnDiscount:globalDiscountMod WithIndex:self.index];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else
    {
        
        [Utils showMessgeWithTitle:nil message:@"请选择消费券" isPopVC:nil];
    }
    
    
    
    
    
}

#pragma mark - getNetData
-(void)getNetData
{
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    
    
   
    
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:self.marrJeson options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [dict setValue:self.vShopId forKey:@"vShopId"];
    [dict setValue:self.shopId forKey:@"shopId"];
    [dict setValue:jsonString forKey:@"json"];
    [dict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];

   
    [Network  HttpGetForRequetURL:[NSString stringWithFormat:@"%@/easybuy/getConsumerCoupons",[GlobalData shareInstance].ecDomain] parameters:(NSDictionary *)dict requetResult:^(NSData *jsonData, NSError *error) {
        
        
        [Utils hideHudViewWithSuperView:self.view];
        
        if (error) {
            //网络请求错误
            [Utils hideHudViewWithSuperView:self.view];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"提交失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
        }else{
            
            NSDictionary *ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            NSLog(@"%@--------dic",ResponseDic);
            
            NSString * str =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
            
            if ([str isEqualToString:@"200"]) {
                //返回正确数据，并进行解析
                
                NSArray *data = ResponseDic[@"data"];
                if (data.count > 0) {
                      tvDiscount.tableFooterView.hidden=NO;
                    for (NSDictionary *dic in data) {
                        
                        DiscountModel *model = [[DiscountModel alloc] init];
                        model.userCouponId =  kSaftToNSString(dic[@"userCouponId"]);
                        model.couponName =  kSaftToNSString(dic[@"couponName"]);
                        model.amount = kSaftToNSString(dic[@"amount"]);
                        model.faceValue = kSaftToNSString(dic[@"faceValue"]);
                        model.surplusNum = kSaftToNSString(dic[@"surplusNum"]);
                        model.sum = kSaftToNSString(dic[@"sum"]);
                        [mArrData addObject:model];
                    }
                    
                    [tvDiscount reloadData];
                    
                    
                }else{
                    
                    
                    
                    tvDiscount.tableFooterView.hidden=YES;
                    UIView * background =[[UIView alloc]initWithFrame:tvDiscount.frame];
                    UILabel * lbTips =[[UILabel alloc]init];
                    lbTips.center=CGPointMake(160, 160);
                    lbTips.textColor=kCellItemTitleColor;
                    lbTips.textAlignment=UITextAlignmentCenter;
                    lbTips.font=[UIFont systemFontOfSize:15.0];
                    lbTips.backgroundColor =[UIColor clearColor];
                    lbTips.bounds=CGRectMake(0, 0, 270, 40);
                    lbTips.text=@"暂无抵扣券!";
                    
                    UIImageView * imgvNoResult =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_no_result.png"]];
                    imgvNoResult.center=CGPointMake(kScreenWidth/2, 100);
                    imgvNoResult.bounds=CGRectMake(0, 0, 52, 59);
                    [background addSubview:imgvNoResult];
                    
                    [background addSubview:lbTips];
                    tvDiscount.backgroundView=background;

                    
                    
                    
                }
                
            }else{
                
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"提交失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                
                
                [av show];
                
                
                //返回数据不正确
            }
        }
    }];
}

#pragma mark 多选的代理方法。
-(void)sendSelectDisCount:(id)sender WithDiscountModel : (DiscountModel *)model
{

    btnTemp.selected=NO;
    btnTemp=sender;
    btnTemp.selected=YES;
    globalDiscountMod =model;


}
@end
