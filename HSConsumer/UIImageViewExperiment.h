//
//  UIImageViewExperiment.h
//  Experiment
//
//  Created by liangzm on 15-3-6.
//
//

#import <UIKit/UIKit.h>

#if 0
#warning 使用方法

UIImageViewExperiment *view0 = [[UIImageViewExperiment alloc] initWithFrame:CGRectMake(0, 0, 200 ,200)];
view0.image = [UIImage imageNamed:@"test6.jpg"];
[view0 setBackgroundColor:[UIColor clearColor]];
[self.view addSubview:view0];
[view0 setBreckImage];

#endif

@interface UIImageViewExperiment : UIImageView

- (void)setBreckImage;

@end
