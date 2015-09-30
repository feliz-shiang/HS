//
//  CellViewGoodsType.h
//  HSConsumer
//
//  Created by apple on 14-11-27.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#define kCellViewGoodsTypeIdentifier @"CellViewGoodsTypeIdentifier"

#import <UIKit/UIKit.h>
#import "ViewGoodsType.h"

@interface CellViewGoodsType : UITableViewCell
@property (strong, nonatomic) IBOutlet ViewGoodsType *viewGoodsType0;
@property (strong, nonatomic) IBOutlet ViewGoodsType *viewGoodsType1;
@end
