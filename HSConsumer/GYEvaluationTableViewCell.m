//
//  GYEvaluationTableViewCell.m
//  HSConsumer
//
//  Created by apple on 14-12-17.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYEvaluationTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+enLargedRect.h"

@implementation GYEvaluationTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.contentView.backgroundColor=kDefaultVCBackgroundColor;
    self.vWhiteBackground.backgroundColor=[UIColor whiteColor];
    self.lbGoodShop.textColor=kCellItemTitleColor;
    self.lbGoodTitle.textColor=kCellItemTextColor;
//    [self.btnMakeEvalutaion setTitle:kLocalized(@"make_evaluation") forState:UIControlStateNormal];
//     [self.btnMakeEvalutaion setTitle:kLocalized(@"already_evaluation") forState:UIControlStateNormal];
    self.btnMakeEvalutaion.backgroundColor=[UIColor clearColor];
//    [self.btnMakeEvalutaion setBackgroundImage:[UIImage imageNamed:@"cell_already_evalutation.png"] forState:UIControlStateSelected];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)refreshUIWithModel :(GYEvaluateGoodModel *)model WithType:(int )cellType;
{
    
    
    [self.imgvGoods sd_setImageWithURL:[NSURL URLWithString:model.urlString] placeholderImage:[UIImage imageNamed:@"ep_placeholder_image_type1.png"]];
    self.lbGoodShop.text=model.titleString;
    self.lbGoodTitle.text=model.skuString;
    
    
    if (cellType==1) {
         [self.btnMakeEvalutaion setTitle:@"已评价" forState:UIControlStateNormal];
        [self.btnMakeEvalutaion setBorderWithWidth:1 andRadius:2 andColor:kCellItemTextColor];
        [self.btnMakeEvalutaion setTitleColor:kCellItemTextColor forState:UIControlStateNormal];
    }
    else
    {
    [self.btnMakeEvalutaion setTitle:kLocalized(@"make_evaluation") forState:UIControlStateNormal];
        [self.btnMakeEvalutaion setBorderWithWidth:1 andRadius:3 andColor:kNavigationBarColor];
         [self.btnMakeEvalutaion setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    }

    

    

}
@end
