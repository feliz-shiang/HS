//
//  GYAddressCountryViewController.h
//  HSConsumer
//
//  Created by apple on 15-1-29.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    noLocationfunction=1,
    locationFunction,
    
    
    
}kAddressType;
typedef NSComparisonResult (^NSComparator)(id obj1, id obj2);
@interface GYAddressCountryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSMutableArray * marrSourceData;
@property (nonatomic,copy)NSString * strSelectedArea;
@property (nonatomic,assign)kAddressType addressType;
@property (nonatomic,assign)int fromBandingCard;
@end
