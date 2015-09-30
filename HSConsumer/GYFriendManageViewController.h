//
//  GYRootViewController.h
//  searchBar
//
//  Created by apple on 14-12-30.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYPopView.h"
@interface GYFriendManageViewController : UIViewController
{

    NSMutableArray *dataArray;
    NSMutableArray *searchResults;
    UISearchBar *mySearchBar;
    UISearchDisplayController *searchDisplayController;

}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableDictionary * filterDictionary;
@property (nonatomic,strong) NSMutableDictionary * nameDictionary;

@property (nonatomic,strong) NSMutableArray * marrDatasource;

@end
