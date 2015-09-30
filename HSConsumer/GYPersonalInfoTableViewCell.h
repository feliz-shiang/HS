//
//  GYPersonalInfoTableViewCell.h
//  HSConsumer
//
//  Created by apple on 14-12-18.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputCellStypeView.h"

@protocol GYPersonalInfoTableViewCellDelegate <NSObject>

@optional
- (void)didEndEditing:(NSInteger)section inRow:(NSInteger)row object:(id)sender;

@end

@interface GYPersonalInfoTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet InputCellStypeView *InputCellInfo;


@property (assign, nonatomic) NSInteger section;
@property (assign, nonatomic) NSInteger row;
@property (weak, nonatomic) id <GYPersonalInfoTableViewCellDelegate> delegate;

@end
