//
//  GYupdateNicknameViewController.h
//  HSConsumer
//
//  Created by apple on 15/6/18.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//
@protocol getRemarkDelegate <NSObject>

-(void)getUserRemark:(NSString * )strRemark;

@end
#import <UIKit/UIKit.h>


@interface GYupdateNicknameViewController : UIViewController
@property (nonatomic,weak)id <getRemarkDelegate>delegate;
@property (nonatomic,copy)NSString * friendId;
@end
