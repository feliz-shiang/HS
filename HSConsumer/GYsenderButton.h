//
//  GYsenderButton.h
//  HSConsumer
//
//  Created by apple on 14-10-28.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  "GYAddressModel.h"
@protocol GYsenderButton <NSObject>
-(void)senderBtn:(id)sender WithCellModel : (GYAddressModel *)mod;
@end
