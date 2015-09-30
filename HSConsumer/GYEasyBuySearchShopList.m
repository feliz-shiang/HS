//
//  GYEasyBuySearchList.m
//  HSConsumer
//
//  Created by apple on 15-4-16.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//
#define KDetailFont [UIFont systemFontOfSize:13]
#define KTitleFont [UIFont systemFontOfSize:15]

#import "GYEasyBuySearchShopList.h"
#import "UIImageView+WebCache.h"

@implementation GYEasyBuySearchShopList


- (void)awakeFromNib {
    // Initialization code
    
    self.lbGoodsName.textColor=kNavigationBarColor;
    self.lbDistance.textColor=kCellItemTextColor;
    self.lbEvaluationCount.textColor=kCellItemTextColor;
    self.lbCompanyAddr.textColor=kCellItemTextColor;
    self.lbCompanyHsnumber.textColor=kCellItemTextColor;
    self.lbCompanyTel.textColor=kCellItemTextColor;

    
    self.lbGoodsName.font = KTitleFont;
    self.lbDistance.font = KDetailFont;
    self.lbEvaluationCount.font = KDetailFont;
    self.lbCompanyAddr.font = KDetailFont;
    self.lbCompanyHsnumber.font = KDetailFont;
    self.lbCompanyTel.font = [UIFont systemFontOfSize:11];
    
    [self.btnShopTel setTitleColor:kCellItemTextColor forState:UIControlStateNormal];
    [self.btnShopTel setImage:[UIImage imageNamed:@"phone_icon.png"] forState:UIControlStateNormal];
    self.btnShopTel.imageEdgeInsets=UIEdgeInsetsMake(1, 0, 1, 120);
    self.btnShopTel.titleEdgeInsets=UIEdgeInsetsMake(0, -60, 0, 0);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    
}


-(void)refreashUIWithModel:(ShopModel *)model
{
    self.lbCompanyTel.text=[NSString stringWithFormat:@"%@",model.strShopTel];
    ;
        UIFont * font = [UIFont systemFontOfSize:14.0];
     CGSize titleSize = [model.shopDistance sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    CGRect distanceFrame =self.lbDistance.frame;
    distanceFrame.size.width=(titleSize.width+20)>58?58:(titleSize.width+20);
    distanceFrame.origin.x=kScreenWidth-distanceFrame.size.width;
    self.lbDistance.frame=distanceFrame;
    CGFloat origiX=kScreenWidth-distanceFrame.size.width-12;
//    self.imgvDistance.frame.origin.x=origiX;
    
    CGRect imgvFrame=self.imgvDistance.frame;
    imgvFrame.origin.x=origiX;
    self.imgvDistance.frame=imgvFrame;
    
    self.beCash=model.beCash;
    self.beReach=model.beReach;
    self.beSell=model.beSell;
    self.beTake=model.beTake;
    self.beTicket=model.beTicket;
    [self.imgvGoodsPicture sd_setImageWithURL:[NSURL URLWithString:model.strShopPictureURL] placeholderImage:kLoadPng(@"ep_placeholder_image_type1")];
    self.lbCompanyAddr.text=model.strShopAddress;
    self.lbCompanyHsnumber.text=[NSString stringWithFormat:@"%@",model.strResourceNumber];
    self.lbEvaluationCount.text=[NSString stringWithFormat:@"好评%@%%",model.strRate];
    self.lbGoodsName.text=model.strCompanyName;
    self.lbDistance.text=[NSString stringWithFormat:@"%.1fkm",[model.shopDistance doubleValue]];
    
    CGFloat border = 10;
//    self.lbDistance.text = @"adfasdgaDSFASGA";
    CGSize distanceSize = [Utils sizeForString:self.lbDistance.text font:KDetailFont width:200];
    self.lbDistance.frame = CGRectMake(kScreenWidth - distanceSize.width - border, self.lbDistance.frame.origin.y, distanceSize.width, self.lbDistance.frame.size.height);
    self.imgvDistance.frame = CGRectMake(self.lbDistance.frame.origin.x - self.imgvDistance.frame.size.width -5, self.imgvDistance.frame.origin.y, self.imgvDistance.frame.size.width, self.imgvDistance.frame.size.height);
    self.imgvDistance.center = CGPointMake(self.imgvDistance.center.x, self.lbDistance.center.y);
    self.lbGoodsName.frame = CGRectMake(CGRectGetMaxX(self.imgvGoodsPicture.frame)+10, self.lbGoodsName.frame.origin.y, self.imgvDistance.frame.origin.x - (CGRectGetMaxX(self.imgvGoodsPicture.frame)+10 +5), self.lbGoodsName.frame.size.height);
    
    [self.btnShopTel setTitle:model.strShopTel forState:UIControlStateNormal];
   [self setIconCout];
}


-(void)setIconCout
{
    //modify by zhangqy
#if 0
    // add by songjk
    NSArray * arrData = [NSArray arrayWithObjects:
                         self.beReach,
                         self.beSell,
                         self.beCash,
                         self.beTake,
                         self.beTicket,
                         nil];
    
    //    NSLog(@"%@-----bbbbb,",arrData);
    NSMutableArray * marrUseData = [NSMutableArray array];
    for (int i =(arrData.count - 1); i>-1; i--) {
        NSString * str = arrData[i];
        if ([str isEqualToString:@"1"]) {
            NSNumber * num = [NSNumber numberWithInt:i+1];
            [marrUseData addObject:num];
        }
    }
    CGFloat iconWith = 15;
    // add bysongjk
    for (int i = 25; i<30; i++) {
        UIView * view = [self viewWithTag:i];
        if (view != nil) {
            [view removeFromSuperview];
        }
    }
    for (int i=0; i<marrUseData.count; i++) {
        UIImageView * imageView =[[UIImageView alloc]init];
        imageView.tag = 25+i;
        imageView.frame=CGRectMake(kScreenWidth-10-iconWith*(i+1), 30, iconWith, iconWith);
        imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"image_good_detail%ld",(long)[marrUseData[i] integerValue]]];
        [self addSubview:imageView];
        
    }
#endif
    //add by zhnagqy  iOS消费者--轻松购--商品展示列表中特色服务排列建议与安卓（UI）一致
    NSArray * arrData = [NSArray arrayWithObjects:
                         self.beTicket,
                         self.beReach,
                         self.beSell,
                         self.beCash,
                         self.beTake,
                         nil];
    NSArray *imageNames = @[@"image_good_detail5",@"image_good_detail1",@"image_good_detail2",@"image_good_detail3",@"image_good_detail4"];
    CGFloat iconWith = 15;
    for (int i = 25; i<30; i++) {
        UIView * view = [self viewWithTag:i];
        if (view != nil) {
            [view removeFromSuperview];
        }
    }
    NSInteger index = arrData.count-1;
    for (NSInteger i=index,j=index; i>=0; i--,j--) {
        UIImageView * imageView =[[UIImageView alloc]init];
        
        if ([arrData[i] isEqualToString:@"1"]) {
            imageView.tag = 25+j;
            imageView.frame=CGRectMake(kScreenWidth-10-iconWith*(index-j+1), 30, iconWith, iconWith);
            imageView.image=[UIImage imageNamed:imageNames[i]];
            [self addSubview:imageView];
        }
        else
        {
            j++;
        }
        
    }
    
    
    
}

@end
