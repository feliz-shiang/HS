//
//  GYBuildMsgView.h
//  HSConsumer
//
//  Created by 00 on 15-1-30.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GYBuildMsgView : NSObject
//计算文本高度，转换表情字符串为图片

-(UIView *)assembleMessageAtIndex : (NSString *) message;

-(void)getImageRange:(NSString*)message : (NSMutableArray*)array;

@end
