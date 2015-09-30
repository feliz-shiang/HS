//
//  GYHealthUploadImgModel.m
//  HSConsumer
//
//  Created by Apple03 on 15/7/24.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYHealthUploadImgModel.h"

@implementation GYHealthUploadImgModel

#define KCellborder 30

-(void)setStrTitle:(NSString *)strTitle
{
    _strTitle =strTitle;
    CGFloat picFrameX = KCellborder;
    CGFloat picFrameY = 0;
    CGFloat picFrameW = (kScreenWidth - KCellborder*4-5)/2;
    CGFloat picFrameH = picFrameW*0.67;
    
    self.picFrame = CGRectMake(picFrameX, picFrameY, picFrameW, picFrameH);
    
    CGFloat needFrameX = picFrameX;
    CGFloat needFrameY = CGRectGetMaxY(self.picFrame)+5;
    CGFloat needFrameW = 5;
    CGFloat needFrameH = 20;
    self.needFrame = CGRectMake(needFrameX, needFrameY, needFrameW, needFrameH);
    
    CGFloat titleFrameX = picFrameX;
    if (_isNeed)
    {
        titleFrameX = CGRectGetMaxX(self.needFrame);
    }
    CGFloat titleFrameY = needFrameY;
    CGSize titleSize = [Utils sizeForString:strTitle font:KtitleFont width:CGRectGetMaxX(self.picFrame)-titleFrameX];
    CGFloat titleFrameW = titleSize.width;
    CGFloat titleFrameH = titleSize.height;
    self.titleFrame = CGRectMake(titleFrameX, titleFrameY, titleFrameW, titleFrameH);
    if (_isNeed && titleSize.width<picFrameW-needFrameW)
    {
        needFrameX = picFrameX + picFrameW*0.5 - (needFrameW + titleFrameW)*0.5;
        self.needFrame = CGRectMake(needFrameX, needFrameY, needFrameW, needFrameH);
        titleFrameX =needFrameX+needFrameW;
        self.titleFrame = CGRectMake(titleFrameX, titleFrameY, titleFrameW, titleFrameH);
    }
    
    CGFloat showTempFrameY = CGRectGetMaxY(self.titleFrame)+2;
    CGFloat showTempFrameW = picFrameW*0.5;
    CGFloat showTempFrameH = 15;
    CGFloat showTempFrameX = picFrameX + picFrameW*0.5 - showTempFrameW*0.5;
    self.showTempFrame = CGRectMake(showTempFrameX, showTempFrameY, showTempFrameW, showTempFrameH);
    if (!self.isShow)// 不显示事例图片
    {
        self.showTempFrame = CGRectZero;
        self.mainFrame = CGRectMake(0, 0, picFrameW, CGRectGetMaxY(self.titleFrame)+20);
    }
    else
    {
        self.mainFrame = CGRectMake(0, 0, picFrameW, CGRectGetMaxY(self.showTempFrame)+20);
    }
    
}
@end
