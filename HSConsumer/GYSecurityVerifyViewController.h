//
//  GYSecurityVerifyViewController.h
//  HSConsumer
//
//  Created by apple on 14-10-17.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYSecurityVerifyViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lbMessage;//顶部提示信息
@property (strong, nonatomic) IBOutlet UIButton *btnGetCode;//获取验证码btn
- (IBAction)getCodeMethod:(id)sender;
//@property (weak, nonatomic) IBOutlet UITextField * tvInputCode;//验证码输入框
@property (weak, nonatomic) IBOutlet UIButton *btnNextStep;//下一步btn
- (IBAction)btnToNextPage:(id)sender;

@end
