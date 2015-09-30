//
//  GYEPOrderQRCoderViewController.m
//  HSConsumer
//
//  Created by apple on 15/5/29.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYEPOrderQRCoderViewController.h"
#import "NSData+Base64.h"

@interface GYEPOrderQRCoderViewController ()
{
    IBOutlet UIImageView *ivOrderQRCoder;
    IBOutlet UILabel *lbTip;
}
@end

@implementation GYEPOrderQRCoderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _orderID = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [lbTip setTextColor:kCellItemTextColor];
    lbTip.text = @"";
    //后台二维码350*350
    [self getOrderQRCoder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma - 获取订单二维码
- (void)getOrderQRCoder
{
    if (!_orderID) return;
    
    GlobalData *data = [GlobalData shareInstance];
    NSDictionary *allParas = @{@"key": data.ecKey,
                               @"orderId": self.orderID
                               };
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    [self.view addSubview:hud];
    //    hud.labelText = @"初始化数据...";
    [hud show:YES];
    
    [Network HttpGetForRequetURL:[data.ecDomain stringByAppendingString:@"/easybuy/buildTakeQRCode"] parameters:allParas requetResult:^(NSData *jsonData, NSError *error) {
        if (!error)
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:kNilOptions
                                                                  error:&error];
            if (!error)
            {
                if (kSaftToNSInteger(dic[@"retCode"]) == kEasyPurchaseRequestSucceedCode)//返回成功数据
                {
                    NSString *message = [NSString stringWithFormat:@"%@", dic[@"data"]];
                    NSData *imgData = [NSData dataFromBase64String:message];
                    UIImage *image = [[UIImage alloc] initWithData:imgData];
                    if (image)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [ivOrderQRCoder setImage:image];
                            lbTip.text = @"请使用手机扫描二维码";
                        });
                    }
                }else//返回失败数据
                {
                    [Utils showMessgeWithTitle:nil message:@"获取订单二维码失败." isPopVC:self.navigationController];
                }
            }else
            {
                [Utils showMessgeWithTitle:nil message:@"获取订单二维码失败." isPopVC:self.navigationController];
            }
            
        }else
        {
            [Utils showMessgeWithTitle:@"提示" message:[error localizedDescription] isPopVC:self.navigationController];
        }
        if (hud.superview)
        {
            [hud removeFromSuperview];
        }
    }];
}

@end
