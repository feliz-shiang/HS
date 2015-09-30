//
//  TestViewController.h
//  company
//
//  Created by apple on 14-10-10.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

//用于个人临时的技术研究，不包含于框架内

#import <UIKit/UIKit.h>
#import "GlobalData.h"


@interface TestViewController : UIViewController
{
    IBOutlet UIButton *btnLogin;
    IBOutlet UILabel *lbShowTip;
    
}
- (void)openHomeVC;
@end
