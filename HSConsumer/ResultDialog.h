//
//  ResultDialog.h
//  HSConsumer
//
//  Created by apple on 14-10-27.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputCellStypeView.h"

@interface ResultDialog : UIView

@property (nonatomic, strong) IBOutlet UILabel *lbTitle;//结果提示
@property (nonatomic, strong) IBOutlet UIImageView *ivTitle;//提示图标

- (void)showWithTitle:(NSString *)title isSucceed:(BOOL)s;

@end
