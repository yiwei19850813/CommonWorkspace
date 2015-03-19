//
//  BaseCollectionView.h
//  MiguMV
//  description:
//  Created by Jun Li on 14-8-18.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaseCollectionViewDelegate <NSObject>

@required
//刷新时的网络请求
- (void)request:(RequestType)type forView:(UIScrollView *)scrollView;

@end


@interface BaseCollectionView : UICollectionView

@property(weak, nonatomic) id<BaseCollectionViewDelegate> pullDelegate;

#pragma mark-   添加控件相关
/**
 *  外部调用添加刷新和加载更多控件
 */
- (void)addRefreshAndLoadMore;

/**
 *  添加刷新控件
 */
- (void)addRefresControl;

/**
 *  添加加载更多控件
 */
- (void)addLoadMoreControl;

#pragma mark - 控制刷新相关
/**
 *  主动刷新,可以用在进入控件的时候就刷新
 */
- (void)refreshData;

/**
 *  设置是否还有更多数据
 *
 *  @param hasMore 是否存在更多
 */
- (void)setHasMore:(BOOL)hasMore;

/**
 *  刷新完成后调用, 关闭刷新控件
 */
- (void)didRefreshFinished;

/**
 *  加载更多完成后调用，关闭更多
 */
- (void)didLoadMoreFinished;



#pragma mark - 结语相关
/**
 *  检查网络连接，并在没有网络连接的时候显示无网络提示语视图
 *
 *  @return 当前是否连网
 */
- (BOOL)checkNetworkAndShowHintView;

/**
 *  显示提示语视图
 *
 *  @param hintViewType 视图的类型
 */
- (void)showHintViewWithType:(HintViewType)hintViewType;

/**
 *  隐藏提示语视图
 */
- (void)hideHintView;

/**
 *  调整结语视图的位置
 *
 *  @param offset 为正则向上调整abs(offset)的高度，为负则向下调整abs(offset)的高度
 */
- (void)changeHintViewWithOffset:(CGFloat)offset;

@end
