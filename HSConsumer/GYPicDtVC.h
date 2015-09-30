//
//  GYPicDtVC.h
//  HSConsumer
//
//  Created by 00 on 15-3-19.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYGoodsDetailModel.h"


@interface GYPicDtVC : UIViewController

@property (strong , nonatomic) GYGoodsDetailModel *model;
@property (strong , nonatomic) IBOutlet UIWebView *wv;
@end
