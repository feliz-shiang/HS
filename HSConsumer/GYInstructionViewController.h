//
//  GYInstructionViewController.h
//  HSConsumer
//
//  Created by 00 on 14-10-20.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYInstructionViewController : UIViewController


@property (weak , nonatomic) NSString * strTitle;//说明标题
@property (weak , nonatomic) NSString * strContent;//说明内容
@property (weak, nonatomic) IBOutlet UITextView *tvInstruction;//文本框


@end
