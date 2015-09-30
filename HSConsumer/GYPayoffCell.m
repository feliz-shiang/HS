//
//  GYPayoffCell.m
//  HSConsumer
//
//  Created by 00 on 14-12-18.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYPayoffCell.h"
#import "GYPayoffListCell.h"
#import "GYCartModel.h"
#import "UIView+CustomBorder.h"
#import "GYGoodsDetailModel.h"
#import "UIImageView+WebCache.h"

@interface GYPayoffCell ()
@property (weak, nonatomic) IBOutlet UILabel *ldDiKouShow;

@end


@implementation GYPayoffCell
{
    BOOL isBill;
    __weak IBOutlet UIImageView *img;//开具发票图片
}



//选择实体店点击事件
- (IBAction)btnSelShop:(id)sender {

    
    [self.delegate pushSelShop:self.tag - 20000];
    

}
// songjk 申请互生卡
- (IBAction)btnApplyHSCClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(PayoffCellDidSelectedApplyHScardWithCell:isApplyHScard:index:)]) {
        [self.delegate PayoffCellDidSelectedApplyHScardWithCell:self isApplyHScard:sender.selected index:self.tag - 20000];
    }
}

- (IBAction)btnDiscountClick:(UIButton *)sender {
    // modify by songjk 是否选择抵扣券
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(PayoffCellDidSelectedDiscountWithCell:isDiscount:index:)]) {
        [self.delegate PayoffCellDidSelectedDiscountWithCell:self isDiscount:sender.selected index:self.tag - 20000];
    }
//    [self.delegate pushSelDiscount:self.tag - 20000];
    
}
// add by songjk 设置抵扣券显示文字
-(void)setDiscountShowWithInfo:(NSString * )info
{
    if (info.length>0)
    {
        self.btnDiscount.hidden = NO;
        self.ldDiKouShow.text = info;
    }
    else
    {
        self.btnDiscount.hidden = YES;
        self.ldDiKouShow.text = @"可用消费抵扣券为0";
    }
}
// songjk 是否可以申请互生卡
-(void)setCanApplyCardWithInfo:(NSString *)info
{
    if (info.length>0) {
//        self.btnAppleHSCard.hidden = NO;
        self.btnAppleHSCard.enabled = YES;
        self.lbApplyHSCard.text = info;
    }
    else
    {
//        self.btnAppleHSCard.hidden = YES;
        self.btnAppleHSCard.enabled = NO;
        self.lbApplyHSCard.text = @"申请赠送互生卡";
    }
}

//配送方式点击事件
- (IBAction)btnSelWayClick:(id)sender {
    

    
    NSMutableArray *mArray = [[NSMutableArray alloc] initWithObjects:@"快递送货",@"门店自提",@"送货上门", nil];

    
    if (_delegate && [_delegate respondsToSelector:@selector(pushSelWayWithMArray:WithIndexPath:)]) {
            [self.delegate pushSelWayWithMArray:mArray WithIndexPath:self.indexPath];
    }
    

    
    
}

//开具发票点击事件
- (IBAction)btnBillClick:(UIButton*)sender {
    isBill = !isBill;
    if (isBill) {
        // 发票是否选择修改
        sender.selected = isBill;
//        [img setImage:[UIImage imageNamed:@"ep_btn_tick_clear.png"]];
        [self.delegate returnbtn:@"1" WithIndex:self.indexPath.row];
        self.tfBill.hidden=NO;

    }else{
        sender.selected = isBill;
//        [img setImage:[UIImage imageNamed:@"ep_btn_tick_noclick.png"]];
        [self.delegate returnbtn:@"0" WithIndex:self.indexPath.row];
        self.tfBill.hidden=YES;
    }
    //tf 输入控制语句
    [self judgeIsBill];
    
}

-(void)reloadTbv
{
    self.tbv.delegate = self;
    self.tbv.dataSource = self;
  
    [self.tbv registerNib:[UINib nibWithNibName:@"GYPayoffListCell" bundle:nil] forCellReuseIdentifier:@"CELLX"];
    self.tbv.frame = CGRectMake(self.tbv.frame.origin.x, self.tbv.frame.origin.y, self.tbv.frame.size.width, self.mArrGoodsList.count * 100);
    
//    NSLog(@"self.mArrGoodsList = %@",self.mArrGoodsList);
    
}


- (void)awakeFromNib
{
    [super awakeFromNib];
   //添加边框
    [self.lbLine1 addTopBorder];
    [self.lbLine2 addTopBorder];
    [self.lbLine3 addTopBorder];
    [self.lbLine4 addTopBorder];
    [self.lbLineBig addTopBorder];
    [self addTopBorder];
    self.tfBill.delegate = self;
    self.tfLeaveWord.delegate = self;
    
    isBill = NO;
    [self judgeIsBill];
    self.tfBill.layer.cornerRadius = 2.0f;
    self.tfLeaveWord.layer.cornerRadius = 2.0f;
    
    self.tbv.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tbv.scrollEnabled = NO;
   
    [self.btnSelShop setTitleColor:kCellItemTextColor forState:UIControlStateNormal];
    [self.btnSelWay setTitleColor:kCellItemTextColor forState:UIControlStateNormal];
    [self.btnDiscount setTitleColor:kCellItemTextColor forState:UIControlStateNormal];
    
    // add by songjk 抵扣券显示选择按钮
    [self.btnDiscount setBackgroundImage:[UIImage imageNamed:@"btn_unselected_gray"] forState:UIControlStateNormal];
    [self.btnDiscount setBackgroundImage:[UIImage imageNamed:@"btn_selected_red"] forState:UIControlStateSelected];
    // by songjk 申请互生卡
    [self.btnAppleHSCard setBackgroundImage:[UIImage imageNamed:@"btn_unselected_gray"] forState:UIControlStateNormal];
    [self.btnAppleHSCard setBackgroundImage:[UIImage imageNamed:@"btn_selected_red"] forState:UIControlStateSelected];
    
    self.ldDiKouShow.font = [UIFont systemFontOfSize:14];
    // add byosngjk
    self.lbShopNameInfo.numberOfLines = 3;
    self.lbShopNameInfo.adjustsFontSizeToFitWidth = YES;
}



-(void)judgeIsBill
{
    
    if (isBill) {
        self.tfBill.userInteractionEnabled = YES;
        self.lbBill.textColor = kCellItemTitleColor;
    }else{
        self.tfBill.userInteractionEnabled = NO;
        self.lbBill.textColor = kDefaultVCBackgroundColor;
        self.tfBill.text = nil;
      
    }
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.mArrGoodsList.count;
   
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYPayoffListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELLX"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    NSMutableDictionary *dic = self.mArrGoodsList[indexPath.row];
    cell.lbTitle.text = dic[@"itemName"];
    //立即付款，传过来的是一张图片
    if ([self.isRightAway isEqualToString:@"1"]) {
        [cell.img sd_setImageWithURL:[NSURL URLWithString:self.strPictureUrl] placeholderImage:[UIImage imageNamed:@"ep_placeholder_image_type1"]];
    }else{
     //从购物车过来，是多张图片，需要放到字典里，方便以后显示
      [cell.img sd_setImageWithURL:[NSURL URLWithString:dic[@"url"]] placeholderImage:[UIImage imageNamed:@"ep_placeholder_image_type1"]];
    }
  
    cell.lbNum.text = [NSString stringWithFormat:@"x%@",dic[@"quantity"]];
    cell.lbParameter.text = dic[@"skus"];
    cell.lbPrice.text = [NSString stringWithFormat:@"%.2f",[dic[@"price"]  floatValue] ];
    
    cell.lbPV.text = [NSString stringWithFormat:@"%.2f",[dic[@"point"]  floatValue] ];
    return cell;
}
// ad by songjk
-(void)setStrShopName:(NSString *)strShopName
{
    _strShopName = strShopName;
    self.lbShopNameInfo.text = strShopName;
    // 计算营业点控件位置
//    CGFloat shopNameW = self.lbShopNameInfo.frame.size.width;
//    CGFloat shopNameH = self.lbShopNameInfo.frame.size.height;
//    CGSize shopNameSize = [Utils sizeForString:strShopName font:[UIFont systemFontOfSize:15] width:shopNameW];
//    if (shopNameSize.height< shopNameH)
//    {
//        shopNameH = shopNameSize.height;
//    }
//    self.lbShopNameInfo.frame = CGRectMake(self.lbShopNameInfo.frame.origin.x, self.lbShopNameInfo.frame.origin.y, shopNameW, shopNameH);
}
@end
