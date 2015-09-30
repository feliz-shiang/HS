//
//  GYBuyGoodTableViewCell.m
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//
#define KDetailFont [UIFont systemFontOfSize:13]
#define KTitleFont [UIFont systemFontOfSize:15]

#import "GYBuyGoodTableViewCell.h"
#import "UIImageView+WebCache.h"
#define goodNameHeight 30
#define shopNameHeight 22
#define addressHeight 26

@implementation GYBuyGoodTableViewCell

{
    __weak IBOutlet UIImageView *imgvGoodPicture;
    
    __weak IBOutlet UILabel *lbGoodName;
    
    __weak IBOutlet UILabel *lbShopName;//实体店
    
    __weak IBOutlet UILabel *lbGoodPrice;
    
    __weak IBOutlet UIImageView *imgvPVIcon;
    
    __weak IBOutlet UILabel *lbPointCount;
    
    __weak IBOutlet UIImageView *imgvLocationIcom;
    
    __weak IBOutlet UILabel *lbLocationDistance;
    
    __weak IBOutlet UILabel *lbShopAddress;//实体店地址
    
    __weak IBOutlet UIImageView *imgvCoin;
    
  
    
    __weak IBOutlet UILabel *lbMonthlySales;
    
}

- (void)awakeFromNib
{

    lbGoodName.textColor=kCellItemTitleColor;
    lbShopName.textColor=kCellItemTextColor;
    lbGoodPrice.textColor=kNavigationBarColor;
    imgvPVIcon.image=[UIImage imageNamed:@"consume_point.png"];
    imgvLocationIcom.image=[UIImage imageNamed:@"imge_map_icon.png"];
    lbShopAddress.textColor=kCellItemTextColor;
    lbPointCount.textColor = kCellItemTextColor;
    lbLocationDistance.textColor = kCellItemTextColor;
    
    lbMonthlySales.textColor=kCellItemTextColor;

    lbGoodName.font = KTitleFont;
    lbShopName.font = KDetailFont;
    lbGoodPrice.font = KDetailFont;
    lbShopAddress.font = KDetailFont;
    lbPointCount.font = KDetailFont;
    lbLocationDistance.font = KDetailFont;
    lbMonthlySales.font = KDetailFont;
    
    [self.btnShopTel setTitleColor:kCellItemTextColor forState:UIControlStateNormal];
    [self.btnShopTel setTitleEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];

    
}



-(void)refreshUIWithModel:(SearchGoodModel *)model
{

    self.model = model;
    if (model.shopUrl.length>0) {
           [imgvGoodPicture sd_setImageWithURL:[NSURL URLWithString:model.shopUrl] placeholderImage:[UIImage imageNamed:@"ep_placeholder_image_type1.png"]];
    }
    NSString *strGoodName = model.name;
    if (!strGoodName || [strGoodName isEqualToString:@""]) {
        strGoodName = @"商品";
    }
    

    
//    CGFloat  GoodNameheight = [Utils heightForString:strGoodName fontSize:17.0 andWidth:190.0];
//    
//    CGRect FrameGoodName = lbGoodName.frame;
//    int multiple=2;
//    FrameGoodName.size.height=GoodNameheight>goodNameHeight?goodNameHeight*multiple:goodNameHeight;
//    lbGoodName.frame=FrameGoodName;

//    CGFloat  shopHeight = [Utils heightForString:[NSString stringWithFormat:@"实体店:%@",model.shopsName ] fontSize:14.0 andWidth:190.0];
//    
//    CGRect FrameShop = lbShopName.frame;
//    FrameShop.origin.y=lbGoodName.frame.origin.y+(GoodNameheight>goodNameHeight?goodNameHeight*multiple:goodNameHeight);
//    FrameShop.size.height=shopHeight;
//    lbShopName.frame=FrameShop;
//    
//    CGFloat  AddressHeight = [Utils heightForString:[NSString stringWithFormat:@"地址:%@",model.addr] fontSize:14.0 andWidth:190.0];
//    CGRect FrameShopTel = lbShopAddress.frame;
//    FrameShopTel.origin.y=lbShopName.frame.origin.y+(shopHeight>shopNameHeight?shopNameHeight*multiple:shopNameHeight);
//    FrameShopTel.size.height=AddressHeight;
//    lbShopAddress.frame=FrameShopTel;
//
//    CGFloat originY =lbShopAddress.frame.origin.y+lbShopAddress.frame.size.height+5;
//    CGRect FrameIcon = imgvCoin.frame;
//    FrameIcon.origin.y=originY;
//    imgvCoin.frame=FrameIcon;
//
//    CGRect Frameprice = lbGoodPrice.frame;
//    Frameprice.origin.y=originY;
//    lbGoodPrice.frame=Frameprice;
    
//    CGRect FramePvIcon = imgvPVIcon.frame;
//    FramePvIcon.origin.y=originY+5;
//    imgvPVIcon.frame=FramePvIcon;
//    
//    CGRect FramePv = lbPointCount.frame;
//    FramePv.origin.y=originY;
//    lbPointCount.frame=FramePv;
    
//    CGRect FrameImgLoction =imgvLocationIcom.frame;
//    FrameImgLoction.origin.y=originY+imgvPVIcon.frame.size.height+10+3;
//    imgvLocationIcom.frame=FrameImgLoction;
//    
//    CGRect FrameLbLocation = lbLocationDistance.frame;
//    FrameLbLocation.origin.y=originY+imgvPVIcon.frame.size.height+5+3;
//    lbLocationDistance.frame=FrameLbLocation;
    lbShopName.text=model.companyName;
    // modify by songjk
    lbMonthlySales.text=[NSString stringWithFormat:@"总销量%@",model.saleCount];
    lbGoodName.text=[NSString stringWithFormat:@"%@",strGoodName];// modify by songjk 改为显商品名称
    lbGoodPrice.text=[NSString stringWithFormat:@"%@",model.price];
    lbPointCount.text=[NSString stringWithFormat:@"%@",model.goodsPv];
    lbShopName.text= [NSString stringWithFormat:@"%@",model.shopsName ];// modify by songjk 改为显示店名称
    lbLocationDistance.text=[NSString stringWithFormat:@"%.1fkm",model.shopDistance.floatValue];// modify by songjk
//    lbShopTel.text=model.shopTel;
    [self.btnShopTel setTitle:model.shopTel forState:UIControlStateNormal];
    lbShopAddress.text= [NSString stringWithFormat:@"%@",model.addr];// modify by songjk 改为显示地址
    
    CGFloat border = 10;
//    lbMonthlySales.text = @"adfasdfagadsf";
    CGSize montySale = [Utils sizeForString:lbMonthlySales.text font:KDetailFont width:200];
    lbMonthlySales.frame = CGRectMake(self.frame.size.width - montySale.width - border, lbMonthlySales.frame.origin.y, montySale.width, lbMonthlySales.frame.size.height);
    lbGoodName.frame = CGRectMake(CGRectGetMaxX(imgvGoodPicture.frame)+10, lbGoodName.frame.origin.y, lbMonthlySales.frame.origin.x - CGRectGetMaxX(imgvGoodPicture.frame)-10-5, lbGoodName.frame.size.height);
    
//    lbPointCount.text =@"22222222222";
    CGSize pointSize = [Utils sizeForString:lbPointCount.text font:KDetailFont width:200];
    lbPointCount.frame = CGRectMake(self.frame.size.width - pointSize.width - border, lbPointCount.frame.origin.y, pointSize.width, lbPointCount.frame.size.height);
    imgvPVIcon.frame = CGRectMake(lbPointCount.frame.origin.x - imgvPVIcon.frame.size.width-5, imgvPVIcon.frame.origin.y, imgvPVIcon.frame.size.width, imgvPVIcon.frame.size.height);
    
//    lbLocationDistance.text =@"22222222222";
    CGSize distanceSize = [Utils sizeForString:lbLocationDistance.text font:KDetailFont width:200];
    lbLocationDistance.frame = CGRectMake(self.frame.size.width - distanceSize.width - border, lbLocationDistance.frame.origin.y, distanceSize.width, lbPointCount.frame.size.height);
    imgvLocationIcom.frame = CGRectMake(lbLocationDistance.frame.origin.x - imgvLocationIcom.frame.size.width-5, imgvLocationIcom.frame.origin.y, imgvLocationIcom.frame.size.width, imgvLocationIcom.frame.size.height);
    [self setTopIcon:0];
 
}

-(void)setTopIcon:(NSInteger )count
{
    //modify by zhangqy
#if 0
    // add by songjk
    NSArray * arrData = [NSArray arrayWithObjects:
                         self.model.beReach,
                         self.model.beSell,
                         self.model.beCash,
                         self.model.beTake,
                         self.model.beTicket,
                         nil];
    
//    NSLog(@"%@---%@- %@----%@---%@---bereach,sell,take,")
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
        imageView.frame=CGRectMake(kScreenWidth-10-iconWith*(i+1), 64, iconWith, iconWith);
        imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"image_good_detail%ld",(long)[marrUseData[i] integerValue]]];
        [self addSubview:imageView];
        
    }
#endif
    //add by zhnagqy  iOS消费者--轻松购--商品展示列表中特色服务排列建议与安卓（UI）一致
    NSArray * arrData = [NSArray arrayWithObjects:
                         self.model.beTicket,
                         self.model.beReach,
                         self.model.beSell,
                         self.model.beCash,
                         self.model.beTake,
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
            imageView.frame=CGRectMake(kScreenWidth-10-iconWith*(index-j+1), 64, iconWith, iconWith);
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
