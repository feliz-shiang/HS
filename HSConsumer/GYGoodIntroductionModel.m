//
//  GYGoodIntroductionModel.m
//  HSConsumer
//
//  Created by Apple03 on 15-5-18.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import "GYGoodIntroductionModel.h"

@implementation GYGoodIntroductionModel
-(void)setStrData:(NSString *)strData
{
    _strData = [strData copy];
    if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0) {
        self.fHight = [Utils heightForString:strData fontSize:15.0 andWidth:kScreenWidth];
    }
    else
    {
              CGSize size = [strData boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kDetailFont} context:nil].size;
        self.fHight =  size.height+20;
    }
}
@end
