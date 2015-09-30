//
//  GYCompanyManageViewController.h
//  company
//
//  Created by apple on 14-11-13.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
//用户个人信息的model
#import "UserData.h"
@interface GYCardInfoBandViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tvCardBand;
@property (nonatomic,strong) UserData * model;
@end
