//
//  GYLoginView.h
//  HSConsumer
//
//  Created by apple on 14-12-25.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputCellStypeView.h"

@protocol GYLoginViewDelegate <NSObject>

@optional
- (void)loginDidSuccess:(NSDictionary *)response sender:(id)sender;
@end

@interface GYLoginView : UIView
@property (weak, nonatomic) IBOutlet InputCellStypeView *InputUserNameRow;
@property (weak, nonatomic) IBOutlet UIImageView *imgvUserNameFront;
@property (weak, nonatomic) IBOutlet UIImageView *imgvPasswordFront;
@property (weak, nonatomic) IBOutlet InputCellStypeView *InputPasswordRow;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnForgetPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnLoginNow;
@property (weak, nonatomic) IBOutlet UIButton *btnGuestLogin;
@property (weak, nonatomic) IBOutlet UIView *vBackground;
@property (assign, nonatomic) id<GYLoginViewDelegate> delegate;
@property (assign, nonatomic) BOOL isStay;

- (void)closeAndRemoveSelf:(UITapGestureRecognizer *)tap;
- (void)showInView:(UIView *)view;
@end
