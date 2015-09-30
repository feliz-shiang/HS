//
//  GYMyInfoTableViewCell.h
//  HSConsumer
//
//  Created by apple on 14-10-16.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYMyInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *vAccessoryView;

-(void)refreshWithImg :(NSString *) imgName WithTitle :(NSString *)title;
@end
