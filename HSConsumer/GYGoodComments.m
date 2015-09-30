//
//  GYGoodComments.m
//  HSConsumer
//
//  Created by apple on 14-12-2.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYGoodComments.h"

@implementation GYGoodComments
// by songjk 计算内容高度
-(void)setStrComments:(NSString *)strComments
{
    _strComments = strComments;
    // 计算内容高度
    CGFloat width = kScreenWidth - 13*2;
    CGSize contentSize = [Utils sizeForString:strComments font:[UIFont systemFontOfSize:17] width:width];
    _contentHeight = contentSize.height;
}
@end
