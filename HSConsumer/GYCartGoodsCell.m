//
//  GYCartGoodsCell.m
//  HSConsumer
//
//  Created by 00 on 14-12-1.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYCartGoodsCell.h"
#import "UIView+CustomBorder.h"
#import "GYShopDetailViewController.h"
#import "GYAppDelegate.h"
#import "GYCartViewController.h"
#import "GYStoreDetailViewController.h"
@implementation GYCartGoodsCell
{
    
    NSUInteger textLength;//输入框字符串长度
    GYShopDetailViewController *shopdetail;
    NSString *textfile;
    
    
}

- (void)awakeFromNib
{

    self.tfNum.frame = CGRectMake(self.tfNum.frame.origin.x, self.tfNum.frame.origin.y, self.tfNum.frame.size.width, self.tfNum.frame.size.height - 0.5);
    [self.tfNum addAllBorder];
    
   // self.tfNum.delegate = self;
    //[self.tfNum addTarget:self action:@selector(delegateShowSetCountView) forControlEvents:UIControlEventEditingDidBegin];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    CGRect rect = self.tfNum.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    btn.frame = rect;
    [self.tfNum addSubview:btn];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.lbLine addTopBorder];
    [self.lbLine2 addTopBorder];
    [self.lbLineBig addTopBorder];
    [self addTopBorder];
    
    // addby songjk
    [self.vShopName addTopBorder];
    [self.vShopName addBottomBorder];
    self.lbShopNameTitle.text = @"选择营业点";
}

-(void)btnClicked:(UIButton *)btn
{
    [self delegateShowSetCountViewwithRow:self.tfNum.tag];
}
- (IBAction)btnDelClick:(id)sender {
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"确定要删除该商品吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [av show];
    
}


#pragma mark - AVdelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0) {
        
        [self.delegate delCell:self.indexPath];
    }

}



//选中按钮点击事件

- (IBAction)btnSelClick:(id)sender {
    self.isSel = !self.isSel;
    if (self.isSel) {
         [sender setImage:[UIImage imageNamed:@"ep_cart_selected.png"] forState:UIControlStateNormal];
    }else{
        [sender setImage:[UIImage imageNamed:@"ep_cart_unselected.png"] forState:UIControlStateNormal];
    }
    [self.delegate isSelCell:self.isSel :self.indexPath];
    
}

- (void)delegateShowSetCountViewwithRow:(NSInteger)row
{
    [self.delegate showSetCountViewGoodsNum:self.tfNum.text.integerValue withRow:row];
    GYCartViewController *cartVC = self.delegate;
    cartVC.cartCellsetNumBlock = ^(NSInteger num)
    {
        self.tfNum.text = @(num).stringValue;
        self.num = num;
        [self setData];
        [self.delegate changeCount:self.num :self.indexPath];
    };
}

//增加按钮点击事件
- (IBAction)btnAddClick:(UIButton *)sender {
#if 0
    [self goodsMaxNum];
    self.num ++;
    [self isHiddenBtnAdd];
    [self setData];
    [self.delegate changeCount:self.num :self.indexPath];
#endif
    [self delegateShowSetCountViewwithRow:sender.tag];
    
}

//减少按钮点击事件
- (IBAction)btnCutClick:(UIButton *)sender {
#if 0
    if (self.num > 1) {
        self.num -- ;
    }else{
        self.num = 0;
        UIAlertView *ar=[[UIAlertView alloc]initWithTitle:@"提示" message:@"商品数量不能为零！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [ar show];
        return;
    }
    [self isHiddenBtnAdd];
    [self setData];
    [self.delegate changeCount:self.num :self.indexPath];
#endif
    [self delegateShowSetCountViewwithRow:sender.tag];
}

//复用刷新函数
-(void)setData
{
    self.tfNum.text = [NSString stringWithFormat:@"%ld",(long)self.num];
    self.lbNumBIg.text = [NSString stringWithFormat:@"共%ld件商品",(long)self.num];
    self.lbPriceTotal.text = [NSString stringWithFormat:@"%.02f",self.price * self.num];
//    NSLog(@"%f %d total=============%f",self.price ,self.num,self.price * self.num);
    
    self.lbPV.text = [NSString stringWithFormat:@"%.02f",self.pv* self.num];
}
//取得商品库存总数量
-(void)goodsMaxNum
{
    GYAppDelegate * applegate = (GYAppDelegate *)[[UIApplication sharedApplication]delegate];
    self.goodsNum=applegate.goodsNum;
}

//大于库存总量使增加按钮失效
-(void)isHiddenBtnAdd
{
    if (self.num>=self.goodsNum) {
        [self.btnAdd setUserInteractionEnabled:NO];
        self.btnAdd.alpha=1;
    }
    else{
        [self.btnAdd setUserInteractionEnabled:YES];
        self.btnAdd.alpha=1;
    }
}
//超过库存数量显示提示框
-(void)setTips
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"该商品库存只有%ld件",self.goodsNum]delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    [self delegateShowSetCountViewwithRow:textField.tag];
    textfile= textField.text;
}



-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@"0"]) {
        UIAlertView *ar=[[UIAlertView alloc]initWithTitle:@"提示" message:@"商品数量不能为零！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [ar show];
        textField.text=textfile;
        return;
    }

    [self goodsMaxNum];
    if ([textField.text integerValue]>=self.goodsNum) {
        [self setTips];
        textField.text=[NSString stringWithFormat:@"%ld",self.goodsNum];
        self.num=self.goodsNum;
        [self.btnAdd setUserInteractionEnabled:NO];
        self.btnAdd.alpha=0.1;
    }
    self.num = [textField.text integerValue];
    
    
    [self setData];
//    [self.delegate changeCount:self.num :self.indexPath];
}
#pragma mark - pushVC
- (void)pushVC:(id)vc animated:(BOOL)ani
{
   [self.nav.topViewController setHidesBottomBarWhenPushed:YES];
   [self.nav pushViewController:vc animated:ani];
}

- (IBAction)getIdgotoVc:(id)sender {
//    GYShopDetailViewController *vc = kLoadVcFromClassStringName(NSStringFromClass([GYShopDetailViewController class]));
//    ;
//    vc.ShopID = kSaftToNSString(self.ShopID);
//    vc.fromEasyBuy = 1;
//    [self pushVC:vc animated:YES];
    
    GYStoreDetailViewController * vc = [[GYStoreDetailViewController alloc] init];
    ShopModel  * model = [[ShopModel alloc] init];
    model.strVshopId = self.ShopID;
    vc.shopModel = model;
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVC:vc animated:YES];
}
@end
