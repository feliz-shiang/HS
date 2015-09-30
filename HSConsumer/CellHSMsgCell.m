//
//  CellHSMsgCell.m
//  HSConsumer
//
//  Created by apple on 14-12-1.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "CellHSMsgCell.h"
#import "UIView+CustomBorder.h"
#import "GYHSMsgShowDetailsVC.h"
#import "GYEPOrderDetailViewController.h"

@implementation CellHSMsgCell

- (void)awakeFromNib
{
    // Initialization code
//    [self.lbShopName setTextColor:kCellItemTitleColor];
//    [self.lbShopAddress setTextColor:kCellItemTextColor];
//    [self.lbShopTel setTextColor:kCellItemTextColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)viewContentBkgClick:(id)sender
{
    UIViewController *v = nil;
    if (self.chatItem.sub_Msg_Code == kSub_Msg_Code_Person_Business_Bind_HSCard_Msg ||
        self.chatItem.sub_Msg_Code == kSub_Msg_Code_Person_HS_Msg)
    {
        GYHSMsgShowDetailsVC *vc = kLoadVcFromClassStringName(NSStringFromClass([GYHSMsgShowDetailsVC class]));
        vc.chatItem = self.chatItem;
        vc.navigationItem.title = self.nav.navigationItem.title;
        v = vc;
    }else if (self.chatItem.sub_Msg_Code == kSub_Msg_Code_Person_Business_Get_Coupons ||
              self.chatItem.sub_Msg_Code == kSub_Msg_Code_Person_Business_Accidental_valid ||
              self.chatItem.sub_Msg_Code == kSub_Msg_Code_Person_Business_Accidental_Invalid ||
              self.chatItem.sub_Msg_Code == kSub_Msg_Code_Person_Business_Free_Insurance )//申领抵扣券消息 没明细 添加免费医疗和意外伤害
    {
        return;
    }else
    {
        NSString *orderNo = @"";
        NSArray *arrOrderNo = [self.chatItem.msgId componentsSeparatedByString:@","];
        if (arrOrderNo && arrOrderNo.count > 0)
        {
            orderNo = kSaftToNSString(arrOrderNo[0]);
        }
        GYEPOrderDetailViewController *vc = kLoadVcFromClassStringName(NSStringFromClass([GYEPOrderDetailViewController class]));
        vc.orderID = orderNo;
        vc.dicDataSource = nil;
        vc.navigationItem.title = kLocalized(@"ep_order_detail");
        v = vc;
    }
    [self pushVC:v animated:YES];
}

- (void)drawRect:(CGRect)rect
{
    [self.lbTitle setTextColor:kCellItemTitleColor];
    [self.lbDatetime setTextColor:kCellItemTextColor];
    [self.lbContent setTextColor:kCellItemTextColor];
    
    [self.lbTitle setBackgroundColor:kClearColor];
    [self.lbDatetime setBackgroundColor:kClearColor];
    [self.lbContent setBackgroundColor:kClearColor];

    
    [self.viewContentBkg addAllBorder];
    [self.viewContentBkg setBottomBorderInset:YES];
    [self.viewContentBkg setRightBorderInset:YES];
    [self.viewContentBkg addTarget:self action:@selector(viewContentBkgClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    [self setBackgroundColor:kDefaultVCBackgroundColor];
    [self.contentView setBackgroundColor:kDefaultVCBackgroundColor];
    if (kSystemVersionLessThan(@"7.0"))
    {
        UIView *cellBk = [[UIView alloc] init];
        [cellBk setBackgroundColor:kDefaultVCBackgroundColor];
        [self setBackgroundView:cellBk];
    }
}

- (void)pushVC:(id)vc animated:(BOOL)ani
{
    if (self.nav && vc)
    {
        UIViewController *tvc = [self.nav topViewController];
        [tvc setHidesBottomBarWhenPushed:YES];
        [self.nav pushViewController:vc animated:ani];
    }
}

+ (CGFloat)getHeightIsShowDatetime:(BOOL)show
{
    if (show)
        return 130.f;
    return 130.f - 45.f;
}

@end
