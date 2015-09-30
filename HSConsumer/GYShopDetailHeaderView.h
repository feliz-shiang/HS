//
//  GYShopDetailHeaderView.h
//  HSConsumer
//
//  Created by apple on 14-12-23.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYEasyBuyModel.h"
//#import "TAPageControl.h"
//#import "TAExampleDotView.h"

@interface GYShopDetailHeaderView : UIView
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
-(id)initWithShopModel:(CGRect)rect WithOwer:(id)ower;

-(void)setShopInfo:(ShopModel *)model;

@end
