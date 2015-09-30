//
//  GYShopheaderViewController.h
//  HSConsumer
//
//  Created by appleliss on 15/8/25.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYEasyBuyModel.h"

@interface GYShopheaderViewController : UIView
@property (nonatomic,strong)UIImageView * imgvShopPicture;
@property (nonatomic,strong)UILabel * lbShopName;
@property (nonatomic,strong)UIButton  * btnCollect;
@property (nonatomic,strong)UIButton  * btnAttention;
@property (nonatomic,strong)UIButton * btnShare;
@property (nonatomic,strong)UIScrollView * srcView;
@property (nonatomic,strong)UIPageControl * PageControl;
@property (nonatomic,assign)CGRect  superframe;
@property (nonatomic,strong)id Ower;
@property (nonatomic,strong)UIView * bottomView;
@property (nonatomic,strong)UILabel *gradeLabel;////评分
@property (nonatomic,strong)UIImageView *gradeView;/////五个星星
@property (nonatomic,strong)UIView *grdeview;//////放星星评价
-(id)initWithShopModel:(CGRect)rect WithOwer:(id)ower;

-(void)setShopInfo:(ShopModel *)model;
@end
