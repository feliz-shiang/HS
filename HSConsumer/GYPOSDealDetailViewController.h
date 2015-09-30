//
//  GYPOSDealDetailViewController.h
//  company
//
//  Created by 00 on 14-11-25.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYCartModel.h"
#import "InputCellStypeView.h"

@interface GYPOSDealDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet InputCellStypeView *vInputPWD;

@property (nonatomic , assign) GYCartModel * model;

@property (nonatomic , assign) BOOL hid;

@end
