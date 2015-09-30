//
//  GYDatePiker.m
//  Buding
//
//  Created by 00 on 14-11-3.
//  Copyright (c) 2014年 00. All rights reserved.
//

#import "GYDatePiker.h"

@implementation GYDatePiker

{


    UIDatePicker *globelDp;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGSize screenSize = UIScreen.mainScreen.bounds.size;
        self.frame = CGRectMake(0, -350, screenSize.width, screenSize.height + 350);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDatePiker)];
        [self addGestureRecognizer:tap];
    
        UIDatePicker *dp = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, screenSize.width+230, 320, 100)];
        dp.alpha = 1.0;
        dp.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0f];
        dp.timeZone = [NSTimeZone timeZoneWithName:@"GTM+8"];
        dp.minimumDate = [NSDate dateWithTimeIntervalSinceNow:5 * 365 * 24 * 60 * 60 * -1]; // 设置最小时间
        dp.maximumDate = [NSDate dateWithTimeIntervalSinceNow:0]; // 设置最大时间
        dp.datePickerMode = UIDatePickerModeDate;
        [dp setDate:[NSDate dateWithTimeIntervalSinceNow:48 * 20 * 18] animated:YES];
        [dp addTarget:self action:@selector(DatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:dp];
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
        if (_delegate &&[_delegate respondsToSelector:@selector(getDate:WithDate:)]) {
            [self.delegate getDate:self.strDate WithDate:nil];
        }
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame WithType:(int)useType
{
    self = [super initWithFrame:frame];
    if (self) {
        CGSize screenSize = UIScreen.mainScreen.bounds.size;
        self.frame = CGRectMake(0, -350, screenSize.width, screenSize.height + 350);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDatePiker)];
        [self addGestureRecognizer:tap];
        
        UIDatePicker *dp = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, screenSize.width+230, 320, 100)];
        dp.alpha = 1.0;
        dp.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0f];
        dp.timeZone = [NSTimeZone timeZoneWithName:@"GTM+8"];
//        dp.minimumDate = [NSDate dateWithTimeIntervalSinceNow:5 * 365 * 24 * 60 * 60 * -1]; // 设置最小时间
        dp.maximumDate = [NSDate dateWithTimeIntervalSinceNow:0]; // 设置最大时间
        dp.datePickerMode = UIDatePickerModeDate;
        [dp setDate:[NSDate dateWithTimeIntervalSinceNow:48 * 20 * 18] animated:YES];
        [dp addTarget:self action:@selector(DatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        globelDp=dp;
        [self addSubview:dp];
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
       
        if (_delegate &&[_delegate respondsToSelector:@selector(getDate:WithDate:)]) {
                  [self.delegate getDate:self.strDate WithDate:nil];
        }

    }
    return self;
}

- (void)noMaxTime
{
    globelDp.maximumDate=nil;


}
-(void)DatePickerValueChanged:(UIDatePicker *)sender
{
    NSDate *select = [sender date]; // 获取被选中的时间
    NSLog(@"%@------select",select);
    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
    selectDateFormatter.dateFormat = @"yyyy-MM-dd"; // 设置时间和日期的格式yyyy-MM-dd HH:mm:ss  yyyy-MM-dd
    NSString *date = [selectDateFormatter stringFromDate:select]; // 把date类型转为设置好格式的string类型
      NSLog(@"%@------date",date);
    self.strDate = date;
    if (_delegate &&[_delegate respondsToSelector:@selector(getDate:WithDate:)]) {
           [self.delegate getDate:self.strDate WithDate:select];
    }
 
}

-(void)dismissDatePiker
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    //动画
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.frame =  CGRectMake(self.frame.origin.x, self.frame.origin.y+350, self.frame.size.width, self.frame.size.height);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

}

@end
