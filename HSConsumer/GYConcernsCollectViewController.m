//
//  GYConcernsCollectViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import "GYConcernsCollectViewController.h"
#import "GlobalData.h"
#import "GYEasyPurchaseMainViewController.h"
#import "MenuTabView.h"
#import "TestViewController.h"
#import "GYConcernsCollectGoodsViewController.h"
#import "GYConcernsCollectShopsViewController.h"

@interface GYConcernsCollectViewController ()<UIScrollViewDelegate, MenuTabViewDelegate>
{
//    GlobalData *data;   //全局单例
    MenuTabView *menu;      //菜单视图
    NSArray *menuTitles;    //菜单标题数组
    NSMutableArray *arrParentViews;    //parentView array
    IBOutlet UIScrollView *_scrollV; //滚动视图，用于装载各vc view
}

@property (nonatomic, strong) NSMutableArray *arrResult;

@end

@implementation GYConcernsCollectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _index = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    
    menuTitles = @[kLocalized(@"ep_concerns_collect_goods"),
                   kLocalized(@"ep_delete_collect_shop")];
    
    [_scrollV setPagingEnabled:YES];
    [_scrollV setBounces:NO];
    [_scrollV setShowsHorizontalScrollIndicator:NO];
    _scrollV.delegate = self;
    //    [_scrollV.panGestureRecognizer addTarget:self action:@selector(scrollHandlePan:)];
    //    [_scrollV setUserInteractionEnabled:YES];
    //[_scrollV setContentSize:CGSizeMake(_scrollV.frame.size.width * menuTitles.count, 150)];
    // m by lizp
    [_scrollV setContentSize:CGSizeMake(_scrollV.frame.size.width, 150)];
    [_scrollV setBackgroundColor:kDefaultVCBackgroundColor];

    //添加 tableview
    arrParentViews = [NSMutableArray array];
    CGRect tableViewFrame = _scrollV.bounds;
    GYConcernsCollectGoodsViewController *concernsCollectGoods = kLoadVcFromClassStringName(NSStringFromClass([GYConcernsCollectGoodsViewController class]));
    concernsCollectGoods.nav = self.navigationController;
    concernsCollectGoods.view.frame = tableViewFrame;
    [_scrollV addSubview:concernsCollectGoods.view];
    [arrParentViews addObject:concernsCollectGoods];
    
    tableViewFrame.origin.x += tableViewFrame.size.width;
    GYConcernsCollectShopsViewController *concernsCollectShops = kLoadVcFromClassStringName(NSStringFromClass([GYConcernsCollectShopsViewController class]));
    concernsCollectShops.nav = self.navigationController;
    concernsCollectShops.view.frame = tableViewFrame;
    [_scrollV addSubview:concernsCollectShops.view];
    [arrParentViews addObject:concernsCollectShops];
//    标题不可点
//    改cell为shopcell
    //初始化menu
//    menu = [[MenuTabView alloc] initMenuWithTitles:menuTitles withFrame:CGRectMake(0, 0, kScreenWidth, 40) isShowSeparator:NO];
    menu = [[MenuTabView alloc] initMenuWithTitles:menuTitles withFrame:CGRectMake(0, 0, kScreenWidth, 40) isShowSeparator:YES];

    menu.delegate = self;
    //必须设置menu的delegate 及 _scrollV delegate后才可以设置默认显示
    [menu setDefaultItem: self.index % 2];
    [self.view addSubview:menu];
    
    [(GYConcernsCollectGoodsViewController *)arrParentViews[0] setBtnMenu:[menu getItemButton:0]];
    [(GYConcernsCollectGoodsViewController *)arrParentViews[1] setBtnMenu:[menu getItemButton:1]];
    
    //设置商铺的菜单title
    concernsCollectShops.block=^(NSInteger index,NSString *title){
        [self setMenuIndex:index withTitle:title];
    };
    //设置商品的菜单title
    concernsCollectGoods.block=^(NSInteger index,NSString *title){
        [self setMenuIndex:index withTitle:title];
    };
    
}

//设置菜单角标数
-(void)setMenuIndex:(NSInteger)index withTitle:(NSString *)title
{
    [menu setNewTitle:title withIndex:index];
}
//-(void)setMenuGoodsString:(NSString *)goodsString shopString:(NSString *)shopString
//{
////    if (goodsString!=nil) {
////        
////    }
////    if (shopString!=nil) {
////        [menu setNewTitle:shopString withIndex:1];
////    }
//    [menu setNewTitle:shopString withIndex:1];
//   
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //只有返回首页才隐藏NavigationBarHidden
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound)//返回
    {
        if ([self.navigationController.topViewController isKindOfClass:[GYEasyPurchaseMainViewController class]])
        {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GYViewControllerDelegate

- (void)pushVC:(id)vc animated:(BOOL)ani
{
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:ani];
}

#pragma mark - MenuTabViewDelegate
- (void)changeViewController:(NSInteger)index
{

//    CGFloat contentOffsetX = _scrollV.contentOffset.x;
//    NSInteger viewIndex = (NSInteger)(contentOffsetX / self.view.frame.size.width);
//    if (viewIndex == index ) return;
//    
//    CGFloat _x = _scrollV.frame.size.width * index;
//    [_scrollV scrollRectToVisible:CGRectMake(_x,
//                                             _scrollV.frame.origin.y,
//                                             _scrollV.frame.size.width,
//                                             _scrollV.frame.size.height)
//                         animated:NO];
    
    //m by lizp
    CGPoint off_set=CGPointMake(index*self.view.bounds.size.width, _scrollV.contentOffset.y);
    _scrollV.contentOffset=off_set;
    
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
    }
}
@end
