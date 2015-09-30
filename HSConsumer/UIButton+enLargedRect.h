//
//  UIButton+enLargedRect.h
//  Srollview
//
//  Created by apple on 14-11-10.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (enLargedRect)

//扩大button的点击范围
-(void)setEnlargEdgeWithTop : (CGFloat )top right :(CGFloat)right bottom :(CGFloat )bottom left :(CGFloat)left;

//add by liangzm 添加边框
- (void)setBorderWithWidth:(CGFloat)width andRadius:(CGFloat)radius andColor:(UIColor *)color;

@end
