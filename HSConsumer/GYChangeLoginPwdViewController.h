//
//  GYChangeLoginPwdViewController.h
//  HSConsumer
//
//  Created by apple on 14-10-16.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYChangeLoginPwdViewController : UIViewController<UITextFieldDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITextField *OldPassword;//旧密码
@property (weak, nonatomic) IBOutlet UITextField *NewPassword;//新密码
@property (weak, nonatomic) IBOutlet UITextField *NewPasswordAgain;//再次输入新密码
@property (weak, nonatomic) IBOutlet UILabel *WaringLabel;//旧密码label
@property (weak, nonatomic) IBOutlet UIButton *BtnnextStep;//下一步btn
@property (nonatomic,assign)BOOL isCardUser;
@property (nonatomic,assign)BOOL fromWhere;


- (IBAction)btnNextStep:(id)sender;

@end
