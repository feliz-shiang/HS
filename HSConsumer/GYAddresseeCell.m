//
//  GYAddresseeCell.m
//  HSConsumer
//
//  Created by 00 on 14-12-18.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYAddresseeCell.h"
#import "GYSelWayVC.h"
#import "GYCartModel.h"
#import "UIView+CustomBorder.h"


@implementation GYAddresseeCell
- (IBAction)btnChangeADClick:(id)sender {
    [self.delegate pushSelAddrVC];
}

//点击支付按钮，创建支付选择页面
- (IBAction)btnSelPayWayClick:(id)sender {

    NSLog(@"进入支付方式选中页面");

    NSMutableArray *mArrData;
    
    if ([GlobalData shareInstance].isCardUser) {
        mArrData= [NSMutableArray arrayWithObjects:@"货到付款",@"网银支付",@"互生币支付",
                                   nil];
    }else{
        mArrData= [NSMutableArray arrayWithObjects:@"货到付款",@"网银支付",
                                   nil];
    }

    [self.delegate pushSelWayVCWithmArray:mArrData WithIndexPath:self.indexPath];
    
}

- (void)awakeFromNib
{
    
    self.contentView.backgroundColor=[UIColor whiteColor];
    [self.lbLine addTopBorder];
    [self.btnChangeAddress setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];
    [self addAllBorder];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
