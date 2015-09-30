//
//  GYEPMyAllOrdersViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//


#import "GYEPMyCouponsMainViewController.h"
#import "MenuTabView.h"
#import "GYEasyPurchaseMainViewController.h"
#import "GYEPMyCouponsViewController.h"

@interface GYEPMyCouponsMainViewController ()<UIScrollViewDelegate, MenuTabViewDelegate>
{
    MenuTabView *menu;      //菜单视图
    NSArray *menuTitles;    //菜单标题数组
    NSMutableArray *arrParentViews;    //parentView array
    IBOutlet UIScrollView *_scrollV; //滚动视图，用于装载各vc view
}

@property (nonatomic, strong) NSMutableArray *arrResult;

@end

@implementation GYEPMyCouponsMainViewController

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
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];

    menuTitles = @[kLocalized(@"可使用"),
                   kLocalized(@"已使用"),
                   ];
    
    [_scrollV setPagingEnabled:YES];
    [_scrollV setBounces:NO];
    [_scrollV setShowsHorizontalScrollIndicator:NO];
    _scrollV.delegate = self;
    //    [_scrollV.panGestureRecognizer addTarget:self action:@selector(scrollHandlePan:)];
    //    [_scrollV setUserInteractionEnabled:YES];
    [_scrollV setContentSize:CGSizeMake(_scrollV.frame.size.width * menuTitles.count, 150)];
    [_scrollV setBackgroundColor:kDefaultVCBackgroundColor];
    
    //添加 tableview
    arrParentViews = [NSMutableArray array];
    CGRect tableViewFrame = _scrollV.bounds;
    GYEPMyCouponsViewController *tmpVc = nil;
    tmpVc = kLoadVcFromClassStringName(NSStringFromClass([GYEPMyCouponsViewController class]));
    tmpVc.firstTipsErr = YES;
    tmpVc.couponsType = kCouponsTypeUnUse;
    tmpVc.nav = self.navigationController;
    tmpVc.view.frame = tableViewFrame;
    [_scrollV addSubview:tmpVc.view];
    [arrParentViews addObject:tmpVc];
    
    tableViewFrame.origin.x += tableViewFrame.size.width;
    tmpVc = kLoadVcFromClassStringName(NSStringFromClass([GYEPMyCouponsViewController class]));
    tmpVc.firstTipsErr = NO;
    tmpVc.couponsType = kCouponsTypeUsed;
    tmpVc.nav = self.navigationController;
    tmpVc.view.frame = tableViewFrame;
    [_scrollV addSubview:tmpVc.view];
    [arrParentViews addObject:tmpVc];
    
//    tableViewFrame.origin.x += tableViewFrame.size.width;
//    order = kLoadVcFromClassStringName(NSStringFromClass([GYEPMyOrderViewController class]));
//    order.orderState = kOrderStateWaittingConfirmReceiving;
//    order.firstTipsErr = NO;
//    order.nav = self.navigationController;
//    order.view.frame = tableViewFrame;
//    [_scrollV addSubview:order.view];
//    [arrParentViews addObject:order];
//    
//    tableViewFrame.origin.x += tableViewFrame.size.width;
//    order = kLoadVcFromClassStringName(NSStringFromClass([GYEPMyOrderViewController class]));
//    
//    order.orderState = kOrderStateFinished;
//    order.firstTipsErr = NO;
//    order.nav = self.navigationController;
//    order.view.frame = tableViewFrame;
//    [_scrollV addSubview:order.view];
//    [arrParentViews addObject:order];
    
    menu = [[MenuTabView alloc] initMenuWithTitles:menuTitles withFrame:CGRectMake(0, 0, kScreenWidth, 40) isShowSeparator:YES];
    menu.delegate = self;
//    [menu setDefaultItem:1];
    [self.view addSubview:menu];

}

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

#pragma mark - xxx

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
