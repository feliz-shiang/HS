//
//  GYSearchGoodViewController.m
//  ZBG
//
//  Created by 00 on 14-12-24.
//  Copyright (c) 2014年 00. All rights reserved.
//

#define ScreenWidth [UIScreen mainScreen].bounds.size.width  //屏幕宽度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height //屏幕高度

#import "GYSearchGoodViewController.h"
#import "GYSearchGoodsCell.h"
#import "UIView+CustomBorder.h"
#import "SearchGoodModel.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "GYGoodDetailViewController.h"
#import "UIButton+enLargedRect.h"

//逛商品
#import "GYBuyGoodViewController.h"
@interface GYSearchGoodViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    __weak IBOutlet UIScrollView *scv;
    
    
    //常用按钮－－－－－－－－－－－－－－－－－－－－－－－－
    
    __weak IBOutlet UILabel *lbCommon;//常用Title
    __weak IBOutlet UIButton *btn1;
    __weak IBOutlet UIButton *btn2;
    __weak IBOutlet UIButton *btn3;
    __weak IBOutlet UIButton *btn4;
    __weak IBOutlet UIButton *btn5;
    __weak IBOutlet UIButton *btn6;
    __weak IBOutlet UIButton *btn7;
    __weak IBOutlet UIButton *btn8;
    __weak IBOutlet UIButton *btn9;
    NSArray *arrBtn;
    NSArray * arrBottomBtn;
    NSMutableArray *mArrCommins;//常用按钮数组
    NSMutableArray *mArrSubs;//类目按钮数组
    NSMutableArray *mArrHeight;//细分按钮个数数组
    NSMutableArray *mArrViews;//按钮试图数组
    
    CGSize sizeScreen;
    
    __weak IBOutlet UILabel *lbAll;//全部Title
    __weak IBOutlet UITableView *tbv;//talbeView
    
    
    //下排按钮－－－－－－－－－－－－－－－－－－－－－－－－
    
    __weak IBOutlet UIView *vBtn;//下排按钮View
    __weak IBOutlet UIButton *btn10;//即时送达
    __weak IBOutlet UIButton *btn11;//送货上门
    __weak IBOutlet UIButton *btn12;//货到付款
    __weak IBOutlet UIButton *btn13;//门店自提
    
    
    NSMutableArray * marrSpecialService;
    BOOL isBtn10Sel;
    BOOL isBtn11Sel;
    BOOL isBtn12Sel;
    BOOL isBtn13Sel;
    
    //假数据－－－－－－－－－－－－－－－－－－－－－－－－－
    
    NSArray *arrImg;
    NSInteger index;
    NSInteger indexSel;
    
    //－－－－－－－－－－－－－－－－－－－－－－－－－－－－
    
}
@end

@implementation GYSearchGoodViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mArrCommins = [[NSMutableArray alloc] init];
    mArrSubs = [[NSMutableArray alloc] init];
    mArrHeight = [[NSMutableArray alloc] init];
    mArrViews = [[NSMutableArray alloc] init];
    marrSpecialService= [NSMutableArray array];
    isBtn10Sel=YES;
    isBtn11Sel=YES;
    isBtn12Sel=YES;
    isBtn13Sel=YES;
    index = -1;
    arrBtn = @[btn1,btn2,btn3,btn4,btn5,btn6,btn7,btn8,btn9];
    arrBottomBtn= @[btn10,btn11,btn12,btn13];
    for (UIButton *btn in arrBtn) {
        [btn addAllBorder];
        
    }
    for (UIButton * btn in arrBottomBtn) {
        [btn setBorderWithWidth:1 andRadius:3 andColor:kDefaultViewBorderColor];
        [btn setTitleColor:kDefaultViewBorderColor forState:UIControlStateNormal];
    }
    
    arrImg = @[@"gd_liquor.png",@"gd_daily.png",@"gd_fruit.png",@"gd_snack.png",@"gd_serves.png"];
    
    [self.view.window addSubview:vBtn];
    
    
    tbv.delegate = self;
    tbv.dataSource = self;
    
    
    tbv.frame = CGRectMake(tbv.frame.origin.x, tbv.frame.origin.y, tbv.frame.size.width, mArrSubs.count * 44 - 0.5);
    [tbv registerNib:[UINib nibWithNibName:@"GYSearchGoodsCell" bundle:nil] forCellReuseIdentifier:@"CELL"];
    scv.contentSize = CGSizeMake(0, CGRectGetMaxY(tbv.frame) + 50);
    [self getNetData];
    
//    [tbv addTopBorder];
    [tbv addBottomBorder];
    [vBtn addAllBorder];
}


-(void)setBtnSelStatus:(UIButton *)sender
{
    sender.layer.borderWidth = 1.0 ;
    sender.layer.cornerRadius = 3.0;
    [sender setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    sender.layer.borderColor = kNavigationBarColor.CGColor;
    
}

-(void)setBtnNormalStatus:(UIButton *)sender
{
    sender.layer.borderWidth = 1.0 ;
    sender.layer.cornerRadius = 3.0;
    [sender setTitleColor:kDefaultViewBorderColor forState:UIControlStateNormal];
    sender.layer.borderColor = kDefaultViewBorderColor.CGColor;
    
}

- (IBAction)btnSelAction:(id)sender {
    UIButton * btnTemp=(UIButton *)sender;
    
    switch (btnTemp.tag) {
        case 10:// 即时送达
        {
            
            if (isBtn10Sel) {
                isBtn10Sel=!isBtn10Sel;
                [marrSpecialService addObject:@"2"];// modify by songjk 1->2
                [self setBtnSelStatus:btnTemp];
            }else
            {
                isBtn10Sel=!isBtn10Sel;
                if ([marrSpecialService containsObject:@"2"]) {
                    [marrSpecialService removeObject:@"2"];
                }
                
                [self setBtnNormalStatus:btnTemp];
            }
            
            
            
            
        }
            break;
        case 11:// 送货上门
        {
            if (isBtn11Sel) {
                isBtn11Sel=!isBtn11Sel;
                [marrSpecialService addObject:@"3"];// modify by songjk 2->3
                [self setBtnSelStatus:btnTemp];
            }else
            {
                isBtn11Sel=!isBtn11Sel;
                if ([marrSpecialService containsObject:@"3"]) {
                    [marrSpecialService removeObject:@"3"];
                }
                [self setBtnNormalStatus:btnTemp];
            }
        }
            break;
        case 12:// 货到付款
        {
            if (isBtn12Sel) {
                isBtn12Sel=!isBtn12Sel;
                [marrSpecialService addObject:@"4"];// modify by songjk 3->4
                [self setBtnSelStatus:btnTemp];
            }else
            {
                isBtn12Sel=!isBtn12Sel;
                if ([marrSpecialService containsObject:@"4"]) {
                    [marrSpecialService removeObject:@"4"];
                }
                [self setBtnNormalStatus:btnTemp];
            }
        }
            break;
        case 13:// 门店自提
        {
            if (isBtn13Sel) {
                isBtn13Sel=!isBtn13Sel;
                [marrSpecialService addObject:@"5"];// modify by songjk 4->5
                [self setBtnSelStatus:btnTemp];
            }else
            {
                isBtn13Sel=!isBtn13Sel;
                if ([marrSpecialService containsObject:@"5"]) {
                    [marrSpecialService removeObject:@"5"];
                }
                [self setBtnNormalStatus:btnTemp];
            }
        }
            break;
        default:
            break;
    }
    
    
    
    
}

- (IBAction)btnActionCommon:(id)sender {
    
    NSInteger i = 0;
    for (UIButton *btn in arrBtn) {
        if (sender == btn) {
            SearchGoodModel *model1 = mArrCommins[i];
            GYBuyGoodViewController * vcGoodDetail =[[GYBuyGoodViewController alloc]initWithNibName:@"GYBuyGoodViewController" bundle:nil];
            vcGoodDetail.hidesBottomBarWhenPushed=YES;
            vcGoodDetail.modelCommins = model1;
            vcGoodDetail.title=model1.name;
            NSUserDefaults * userDefaultGoods =[NSUserDefaults standardUserDefaults];
            [userDefaultGoods setObject:model1.name forKey:@"surroundingGoodsTitle"];
            [userDefaultGoods synchronize];
            vcGoodDetail.strSpecialService=[marrSpecialService componentsJoinedByString:@","];
            [self.nc pushViewController:vcGoodDetail animated:YES];
            [vcGoodDetail setHidesBottomBarWhenPushed:NO];
        }
        i++;
    }
}

#pragma mark - UITableViewDelegate


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mArrSubs.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row  == index ) {
        
        
        NSNumber *num = mArrHeight[indexPath.row];
        NSInteger b = [num integerValue];
        return 44 + [self countY:b]*21 + 20;
    }else{
        return 44;
    }
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYSearchGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    
    if (cell.vBtn != nil) {
        
        [cell.vBtn removeFromSuperview];
    }
    
    
    SearchGoodModel *model = mArrSubs[indexPath.row];
    cell.lbTitle.text = model.name;
    UIView *view = mArrViews[indexPath.row];
    [cell.img sd_setImageWithURL:[NSURL URLWithString:kSaftToNSString(model.picAddr)] placeholderImage:kLoadPng(@"ep_placeholder_image_type1")];
    cell.vBtn = view;
    [cell.contentView addSubview:cell.vBtn];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    view.hidden = YES;
    
    
    if (indexPath.row == index) {
        view.hidden = NO;
    }
    return cell;
}

//按钮点击事件
-(void)btnCilck:(UIButton *)button
{
    NSInteger z = button.tag/100000;
    NSInteger y = button.tag%100000;
    
    SearchGoodModel *model = mArrSubs[z];
    SearchGoodModel *model1 = model.arrModel[y];
    
    GYBuyGoodViewController * vcGoodDetail =[[GYBuyGoodViewController alloc]initWithNibName:@"GYBuyGoodViewController" bundle:nil];
    vcGoodDetail.hidesBottomBarWhenPushed=YES;
    vcGoodDetail.modelCommins = model1;
    NSUserDefaults * userDefaultGoods =[NSUserDefaults standardUserDefaults];
    [userDefaultGoods setObject:model1.name forKey:@"surroundingGoodsTitle"];
    
    [userDefaultGoods synchronize];
    vcGoodDetail.title=model1.name;
    
 
    // add by songjk
    vcGoodDetail.strSpecialService=[marrSpecialService componentsJoinedByString:@","];
    [self.nc pushViewController:vcGoodDetail animated:YES];
    [vcGoodDetail setHidesBottomBarWhenPushed:NO];
    
}


//计算按钮行值
-(NSInteger)countY:(int)arrayCount
{
    NSInteger x;
    if (arrayCount%4 == 0) {
        x = arrayCount/4;
        return x;
    }else{
        x = arrayCount/4 +1;
        return x;
    }
    
}

-(void)setButtonView
{
    NSInteger z;
    NSInteger y;
    z = 0;
    for (NSNumber *num in mArrHeight) {
        NSInteger b = [num integerValue];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth, [self countY:b]*21 + 20)];
        y = 0;
        SearchGoodModel *model = mArrSubs[z];
        for (NSInteger i = 0; i < [self countY:b]; i++) {
            for (NSInteger j = 0; j < 4; j++) {
                if (y < b) {
                    SearchGoodModel *model1 = model.arrModel[y];
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame = CGRectMake(0 + j*ScreenWidth/4,10 + i*21, ScreenWidth/4-1, 20);
                    
                    btn.tag = 100000 * z + y;
                    
                    [btn addTarget:self action:@selector(btnCilck:) forControlEvents:UIControlEventTouchUpInside];
                    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                    [btn setTitle:model1.name forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont systemFontOfSize:12];
                    [view addSubview:btn];
                    
                    y++;
                }
            }
        }
        view.hidden = YES;
        [mArrViews addObject:view];
        z++;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSNumber *num = mArrHeight[indexPath.row];
    NSInteger b = [num integerValue];
    
    if (index == indexPath.row) {
        
        tbv.frame = CGRectMake(tbv.frame.origin.x, tbv.frame.origin.y, tbv.frame.size.width, mArrSubs.count * 44 - 0.5);
        index = -1;
    }else{
        index = indexPath.row;
        tbv.frame = CGRectMake(tbv.frame.origin.x, tbv.frame.origin.y, tbv.frame.size.width, mArrSubs.count * 44 + [self countY:b]*21 + 20 - 0.5);
        scv.contentSize = CGSizeMake(0, CGRectGetMaxY(tbv.frame) + 50);
    }
    
    [tbv removeTopBorder];
    [tbv removeBottomBorder];
    [tbv addTopBorder];
    [tbv addBottomBorder];
    
    [tbv reloadData];
}

#pragma mark - getNetData
//网络请求函数，包含网络等待弹窗控件，数据解析回调函数
-(void)getNetData
{
    [Utils showMBProgressHud:self SuperView:self.view Msg:@"网络请求中"];
    //测试get
    NSString *url = [[GlobalData shareInstance].ecDomain stringByAppendingString:@"/goods/getMainInterface"];
    [Network  HttpGetForRequetURL:url parameters:nil requetResult:^(NSData *jsonData, NSError *error){
        [Utils hideHudViewWithSuperView:self.view];
        
        if (error) {
            NSLog(@"错误");
            NSLog(@"%@",error);
            self.view.hidden = YES;

            [Utils hideHudViewWithSuperView:self.view];
        }else{
            self.view.hidden = NO;

            NSDictionary *ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            NSString *retCode = ResponseDic[@"retCode"];
            if ([retCode integerValue] == 200) {
                
                mArrCommins = [[NSMutableArray alloc] init];
                mArrSubs = [[NSMutableArray alloc] init];
                mArrHeight = [[NSMutableArray alloc] init];
                mArrViews = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in ResponseDic[@"data"][@"commons"]) {
                    SearchGoodModel *modelCommins = [[SearchGoodModel alloc] init];
                    modelCommins.name = dic[@"name"];
                    modelCommins.uid = dic[@"id"];
                    [mArrCommins addObject:modelCommins];
                }
                [self btnReloadData];
                for (NSDictionary *dic1 in ResponseDic[@"data"][@"categories"]) {
                    SearchGoodModel *modelCategories = [[SearchGoodModel alloc] init];
                    modelCategories.name = dic1[@"categoryName"];
                    modelCategories.uid = dic1[@"id"];
                    modelCategories.picAddr = dic1[@"picAddr"];
                    [mArrSubs addObject:modelCategories];
                    for (NSDictionary *dic2 in dic1[@"subs"]) {
                        SearchGoodModel *modelSubs = [[SearchGoodModel alloc] init];
                        modelSubs.name = dic2[@"name"];
                        modelSubs.uid = dic2[@"id"];
                        [modelCategories.arrModel addObject:modelSubs];
                    }
                    [mArrHeight addObject:[NSNumber numberWithInt:modelCategories.arrModel.count]];
                }
                
            }else{
                // 使用本地数据
                
            } 
            //网络请求回调后弹窗
            [Utils hideHudViewWithSuperView:self.view];
        }
        [self setButtonView];
        [tbv reloadData];
        [self cellBtnReloadData];
    }];
    
    
}

-(void)btnReloadData
{
    if (mArrCommins.count < 9) {
        
        for (NSInteger i = 0; i < mArrCommins.count; i++) {
            SearchGoodModel *model = mArrCommins[i];
            
            [arrBtn[i] setTitle:model.name forState:UIControlStateNormal];
            [arrBtn[i] setHidden:NO];
        }
        
    }else{
        for (NSInteger i = 0; i < 9; i++) {
            SearchGoodModel *model = mArrCommins[i];
            
            [arrBtn[i] setTitle:model.name forState:UIControlStateNormal];
            
            [arrBtn[i] setHidden:NO];
            
            [arrBtn[i] sd_setImageWithURL:[NSURL URLWithString:model.picAddr] forState:UIControlStateNormal];
            
        }
    }
}

-(void)cellBtnReloadData
{
    tbv.frame = CGRectMake(tbv.frame.origin.x, tbv.frame.origin.y, tbv.frame.size.width, mArrSubs.count * 44 - 0.5);
    scv.contentSize = CGSizeMake(320, 150 + tbv.frame.size.height + 200);
    
}


@end
