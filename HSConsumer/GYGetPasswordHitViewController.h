//
//  GYGetPasswordHitViewController.h
//  HSConsumer
//
//  Created by apple on 15-3-24.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "GYQuestionModel.h"
@protocol selectQuestionForNoLoginDelegate <NSObject>

-(void)selectedOneQuestion:(GYQuestionModel *)Model;

@end


@interface GYGetPasswordHitViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSMutableArray * marrQuestion;
@property (nonatomic,weak)id <selectQuestionForNoLoginDelegate>delegate;
@end
