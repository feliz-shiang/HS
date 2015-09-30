//
//  GYAddFriendViewController.h
//  HSConsumer
//
//  Created by apple on 14-12-30.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYAddFriendViewController : UIViewController
{
    UISearchBar *mySearchBar;
    UISearchDisplayController *searchDisplayController;

}
-(void)refresdData;
@property (nonatomic,strong)NSMutableArray * marrDatasource;
@end
