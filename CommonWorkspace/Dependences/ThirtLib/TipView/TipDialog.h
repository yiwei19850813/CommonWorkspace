//
//  TipDialog.h
//  WaitView
//
//  Created by wxj wu on 11-12-9.
//  Copyright (c) 2011年 tt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipDialog : UIView
{
    UIFont *_font;                 // 提示文字的字体
    UILabel *_tipLabel;            // 显示提示文字的标签
    NSString *_tip;                // 提示的文字
    UIWindow *_window;             // 加载提示框的window
    BOOL _isModal;                 // 是否模态
    
    // add by bwzhu 2013-2-18
    CGFloat  _timeRate;             // 显示的时间比例，默认为1.0，大于1.0则延长显示，反之缩短显示
}

// 提示tip内容
+ (void)runTipDialogWithTip:(NSString *)tip;

// 提示tip内容，如果tip为nil 或“”，则提示defaultStr
+ (void)runTipDialogWithTip:(NSString *)tip defaultStr:(NSString *)defaultStr;

+ (void)runTipDialogWithTip:(NSString *)tip needModalStatus:(BOOL)isModal;
- (id)initWithTip:(NSString *)tip;
- (id)initWithTip:(NSString *)tip needModalStatus:(BOOL)isModal;
- (void)setTip:(NSString *)tip;
- (void)showWithAnimate:(BOOL)animate;
+ (void)releaseTipDialogMgr;
- (void)done;

// add by bwzhu 2013-2-18
+ (void)runTipDialogWithTip:(NSString *)tip timeRate:(CGFloat)timeRate;
- (id)initWithTip:(NSString *)tip timeRate:(CGFloat)timeRate;
@end
