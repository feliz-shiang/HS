//
//  GYCertificationTypeViewController.h
//  HSConsumer
//
//  Created by apple on 15-2-9.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  GYCertificationType ;
@protocol GYSenderTestDataDelegate <NSObject>

-(void)sendSelectDataWithMod :(GYCertificationType *)model;

@end

@interface GYCertificationTypeViewController : UIViewController
@property (nonatomic,weak) id<GYSenderTestDataDelegate> delegate;
@property (nonatomic,strong) NSMutableArray * marrDataSoure;
@end
