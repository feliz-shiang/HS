//
//  EasyPurchaseHead.h
//  HSConsumer
//
//  Created by apple on 14-11-25.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EasyPurchaseHead : UIView
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;


#warning 修改引用类型 strong ->weak
@property (weak, nonatomic) IBOutlet UIButton *btnCart;

@property (weak, nonatomic) IBOutlet UIButton *btnMyHushang;

@end
