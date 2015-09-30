//
//  ViewGoodsType.h
//  HSConsumer
//
//  Created by apple on 14-11-27.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
@interface ViewGoodsType : UIControl

@property (strong, nonatomic) IBOutlet UIImageView *ivPicture;
@property (strong, nonatomic) IBOutlet RTLabel *lbGoodsTypeTitle;
@property (strong, nonatomic) IBOutlet RTLabel *lbGoodsTypeDescription;
@property (strong, nonatomic) NSString *strNextVcName;
@property (strong, nonatomic) NSString *strTitleTextNoTags;
@property (strong, nonatomic) NSString *strDescriptionTextNoTags;
@property (strong, nonatomic) NSString *strID;

- (void)setGoodsTypeTitleTextWithDefaultAttributes:(NSString *)text;
- (void)setGoodsTypeDescriptionTextWithDefaultAttributes:(NSString *)text;

@end
