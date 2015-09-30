//
//  GYMainEvaluationGoodsViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

//全部订单


#define kCellSubCellHeight 80.f

#import "GYMainEvaluationGoodsViewController.h"
#import "MenuTabView.h"
#import "GYEvaluationGoodsViewController.h"
#import "GYAlreadyEvaluateGoodsViewController.h"
#import "GYEasyPurchaseMainViewController.h"

@interface GYMainEvaluationGoodsViewController ()<UIScrollViewDelegate, MenuTabViewDelegate>
{
//    GlobalData *data;   //全局单例
    MenuTabView *menu;      //菜单视图
    NSArray *menuTitles;    //菜单标题数组
    NSMutableArray *arrParentViews;    //parentView array
    IBOutlet UIScrollView *_scrollV; //滚动视图，用于装载各vc view
    GYAlreadyEvaluateGoodsViewController *vcFiniedEvaluationGoods;
    GYEvaluationGoodsViewController *vcUnfiniedEvaluationGoods;
    
    
}

@end

@implementation GYMainEvaluationGoodsViewController

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
    
    menuTitles = @[kLocalized(@"already_evaluation"),
                   kLocalized(@"ep_wait_evaluate")];

    [_scrollV setPagingEnabled:YES];
    [_scrollV setBounces:NO];
    [_scrollV setShowsHorizontalScrollIndicator:NO];
    _scrollV.delegate = self;
   
    [_scrollV setContentSize:CGSizeMake(_scrollV.frame.size.width * menuTitles.count, 150)];
    [_scrollV setBackgroundColor:kDefaultVCBackgroundColor];

    //添加 tableview
    vcFiniedEvaluationGoods = kLoadVcFromClassStringName(NSStringFromClass([GYAlreadyEvaluateGoodsViewController class]));
    vcUnfiniedEvaluationGoods = kLoadVcFromClassStringName(NSStringFromClass([GYEvaluationGoodsViewController class]));
    arrParentViews = [@[vcFiniedEvaluationGoods, vcUnfiniedEvaluationGoods] mutableCopy];
    CGRect tableViewFrame = _scrollV.bounds;
    
    for (int i = 0; i < menuTitles.count; i++)
    {
        tableViewFrame.origin.x = tableViewFrame.size.width * i;
        GYEvaluationGoodsViewController *vc = arrParentViews[i];
        vc.nav = self.navigationController;
        vc.view.frame = tableViewFrame;
        [_scrollV addSubview:vc.view];
    }
    
    //初始化menu
    menu = [[MenuTabView alloc] initMenuWithTitles:menuTitles withFrame:CGRectMake(0, 0, kScreenWidth, 40) isShowSeparator:YES];
    menu.delegate = self;
    //必须设置menu的delegate 及 _scrollV delegate后才可以设置默认显示
    [menu setDefaultItem:self.index % 2];
    [self.view addSubview:menu];

}

-(void)viewWillDisappear:(BOOL)animated
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

#pragma mark - GYViewControllerDelegate

- (void)pushVC:(id)vc animated:(BOOL)ani
{
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:ani];
}

#pragma mark - MenuTabViewDelegate
- (void)changeViewController:(NSInteger)index
{
    
    CGFloat contentOffsetX = _scrollV.contentOffset.x;
    NSInteger viewIndex = (NSInteger)(contentOffsetX / self.view.frame.size.width);
    if (viewIndex == index ) return;
    
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
    }
}
@end
