//
//  InputCellStypeView.h
//  HSConsumer
//
//  Created by apple on 14-10-23.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

//公共组件，左边是栏位名，右边输入，如： 输入姓名  xxxxxx

#import <UIKit/UIKit.h>

@interface InputCellStypeView : UIView
@property (strong, nonatomic) IBOutlet UILabel *lbLeftlabel;
@property (strong, nonatomic) IBOutlet UITextField *tfRightTextField;

@end
