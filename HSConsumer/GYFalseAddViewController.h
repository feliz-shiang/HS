//
//  GYFalseAddViewController.h
//  HSConsumer
//
//  Created by 00 on 14-11-6.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYAddressModel.h"
@protocol GYFalseAddDelegate <NSObject>

-(void)returnAdd:(GYAddressModel *)model;

@end


@interface GYFalseAddViewController : UIViewController

@property (assign , nonatomic) id <GYFalseAddDelegate> delegate;



@end
