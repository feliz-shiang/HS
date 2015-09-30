//
//  GYEPMyAllOrdersViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

//全部订单


#define kCellSubCellHeight 80.f

#import "GYEPMyAllOrdersViewController.h"
#import "MenuTabView.h"
#import "GYEasyPurchaseMainViewController.h"
#import "GYEPMyOrderViewController.h"
#import "GYEPMyHEViewController.h"


@interface GYEPMyAllOrdersViewController ()<UIScrollViewDelegate, MenuTabViewDelegate>
{
    MenuTabView *menu;      //菜单视图
    NSArray *menuTitles;    //菜单标题数组
    NSMutableArray *arrParentViews;    //parentView array
    IBOutlet UIScrollView *_scrollV; //滚动视图，用于装载各vc view
}

@property (nonatomic, strong) NSMutableArray *arrResult;

@end

@implementation GYEPMyAllOrdersViewController

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

    menuTitles = @[kLocalized(@"all"),
                   kLocalized(@"ep_myorder_wait_pay"),
                    kLocalized(@"ep_wait_send"),
                   kLocalized(@"ep_wait_get_goods"),
                   kLocalized(@"ep_myorder_wait_goods_receipt")];
    
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
    GYEPMyOrderViewController *order = nil;
    order = kLoadVcFromClassStringName(NSStringFromClass([GYEPMyOrderViewController class]));
    order.orderState = kOrderStateAll;
    order.firstTipsErr = YES;
    order.nav = self.navigationController;
    order.view.frame = tableViewFrame;
    [_scrollV addSubview:order.view];
    [arrParentViews addObject:order];
    
    tableViewFrame.origin.x += tableViewFrame.size.width;
    order = kLoadVcFromClassStringName(NSStringFromClass([GYEPMyOrderViewController class]));
    order.orderState = kOrderStateWaittingPay;
    order.firstTipsErr = NO;
    order.nav = self.navigationController;
    order.view.frame = tableViewFrame;
    [_scrollV addSubview:order.view];
    [arrParentViews addObject:order];
    
    tableViewFrame.origin.x += tableViewFrame.size.width;
    order = kLoadVcFromClassStringName(NSStringFromClass([GYEPMyOrderViewController class]));//m by wang 状态码 2
    order.orderState = kOrderStateWaittingDelivery;
    order.firstTipsErr = NO;
    order.nav = self.navigationController;
    order.view.frame = tableViewFrame;
    [_scrollV addSubview:order.view];
    [arrParentViews addObject:order];
    
    tableViewFrame.origin.x += tableViewFrame.size.width;
    order = kLoadVcFromClassStringName(NSStringFromClass([GYEPMyOrderViewController class]));
    order.orderState = kOrderStateWaittingPickUpCargo;//待自提
    order.firstTipsErr = NO;
    order.nav = self.navigationController;
    order.view.frame = tableViewFrame;
    [_scrollV addSubview:order.view];
    [arrParentViews addObject:order];
    
    tableViewFrame.origin.x += tableViewFrame.size.width;
    order = kLoadVcFromClassStringName(NSStringFromClass([GYEPMyOrderViewController class]));
    
    order.orderState = kOrderStateWaittingConfirmReceiving;//待发货 3 、8
    order.firstTipsErr = NO;
    order.nav = self.navigationController;
    order.view.frame = tableViewFrame;
    [_scrollV addSubview:order.view];
    [arrParentViews addObject:order];
    
    menu = [[MenuTabView alloc] initMenuWithTitles:menuTitles withFrame:CGRectMake(0, 0, kScreenWidth, 40) isShowSeparator:NO];
    menu.delegate = self;
//    [menu setDefaultItem:1];
    [self.view addSubview:menu];

    //重写左侧按钮点击事件
    UIImage* image= kLoadPng(@"nav_btn_back");
    CGRect backframe= CGRectMake(0, 0, image.size.width * 0.5, image.size.height * 0.5);
    UIButton* backButton= [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = backframe;
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton setTitle:@"" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
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

- (void)pop
{
    //如果从商品详情页进入则返回首页，否则返回上一页，我的订单
    if ([self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2] isKindOfClass:[GYEPMyHEViewController class]]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
