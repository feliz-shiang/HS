//
//  GYSearchShopGoodsHistoryViewController.m
//  HSConsumer
//
//  Created by zhangqy on 15/9/16.
//  Copyright (c) 2015年 guiyi. All rights reserved.
//
#define GYSearchShopGoodsHistoryUserDefaultsKey @"GYSearchShopGoodsHistoryUserDefaultsKey"
#import "GYSearchShopGoodsHistoryViewController.h"
#import "UIButton+enLargedRect.h"

@interface GYSearchShopGoodsHistoryViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)UITextField *searchField;
@property (strong, nonatomic)UIButton *leftBtn;
@property (strong, nonatomic)NSMutableArray *searchHistory;
@property (strong, nonatomic) IBOutlet UIButton *clearBtn;
@property (assign, nonatomic)CGRect keyboardFrame;
@end

@implementation GYSearchShopGoodsHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setupNav];
    [_searchField becomeFirstResponder];
    NSArray * history = [[NSUserDefaults standardUserDefaults]objectForKey:GYSearchShopGoodsHistoryUserDefaultsKey];
    if (history) {
        _searchHistory = [NSMutableArray arrayWithArray:history];
    }
    else
    {
        _searchHistory = [NSMutableArray array];
    }
     NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    [_clearBtn addTarget:self action:@selector(clearBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_clearBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_clearBtn setBorderWithWidth:1/[UIScreen mainScreen].scale andRadius:5.0f andColor:[UIColor redColor]];
    CGPoint center = _tableView.center;
    center.y +=(_tableView.frame.size.height/2-7);
    _clearBtn.center = center;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)keyboardWillShow:(NSNotification*)noti
{
    _keyboardFrame = [[noti.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    _tableView.frame = CGRectMake(0, 0, kScreenWidth, _keyboardFrame.origin.y - 40-64);
    _clearBtn.center = CGPointMake(kScreenWidth/2, _keyboardFrame.origin.y - 19-64);
}

- (void)keyboardWillHidden:(NSNotification*)noti
{
    _tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-180);
    _clearBtn.center = CGPointMake(kScreenWidth/2, kScreenHeight-160);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (kSystemVersionLessThan(@"7.0")) //ios < 7.0
    {
        //设置Navigation颜色
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }else
    {
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    }
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (kSystemVersionLessThan(@"7.0")) //ios < 7.0
    {
        //设置Navigation颜色
        self.navigationController.navigationBar.tintColor = kNavigationBarColor;
    }else
    {
        self.navigationController.navigationBar.barTintColor = kNavigationBarColor;
    }
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleBlackOpaque];
}

- (void)setupNav {
    _searchField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-120, 30)];
    _searchField.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0f];
    UIImageView *leftSearchIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 12)];
    leftSearchIV.image = [UIImage imageNamed:@"image_search_front"];
    leftSearchIV.contentMode = UIViewContentModeScaleAspectFit;
    _searchField.leftView = leftSearchIV;
    _searchField.leftViewMode = UITextFieldViewModeAlways;
    _searchField.textColor = [UIColor grayColor];
    _searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchField.placeholder = @"搜索店铺内商品";
    _searchField.keyboardType = UIKeyboardTypeDefault;
    _searchField.returnKeyType = UIReturnKeySearch;
    _searchField.delegate = self;
    [self.navigationItem.leftBarButtonItem setTintColor:kNavigationTitleColor];
    self.navigationItem.titleView = _searchField;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"nav_btn_redback"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 40, 20);
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    _leftBtn=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = _leftBtn;
    [btn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)backBtnClicked:(UIButton*)btn
{
    [_searchField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchHistory.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = (int)indexPath.row;
    int count = (int)_searchHistory.count;
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchHistoryCell"];
    cell.textLabel.text = _searchHistory[count-row-1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_searchField resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int row = (int)indexPath.row;
    int count = (int)_searchHistory.count;

        NSString *searchText = _searchHistory[count-row-1];
        _searchField.text = searchText;
        searchText = [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    GYSearchShopGoodsViewController *delegateVC = self.delegate;
        [delegateVC.params setObject:searchText forKey:@"keyword"];
        
        [delegateVC.params setObject:@"" forKey:@"categoryName"];
    [delegateVC performSelector:@selector(loadDataAll)];
    
    [self.navigationController popViewControllerAnimated:YES];
        
    
    
}


-(void)clearBtnClicked:(UIButton*)btn
{
    [_searchHistory removeAllObjects];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:GYSearchShopGoodsHistoryUserDefaultsKey];
    [self.tableView reloadData];
}

#pragma mark  UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    

    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchBtnClicked:nil];
    return YES;
}

- (void)searchBtnClicked:(UIBarButtonItem *)btn{
    [_searchField resignFirstResponder];
    NSString *keyword = _searchField.text;
    if (keyword&&keyword.length>0) {
        int k=0;
        for (; k<_searchHistory.count; k++) {
            NSString *str = _searchHistory[k];
            if ([str isEqualToString:keyword]) {
                break;
            }
        }
        if (k>=_searchHistory.count) {
            [_searchHistory addObject:keyword];
            [[NSUserDefaults standardUserDefaults]setObject:_searchHistory forKey:GYSearchShopGoodsHistoryUserDefaultsKey];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self.tableView reloadData];
        }
        keyword = [keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[self.delegate params] setObject:keyword forKey:@"keyword"];
        
        
    }
    else
    {
        [[self.delegate params] setObject:@"" forKey:@"keyword"];
    }
    
    [[self.delegate params] setObject:@"" forKey:@"categoryName"];

    [self.delegate performSelector:@selector(loadDataAll)];
    
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
