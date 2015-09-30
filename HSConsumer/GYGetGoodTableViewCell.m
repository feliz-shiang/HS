//
//  GYGetGoodTableViewCell.m
//  HSConsumer
//
//  Created by apple on 14-10-17.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYGetGoodTableViewCell.h"
#import "UIView+CustomBorder.h"

@implementation GYGetGoodTableViewCell
{
    BOOL isChoosed;
    __weak IBOutlet UIView *vBackgroundWhite;//背景的白色view
    
}
//初始化数据，设置button 不同状态下的背景图片
- (void)awakeFromNib
{
    // Initialization code
    self.contentView.backgroundColor=kDefaultVCBackgroundColor;
    self.lbCustomerAddress.numberOfLines=0;
    [self.btnChooseDefaultAddress setImage:[UIImage imageNamed:@"cell_btn_shipping_address_tick_no.png"] forState:UIControlStateNormal];
    self.btnChooseDefaultAddress.imageEdgeInsets=UIEdgeInsetsMake(8, 8, 8, 8);
    
    [ self.btnChooseDefaultAddress setImage:[UIImage imageNamed:@"cell_btn_shipping_address_tick_yes.png"] forState:UIControlStateSelected];
    isChoosed=YES;
    [vBackgroundWhite addAllBorder];

    self.lbCustomerName.textColor=kCellItemTitleColor;
    self.lbCustomerAddress.textColor=kCellItemTextColor;
    self.lbCustomerPhone.textColor=kCellItemTitleColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    
}

//通过model数据更新ui.
-(void)refreshUIWith:( GYAddressModel *)model
{
    self.mod=model;
    self.lbCustomerName.text=model.CustomerName;
    self.lbCustomerPhone.text=model.CustomerPhone;
   
    if ([model.BeDefault isEqualToString:@"1"]) {
        self.btnChooseDefaultAddress.selected=YES;
    }else{
        self.btnChooseDefaultAddress.selected=NO;
    }
    
    
   // if ([model.Area isKindOfClass:[NSNull class]]) {
    NSMutableAttributedString * attribString;
    if([model.Area isEqualToString:@"<null>"]){
          //  self.lbCustomerAddress.text=[NSString stringWithFormat:@"%@%@",model.Province,model.City];
//        attribString=@"";
    }else{
        self.lbCustomerAddress.text=[NSString stringWithFormat:@"%@ %@ %@ %@",model.Province,model.City,model.Area,model.PostCode];
        attribString =[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@%@ (%@)",model.Province,model.City,model.DetailAddress,model.PostCode]];
    
    }

    NSLog(@"%@======code",model.PostCode);
   
    if (kSystemVersionGreaterThanOrEqualTo(@"6.0")) {
        self.lbCustomerAddress.attributedText=attribString;
    }
   
    [self.btnChooseDefaultAddress  addTarget:self action:@selector(chooseOneAddress:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(BOOL)isNullOrNil :(id)sender
{
    if ([sender isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return NO;

}



//控制button的选中状态
-(void)chooseOneAddress:(UIButton *)sender
{
    if (isChoosed) {
        sender.selected=YES;
        isChoosed=NO;
    }else{
        sender.selected=NO;
        isChoosed=YES;
    }
    
    //通过代理 将 button 传到 controller
    if (_senderBtnDelegate && [_senderBtnDelegate respondsToSelector:@selector(senderBtn:WithCellModel:)])
    {
        [_senderBtnDelegate senderBtn:sender WithCellModel:self.mod];
        
    }
    
}

@end
