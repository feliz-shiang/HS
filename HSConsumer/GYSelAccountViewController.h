//
//  GYSelAccountViewController.h
//  HSConsumer
//
//  Created by 00 on 14-11-5.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYSelAccDelegate <NSObject>

-(void)returnAccNum:(NSString *)AccNum;

@end


@interface GYSelAccountViewController : UIViewController


@property (nonatomic , assign) id <GYSelAccDelegate> delegate;


@end
