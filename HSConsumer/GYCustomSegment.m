//
//  GYCustomSegment.m
//  HSConsumer
//
//  Created by apple on 14-11-4.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYCustomSegment.h"

@implementation GYCustomSegment


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _btnFirst =[UIButton buttonWithType:UIButtonTypeCustom];
        [ _btnFirst setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
        [_btnFirst setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_btnFirst setBackgroundImage:[UIImage imageNamed:@"img_getback_left.png"] forState:UIControlStateSelected];
        _btnFirst.backgroundColor=[UIColor clearColor];
        _btnSecond =[UIButton buttonWithType:UIButtonTypeCustom];
        [_btnSecond setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_btnSecond  setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
        [_btnSecond  setBackgroundImage:[UIImage imageNamed:@"img_getback_middle.png"] forState:UIControlStateSelected];
        
        _btnSecond.backgroundColor=[UIColor clearColor];
        _btnThird =[UIButton buttonWithType:UIButtonTypeCustom];
        [_btnThird setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_btnThird setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
        [_btnThird  setBackgroundImage:[UIImage imageNamed:@"img_getback_right.png"] forState:UIControlStateSelected];
        _btnThird.backgroundColor=[UIColor clearColor];
        self.userInteractionEnabled=YES;
        [self addSubview:_btnFirst];
        [self addSubview:_btnSecond];
        [self addSubview:_btnThird];
    }
    return self;
}
-(void)setItemTitleWith:(NSArray *)title
{
    
    
    
    if (title.count) {
        [_btnFirst setTitle:title[0] forState:UIControlStateNormal];
        [_btnSecond setTitle:title[1] forState:UIControlStateNormal];
        [_btnThird setTitle:title[2] forState:UIControlStateNormal];
        CGFloat width=kScreenWidth-20;
        CGFloat eachWidth=width/3;
        _btnFirst.frame=CGRectMake(10, 15, eachWidth, 30);
        
        _btnSecond.frame=CGRectMake(_btnFirst.frame.origin.x+_btnFirst.frame.size.width-1, 15, eachWidth, 30);
        _btnThird.frame=CGRectMake(_btnSecond.frame.origin.x+_btnSecond.frame.size.width-1, 15, eachWidth, 30);
        UIView * vLineTop =[[UIView alloc]initWithFrame:CGRectMake(10+2, 15, width-8, 1)];
        vLineTop.backgroundColor=kNavigationBarColor;
        [Utils setBorderWithView:_btnFirst WithWidth:1 WithRadius:3 WithColor:kNavigationBarColor];
        [Utils setBorderWithView:_btnSecond  WithWidth:1 WithRadius:0 WithColor:kNavigationBarColor];
        [Utils setBorderWithView:_btnThird WithWidth:1 WithRadius:3 WithColor:kNavigationBarColor];
        UIView * vLineBottom =[[UIView alloc]initWithFrame:CGRectMake(_btnFirst.frame.origin.x +2 , _btnThird.frame.origin.y+_btnThird.frame.size.height-1   , width-8, 1)];
        vLineBottom.backgroundColor=kNavigationBarColor;
        [self addSubview:vLineTop];
        [self addSubview:vLineBottom];
        
    }
    
    
}
-(void)setItemTitleWith:(NSArray *)title WithIndex :(int)index
{
    
    [_btnThird removeFromSuperview];
    [_btnFirst setTitle:title[0] forState:UIControlStateNormal];
    [_btnSecond setTitle:title[1] forState:UIControlStateNormal];
    CGFloat width=kScreenWidth-30;
    CGFloat eachWidth=width/2;
    _btnFirst.frame=CGRectMake(15, 16, eachWidth, 30);
    
    _btnSecond.frame=CGRectMake(_btnFirst.frame.origin.x+_btnFirst.frame.size.width-1, _btnFirst.frame.origin.y, eachWidth, 30);
    //需要把第二个BTN的背景图片重新设置下。
    [_btnSecond  setBackgroundImage:[UIImage imageNamed:@"img_getback_right.png"] forState:UIControlStateSelected];
    [Utils setBorderWithView:_btnFirst WithWidth:1 WithRadius:3 WithColor:kNavigationBarColor];
    [Utils setBorderWithView:_btnSecond  WithWidth:1 WithRadius:3 WithColor:kNavigationBarColor];
    
    UIView * vLineTop =[[UIView alloc]initWithFrame:CGRectMake(18, 16, width-8, 1)];
    vLineTop.backgroundColor=kNavigationBarColor;
    UIView * vLineBottom =[[UIView alloc]initWithFrame:CGRectMake(_btnFirst.frame.origin.x +2 , _btnThird.frame.origin.y+_btnThird.frame.size.height-1   , width-8, 1)];
    vLineBottom.backgroundColor=kNavigationBarColor;
    [self addSubview:vLineTop];
    [self addSubview:vLineBottom];
}

@end
