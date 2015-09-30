//
//  GYEeayBuyTableViewCell.m
//  HSConsumer
//
//  Created by apple on 14-11-26.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYEeayBuyTableViewCell.h"
#import "UIView+CustomBorder.h"
#import "UIImageView+WebCache.h"
@implementation GYEeayBuyTableViewCell

- (void)awakeFromNib
{
    self.btnRightCover.backgroundColor=[UIColor clearColor];
    self.btnLeftCover.backgroundColor=[UIColor clearColor];
    self.lbLeftGoodName.backgroundColor=[UIColor clearColor];
    self.lbRightGoodName.backgroundColor=[UIColor clearColor];
    self.lbLeftGoodPrice.backgroundColor=[UIColor clearColor];
    self.lbRightGoodPrice.backgroundColor=[UIColor clearColor];
    self.lbLeftGoodPv.backgroundColor=[UIColor clearColor];
    self.lbRightGoodPv.backgroundColor=[UIColor clearColor];
    self.lbRightSellCount.backgroundColor=[UIColor clearColor];
    self.lbRightHscompany.backgroundColor=[UIColor clearColor];
    self.lbRightCity.backgroundColor=[UIColor clearColor];
    self.lbLeftCity.backgroundColor=[UIColor clearColor];
    self.lbLeftHScompany.backgroundColor=[UIColor clearColor];
    self.lbLeftSellCount.backgroundColor=[UIColor clearColor];
    [self sendSubviewToBack:self.btnLeftCover];
    [self sendSubviewToBack:self.btnRightCover];
    
    //设置字体颜色
    self.lbRightGoodPrice.textColor=kNavigationBarColor;
    self.lbLeftGoodPrice.textColor=kNavigationBarColor;
    self.lbLeftGoodName.textColor=kCellItemTitleColor;
    self.lbRightGoodName.textColor=kCellItemTitleColor;
    self.lbLeftGoodPv.textColor=kCellItemTextColor;
    self.lbRightGoodPv.textColor=kCellItemTextColor;
    self.lbLeftSellCount.textColor=kCellItemTextColor;
    self.lbLeftHScompany.textColor=kCellItemTextColor;
    self.lbLeftCity.textColor=kCellItemTextColor;
    self.lbRightCity.textColor=kCellItemTextColor;
    self.lbRightHscompany.textColor=kCellItemTextColor;
    self.lbRightSellCount.textColor=kCellItemTextColor;
    [self.vLine addRightBorder];
    
    [self.lbLeftGoodPv addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
//     [self.lbRightGoodPv addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
//    
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context

{
    
    if ([keyPath isEqualToString:@"text"] && object == self.lbLeftGoodPv)
        
    {
        
        [self setHsbLogoOffsetX:self.lbLeftGoodPv.text from:160 withType:1
         ];
        
    }
    if ([keyPath isEqualToString:@"text"] && object == self.lbRightGoodPv)
        
    {
        
        [self setHsbLogoOffsetX:self.lbLeftGoodPv.text from:290 withType:1
         ];
        
    }
    
    
}



- (void)setHsbLogoOffsetX:(NSString *)text from:(CGFloat)fromX withType:(int)sourceType

{
    
    switch (sourceType) {
        case 1:
        {
            NSString *str = text;
            
            CGSize strSize = [str sizeWithFont:self.lbLeftGoodPv.font
                              
                             constrainedToSize:CGSizeMake(MAXFLOAT, self.lbLeftGoodPv.frame.size.width)];
            
            CGRect iconRect = self.imgvPointIcon.frame;
            
            if (strSize.width <= self.lbLeftGoodPv.frame.size.width)
                
            {
                
                iconRect.origin.x = self.frame.size.width - kDefaultMarginToBounds -fromX- strSize.width - iconRect.size.width - 5;//距离文字5
                
                self.imgvPointIcon.frame = iconRect;
                
            }//else使用xib的布局
            
            
            
            
        }
            break;
        default:
            break;
    }
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void)refreshUIWithModel : (GYEasyBuyModel *)model WithSecondModel:(GYEasyBuyModel *)rightModel

{
    for (int i = 125; i<130; i++) {
        UIView * view = [self viewWithTag:i];
        if (view != nil) {
            [view removeFromSuperview];
        }
    }
#pragma mark 左右都有
    if (model!=nil&&rightModel!=nil) {

///// 右边
        
        NSString *str = rightModel.strGoodPoints;
        CGSize strSize = [str sizeWithFont:self.lbRightGoodPv.font
                         constrainedToSize:CGSizeMake(MAXFLOAT, self.lbRightGoodPv.frame.size.width)];
        CGRect iconRect = self.imgvRightPointIcon.frame;
        if (strSize.width <= self.lbRightGoodPv.frame.size.width)
        {
            iconRect.origin.x = self.frame.size.width - kDefaultMarginToBounds - strSize.width - iconRect.size.width -15;//距离文字5
            self.imgvRightPointIcon.frame = iconRect;
        }
        
        [self setIconCout:kScreenWidth/2-8 withType:100 andModel:rightModel];
        
        self.lbRightGoodName.text=rightModel.strGoodName;
        self.lbRightGoodPrice.text=[NSString stringWithFormat:@"%.2f",rightModel.strGoodPrice.floatValue];;
        self.lbRightGoodPv.text=[NSString stringWithFormat:@"%.2f",rightModel.strGoodPoints.floatValue];;
        self.lbRightCity.text=rightModel.city;
        self.lbRightHscompany.text=rightModel.companyName;
        //monthlySales 换成 saleCount
        self.lbRightSellCount.text=[NSString stringWithFormat:@"总销量%@",rightModel.saleCount];
        [self.imgRightImage sd_setImageWithURL:[NSURL URLWithString:rightModel.strGoodPictureURL] placeholderImage:kLoadPng(@"ep_placeholder_image_type1")];

    }else{
#pragma mark  如果右边没有
        self.lbRightGoodName.hidden=YES;
        self.lbRightGoodPrice.hidden=YES;
        self.lbRightGoodPv.hidden=YES;
        self.imgRightImage.hidden=YES;
        self.btnRightCover.hidden=YES;
        self.imgvRightCoinIcon.hidden=YES;
        self.imgvRightPointIcon.hidden=YES;
        self.lbRightCity.hidden=YES;
        self.lbRightHscompany.hidden=YES;
        self.lbRightSellCount.hidden=YES;
    }
    
    [self setIconCout :0 withType:0 andModel:model];
    [self.imgLeftImage sd_setImageWithURL:[NSURL URLWithString:model.strGoodPictureURL] placeholderImage:kLoadPng(@"ep_placeholder_image_type1")];
    self.lbLeftGoodName.text=model.strGoodName;
    self.lbLeftGoodPrice.text=[NSString stringWithFormat:@"%.2f",model.strGoodPrice.floatValue];
    self.lbLeftGoodPv.text=[NSString stringWithFormat:@"%.2f",model.strGoodPoints.floatValue];
    self.lbLeftHScompany.text=model.companyName;
    //monthlySales 换成 saleCount
    self.lbLeftSellCount.text=[NSString stringWithFormat:@"总销量%@",model.saleCount];
    self.lbLeftCity.text=model.city;
    
    
}

-(void)setIconCout:(CGFloat )Xstart withType:(int) type andModel:(GYEasyBuyModel*)model
{
    self.beReach=[NSString stringWithFormat:@"%d",model.beReach];
    self.beCash=[NSString stringWithFormat:@"%d",model.beCash];
    self.beSell=[NSString stringWithFormat:@"%d",model.beSell];
    self.beTake=[NSString stringWithFormat:@"%d",model.beTake];
    self.beTicket=[NSString stringWithFormat:@"%d",model.beTicket];

    //modify by zhangqy 9224 iOS消费者--轻松购--商品展示列表中特色服务排列建议与安卓（UI）一致
#if 0
    // add by songjk
    NSArray * arrData = [NSArray arrayWithObjects:
                         self.beReach,
                         self.beSell,
                         self.beCash,
                         self.beTake,
                         self.beTicket,
                         nil];
    
    
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
    
    for (int i=0; i<marrUseData.count; i++) {
        UIImageView * imageView =[[UIImageView alloc]init];
        imageView.tag = 25+i+type;
        imageView.frame=CGRectMake(Xstart+iconWith*(i+1), 208, iconWith, iconWith);
        imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"image_good_detail%ld",(long)[marrUseData[i] integerValue]]];
        [self addSubview:imageView];
        [self bringSubviewToFront:imageView];
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
    for (int i=0,j=0; i<arrData.count; i++,j++) {
        UIImageView * imageView =[[UIImageView alloc]init];
        if ([arrData[i] isEqualToString:@"1"]) {
            imageView.tag = 25+j+type;
            imageView.frame=CGRectMake(Xstart+iconWith*(j+1), 208, iconWith, iconWith);
            imageView.image=[UIImage imageNamed:imageNames[i]];
            [self addSubview:imageView];
            [self bringSubviewToFront:imageView];
        }
        else
        {
            j--;
        }

    }
}


- (void)dealloc

{
    [self.lbLeftGoodPv removeObserver:self forKeyPath:@"text"];
    
}

@end
