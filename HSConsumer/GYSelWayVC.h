//
//  GYSelWayViewController.h
//  HSConsumer
//
//  Created by 00 on 14-12-19.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYExpress ;
@protocol GYSelWayDelegate <NSObject>




-(void)returnTitle:(GYExpress *)model WithIndexPath:(NSIndexPath *)indexPath WithRetIndex:(NSInteger)index WithFee :(NSString *)fee;

@end


@interface GYSelWayVC : UIViewController

//
@property (strong ,nonatomic) NSMutableArray *marrDataSource;

@property (assign ,nonatomic) id<GYSelWayDelegate> delegate;

@property (strong , nonatomic) NSIndexPath *indexPath;

@property (nonatomic,copy)NSDictionary * dictShopInfo;
@end
