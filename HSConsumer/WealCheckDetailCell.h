//
//  WealCheckDetailCell.h
//  HSConsumer
//
//  Created by 00 on 15-3-16.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WealCheckDetailCell : UITableViewCell


@property (strong , nonatomic) UINavigationController *nc;

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

@property (weak, nonatomic) IBOutlet UILabel *lbContent;

@property (copy , nonatomic)  NSString *imgUrl;


@property (weak, nonatomic) IBOutlet UIButton *btn;

- (IBAction)btnClick:(id)sender;



@end
