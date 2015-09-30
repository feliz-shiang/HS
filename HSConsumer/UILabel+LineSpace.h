//
//  UILabel+LineSpace.h
//  HSConsumer
//
//  Created by apple on 14-11-10.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (LineSpace)
//设置行间距的方法
-(void)setLineSpace : (CGFloat)spaceCout WithLabel :(UILabel *) label  WithText:(NSString *)text;
@end
