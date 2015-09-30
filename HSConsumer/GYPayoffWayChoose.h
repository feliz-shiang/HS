//
//  ResultDialogRows7.h
//  HSConsumer
//
//  Created by apple on 14-10-27.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputCellStypeView.h"

@interface GYPayoffWayChoose : UIView

@property (weak, nonatomic) IBOutlet UIButton *btnChangePayoffWay;
@property (weak, nonatomic) IBOutlet UIButton *btnPayoffIcon;



//每一行
@property (nonatomic, strong) IBOutlet InputCellStypeView *viewResultRow2;


@end
