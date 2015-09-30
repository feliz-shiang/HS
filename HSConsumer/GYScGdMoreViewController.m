//
//  GYSearchGoodViewController.m
//  ZBG
//
//  Created by 00 on 14-12-24.
//  Copyright (c) 2014年 00. All rights reserved.
//

#define ScreenWidth [UIScreen mainScreen].bounds.size.width  //屏幕宽度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height //屏幕高度
#define kTagPre 2100

#import "GYScGdMoreViewController.h"
#import "GYSearchGoodsCell.h"
#import "UIView+CustomBorder.h"
#import "SearchGoodModel.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "GYFindShopViewController.h"
#import "GYCartViewController.h"

@interface GYScGdMoreViewController ()<UITableViewDataSource,UITableViewDelegate>
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
    NSMutableArray *arrBtn;


    NSMutableArray *mArrCommins;//常用按钮数组
    NSMutableArray *mArrSubs;//类目按钮数组
    NSMutableArray *mArrHeight;//细分按钮个数数组
    NSMutableArray *mArrViews;//按钮试图数组
    
    
    NSMutableArray *marrResult;
    
__weak IBOutlet UILabel *lbAll;//全部Title
__weak IBOutlet UITableView *tbv;//talbeView
    

//假数据－－－－－－－－－－－－－－－－－－－－－－－－－

    NSArray *arrData;
    NSArray *arrImg;
    
    NSInteger index;
    NSInteger indexSel;
    
    
//－－－－－－－－－－－－－－－－－－－－－－－－－－－－
    
}
@end

@implementation GYScGdMoreViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mArrCommins = [[NSMutableArray alloc] init];
    mArrSubs = [[NSMutableArray alloc] init];
    mArrHeight = [[NSMutableArray alloc] init];
    mArrViews = [[NSMutableArray alloc] init];
    
    index = -1;
    arrBtn = [@[btn1,btn2,btn3,btn4,btn5,btn6,btn7,btn8,btn9] mutableCopy];
    for (UIButton *btn in arrBtn)
    {
        [btn addTarget:self action:@selector(btnCilck:) forControlEvents:UIControlEventTouchUpInside];
        [btn addAllBorder];
    }
    
//    arrData = [NSArray arrayWithObjects:
//               @"美吃",
//               @"休闲娱乐",
//               @"酒店",
//               @"电影",
//               @"生活服务",
//               @"丽人",
//               nil];
    arrImg = @[@"gd_cate.png",@"gd_relax.png",@"gd_hotel.png",@"gd_movie.png",@"gd_serve.png",@"gd_beauty.png"];
  

    tbv.delegate = self;
    tbv.dataSource = self;
    
   
    tbv.frame = CGRectMake(tbv.frame.origin.x, tbv.frame.origin.y, tbv.frame.size.width, arrData.count * 44 - 0.5);
    [tbv registerNib:[UINib nibWithNibName:@"GYSearchGoodsCell" bundle:nil] forCellReuseIdentifier:@"CELL"];
    scv.contentSize = CGSizeMake(0, CGRectGetMaxY(tbv.frame) + 50);
    
    [tbv addTopBorder];
    [tbv addBottomBorder];
    
    UIImage* image= kLoadPng(@"ep_img_nav_cart");
    CGRect backframe= CGRectMake(0, 0, image.size.width * 0.5, image.size.height * 0.5);
    UIButton* backButton= [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = backframe;
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton setTitle:@"" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(pushCartVc:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnSetting= [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.rightBarButtonItem = btnSetting;
    
    [self getNetData];
}

#pragma mark - 进入购物车

- (void)pushCartVc:(id)sender
{
    if (![GlobalData shareInstance].isEcLogined)
    {
        [[GlobalData shareInstance] showLoginInView:self.navigationController.view withDelegate:nil isStay:NO];
        return;
    }
    DDLogDebug(@"into cart.");
    GYCartViewController *vcCart = kLoadVcFromClassStringName(NSStringFromClass([GYCartViewController class]));
    vcCart.navigationItem.title = kLocalized(@"ep_usual_myhe");
    [self pushVC:vcCart animated:YES];
}

#pragma mark - pushVC

- (void)pushVC:(id)vc animated:(BOOL)ani
{
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:ani];
    [self setHidesBottomBarWhenPushed:NO];
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
    cell.vBtn = view;
    [cell.img sd_setImageWithURL:[NSURL URLWithString:model.picAddr] placeholderImage:kLoadPng(@"ep_placeholder_image_type1")];

    [cell.contentView addSubview:cell.vBtn];
    
    
    //    NSLog(@"%d",model.arrModel.count);
    
    //    cell.img.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",arrImg[indexPath.row]]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    view.hidden = YES;
    
    
    
    
    if (indexPath.row == index) {
        view.hidden = NO;
    }
    
    return cell;
}


//按钮点击事件
-(void)btnCilck:(UIButton *)sender
{
    NSInteger itemIndex = sender.tag - kTagPre;
    GYFindShopViewController *vc =[[GYFindShopViewController alloc] init];
    vc.strSortType = @"1";
    SearchGoodModel *model = marrResult[itemIndex];
    vc.title = model.name;
    vc.modelID = model.uid;
    vc.modelTitle = model.name;
    
    NSUserDefaults * userDefault =[NSUserDefaults standardUserDefaults];
    [userDefault setObject:model.name forKey:@"surroundingTitle"];
    [userDefault synchronize];
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
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
    
    marrResult = [NSMutableArray array];
    int maxComminsCount = mArrCommins.count;
    NSInteger tags = kTagPre;
    if (maxComminsCount > arrBtn.count)
    {
        maxComminsCount = arrBtn.count;
    }
    for (int i = 0; i < maxComminsCount; i++)
    {
        [marrResult addObject:mArrCommins[i]];
        UIButton *btnt = arrBtn[i];
        btnt.tag = tags;
        tags++;
    }
    
    NSInteger z;
    NSInteger y;
    z = 0;
    for (NSNumber *num in mArrHeight)
    {
        NSInteger b = [num integerValue];
        //        NSLog(@"===========%d",b);
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth, [self countY:b]*21 + 20)];
        
        y = 0;
        SearchGoodModel *model = mArrSubs[z];
        for (NSInteger i = 0; i < [self countY:b]; i++)
        {
            for (NSInteger j = 0; j < 4; j++)
            {
                if (y < b)
                {
                    SearchGoodModel *model1 = model.arrModel[y];
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame = CGRectMake(0 + j*ScreenWidth/4,10 + i*21, ScreenWidth/4-1, 20);
                    
                    [btn addTarget:self action:@selector(btnCilck:) forControlEvents:UIControlEventTouchUpInside];
                    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                    [btn setTitle:model1.name forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont systemFontOfSize:12];
                    
                    [marrResult addObject:model1];
                    btn.tag = tags;
                    tags++;

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
    NSString *url = [[GlobalData shareInstance].ecDomain stringByAppendingString:@"/shops/getMore"];
    [Network  HttpGetForRequetURL:url parameters:@{@"count":@"5"} requetResult:^(NSData *jsonData, NSError *error){
        
        [Utils hideHudViewWithSuperView:self.view];
        
        if (error) {
            NSLog(@"错误");
            NSLog(@"%@",error);
            
            [Utils hideHudViewWithSuperView:self.view];
        }else{
            
            NSDictionary *ResponseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            
            //            int retCode = ResponseDic[@"retCode"];
            //            if (retCode == 200) {
            //
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
            //
            //            }else{
            //            // 使用本地数据
            //
            //            }
            //
            
            //网络请求回调后弹窗
            [Utils hideHudViewWithSuperView:self.view];
        }
        [self setButtonView];
        [tbv reloadData];
        [self cellBtnReloadData];
        [self btnReloadData];
    }];
    
    
}

-(void)btnReloadData
{
    if (mArrCommins.count < 9)
    {
        for (NSInteger i = 0; i < mArrCommins.count; i++)
        {
            SearchGoodModel *model = mArrCommins[i];
            
            [arrBtn[i] setTitle:model.name forState:UIControlStateNormal];
            [arrBtn[i] setHidden:NO];
            
            
            [arrBtn[i] sd_setImageWithURL:[NSURL URLWithString:model.picAddr] forState:UIControlStateNormal  placeholderImage:kLoadPng(@"ep_placeholder_image_type1")];
        }
        
    }else
    {
        for (NSInteger i = 0; i < 9; i++)
        {
            SearchGoodModel *model = mArrCommins[i];
            
            [arrBtn[i] setTitle:model.name forState:UIControlStateNormal];
            
            [arrBtn[i] setHidden:NO];
        }
    }
    
}

-(void)cellBtnReloadData
{
    tbv.frame = CGRectMake(tbv.frame.origin.x, tbv.frame.origin.y, tbv.frame.size.width, mArrSubs.count * 44 - 0.5);
    scv.contentSize = CGSizeMake(320, 150 + tbv.frame.size.height + 200);
    
}


@end
