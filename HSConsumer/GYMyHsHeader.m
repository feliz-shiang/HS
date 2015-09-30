//
//  GYMyHsHeader.m
//  HSConsumer
//
//  Created by apple on 15/8/14.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYMyHsHeader.h"
#import "UIButton+enLargedRect.h"


@implementation GYMyHsHeader


-(void)awakeFromNib
{

    //[self.LbUserHello setTextColor:kCellItemTitleColor];
    //[self.lbLastLoginTime setTextColor:kCellItemTextColor];
    [Utils setFontSizeToFitWidthWithLabel:self.lbLastLoginTime labelLines:1];
    //[Utils setFontSizeToFitWidthWithLabel:self.LbUserHello labelLines:1];
//    [self addSubview:self.imgBackground];
//    [self sendSubviewToBack:self.imgBackground];
//    self.imgBackground.frame=self.frame;
//    self.imgBackground.image = [UIImage imageNamed:@"img_hsBackground.png"];
    [self.mvBack setImage:[UIImage imageNamed:@"img_hsBackground.png"]];
    self.btnHeadPic.clipsToBounds = YES;
    self.btnHeadPic.layer.cornerRadius = 35;
    
    UIImage* image= kLoadPng(@"nav_btn_back");
    //    CGRect backframe= CGRectMake(0, 0, 44, 44);
    CGRect backframe= CGRectMake(15, 30, image.size.width * 0.5, image.size.height * 0.5);
   
    [self addSubview:self.btnBackToRoot];
     self.btnBackToRoot.frame = backframe;
    [self.btnBackToRoot setBackgroundImage:image forState:UIControlStateNormal];

  



}


-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.btnBackToRoot setEnlargEdgeWithTop:10 right:30 bottom:10 left:25];

}

-(UIImageView *)imgBackground
{
    if (!_imgBackground) {
        _imgBackground =[[UIImageView alloc]init];
    }
    return _imgBackground;
}

-(UIButton *)btnBackToRoot
{
    if (!_btnBackToRoot) {
        _btnBackToRoot = [UIButton buttonWithType:UIButtonTypeCustom];
      
    }
    return _btnBackToRoot;
}

- (void)btnBackToRootClicked:(UIButton*)btn
{
    
}
@end
