//
//  BaseCollectionView.m
//  MiguMV
//  可以添加刷新和加载更多的CollectionView
//  Created by Jun Li on 14-8-18.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import "BaseCollectionView.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "MJRefresh.h"
#import "UIView+HintView.h"

@interface BaseCollectionView ()
{
    UIView *_noMoewView;             //没有更多的view.
}
/**
 *  结语视图
 */
@property (nonatomic)UIView *hintView;

@end


@implementation BaseCollectionView

- (instancetype)init
{
    if(self = [super init]){
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

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
    [self addHeaderWithTarget:self action:@selector(refresh)];
    
    self.headerPullToRefreshText = @"下拉刷新";
    self.headerReleaseToRefreshText = @"松开刷新";
    self.headerRefreshingText = @"刷新中...";
}

// 添加加载更多控件
- (void)addLoadMoreControl
{
    __weak typeof(self) wself = self;
    [self addInfiniteScrollingWithActionHandler:^{
        if([wself.pullDelegate respondsToSelector:@selector(request:forView:)]){
            [wself.pullDelegate request:Req_LoadMore forView:wself];
        }else{
            [wself didLoadMoreFinished];
        }
    }];
}

- (void)refresh
{
    if([self.pullDelegate respondsToSelector:@selector(request:forView:)]){
        [self.pullDelegate request:Req_Refresh forView:self];
    }else{
        [self headerEndRefreshing];
    }
}

- (void)refreshData
{
    [self headerBeginRefreshing];
}

- (void)setHasMore:(BOOL)hasMore
{
    [self setShowsInfiniteScrolling:hasMore];
    self.infiniteScrollingView.enabled = hasMore;
}

- (void)didRefreshFinished
{
    [self headerEndRefreshing];
}

- (void)didLoadMoreFinished
{
    [self.infiniteScrollingView stopAnimating];
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
    self.hintView = [UIView getHintViewWithType:hintViewType withBounds:self.bounds];
    self.hintView.hidden = NO;
    self.hintView.alpha = 1.0f;
    
    //TODO:这里需要调试
    [self setBackgroundView:self.hintView];
//    
//    [self.view addSubview:self.hintView];
//    [self.view bringSubviewToFront:self.hintView];
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
        [wself setBackgroundView:nil];
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
