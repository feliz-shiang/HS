//
//  ViewCellForOrders.m
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "ViewCellForOrders.h"
#import "UIView+CustomBorder.h"
#import "JSBadgeView.h"
#import "GYEPSaleAfterViewController.h"   //售后
#import "GYEPMyAllOrdersViewController.h" //全部订单
#import "GYEPMyOrderViewController.h"     //订单
#import "GYMainEvaluationGoodsViewController.h" //评价商品

@interface ViewCellForOrders ()
{
    IBOutlet UIView *vBkg0;
    
    JSBadgeView *badgeView0;
    JSBadgeView *badgeView1;
    JSBadgeView *badgeView2;
    JSBadgeView *badgeView3;

    
    IBOutlet UILabel *lbLablel0;
    IBOutlet UILabel *lbLablel1;
    IBOutlet UILabel *lbLablel2;
    IBOutlet UILabel *lbLablel3;
    
    
    IBOutlet UIButton *ivIcon0;
    IBOutlet UIButton *ivIcon1;
    IBOutlet UIButton *ivIcon2;
    IBOutlet UIButton *ivIcon3;
 
    
    IBOutlet UIButton *btnAllOrders;
}
@end

@implementation ViewCellForOrders

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)init
{
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    ViewCellForOrders *v = [subviewArray objectAtIndex:0];
    
    [v->vBkg0 addTopBorder];
    
    [Utils setFontSizeToFitWidthWithLabel:v->lbLablel0 labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:v->lbLablel1 labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:v->lbLablel2 labelLines:1];
    [Utils setFontSizeToFitWidthWithLabel:v->lbLablel3 labelLines:1];
//    [Utils setFontSizeToFitWidthWithLabel:lbLabel4 labelLines:1];
    [v->lbLablel0 setTextColor:kCellItemTextColor];
    [v->lbLablel1 setTextColor:kCellItemTextColor];
    [v->lbLablel2 setTextColor:kCellItemTextColor];
    [v->lbLablel3 setTextColor:kCellItemTextColor];
   
//      [lbLabel4 setTextColor:kCellItemTextColor];
    [v->lbLablel0 setText:kLocalized(@"待付款")];
    [v->lbLablel1 setText:kLocalized(@"待发货")];
    [v->lbLablel2 setText:kLocalized(@"待自提")];
    [v->lbLablel3 setText:kLocalized(@"待收货")];
//     [lbLabel4 setText:kLocalized(@"待评价")];
    [Utils setFontSizeToFitWidthWithLabel:v->btnAllOrders.titleLabel labelLines:1];
    [v->btnAllOrders setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];
    [v->btnAllOrders setTitle:kLocalized(@"全部订单") forState:UIControlStateNormal];

    [v setBackgroundColor:[UIColor whiteColor]];
    [v addTopBorderAndBottomBorder];
    return v;
}

- (IBAction)pushVC:(id)sender
{
    UIViewController *vc = nil;
    if (sender == ivIcon0)
    {
        GYEPMyOrderViewController *_vc = kLoadVcFromClassStringName(NSStringFromClass([GYEPMyOrderViewController class]));
        [_vc setOrderState:kOrderStateWaittingPay];
        _vc.firstTipsErr = YES;
        //            label = (UILabel *)[self viewWithTag:200];
        vc = _vc;
        vc.navigationItem.title = kLocalized(@"订单-待付款");
        
        DDLogInfo(@"待付款");
    }else if (sender == ivIcon1)
    {
        GYEPMyOrderViewController *_vc = kLoadVcFromClassStringName(NSStringFromClass([GYEPMyOrderViewController class]));
        [_vc setOrderState:kOrderStateWaittingDelivery];
        _vc.firstTipsErr = YES;
        //            label = (UILabel *)[self viewWithTag:200];
        vc = _vc;
        vc.navigationItem.title = kLocalized(@"订单-待发货");

        DDLogInfo(@"待发货");
        
    }else if (sender == ivIcon2)
    {
        GYEPMyOrderViewController *_vc = kLoadVcFromClassStringName(NSStringFromClass([GYEPMyOrderViewController class]));
        [_vc setOrderState:kOrderStateWaittingPickUpCargo];
        _vc.firstTipsErr = YES;
        //            label = (UILabel *)[self viewWithTag:200];
        vc = _vc;
        vc.navigationItem.title = kLocalized(@"订单-待自提");
        DDLogInfo(@"待自提");
        
    }else if (sender == ivIcon3)
    {

        GYEPMyOrderViewController *_vc = kLoadVcFromClassStringName(NSStringFromClass([GYEPMyOrderViewController class]));
        [_vc setOrderState:kOrderStateWaittingConfirmReceiving];
        _vc.firstTipsErr = YES;
        //            label = (UILabel *)[self viewWithTag:200];
        vc = _vc;
        vc.navigationItem.title = kLocalized(@"订单-待收货");
        
        DDLogInfo(@"待收货");
        
    }else if (sender == btnAllOrders)
    {
        GYEPMyAllOrdersViewController *_vc = kLoadVcFromClassStringName(NSStringFromClass([GYEPMyAllOrdersViewController class]));
       
        vc = _vc;
        vc.navigationItem.title = kLocalized(@"ep_myhe_all_orders");
        DDLogInfo(@"全部订单");
    }
//    else if (sender == ivIcon4)
//    {
//        GYMainEvaluationGoodsViewController *_vc = kLoadVcFromClassStringName(NSStringFromClass([GYMainEvaluationGoodsViewController class]));
//        _vc.index = 1;
//        vc = _vc;
//        vc.navigationItem.title = kLocalized(@"待评价");
//        DDLogInfo(@"待评价");
//    }

    if (!vc || !self.nav) return;
    [self.nav.topViewController setHidesBottomBarWhenPushed:YES];
    [self.nav pushViewController:vc animated:YES];
}


- (void)setNumber:(NSInteger)number index:(NSInteger)index
{
    NSString *str = @"";
    if (number > 0 && number < 100)
    {
        str = [@(number) stringValue];
    }else if(number >= 100)
    {
        str = @"99+";
    }
        
    switch (index)
    {
        case 0:
        {
            if (badgeView0)
            {
                [badgeView0 removeFromSuperview];
            }
            badgeView0 = [[JSBadgeView alloc] initWithParentView:ivIcon0 alignment:JSBadgeViewAlignmentTopRight];
            badgeView0.badgeText = str;
        }
            break;
        case 1:
        {
            if (badgeView1)
            {
                [badgeView1 removeFromSuperview];
            }
            badgeView1 = [[JSBadgeView alloc] initWithParentView:ivIcon1 alignment:JSBadgeViewAlignmentTopRight];
            badgeView1.badgeText = str;
        }
            break;
        case 2:
        {
            if (badgeView2)
            {
                [badgeView2 removeFromSuperview];
            }
            
            badgeView2 = [[JSBadgeView alloc] initWithParentView:ivIcon2 alignment:JSBadgeViewAlignmentTopRight];
            badgeView2.badgeText = str;
        }
            break;
        case 3:
        {
            if (badgeView3)
            {
                [badgeView3 removeFromSuperview];
            }
            badgeView3 = [[JSBadgeView alloc] initWithParentView:ivIcon3 alignment:JSBadgeViewAlignmentTopRight];
            badgeView3.badgeText = str;
        }
            break;
//        case 4:
//        {
//            if (badgeView4)
//            {
//                [badgeView4 removeFromSuperview];
//            }
//            badgeView4 = [[JSBadgeView alloc] initWithParentView:ivIcon4 alignment:JSBadgeViewAlignmentTopRight];
//             lbLabel4.textColor=kCellItemTextColor;
//            badgeView4.badgeText = str;
//        }
//            break;
        default:
            break;
    }
}

+ (CGFloat)getHeight
{
    return 120.f;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
