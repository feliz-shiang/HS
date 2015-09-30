//
//  GYARMainViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYARMainViewController.h"
#import "MenuTabView.h"
#import "GYSearchShopViewController.h"
#import "GYSearchGoodViewController.h"
#import "GYGoodDetailViewController.h"
#import "GYCartViewController.h"
#import "GYEPMyHEViewController.h"
#import "GYAppDelegate.h"
@interface GYARMainViewController ()<UIScrollViewDelegate, MenuTabViewDelegate>
{
    
//    GlobalData *data;   //全局单例
    MenuTabView *menu;      //菜单视图
    NSArray *menuTitles;    //菜单标题数组
    NSMutableArray *arrParentViews;    //parentView array
    IBOutlet UIScrollView *_scrollV; //滚动视图，用于装载各vc view
    
    GYSearchShopViewController *vcSearchShop;
    GYSearchGoodViewController *vcSearchGoods;
}

@property (nonatomic, strong) NSMutableArray *arrResult;

@end

@implementation GYARMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"周边逛";
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];

    menuTitles = @[kLocalized(@"ar_title_lookover_shops"),
                   kLocalized(@"ar_title_lookover_goods")];
    
    CGRect scrFrame = _scrollV.frame;
    if (kSystemVersionGreaterThanOrEqualTo(@"7.0"))
        scrFrame.size.height -= self.tabBarController.tabBar.frame.size.height;

    [_scrollV setFrame:scrFrame];
    
    [_scrollV setPagingEnabled:YES];
    [_scrollV setBounces:NO];
    [_scrollV setShowsHorizontalScrollIndicator:NO];
    
    _scrollV.delegate = self;
    [_scrollV setContentSize:CGSizeMake(_scrollV.frame.size.width * menuTitles.count, 0)];
    [_scrollV setBackgroundColor:kDefaultVCBackgroundColor];
    
    //添加 tableview
    arrParentViews = [NSMutableArray array];
    CGRect tableViewFrame = _scrollV.bounds;
    
    vcSearchShop = [[GYSearchShopViewController alloc] init];
    vcSearchShop.nc = self.navigationController;
//    [vcSearchShop getNetData];
    
    vcSearchGoods = [[GYSearchGoodViewController alloc] init];
    vcSearchGoods.nc = self.navigationController;
//    [vcSearchGoods getNetData];
    
    vcSearchShop.view.frame = tableViewFrame;
    tableViewFrame.origin.x += tableViewFrame.size.width;
    
    vcSearchGoods.view.frame = tableViewFrame;
    [_scrollV addSubview:vcSearchShop.view];
    [_scrollV addSubview:vcSearchGoods.view];
    
    
    menu = [[MenuTabView alloc] initMenuWithTitles:menuTitles withFrame:CGRectMake(0, 0, kScreenWidth, 40) isShowSeparator:YES];
    menu.delegate = self;
//    [menu setDefaultItem:1];
    [self.view addSubview:menu];

    
    UIBarButtonItem *btnSetting= [[UIBarButtonItem alloc] initWithCustomView:[self leftView]];
    self.navigationItem.rightBarButtonItem = btnSetting;
    
    [self getGoodsNum];
}

#warning 商品个数
-(void)getGoodsNum
{
    GlobalData *data = [GlobalData shareInstance];
    [Network HttpGetForRequetURL:[data.ecDomain stringByAppendingString:@"/easybuy/getCartMaxSize"] parameters:nil requetResult:^(NSData *jsonData, NSError *error) {
        if (!error) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:kNilOptions
                                                                   error:&error];
            if (!error){
                
                if (kSaftToNSInteger(dict[@"retCode"]) == kEasyPurchaseRequestSucceedCode)//返回成功数据
                {
                    GYAppDelegate * delegate = (GYAppDelegate *)[[UIApplication sharedApplication]delegate];
                    delegate.goodsNum=[dict[@"data"] integerValue];
                    NSLog(@"%ld",delegate.goodsNum);
                }
                else{
                    [Utils showMessgeWithTitle:nil message:@"操作失败." isPopVC:nil];
                }
            }
        }
        
    }];

}

-(UIView *)leftView
{
    UIView * vBackground = [[UIView alloc]initWithFrame:CGRectMake(0, 0,65, 30)];
    
    UIImage* imageHs= kLoadPng(@"myHs");
    UIImage* imageCart= kLoadPng(@"ep_img_nav_cart");
    CGRect backframe= CGRectMake(0, 2, imageCart.size.width * 0.5, imageCart.size.height * 0.48);
    UIButton* cartButton= [UIButton buttonWithType:UIButtonTypeCustom];
    cartButton.frame = backframe;
    [cartButton setBackgroundImage:imageHs forState:UIControlStateNormal];
    [cartButton setTitle:@"" forState:UIControlStateNormal];
    [cartButton addTarget:self action:@selector(pushToMyHS:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* myHSButton= [UIButton buttonWithType:UIButtonTypeCustom];
   
    CGRect Hsframe= CGRectMake(40, 2, imageCart.size.width * 0.5, imageCart.size.height * 0.5);
    myHSButton.frame=Hsframe;
    [myHSButton setBackgroundImage:imageCart forState:UIControlStateNormal];
    [myHSButton setTitle:@"" forState:UIControlStateNormal];
    [myHSButton addTarget:self action:@selector(pushCartVc:) forControlEvents:UIControlEventTouchUpInside];
    [vBackground addSubview:cartButton];
    [vBackground addSubview:myHSButton];
    
   
    return vBackground;
}


-(void)pushToMyHS:(UIButton *)sender
{
    if (![GlobalData shareInstance].isEcLogined)
    {
        [[GlobalData shareInstance] showLoginInView:self.navigationController.view withDelegate:nil isStay:NO];
        return;
    }
    DDLogDebug(@"into cart.");
    GYEPMyHEViewController *vcCart = kLoadVcFromClassStringName(NSStringFromClass([GYEPMyHEViewController class]));
    vcCart.navigationItem.title = kLocalized(@"ep_shopping_cart");
    [self pushVC:vcCart animated:YES];
    
}

//进入购物车
- (void)pushCartVc:(id)sender
{
    if (![GlobalData shareInstance].isEcLogined)
    {
        [[GlobalData shareInstance] showLoginInView:self.navigationController.view withDelegate:nil isStay:NO];
        return;
    }
    DDLogDebug(@"into cart.");
    GYCartViewController *vcCart = kLoadVcFromClassStringName(NSStringFromClass([GYCartViewController class]));
    vcCart.navigationItem.title = kLocalized(@"ep_shopping_cart");
    [self pushVC:vcCart animated:YES];
}

- (void)showTabBar{    if (self.tabBarController.tabBar.hidden == NO)    {        return;    }
    UIView *contentView;
    if ([[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]])                contentView = [self.tabBarController.view.subviews objectAtIndex:1];    else                contentView = [self.tabBarController.view.subviews objectAtIndex:0];              contentView.frame = CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height - self.tabBarController.tabBar.frame.size.height);        self.tabBarController.tabBar.hidden = NO;}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated]; // add by songjk
     [self showTabBar];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self showTabBar];
    [vcSearchShop getNetData];
    [vcSearchGoods getNetData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - pushVC

- (void)pushVC:(id)vc animated:(BOOL)ani
{
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:ani];
    [self setHidesBottomBarWhenPushed:NO];
}

#pragma mark - MenuTabViewDelegate
- (void)changeViewController:(NSInteger)index
{
    CGFloat contentOffsetX = _scrollV.contentOffset.x;
    NSInteger viewIndex = (NSInteger)(contentOffsetX / self.view.frame.size.width);
    if (viewIndex == index )
        return;
    CGFloat _x = _scrollV.frame.size.width * index;
    [_scrollV scrollRectToVisible:CGRectMake(_x,
                                             _scrollV.frame.origin.y,
                                             _scrollV.frame.size.width,
                                             _scrollV.frame.size.height)
                         animated:NO];
    //设置当前导航条标题
//    [self.navigationItem setTitle:menuTitles[index]];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _scrollV)//因为tableview 中的scrollView 也使用同一代理，所以要判断，否则取得x值不是预期的
    {
        CGFloat _x = scrollView.contentOffset.x;//滑动的即时位置x坐标值
        NSInteger index = (NSInteger)(_x / self.view.frame.size.width);//所偶数当前视图
        
        //设置滑动过渡位置
        if (index < menu.selectedIndex)
        {
            if (_x < menu.selectedIndex * self.view.frame.size.width - 0.5 * self.view.frame.size.width)
            {
                [menu updateMenu:index];
//                [self.navigationItem setTitle:menuTitles[index]];
            }
        }else if (index == menu.selectedIndex)
        {
            if (_x > menu.selectedIndex * self.view.frame.size.width + 0.5 * self.view.frame.size.width)
            {
                [menu updateMenu:index + 1];
//                [self.navigationItem setTitle:menuTitles[index + 1]];
            }
        }else
        {
            [menu updateMenu:index];
//            [self.navigationItem setTitle:menuTitles[index]];
        }
        
        if (menu.selectedIndex == 0) {
            
        }else
        {
            
        }
       }
}
@end
