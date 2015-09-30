//
//  CellUserInfo.h
//  HSConsumer
//
//  Created by apple on 14-10-17.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"

@interface CellUserInfo : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *btnUserPicture;//头像
@property (strong, nonatomic) IBOutlet UIButton *btnRealName;   //实名认证按钮
@property (strong, nonatomic) IBOutlet UIButton *btnPhoneYes;   //实名手机绑定按钮
@property (strong, nonatomic) IBOutlet UIButton *btnEmailYes;   //实名绑定邮箱按钮
@property (strong, nonatomic) IBOutlet UIButton *btnBankYes;    //实名银行账户绑定按钮

@property (strong, nonatomic) IBOutlet UILabel *lbLabelCardNo;  //积分卡信息
@property (strong, nonatomic) IBOutlet UILabel *lbLabelHello;   //问候语
@property (strong, nonatomic) IBOutlet UILabel *lbLastLoginInfo;//登录信息
@property (strong, nonatomic) IBOutlet RTLabel *vTipToInputInfo;//没有完善信息，提示

@end
