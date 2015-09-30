//
//  AppVersionInfoView.h
//  HSConsumer
//
//  Created by apple on 14-12-25.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppVersionInfoView : UIView
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIView *vBackground;

- (void)showInView:(UIView *)view;

@end
