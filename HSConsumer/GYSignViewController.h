//
//  GYSignViewController.h
//  HSConsumer
//
//  Created by apple on 15-2-10.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//


@protocol sendSignText <NSObject>

-(void)sendSignTextString:(NSString *)sign;

@end
#import <UIKit/UIKit.h>

@interface GYSignViewController : UIViewController<UITextViewDelegate>


@property (nonatomic,copy)NSString * strText;
@property (nonatomic,weak)id <sendSignText> delegate;
@property (nonatomic,copy) NSString * strSign;
@property (nonatomic,assign)int useType;
@end
