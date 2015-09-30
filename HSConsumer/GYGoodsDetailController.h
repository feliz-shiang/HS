//
//  GYGoodsDetailController.h
//  HSConsumer
//
//  Created by 00 on 14-12-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  "GYEasyBuyModel.h"



@interface GYGoodsDetailController : UIViewController<UIScrollViewDelegate>

@property (nonatomic,strong)GYEasyBuyModel * model;
@property (nonatomic,strong)UIPageControl * pageControl;
@property (nonatomic,strong)UIScrollView * mainScrollView;
@property (weak,nonatomic)IBOutlet UITableView *tbvSel;
@property (weak, nonatomic) IBOutlet UIView *vButton;


@end
