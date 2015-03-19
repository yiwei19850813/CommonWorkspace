//
//  BaseTableViewController.m
//  MiguMV
//
//  Created by xdyang on 14-8-16.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import "BaseTableViewController.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "MJRefresh.h"
#import "UIView+HintView.h"
#import "ShareViewController.h"

@interface BaseTableViewController ()
{
    UIView *_noMoewView;             //没有更多的view.
}
/**
 *  结语视图
 */
@property (nonatomic)UIView *hintView;

//message button上面的红点
@property (nonatomic, strong)UIImageView *redDotView;

@property (nonatomic, strong)ShareViewController *viewcon;

@end

@implementation BaseTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarToDefaultStyle];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    self.navigationController.navigationBar.translucent = NO;
    
    self.view.backgroundColor = self.view.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    
}

- (void)unreadMessageCountChanged:(NSNotification *)notification
{
    
}

- (BOOL)showDrawerToolBar
{
    return NO;
}

- (void)onMiddleItem
{
    _viewcon = [ShareViewController instance];
    [_viewcon show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    if (title.length > 4) {
        [self.navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeFont:[UIFont systemFontOfSize:18],
                                                                          UITextAttributeTextColor:[UIColor whiteColor]}];
    } else {
        [self.navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeFont:[UIFont systemFontOfSize:20],
                                                                          UITextAttributeTextColor:[UIColor whiteColor]}];
    }
}

#pragma mark - Table view data source


#pragma mark - 网络请求相关
/**
 *  网络请求
 */
- (void)request:(RequestType)type forView:(UIScrollView *)scrollView;
{
    
}

#pragma mark-   添加控件相关
- (void)addRefreshAndLoadMore
{
    // 添加刷新控件
    [self addRefresControl];
    // 添加加载更多
    [self addLoadMoreControl];
}

// 添加UIRefreshControl下拉刷新控件到UITableViewController的view中
-(void)addRefresControl
{
    [self.tableView addHeaderWithTarget:self action:@selector(refresh)];
    
    self.tableView.headerPullToRefreshText = @"下拉刷新";
    self.tableView.headerReleaseToRefreshText = @"松开刷新";
    self.tableView.headerRefreshingText = @"刷新中...";
}

// 添加加载更多控件
- (void)addLoadMoreControl
{
    __weak typeof(self) wself = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        if([wself respondsToSelector:@selector(request:forView:)]){
            [wself request:Req_LoadMore forView:wself.tableView];
        }else{
            [wself didLoadMoreFinished];
        }
    }];
}

- (void)refresh
{
    if([self respondsToSelector:@selector(request:forView:)]){
        [self request:Req_Refresh forView:self.tableView];
    }else{
        [self.tableView headerEndRefreshing];
    }
}

- (void)refreshData
{
    [self.tableView headerBeginRefreshing];
}

- (void)setHasMore:(BOOL)hasMore
{
    [self.tableView setShowsInfiniteScrolling:hasMore];
    [self.tableView setTableFooterView:hasMore ? nil : _noMoewView];
    self.tableView.infiniteScrollingView.enabled = hasMore;
}

- (void)didRefreshFinished
{
    [self.tableView headerEndRefreshing];
}

- (void)didLoadMoreFinished
{
    [self.tableView.infiniteScrollingView stopAnimating];
}

#pragma mark - 结语相关
/**
 *  检查网络连接，并在没有网络连接的时候显示无网络提示语视图
 *
 *  @return 当前是否连网
 */
- (BOOL)checkNetworkAndShowHintView
{
    BOOL connect = [[NetworkManager getInstance] isConnectToNet];
    if(!connect){
        [self showHintViewWithType:HintView_NoNetwork];
    }
    return connect;
}

/**
 *  显示提示结语视图
 *
 *  @param hintViewType 视图的类型
 */
- (void)showHintViewWithType:(HintViewType)hintViewType
{
    self.hintView = nil;
    self.hintView = [UIView getHintViewWithType:hintViewType];
    self.hintView.hidden = NO;
    self.hintView.alpha = 1.0f;
    
    [self.view addSubview:self.hintView];
    [self.view bringSubviewToFront:self.hintView];
}

/**
 *  隐藏提示语视图
 */
- (void)hideHintView
{
    __weak typeof(self) wself = self;
    [UIView animateWithDuration:0.4 animations:^{
        wself.hintView.alpha = 0.0f;
    }completion:^(BOOL finished){
        wself.hintView.hidden = YES;
        [wself.hintView removeFromSuperview];
    }];
}

/**
 *  调整结语视图的位置
 *
 *  @param offset 为正则向下调整abs(offset)的高度，为负则向上调整abs(offset)的高度
 */
- (void)changeHintViewWithOffset:(CGFloat)offset
{
    UIView *view = [self.hintView viewWithTag:HintViewImageTag];
    if(view){
        CGRect rect = view.frame;
        rect.origin.y += offset;
        view.frame = rect;
    }
    view = [self.hintView viewWithTag:HintViewLabelTag];
    if(view){
        CGRect rect = view.frame;
        rect.origin.y += offset;
        view.frame = rect;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DLOG(@"===============================++++++++\n");
    NSLog(@"页面%@ 释放",self);
    DLOG(@"===============================++++++++\n");
}


@end
