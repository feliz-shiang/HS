//
//  ViewTransferResultDialog.h
//  HSConsumer
//
//  Created by apple on 14-10-27.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputCellStypeView.h"

@interface ViewTransferResultDialog : UIView


@property (nonatomic, strong) IBOutlet UILabel *lbTitle;//结果提示
@property (nonatomic, strong) IBOutlet UIImageView *viTitle;//提示图标

//每一行
@property (strong, nonatomic) IBOutlet UITextView *tvRow0;
@property (strong, nonatomic) IBOutlet UITextView *tvRow1;

@end
