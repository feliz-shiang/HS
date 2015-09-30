//
//  GYViewControllerDelegate.h
//  HSConsumer
//
//  Created by apple on 14-10-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

// 弹出一个视图的协议

#import <Foundation/Foundation.h>

@protocol GYViewControllerDelegate <NSObject>

@optional
- (void)pushVC:(id)sender animated:(BOOL)ani;
@end
