//
//  GYLoginController.h
//  SelfActionSheetTest
//
//  Created by Apple03 on 15/8/3.
//  Copyright (c) 2015年 Apple03. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GYLoginControllerDelegate <NSObject>

@optional
- (void)loginDidSuccess:(NSDictionary *)response sender:(id)sender;
@end
@interface GYLoginController : UIView
@property (assign, nonatomic) id<GYLoginControllerDelegate> delegate;
@property (assign, nonatomic) BOOL isStay;
@property (strong,nonatomic)UIViewController * vc;
@property (assign,nonatomic) BOOL  ischang;//////修改密码

- (void)closeAndRemoveSelf:(UITapGestureRecognizer *)tap;
- (void)showInView:(UIView *)view;
@end
