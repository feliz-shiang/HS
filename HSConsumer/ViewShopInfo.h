//
//  ViewShopInfo.h
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewShopInfo : UIView

@property (weak, nonatomic) IBOutlet UIView *vLine;
//@property (strong, nonatomic) IBOutlet UILabel *lbShopName;
@property (weak, nonatomic) IBOutlet UILabel *lbShopAddress;

@property (weak, nonatomic) IBOutlet UIButton *btnShopTel;

+ (CGFloat)getHeight;
@end
