//
//  GYPhoneScr.h
//  Animation
//
//  Created by mac on 14-11-19.
//  Copyright (c) 2014年 whf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYPhoneScr : UIView<UIScrollViewDelegate>
@property (nonatomic,strong)NSMutableArray * imgArr;
@property (nonatomic,assign)NSInteger curPage;
@property (nonatomic,strong)UIViewController * owner;
@property (nonatomic,strong)UIImageView * imgvDisplayZoom;
@property (nonatomic,strong)NSMutableArray * marrImgvStore;
- (id)initWithFrame:(CGRect)frame WithOwer:(id )ower;
@end
