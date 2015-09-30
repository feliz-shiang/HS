//
//  GYConfirmTransferInfoViewController.h
//  HSConsumer
//
//  Created by apple on 14-10-30.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InputCellStypeView;
@interface GYConfirmTransferInfoViewController : UIViewController

@property (nonatomic, assign) double inputValue;//传过来的值
//@property (nonatomic, assign) double actualAccAmount;//到账金额
@property (nonatomic, strong) NSMutableArray *arrStrings;
@property (nonatomic, strong) NSString *bankID;

@end
