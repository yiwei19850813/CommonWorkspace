//
//  BaseCollectionViewController.m
//  MiguMV
//
//  Created by xdyang on 14-8-16.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import "BaseCollectionViewController.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "MJRefresh.h"
#import "UIView+HintView.h"

@interface BaseCollectionViewController ()
{
    UIView *_noMoewView;             //没有更多的view.
}
/**
 *  结语视图
 */
@property (nonatomic)UIView *hintView;

@end

@implementation BaseCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarToDefaultStyle];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    self.navigationController.navigationBar.translucent = NO;
    
    self.view.backgroundColor = self.view.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 网络请求相关
/**
 *  网络请求
 */
- (void)request:(RequestType)type forView:(UIScrollView *)scrollView
{
    
}

#pragma mark - 添加刷新和下拉加载更多控件
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
    [self.collectionView addHeaderWithTarget:self action:@selector(refresh)];
    
    self.collectionView.headerPullToRefreshText = @"下拉刷新";
    self.collectionView.headerReleaseToRefreshText = @"松开刷新";
    self.collectionView.headerRefreshingText = @"刷新中...";
}

// 添加加载更多控件
- (void)addLoadMoreControl
{
    __weak typeof(self) wself = self;
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        if([wself respondsToSelector:@selector(request:forView:)]){
            [wself request:Req_LoadMore forView:wself.collectionView];
        }else{
            [wself didLoadMoreFinished];
        }
    }];
}

- (void)refresh
{
    if([self respondsToSelector:@selector(request:forView:)]){
        [self request:Req_Refresh forView:self.collectionView];
    }else{
        [self.collectionView headerEndRefreshing];
    }
}

- (void)refreshData
{
    [self.collectionView headerBeginRefreshing];
}

- (void)setHasMore:(BOOL)hasMore
{
    [self.collectionView setShowsInfiniteScrolling:hasMore];
    self.collectionView.infiniteScrollingView.enabled = hasMore;
}

- (void)didRefreshFinished
{
    [self.collectionView headerEndRefreshing];
}

- (void)didLoadMoreFinished
{
    [self.collectionView.infiniteScrollingView stopAnimating];
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
