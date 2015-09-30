//
//  GYGetPaymentTypeViewController.m
//  HSConsumer
//
//  Created by apple on 15-3-31.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYGetPaymentTypeViewController.h"
#import "GYPaymentType.h"
#import "UPPayPlugin.h"
#import "GYIconPayTypeViewController.h"
#import "GYEPMyAllOrdersViewController.h"
// add by songjk
#import "GYResultView.h"
@interface GYGetPaymentTypeViewController ()<UPPayPluginDelegate,GYResultViewDelegate>

@end

@implementation GYGetPaymentTypeViewController

{

    __weak IBOutlet UITableView *tvPaymentType;
    NSMutableArray * marrDatasource;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    marrDatasource=[NSMutableArray array];
    self.title=@"支付方式";
    // Do any additional setup after loading the view from its nib.
    
    [self getNetData];
}

#pragma mark -getAddrData
-(void)getNetData
{
    NSMutableDictionary * dict =[[NSMutableDictionary alloc]init];
    [dict setValue:[GlobalData shareInstance].ecKey forKey:@"key"];
    [dict setValue:self.strShopid forKey:@"shopIds"];
    [dict setValue:self.isDelivery forKey:@"isDelivery"];
 
    
    //测试get
    [Network  HttpGetForRequetURL:[NSString stringWithFormat:@"%@/easybuy/getPaymentType",[GlobalData shareInstance].ecDomain] parameters:(NSDictionary *)dict requetResult:^(NSData *jsonData, NSError *error) {
        
        if (error) {
            //网络请求错误
            
        }else{
            
            [Utils hideHudViewWithSuperView:self.view];
            
            NSDictionary *ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            NSString * str =[NSString stringWithFormat:@"%@",ResponseDic[@"retCode"]];
            
            if ([str isEqualToString:@"200"]) {
                //返回正确数据，并进行解析
                
                if ([ResponseDic[@"data"]  isKindOfClass:[NSDictionary class]]) {
                    for (NSDictionary *dic in ResponseDic[@"data"][@"types"])
                    {
                        GYPaymentType * model =[[GYPaymentType alloc ]init];
                        model.strPayment=dic[@"type"];
                        [marrDatasource addObject:model];
                    }
                    [tvPaymentType reloadData];
                }
            }else{

            }
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return marrDatasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    GYPaymentType * model =marrDatasource[indexPath.row];
    
    NSString * paymentType;
    if ([model.strPayment isEqualToString:@"EP"]) {
        paymentType=@"网银支付";
    }else if ([model.strPayment isEqualToString:@"AC"])
    {
      paymentType=@"互生币支付"; // 修改为互生币支付
    
    }
    // modify by songjk 不要货到付款
    else if ([model.strPayment isEqualToString:@"CD"])
    {
     paymentType=@"货到付款";
    
    }
    cell.textLabel.textColor=kCellItemTitleColor;
    cell.textLabel.text = paymentType;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GYPaymentType * model =marrDatasource[indexPath.row];
    if (_delegate && [_delegate respondsToSelector:@selector(selectPaymentWithModel:)])
    {
        [_delegate selectPaymentWithModel:model];
        [self.navigationController popViewControllerAnimated:YES];
    }else//本地支付
    {
        if ([model.strPayment isEqualToString:@"EP"])//网银支付
        {
            [self getTnCodeAndPay];
        }else if ([model.strPayment isEqualToString:@"AC"])//互生币
        {
            GYIconPayTypeViewController *vcIconPayType = kLoadVcFromClassStringName(NSStringFromClass([GYIconPayTypeViewController class]));
            vcIconPayType.strPriceAmount = kSaftToNSString(self.dicOrderInfo[@"total"]);
            vcIconPayType.strPvAmount = kSaftToNSString(self.dicOrderInfo[@"totalPv"]);
            vcIconPayType.strOrderId = kSaftToNSString(self.dicOrderInfo[@"number"]);
            [self.navigationController pushViewController:vcIconPayType animated:YES];

        }else // if ([model.strPayment isEqualToString:@"CD"])//货到付款
        {
            
        }
    }
}

#pragma mark - 本界面网银支付
- (void)getTnCodeAndPay
{
    if (!self.dicOrderInfo) return;
    GlobalData *data = [GlobalData shareInstance];
    
    NSDictionary *allParas = @{@"key": data.ecKey,
                               @"orderId": kSaftToNSString(self.dicOrderInfo[@"number"]),
                               @"coinCode": data.user.currencyCode,
                               @"amount" : kSaftToNSString(self.dicOrderInfo[@"total"])
                               };
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    [self.navigationController.view addSubview:hud];
    //    hud.labelText = @"初始化数据...";
    [hud show:YES];
    [Network HttpPostRequetURL:[data.ecDomain stringByAppendingString:@"/easybuy/payOrderInOnlineBank"] parameters:allParas requetResult:^(NSData *jsonData, NSError *error) {
        //    [Network HttpGetForRequetURL:[data.ecDomain stringByAppendingString:@"/easybuy/againBuy"] parameters:allParas requetResult:^(NSData *jsonData, NSError *error) {
        if (!error)
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:kNilOptions
                                                                  error:&error];
            if (!error)
            {
                if (kSaftToNSInteger(dic[@"retCode"]) == kEasyPurchaseRequestSucceedCode)//返回成功数据
                {
                    //调用银联支付
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *tnCode = kSaftToNSString(dic[@"data"]);
                        if (tnCode.length > 0)
                        {
                            [UPPayPlugin startPay:tnCode mode:kUPPayPluginMode viewController:self delegate:self];
                        }
                    });
                }else//返回失败数据
                {
                    [Utils showMessgeWithTitle:nil message:@"操作失败." isPopVC:nil];
                }
            }else
            {
                [Utils showMessgeWithTitle:nil message:@"操作失败." isPopVC:nil];
            }
            
        }else
        {
            [Utils showMessgeWithTitle:@"提示" message:[error localizedDescription] isPopVC:nil];
        }
        if (hud.superview)
        {
            [hud removeFromSuperview];
        }
    }];
}

#pragma mark - UPPayPluginDelegate
- (void)UPPayPluginResult:(NSString *)result
{
    //    支付状态返回值:success、fail、cancel
    DDLogInfo(@"网银兑换互生币,支付结果:%@", result);
    GYResultView* vReslut = [[GYResultView alloc] init];
    vReslut.delegate = self;
    if ([result isEqualToString:@"success"])
    {
//        [Utils showMessgeWithTitle:kLocalized(@"提示") message:kLocalized(@"付款成功。") isPopVC:nil];
        [vReslut showWithView:self.view status:YES message:@"付款成功！"];
        NSString * strPostNofificationName = [kNotificationNameRefreshOrderList stringByAppendingString:kSaftToNSString(self.dicOrderInfo[@"status"])];
        NSLog(@"strPostNofificationName = %@",strPostNofificationName);
        NSString * strNumber = self.dicOrderInfo[@"number"];// add by songjk 记录要刷新支付状态的订单number
        [[NSNotificationCenter defaultCenter] postNotificationName:strPostNofificationName object:strNumber userInfo:nil];
        
        
        strPostNofificationName = [kNotificationNameRefreshOrderList stringByAppendingString:[@(kOrderStateAll) stringValue]];
        NSLog(@"strPostNofificationName = %@",strPostNofificationName);
        [[NSNotificationCenter defaultCenter] postNotificationName:[kNotificationNameRefreshOrderList stringByAppendingString:[@(kOrderStateAll) stringValue]] object:strNumber userInfo:nil];
        
    }else
    {
//        [Utils showMessgeWithTitle:kLocalized(@"提示") message:kLocalized(@"付款失败。") isPopVC:nil];
        [vReslut showWithView:self.view status:YES message:@"付款失败！"];
    }
    // modify by songjk
//    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark GYResultViewDelegate
-(void)ResultViewConfrimButtonClicked:(GYResultView *)ResultView success:(BOOL)success
{
    if (success)
    {
        for (UIViewController * vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[GYEPMyAllOrdersViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }
}
@end
