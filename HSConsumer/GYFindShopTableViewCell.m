//
//  GYFindShopTableViewCell.m
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//
#define KDetailFont [UIFont systemFontOfSize:13]
#define KTitleFont [UIFont systemFontOfSize:15]

#import "GYFindShopTableViewCell.h"
#import "UIImageView+WebCache.h"
#import <BaiduMapAPI/BMapKit.h>


@implementation GYFindShopTableViewCell
{
    __weak IBOutlet UIImageView *imgvShopImage;

    __weak IBOutlet UILabel *lbShopTitle;
    __weak IBOutlet UILabel *lbShopAddress;

 

    __weak IBOutlet UILabel *lbDistance;
    __weak IBOutlet UIImageView *imgvLocation;

    __weak IBOutlet UILabel *lbComment;
    
    
    __weak IBOutlet UILabel *lbHsNumber;
    

    
    NSString * phoneNumber;
    
    
}
- (void)awakeFromNib
{
    // Initialization code
    lbShopTitle.textColor = kNavigationBarColor;
    lbShopAddress.textColor = kCellItemTextColor;
//    lbShopTel.textColor = kCellItemTextColor;
    lbDistance.textColor = kCellItemTextColor;
    lbComment.textColor = kCellItemTextColor;
    lbHsNumber.textColor=kCellItemTextColor;
    imgvLocation.image = [UIImage imageNamed:@"imge_map_icon.png"];
    [self.btnShopTel setTitleColor:kCellItemTextColor forState:UIControlStateNormal];
    lbShopTitle.font = KTitleFont;
    lbShopAddress.font = KDetailFont;
//    lbShopTel.font = [UIFont systemFontOfSize:11];
    lbDistance.font = KDetailFont;
    lbComment.font = KDetailFont;
    lbHsNumber.font = [UIFont systemFontOfSize:12];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)refreshUIWith:(ShopModel *)model
{
   
    self.model=model;
   [imgvShopImage sd_setImageWithURL:[NSURL URLWithString:model.strShopPictureURL] placeholderImage:[UIImage imageNamed:@"ep_placeholder_image_type1.png"]];
  //所有高度重新计算
//    CGFloat  height = [Utils heightForString:model.strShopName fontSize:17.0 andWidth:190.0];
//    CGRect frame = lbShopTitle.frame;
//    frame.size.height=height;
//    lbShopTitle.frame=frame;
    BOOL str=[Utils isBlankString:model.strCompanyName];
    lbShopTitle.text=[model.strCompanyName isEqualToString:@"<null>"]||str==YES ?[NSString stringWithFormat:@""]:model.strCompanyName;
    lbHsNumber.text=[NSString stringWithFormat:@"互生号:%@",model.strResno];
    
    
    phoneNumber=model.strShopTel;
    [self.btnShopTel setTitle:[NSString stringWithFormat:@"%@",model.strShopTel] forState:UIControlStateNormal];

    lbDistance.text=[NSString stringWithFormat:@"%.1fkm",model.shopDistance.floatValue];// modify by songjk
    if (!model.strRate.length>0) {
        model.strRate=@"0.00";
    }
    // modify by songjk
    CGFloat fRate = [model.strRate floatValue];
    NSString * strRate = [NSString stringWithFormat:@"%.1f",fRate];
    lbComment.text=[NSString stringWithFormat:@"好评%@%%",strRate];

    lbShopAddress.text=[NSString stringWithFormat:@"%@",model.strShopAddress];
    
    
    CGFloat border = 10;
    CGSize distanceSize = [Utils sizeForString:lbDistance.text font:KDetailFont width:200];
    lbDistance.frame = CGRectMake(self.frame.size.width - distanceSize.width - border, lbDistance.frame.origin.y, distanceSize.width, lbDistance.frame.size.height);
    imgvLocation.frame = CGRectMake(lbDistance.frame.origin.x - imgvLocation.frame.size.width-5, imgvLocation.frame.origin.y, imgvLocation.frame.size.width, imgvLocation.frame.size.height);
    lbShopTitle.frame = CGRectMake(CGRectGetMaxX(imgvShopImage.frame)+10, lbShopTitle.frame.origin.y, imgvLocation.frame.origin.x - CGRectGetMaxX(imgvShopImage.frame)-10-5, lbShopTitle.frame.size.height);
    
    [self setIconCout];

}

-(void)setIconCout
{
#if 0
    // add by songjk
    NSArray * arrData = [NSArray arrayWithObjects:
                         self.model.beReach,
                         self.model.beSell,
                         self.model.beCash,
                         self.model.beTake,
                         self.model.beTicket,
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

//- (IBAction)btnPhoneCall:(id)sender {
//    
//    JGActionSheetSection * ass0 = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"呼叫号码"] buttonStyle:JGActionSheetButtonStyleHSDefaultGray];
//    JGActionSheetSection * ass1 = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"取消"] buttonStyle:JGActionSheetButtonStyleHSDefaultRed];
//    NSArray *asss = @[ass0, ass1];
//    JGActionSheet *as = [[JGActionSheet alloc] initWithSections:asss];
//    as.delegate = self;
//    
//    [as setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
//        
//        switch (indexPath.section) {
//            case 0:
//            {
//                if (indexPath.row == 0)
//                {
//                    NSLog(@"呼叫号码");
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", phoneNumber]]];
//                }else if (indexPath.row == 1)
//                {
//                    NSLog(@"复制号码");
//                }
//            }
//                break;
//            case 1:
//            {
//                NSLog(@"取消");
//            }
//                break;
//                break;
//                
//            default:
//                break;
//        }
//        
//        [sheet dismissAnimated:YES];
//    }];
//    
//    [as setCenter:CGPointMake(100, 100)];
//    
//    [as showInView:self animated:YES];
//}

@end
