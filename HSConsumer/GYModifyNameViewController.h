//
//  GYModifyNameViewController.h
//  HSConsumer
//
//  Created by apple on 15-1-23.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//
@protocol getTextDelegate <NSObject>

-(void)getInputedText:(NSString *)text WithIndexPath:(NSIndexPath *)path;

@end

#import <UIKit/UIKit.h>

@interface GYModifyNameViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic,weak)id <getTextDelegate>delegate;
@property (nonatomic,copy)NSString * strText;

@property (nonatomic,copy)NSString * strPlaceHolder;
@property (nonatomic,copy)NSIndexPath * indexPath;
@end
