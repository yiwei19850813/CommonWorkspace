//
//  BaseViewController.h
//  MiguMV
//  description:所有ViewController的基类

/*
 
 */
//  Created by xdyang on 14-8-15.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic, strong)UIButton *menuButton, *messageButton, *makeMVButton;

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
 *  @param offset 为正则向下调整abs(offset)的高度，为负则向上调整abs(offset)的高度
 */
- (void)changeHintViewWithOffset:(CGFloat)offset;

@end
