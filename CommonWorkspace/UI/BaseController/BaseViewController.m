//
//  BaseViewController.m
//  MiguMV
//
//  Created by xdyang on 14-8-15.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import "BaseViewController.h"
#import "UIView+HintView.h"
#import "UploadService.h"

@interface BaseViewController () <UploadResourceDelegate>
/**
 *  结语视图
 */
@property (nonatomic)UIView *hintView;

//message button上面的红点
@property (nonatomic, strong)UIImageView *redDotView;

@end

@implementation BaseViewController

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
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarToDefaultStyle];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    self.navigationController.navigationBar.translucent = NO;
    
    self.view.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
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

- (void)onMiddleItem
{

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

- (BOOL)showDrawerToolBar
{
    return NO;
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
