
//
//  GYPhoneScr.m
//  Animation
//
//  Created by mac on 14-11-19.
//  Copyright (c) 2014年 whf. All rights reserved.
//

#import "GYPhoneScr.h"
#import "UIImageView+WebCache.h"
#import "GYGoodsDetailController.h"

@implementation GYPhoneScr
{
    UILabel * titleLabel;
    UIScrollView * scrollview;

}

- (id)initWithFrame:(CGRect)frame WithOwer:(id )ower
{

    self =[super initWithFrame:frame];
    if (self) {
        
        self.owner=ower;
        scrollview  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        scrollview.pagingEnabled=YES;
        scrollview.bounces=NO;
        scrollview.delegate=self;
        scrollview.backgroundColor=[UIColor whiteColor];
        scrollview.showsHorizontalScrollIndicator=YES;
         scrollview.showsVerticalScrollIndicator=NO;
        scrollview.minimumZoomScale=1.0;
        scrollview.maximumZoomScale=2.0;
        [self addSubview:scrollview];
        
        self.marrImgvStore=[NSMutableArray array];
        titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 40, 60, 34)];
        titleLabel.textColor=[UIColor grayColor];
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.layer.cornerRadius=3;
        [self addSubview:titleLabel];

        UITapGestureRecognizer * tap2 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reset:)];
        [self addGestureRecognizer:tap2];
        if ([self.owner isKindOfClass:[GYGoodsDetailController class]]) {
            GYGoodsDetailController * goodsVc =(GYGoodsDetailController *)self.owner;
            goodsVc.vButton.hidden=YES;
        }
        [UIView animateWithDuration:0.25 animations:^{
            self.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        }];
    }
    return self;
}


//获取到数组里面的uiimage 就根据 数据的个数 创建uiimageview 并且添加到滚动试图里面
-(void)setImgArr:(NSMutableArray *)imgArr
{
    if (_imgArr!=imgArr) {
        _imgArr=nil;
        _imgArr=imgArr;
        if (_imgArr.count!=0) {
            scrollview.contentSize=CGSizeMake(kScreenWidth*imgArr.count, kScreenHeight);
            for (int i=0; i<imgArr.count; i++) {
                UIImageView * imgView =[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth*i, 64, kScreenWidth, 480)];
                [imgView setBackgroundColor:[UIColor clearColor]];
                imgView.contentMode=UIViewContentModeScaleAspectFit;
               [imgView sd_setImageWithURL:_imgArr[i] placeholderImage:[UIImage imageNamed:@"ep_placeholder_image_type1"]];
                _imgvDisplayZoom=imgView;
                [self.marrImgvStore addObject:imgView];
                [scrollview addSubview:imgView];
            }
//            self.imgvDisplayZoom =[[UIImageView alloc]init];
//            self.imgvDisplayZoom.frame=CGRectMake(0, 64, kScreenWidth, 480);
//            self.imgvDisplayZoom.contentMode=UIViewContentModeScaleAspectFit;
//            [self.imgvDisplayZoom sd_setImageWithURL:_imgArr[0] placeholderImage:[UIImage imageNamed:@"ep_placeholder_image_type1"]];
//            
//              [self addSubview:self.imgvDisplayZoom];
            
        }
    }
    
    
}


#pragma mark--UIScrollViewDelegate 先进入代理方法获取到_curpage
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _curPage=scrollView.contentOffset.x/kScreenWidth+1;
    titleLabel.text=[NSString stringWithFormat:@"%d/%d",(int)_curPage,_imgArr.count];
//    [_imgvDisplayZoom sd_setImageWithURL:_imgArr[_curPage-1] placeholderImage:[UIImage imageNamed:@"ep_placeholder_image_type1"]];
}

//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
//{
//    _curPage=scrollView.contentOffset.x/kScreenWidth+1;
//       UIImageView * imgvTempForZoom = _marrImgvStore[_curPage-1];
//    scrollview.contentSize=CGSizeMake(imgvTempForZoom.frame.size.width*_imgArr.count, kScreenHeight);
//
//    return _imgvDisplayZoom;
//}


//根据_curPage 来计算title现实的内容
-(void)setCurPage:(NSInteger)curPage
{
    _curPage=curPage;
    titleLabel.text =[NSString stringWithFormat:@"%d/%d",(int)_curPage,_imgArr.count];
    
    //此方法是滚动到可视范围的方法，用于计算当()前的_curPage
    [scrollview scrollRectToVisible:CGRectMake(kScreenWidth*(_curPage-1), 0, kScreenWidth, kScreenHeight) animated:YES];
    
    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so you need to re-center the contents
//    [self centerScrollViewContents];
}

-(void)centerScrollViewContents
{
    scrollview.zoomScale=1.0;

}

-(void)reset:(UITapGestureRecognizer *)tap
{

    if ([self.owner isKindOfClass:[GYGoodsDetailController class]]) {
        GYGoodsDetailController * goodsVc =(GYGoodsDetailController *)self.owner;
       goodsVc.vButton.hidden=NO;
    }

   [UIView animateWithDuration:0.24 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
       tap.view.alpha=0;
    } completion:^(BOOL finished) {
      if (finished) {
          if (_imgArr.count>0) {
              [_imgArr removeAllObjects];
          }
            [tap.view removeFromSuperview];
      }
   }];
    
    
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [scrollView setZoomScale:scale animated:NO];
}

@end
