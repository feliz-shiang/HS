//
//  ViewHeaderForMyOrder.h
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewHeaderForMyOrder : UIView
@property (strong, nonatomic) IBOutlet UILabel *lbState;
@property (strong, nonatomic) IBOutlet UILabel *lbOrderNo;
@property (strong, nonatomic) IBOutlet UIButton *btnTrash;
@property (strong, nonatomic) IBOutlet UIView *viewLine;

@property (strong, nonatomic) IBOutlet UIButton *btnShopName;//商铺名称
@property (strong, nonatomic) IBOutlet UIButton *btnShopName2;//箭头

+ (CGFloat)getHeight;

@end
