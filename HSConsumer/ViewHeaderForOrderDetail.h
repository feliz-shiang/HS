//
//  ViewHeaderForOrderDetail.h
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewHeaderForOrderDetail : UIView
//zhangqy
//{
//    
//    IBOutlet UIView *_viewBkg0;
//    IBOutlet UIView *_viewBkg1;
//}
@property (strong, nonatomic) IBOutlet UILabel *lbLabelLogisticInfo;
@property (strong, nonatomic) IBOutlet UILabel *lbLogisticName;
@property (strong, nonatomic) IBOutlet UILabel *lbLogisticOrderNo;
@property (strong, nonatomic) IBOutlet UIButton *btnCheckLogisticDetail;

@property (strong, nonatomic) IBOutlet UILabel *lbConsignee;
@property (strong, nonatomic) IBOutlet UILabel *lbTel;
@property (strong, nonatomic) IBOutlet UILabel *lbLabelConsigneeAddress;
@property (strong, nonatomic) IBOutlet UILabel *lbConsigneeAddress;
@property (strong, nonatomic) IBOutlet UIButton *btnVshopName;
@property (strong, nonatomic) IBOutlet UIView *viewBkg2;//新增 物流信息
@property (weak, nonatomic) IBOutlet UIView *viewBkg3;//zhangqy 自动收货倒计时
@property (weak, nonatomic) IBOutlet UIView *viewBkg0;
@property (weak, nonatomic) IBOutlet UIView *viewBkg1;

@property (weak, nonatomic) IBOutlet UILabel *lbTimeLeft;
@property (weak, nonatomic) IBOutlet UIImageView *mvArrowRight;// add by songjk 进入商铺按钮

@property (strong, nonatomic) NSString *strCheckLogisticDetailUrl;//保存查看物流详情的URL，初始为nil

+ (CGFloat)getHeight;
@end
