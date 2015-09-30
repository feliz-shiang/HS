//
//  GYCardBandTableViewCell.m
//  HSConsumer
//
//  Created by apple on 14-10-21.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYCardBandTableViewCell.h"
#import "UIView+CustomBorder.h"
@implementation GYCardBandTableViewCell
{
    __weak IBOutlet UILabel *lbUserName;//真实姓名
    __weak IBOutlet UIImageView *imgLine;
    
    __weak IBOutlet UIView *vBackground;//背景view
    
    __weak IBOutlet UILabel *lbCardNumber;//卡号
    
    __weak IBOutlet UILabel *lbIsVerify;//是否已验证
    
    __weak IBOutlet UILabel *lbLocationName;//银行卡名称
    
    __weak IBOutlet UILabel *lbIsDefaultCard;//默认银行卡
}

//cell的初始化
- (void)awakeFromNib
{
    // Initialization code
    self.contentView.backgroundColor=kDefaultVCBackgroundColor;
    [vBackground addAllBorder];
    lbIsVerify.textColor=kCellItemTitleColor;
    lbLocationName.textColor=kCellItemTextColor;
    lbCardNumber.textColor=kCellItemTextColor;
    lbUserName.textColor=kCellItemTitleColor;
    lbIsDefaultCard.textColor=kCellItemTitleColor;
    [self.btnQuitBanding setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    lbIsDefaultCard.text=kLocalized(@"default_bank_card");
    [self.btnQuitBanding setTitle:kLocalized(@"delete_card") forState:UIControlStateNormal];
    [imgLine addLeftBorder];
    
    
}
//model.strBankCode=[dict objectForKey:@"bankCode"];
//model.strAcctType=[dict objectForKey:@"acctType"];
//model.strAcctType=[dict objectForKey:@"cityName"];
//model.strAcctType=[dict objectForKey:@"custResNo"];
//model.strAcctType=[dict objectForKey:@"defaultFlag"];
//model.strAcctType=[dict objectForKey:@"custResType"];
//model.strAcctType=[dict objectForKey:@"bankAcctId"];
//model.strAcctType=[dict objectForKey:@"bankAreaNo"];
//model.strAcctType=[dict objectForKey:@"bankAcctName"];
//model.strAcctType=[dict objectForKey:@"bankAccount"];
//model.strAcctType=[dict objectForKey:@"bankBranch"];
//model.strAcctType=[dict objectForKey:@"provinceCode"];
//model.strAcctType=[dict objectForKey:@"usedFlag"];
//model.strAcctType=[dict objectForKey:@"acctType"];

-(void)refreshUIWith:(GYCardBandModel *)mod
{
   
    lbIsDefaultCard.hidden=NO;
    self.btnQuitBanding.hidden=NO;
    
    lbCardNumber.text=mod.strTempAccount;
    
    // modify by songjk
    NSString * strName = mod.strBankAcctName;
    NSInteger length = strName.length;
    if (length>0)
    {
        strName = [strName substringToIndex:1];
        for (int i = 0; i<length-1; i++) {
            strName = [NSString stringWithFormat:@"%@*",strName];
        }
    }
    lbUserName.text=strName;
    
    lbLocationName.text=mod.strBankName;
    
    if (mod.strDefaultFlag) {
        lbIsDefaultCard.text=@"默认银行卡";
    }else {
       lbIsDefaultCard.hidden=YES;
    }
    
    if (mod.strUsedFlag) {
        lbIsVerify.text=@"已验证";
    }else {
        lbIsVerify.text=@"未验证";

    
    }
    
    
    
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
