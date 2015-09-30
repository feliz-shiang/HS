//
//  GYAgainViewController.m
//  HSConsumer
//
//  Created by 00 on 14-10-16.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYAgainViewController.h"
#import "GYAgainConfirmViewController.h"
#import "GYFalseAddViewController.h"
#import "GYAddressModel.h"
#import "UIView+CustomBorder.h"

#import "GYGetGoodViewController.h"




@interface GYAgainViewController ()<UITextViewDelegate,GYGetAddressDelegate>
{

    __weak IBOutlet UIScrollView *scvAgain;//scrollView
    __weak IBOutlet UIView *vHSC;//互生卡行
    __weak IBOutlet UILabel *lbHSCTitle;//互生卡title
    __weak IBOutlet UILabel *lbHSCNum;//互生号
    
    
    __weak IBOutlet UIButton *btnAddress;//获取地址按钮
    __weak IBOutlet UIButton *btnCommit;//确认按钮
    
    __weak IBOutlet UIView *vReason;//补办原因底图
    __weak IBOutlet UITextView *tvReason;//补办原因输入框
    __weak IBOutlet UILabel *lbReason;//原因标题
    __weak IBOutlet UILabel *lbAddress;//收货地址标题
    __weak IBOutlet UILabel *lbAddressLong;//收货地址内容
    __weak IBOutlet UILabel *lbPlaceholder;//补办原因占位符
    __weak IBOutlet UILabel *lbPhone;//电话号码展示
    
    
    GlobalData *data;

    GYAddressModel *addrModel;
    
}
@end

@implementation GYAgainViewController

//下一步按钮 点击事件
- (IBAction)btnNextClick:(UIButton *)sender
{
    if (tvReason.text.length < 1)
    {
        [Utils showMessgeWithTitle:@"提示" message:kLocalized(@"请输入补办原因。") isPopVC:nil];
        return;
    }
    if (lbAddress.text.length < 1 || lbAddressLong.text.length < 1)
    {
        [Utils showMessgeWithTitle:@"提示" message:kLocalized(@"请选择地址.") isPopVC:nil];
        return;
    }
    if (tvReason.text.length > 30)
    {
        [Utils showMessgeWithTitle:@"提示" message:@"填写补办原因不应超过30字。" isPopVC:nil];
        return;
    }
    
    [self commit];
}
//进入选择收货地址页面
- (IBAction)btnAddressClick:(id)sender {
    
    GYGetGoodViewController *vcAdd = [[GYGetGoodViewController alloc] init];
    vcAdd.deletage = self;
    [self.navigationController pushViewController:vcAdd animated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    data = [GlobalData shareInstance];

    //国际化
    self.title = kLocalized(@"points_card_rehandle");
    lbReason.text = kLocalized(@"rehandle_reason");
    [btnAddress setTitle:kLocalized(@"again_hs_card_choose_shipping_address") forState:UIControlStateNormal];
    lbHSCTitle.text = kLocalized(@"points_card_number");
    [lbHSCTitle setTextColor:kCellItemTitleColor];
    lbHSCNum.text = [Utils formatCardNo:data.user.cardNumber];
    
    //确认提交按钮设置
    btnCommit.layer.cornerRadius = 4.0f;
    btnCommit.titleLabel.text = kLocalized(@"next");
    
    //textView
    [vReason addAllBorder];
    
    //textview
    lbPlaceholder.text = kLocalized(@"input_rehandle_reason");
    lbPlaceholder.enabled = NO;
    tvReason.delegate = self;
    [vHSC addTopBorderAndBottomBorder];
    scvAgain.contentSize = CGSizeMake(0, CGRectGetMaxY(btnCommit.frame) + 80);

    [self getAddrFromNetwork];
}

#pragma mark - UITextViewDelegate
//占位符逻辑
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        lbPlaceholder.text = kLocalized(@"input_rehandle_reason");
    }else{
        lbPlaceholder.text = @"";
    }
}

//地址回调函数
-(void)getAddressModle:(GYAddressModel *)model
{
    addrModel = model;
    lbAddress.text = model.CustomerName;
    lbAddressLong.text = [NSString stringWithFormat:@"%@%@%@%@",
                          kSaftToNSString(model.Province),
                          kSaftToNSString(model.City),
                          kSaftToNSString(model.Area),
                          kSaftToNSString(model.DetailAddress)];
    addrModel.fullAddress = lbAddressLong.text;
    lbPhone.text = model.CustomerPhone;
    [btnAddress setTitle:kLocalized(@"again_hs_card_change_shipping_address") forState:UIControlStateNormal];
}

#pragma mark - 网络数据交换
- (void)commit//提交
{
    NSDictionary *subParas = @{@"resource_no": data.user.cardNumber,
                               @"consignee": addrModel.CustomerName,
                               @"mobile": addrModel.CustomerPhone,
                               @"fullAddr": addrModel.fullAddress,
                               @"zipCode": kSaftToNSString(addrModel.PostCode),
                               @"remark": tvReason.text
                               };
    
    NSDictionary *allParas = @{@"system": @"person",
                               @"cmd": @"remake_card",
                               @"params": subParas,
                               @"uType": kuType,
                               @"mac": kHSMac,
                               @"mId": data.midKey,
                               @"key": data.hsKey
                               };
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    [self.view addSubview:hud];
    //    hud.labelText = @"初始化数据...";
    [hud show:YES];
    
    [Network HttpGetForRequetURL:[data.hsDomain stringByAppendingString:kHSApiAppendUrl] parameters:allParas requetResult:^(NSData *jsonData, NSError *error) {
        if (!error)
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:kNilOptions
                                                                  error:&error];
            if (!error)
            {
                if ([kSaftToNSString(dic[@"code"]) isEqualToString:kHSRequestSucceedCode] &&
                    dic[@"data"] &&
                    (kSaftToNSInteger(dic[@"data"][@"resultCode"]) == kHSRequestSucceedSubCode))//返回成功数据
                {
                    dic = dic[@"data"][@"order"];
                    GYAgainConfirmViewController *vcConfirm = [[GYAgainConfirmViewController alloc] init];
                    vcConfirm.dicOrderInfo = dic;
                    [self.navigationController pushViewController:vcConfirm animated:YES];
                }else//返回失败数据
                {
                    [Utils showMessgeWithTitle:nil message:@"生成订单失败." isPopVC:nil];
                }
            }else
            {
                [Utils showMessgeWithTitle:nil message:@"生成订单失败." isPopVC:nil];
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

#pragma mark - 获取一个地址
- (void)getAddrFromNetwork
{
    NSDictionary *allParas = @{@"key": data.ecKey
                               };
    
    [Network HttpGetForRequetURL:[data.ecDomain stringByAppendingString:@"/easybuy/getDeliveryAddress"] parameters:allParas requetResult:^(NSData *jsonData, NSError *error) {
        if (!error)
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:kNilOptions
                                                                  error:&error];
            if (!error)
            {
                if (kSaftToNSInteger(dic[@"retCode"]) == kEasyPurchaseRequestSucceedCode)//返回成功数据
                {
                    NSArray *addList = dic[@"data"];
                    if (!addList || addList.count < 1) return;

                    int beDefaultIndex = 0;
                    for (int i = 0; i < addList.count; i++)//找默认，没有使用 beDefaultIndex＝0
                    {
                        NSDictionary *dicAdd = addList[i];
                        if ([dicAdd[@"beDefault"] boolValue])
                        {
                            beDefaultIndex = i;
                            break;
                        }
                    }
                    NSDictionary *dicAdd = addList[beDefaultIndex];
                    GYAddressModel *model = [[GYAddressModel alloc] init];
                    model.Province = kSaftToNSString(dicAdd[@"province"]);
                    model.City = kSaftToNSString(dicAdd[@"city"]);
                    model.Area = kSaftToNSString(dicAdd[@"area"]);
                    model.DetailAddress = kSaftToNSString(dicAdd[@"detail"]);
                    model.CustomerName = kSaftToNSString(dicAdd[@"consignee"]);
                    model.CustomerPhone = kSaftToNSString(dicAdd[@"mobile"]);
                    model.PostCode = kSaftToNSString(dicAdd[@"postcode"]);
                    [self getAddressModle:model];
                }else//返回失败数据
                {
//                    [Utils showMessgeWithTitle:nil message:@"." isPopVC:nil];
                }
            }else
            {
//                [Utils showMessgeWithTitle:nil message:@"." isPopVC:nil];
            }
            
        }else
        {
//            [Utils showMessgeWithTitle:@"提示" message:[error localizedDescription] isPopVC:nil];
        }
    }];
}
@end
