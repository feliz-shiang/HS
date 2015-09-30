//
//  GYShopDetailHeaderView.m
//  HSConsumer
//
//  Created by apple on 14-12-23.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYGoodDetailHeaderView.h"
#import "UIImageView+WebCache.h"

@implementation GYGoodDetailHeaderView

-(id)initWithShopModel: (SearchGoodModel *)model WithFrame :(CGRect )frame WithOwer :(id) ower
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.superFrame=frame;
        CGRect tempRect =frame;
        self.ower=ower;
       
        tempRect.size.height=frame.size.height-70;
        self.imgvGoodPicture=[[UIImageView alloc]initWithFrame:tempRect];
        self.imgvGoodPicture.contentMode=UIViewContentModeScaleAspectFit;
        // add by songjk
        UIImageView * ivIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hs_coin.png"]];
        ivIcon.frame = CGRectMake(kDefaultMarginToBounds, 2, 20, 20);
        self.lbGoodPrice=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(ivIcon.frame), 0, 250, 25)];
        self.lbGoodPrice.textColor=kCellItemTitleColor;
        self.lbGoodPrice.backgroundColor=[UIColor clearColor];
        // add by songjk
        CGFloat  fPrice = [model.price floatValue];
        NSString * strPrice = [NSString stringWithFormat:@"%.02f",fPrice];
        self.lbGoodPrice.text=[NSString stringWithFormat:@"%@",strPrice]; // modify by songjk
        self.lbGoodPrice.textColor=kNavigationBarColor;
        self.lbGoodPrice.font=[UIFont systemFontOfSize:20.0f];
        
        self.imgvPointIcon=[[UIImageView alloc]initWithFrame:CGRectMake(kDefaultMarginToBounds, self.lbGoodPrice.frame.origin.y+self.lbGoodPrice.frame.size.height+5, 29, 13)];
        self.imgvPointIcon.image=[UIImage imageNamed:@"PointPV.png"];
        
        self.lbPoint=[[UILabel alloc]initWithFrame:CGRectMake(self.imgvPointIcon.frame.origin.x+self.imgvPointIcon.frame.size.width+3, self.lbGoodPrice.frame.origin.y+self.lbGoodPrice.frame.size.height+3, 100, 20)];
        self.lbPoint.text=[NSString stringWithFormat:@"%@", model.goodsPv];
        self.lbPoint.font=[UIFont systemFontOfSize:17.0f];
        self.lbPoint.backgroundColor = [UIColor clearColor];
        self.lbPoint.textColor=kCorlorFromRGBA(0, 143, 215, 1);
        
        self.imgvPointIcon.center = CGPointMake(self.imgvPointIcon.center.x, self.lbPoint.center.y);
        
        // add by songjk 月销量
        self.lbMonthSale = [[UILabel alloc] init];
        if (model.saleCount == nil || [model.saleCount isKindOfClass:[NSNull class]]) {
            self.lbMonthSale.text = @"总销量0";
        }
        else
        {
            self.lbMonthSale.text = [NSString stringWithFormat:@"总销量%@", model.saleCount];
        }
         self.lbMonthSale.textColor = kCellItemTextColor;
         self.lbMonthSale.font = [UIFont systemFontOfSize:10.0f];
         self.lbMonthSale.backgroundColor =[UIColor clearColor];
         self.lbMonthSale.frame = CGRectMake(CGRectGetMaxX(self.lbPoint.frame) + 10, self.imgvPointIcon.frame.origin.y, 200, 20);
        [self.vBottomBackground addSubview: self.lbMonthSale];
        
//        _btnEnterVShop=[UIButton buttonWithType: UIButtonTypeCustom];
//        [_btnEnterVShop setImage:[UIImage imageNamed:@"image_enter_shop.png"] forState:UIControlStateNormal];
//        _btnEnterVShop.frame=CGRectMake(kScreenWidth-kDefaultMarginToBounds-60-20, 0, 60, 40);
//        _btnEnterVShop.imageView.contentMode=UIViewContentModeScaleAspectFit;
//        [_btnEnterVShop setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
//        _btnEnterVShop.imageEdgeInsets=UIEdgeInsetsMake(5, 20, 15, 20);
//        _btnEnterVShop.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//        [_btnEnterVShop setTitleEdgeInsets:UIEdgeInsetsMake(33,-_btnEnterVShop.frame.size.width+5, 5,0.0)];
//        _btnEnterVShop.titleLabel.font=[UIFont systemFontOfSize:10.0f];
        
        _btnAttention=[UIButton buttonWithType:UIButtonTypeCustom];
        _btnAttention.frame=CGRectMake(kScreenWidth-kDefaultMarginToBounds-40, 0, 60, 50);
        [_btnAttention setImage:[UIImage imageNamed:@"image_colection.png"] forState:UIControlStateNormal];
        [_btnAttention  setImage:[UIImage imageNamed:@"ep_btn_collect_yes.png"] forState:UIControlStateSelected];
        _btnAttention.imageView.contentMode=UIViewContentModeScaleAspectFit;
        _btnAttention.titleLabel.font=[UIFont systemFontOfSize:10.0f];
        _btnAttention.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_btnAttention setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
        
        _btnAttention.imageEdgeInsets=UIEdgeInsetsMake(5, 20, 15, 20);
        _btnAttention.titleEdgeInsets=UIEdgeInsetsMake(33,-self.btnAttention.frame.size.width, 5,0);
        
        [_btnAttention setTitle:@"收藏" forState:UIControlStateNormal];
//        [_btnEnterVShop setTitle:@"商铺" forState:UIControlStateNormal];
        
        [self.mainScrollView addSubview:self.imgvGoodPicture];
        self.mainScrollView.showsHorizontalScrollIndicator = NO;
//        [self addSubview:self.imgvGoodPicture];
        [self addSubview:self.mainScrollView];
//        [self addSubview:self.pageControl];
        
        // add bysongjk 快递信息
        CGFloat lbExpressTitleX = self.imgvPointIcon.frame.origin.x;
        CGFloat lbExpressTitleY = CGRectGetMaxY(self.imgvPointIcon.frame)+5;
        CGFloat lbExpressTitleW = 38;
        CGFloat lbExpressTitleH = 15;
        UILabel * lbExpressTitle = [[UILabel alloc] initWithFrame:CGRectMake(lbExpressTitleX, lbExpressTitleY, lbExpressTitleW, lbExpressTitleH)];
        lbExpressTitle.font = [UIFont systemFontOfSize:15];
        lbExpressTitle.textColor = kCellItemTextColor;
        lbExpressTitle.text = @"快递";
        self.lbExpressTitle = lbExpressTitle;
        
        CGFloat ivExpressIconX = CGRectGetMaxX(lbExpressTitle.frame)+3;
        CGFloat ivExpressIconY = lbExpressTitleY-1;
        CGFloat ivExpressIconW = 17;
        CGFloat ivExpressIconH = 17;
        UIImageView * ivExpressIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hs_coin.png"]];
        ivExpressIcon.frame= CGRectMake(ivExpressIconX, ivExpressIconY, ivExpressIconW, ivExpressIconH);
        self.mvExpressCoin = ivExpressIcon;
        
        CGFloat lbExpressFeeX = CGRectGetMaxX(ivExpressIcon.frame)+3;
        CGFloat lbExpressFeeY = lbExpressTitleY;
        CGFloat lbExpressFeeW = 60;
        CGFloat lbExpressFeeH = 15;
        UILabel * lbExpressFee = [[UILabel alloc] initWithFrame:CGRectMake(lbExpressFeeX, lbExpressFeeY, lbExpressFeeW, lbExpressFeeH)];
        lbExpressFee.font = [UIFont systemFontOfSize:15];
        lbExpressFee.textColor = kCellItemTextColor;
        self.lbExpressFee = lbExpressFee;
        
        CGFloat lbExpressInfoX = CGRectGetMaxX(lbExpressFee.frame)+5;
        CGFloat lbExpressInfoY = lbExpressTitleY;
        CGFloat lbExpressInfoW = kScreenWidth - lbExpressInfoX;
        CGFloat lbExpressInfoH = 15;
        UILabel * lbExpressInfo = [[UILabel alloc] initWithFrame:CGRectMake(lbExpressInfoX, lbExpressInfoY, lbExpressInfoW, lbExpressInfoH)];
        lbExpressInfo.font = [UIFont systemFontOfSize:15];
        lbExpressInfo.textColor = kCellItemTextColor;
        self.lbExpressInfo = lbExpressInfo;
        
        
        [self.vBottomBackground addSubview:self.lbExpressTitle];
        [self.vBottomBackground addSubview:self.mvExpressCoin];
        [self.vBottomBackground addSubview:self.lbExpressFee];
        [self.vBottomBackground addSubview:self.lbExpressInfo];
        
        
        [self.vBottomBackground addSubview:ivIcon];// add by songjk
        [self.vBottomBackground addSubview:self.lbGoodPrice];
        [self.vBottomBackground addSubview:self.imgvPointIcon];
//        [self.vBottomBackground addSubview:self.btnEnterVShop];
        [self.vBottomBackground addSubview:self.btnAttention];
        [self.vBottomBackground addSubview:self.lbPoint];
        
        [self addSubview:self.vBottomBackground];
    }
    return self;
}

-(void)setInfoForHeaderView:(GYSurrondGoodsDetailModel *)model
{
    // add by songjk
    // add by songjk
    self.lbExpressFee.text = [NSString stringWithFormat:@"%.02f",[model.postage floatValue]] ;
    self.lbExpressInfo.text = model.postageMsg;
    if ([model.postage integerValue] == 0)
    {
        self.lbExpressTitle.hidden = YES;
        self.mvExpressCoin.hidden = YES;
        self.lbExpressFee.hidden = YES;
        self.lbExpressInfo.text = @"包邮";
        self.lbExpressInfo.frame = CGRectMake(self.lbExpressTitle.frame.origin.x, self.lbExpressInfo.frame.origin.y, self.lbExpressInfo.frame.size.width, self.lbExpressInfo.frame.size.height);
    }
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((kScreenWidth - 50)*0.5, CGRectGetMaxY(self.mainScrollView.frame)*0.95, 50, 15)];
    if (kSystemVersionGreaterThanOrEqualTo(@"6.0"))
    {
        self.pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
        self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        //        self.PageControl.pageIndicatorTintColor = [UIColor colorWithRed:0 green:107/255.0 blue:183/255.0 alpha:1];
    }
//    self.pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
//    self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0 green:107/255.0 blue:183/255.0 alpha:1];
    [self addSubview:_pageControl];
    if (model.shopUrl.count>0) {
        
        [self.imgvGoodPicture sd_setImageWithURL:[NSURL URLWithString:model.shopUrl[0][@"url"]]];
        
        
        [self.imgvGoodPicture sd_setImageWithURL:[NSURL URLWithString:model.shopUrl[0][@"url"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image)
            {
                NSLog(@"%@------22222-size",NSStringFromCGSize(image.size));
//                image =[Utils imageCompressForWidth:image targetWidth:kScreenWidth];
                self.imgvGoodPicture.image=image;
                NSLog(@"%@-------size",NSStringFromCGSize(image.size));
                
            }
            
        }];
        
        
        _pageControl.numberOfPages=model.shopUrl.count;
        
        CGSize sizeForMainScr =self.mainScrollView.contentSize;
        self.mainScrollView.contentSize=CGSizeMake(kScreenWidth*model.shopUrl.count, sizeForMainScr.height);
  
    }
    // add by songjk
    if (model.saleCount && ![model.saleCount isKindOfClass:[NSNull class]]) {
        self.lbMonthSale.text = [NSString stringWithFormat:@"总销量%@",model.saleCount];
    }
}

-(UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.mainScrollView.frame) - 20, CGRectGetWidth(self.mainScrollView.frame), 20)];
        _pageControl.currentPage=0;
        _pageControl.numberOfPages=1;
        _pageControl.backgroundColor=[UIColor clearColor];
        _pageControl.currentPageIndicatorTintColor=[UIColor whiteColor];
    }
    return _pageControl;
    
}

-(UIScrollView *)mainScrollView
{
    if (!_mainScrollView) {
        _mainScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, self.imgvGoodPicture.frame.size.height)];
        _mainScrollView.pagingEnabled=YES;
        _mainScrollView.contentSize=CGSizeMake(kScreenWidth, self.imgvGoodPicture.frame.size.height);
        _mainScrollView.backgroundColor=[UIColor whiteColor];
        _mainScrollView.showsVerticalScrollIndicator=NO;
        _mainScrollView.delegate=self.ower;
    }
    return _mainScrollView;
}

-(UIView * )vBottomBackground
{
    if (!_vBottomBackground) {
        _vBottomBackground =[[UIView alloc]initWithFrame:CGRectMake(0, self.imgvGoodPicture.frame.origin.y+self.imgvGoodPicture.frame.size.height, 320, 60)];
        
    }
    return _vBottomBackground;
}
@end
