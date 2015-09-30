//
//  DiscountCell.m
//  HSConsumer
//
//  Created by 00 on 15-3-19.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "DiscountCell.h"

@implementation DiscountCell
{

    BOOL  isChoosed;


}

- (void)awakeFromNib {
    // Initialization code
    
    self.contentView.backgroundColor=[UIColor whiteColor];
        isChoosed=YES;
    [self.btnMutebleSelect setBackgroundImage:[UIImage imageNamed:@"btn_tick_noclick.png"] forState:UIControlStateNormal];
    [self.btnMutebleSelect setBackgroundImage:[UIImage imageNamed:@"btn_tick_clear.png"] forState:UIControlStateSelected];
    [self.btnMutebleSelect addTarget:self action:@selector(selectOneDiscount:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)selectOneDiscount:(UIButton *)sender
{
    
    if (isChoosed) {
        sender.selected=YES;
        isChoosed=NO;
    }else{
        sender.selected=NO;
        isChoosed=YES;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(sendSelectDisCount:WithDiscountModel:)]) {
        [_delegate sendSelectDisCount:sender WithDiscountModel:self.model];
    }
   

}


-(void)refreshUiWithModel:(DiscountModel *)model
{
    
    self.model=model;
    self.lbDiscountName.text = model.couponName;
    
    self.lbCount.text =model.sum ;
    self.lbRemain.text = [NSString stringWithFormat:@"剩余%@张",model.surplusNum];
    self.lbUnitPrice.text = model.faceValue;
    self.lbTotal.text =[NSString stringWithFormat:@"x%@张",model.amount];

}

@end
