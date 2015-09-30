//
//  ViewCellStyle.h
//  HSConsumer
//
//  Created by apple on 14-10-23.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

//各账户下功能共公的view

#import <UIKit/UIKit.h>

@interface ViewCellStyle : UIControl

@property (strong, nonatomic) IBOutlet UIImageView *ivTitle;    //cell的图标
@property (strong, nonatomic) IBOutlet UILabel *lbActionName;   //功能名称
@property (strong, nonatomic) NSString *nextVcName;   //下一个VC

@end
