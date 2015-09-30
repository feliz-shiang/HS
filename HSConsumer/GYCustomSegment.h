//
//  GYCustomSegment.h
//  HSConsumer
//
//  Created by apple on 14-11-4.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface GYCustomSegment : UIView

@property (nonatomic,weak)id buttonDelegate;
@property (nonatomic,strong)UIButton *btnFirst;
@property (nonatomic,strong)UIButton *btnSecond;
@property (nonatomic,strong)UIButton *btnThird;
-(void)setItemTitleWith:(NSArray *)title ;
-(void)setItemTitleWith:(NSArray *)title WithIndex :(int)index;
@end
