//
//  GYEasyBuySearchList.m
//  HSConsumer
//
//  Created by apple on 15-4-16.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//
#define KDetailFont [UIFont systemFontOfSize:14]
#define KTitleFont [UIFont systemFontOfSize:15]

#import "GYEasyBuySearchList.h"
#import "UIImageView+WebCache.h"

@implementation GYEasyBuySearchList

- (void)awakeFromNib {
    // Initialization code
    
    self.lbGoodsName.textColor=kCellItemTitleColor;
    self.lbPrice.textColor=kNavigationBarColor;

    self.lbCompanyName.textColor=kCellItemTextColor;
    self.lbCity.textColor=kCellItemTextColor;
    self.lbMonthlyRate.textColor=kCellItemTextColor;
  [self.lbPoint addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    
    self.lbGoodsName.font = KTitleFont;
    self.lbPoint.font = KDetailFont;
    self.lbPrice.font = KDetailFont;
    self.lbMonthlyRate.font = KDetailFont;
    self.lbCompanyName.font = KDetailFont;
    self.lbCity.font = KDetailFont;
    
    self.lbPoint.textColor = kCorlorFromRGBA(0, 143, 215, 1);
}

-(void)refreashUIWithModel:(GYEasyBuyModel *)model
{
    self.beCash=[NSString stringWithFormat:@"%d",model.beCash];
    self.beReach=[NSString stringWithFormat:@"%d",model.beReach];
    self.beSell=[NSString stringWithFormat:@"%d",model.beSell];
    self.beTake=[NSString stringWithFormat:@"%d",model.beTake];
    self.beTicket=[NSString stringWithFormat:@"%d",model.beTicket];
    [self.imgvGoodsPicture sd_setImageWithURL:[NSURL URLWithString:model.strGoodPictureURL] placeholderImage:kLoadPng(@"ep_placeholder_image_type1")];
    self.lbGoodsName.text=model.strGoodName;
    self.lbPoint.text=[NSString stringWithFormat:@"%.2f",model.strGoodPoints.floatValue];
    self.lbPrice.text=[NSString stringWithFormat:@"%.2f",model.strGoodPrice.floatValue];
    // 月销改为总销量
    self.lbMonthlyRate.text=[NSString stringWithFormat:@"总销量%@",model.saleCount];
    self.lbCompanyName.text=model.companyName;
    self.lbCity.text=model.city;
    
    // add by songjk
//    self.lbMonthlyRate.text = @"00000000000";
    CGFloat border = 10;
    CGSize montySale = [Utils sizeForString:self.lbMonthlyRate.text font:KDetailFont width:200];
    self.lbMonthlyRate.frame = CGRectMake(self.frame.size.width - montySale.width - border, self.lbMonthlyRate.frame.origin.y, montySale.width, self.lbMonthlyRate.frame.size.height);
    
//    self.lbCity.text = @"内蒙古自治区";
    CGSize citySize = [Utils sizeForString:self.lbCity.text font:KDetailFont width:200];
    self.lbCity.frame = CGRectMake(self.frame.size.width - citySize.width - border, self.lbCity.frame.origin.y, citySize.width, self.lbCity.frame.size.height);
    self.lbCompanyName.frame = CGRectMake(self.lbGoodsName.frame.origin.x, self.lbCompanyName.frame.origin.y, self.lbCity.frame.origin.x - self.lbGoodsName.frame.origin.x,self.lbCompanyName.frame.size.height);
    
//    self.lbPoint.text = @"99999999999";
    CGSize pointSize = [Utils sizeForString:self.lbPoint.text font:KDetailFont width:200];
    self.lbPoint.frame = CGRectMake(self.frame.size.width - pointSize.width - border, self.lbPoint.frame.origin.y, pointSize.width, self.lbPoint.frame.size.height);
    self.imgvPoint.frame = CGRectMake(self.lbPoint.frame.origin.x - self.imgvPoint.frame.size.width - 5, self.imgvPoint.frame.origin.y, self.imgvPoint.frame.size.width, self.imgvPoint.frame.size.height);
    self.imgvPoint.center = CGPointMake(self.imgvPoint.center.x, self.lbPoint.center.y);
    self.imgvCoin.center= CGPointMake(self.imgvCoin.center.x, self.lbPoint.center.y);
    self.lbPrice.center= CGPointMake(self.lbPrice.center.x, self.lbPoint.center.y);
    [self setIconCout];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"text"] && object == self.lbPoint)
        
    {
        
        [self setHsbLogoOffsetX:self.lbPoint.text];
        
    }
    
}



- (void)setHsbLogoOffsetX:(NSString *)text

{
    
    NSString *str = text;
    
    CGSize strSize = [str sizeWithFont:self.lbPoint.font
                      
                     constrainedToSize:CGSizeMake(MAXFLOAT, self.lbPoint.frame.size.width)];
    
    CGRect iconRect = self.imgvPoint.frame;
    
    if (strSize.width <= self.lbPoint.frame.size.width)
        
    {
        
        iconRect.origin.x = self.frame.size.width - kDefaultMarginToBounds - strSize.width - iconRect.size.width - 5;//距离文字5
        
        self.imgvPoint.frame = iconRect;
        
    }//else使用xib的布局
    
}



- (void)dealloc

{
    [self.lbPoint removeObserver:self forKeyPath:@"text"];
}

#if 0
-(void)setIconCout
{
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
    for (NSInteger i =(arrData.count - 1); i>-1; i--) {
        NSString * str = arrData[i];
        if ([str isEqualToString:@"1"]) {
            NSNumber * num = [NSNumber numberWithInteger:i+1];
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
        imageView.frame=CGRectMake(94+iconWith*(i+1)-iconWith, 68, iconWith, iconWith);
        imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"image_good_detail%ld",(long)[marrUseData[i] integerValue]]];
        [self addSubview:imageView];
        
    }
}
#endif
//add by zhangqy
-(void)setIconCout
{
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
    for (NSInteger i=0,j=0; i<=index; i++,j++) {
        UIImageView * imageView =[[UIImageView alloc]init];
        
        if ([arrData[i] isEqualToString:@"1"]) {
            imageView.tag = 25+j;//94+iconWith*(i+1)-iconWith
            imageView.frame=CGRectMake(94+iconWith*(j+1)-iconWith, 68, iconWith, iconWith);
            imageView.image=[UIImage imageNamed:imageNames[i]];
            [self addSubview:imageView];
        }
        else
        {
            j--;
        }
        
    }
}


@end
