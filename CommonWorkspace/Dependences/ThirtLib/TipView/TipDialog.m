//
//  TipDialog.m
//  WaitView
//
//  Created by wxj wu on 11-12-9.
//  Copyright (c) 2011年 tt. All rights reserved.
//
//  Important  History:
//  index    version       date             author        notes
//  0        1.0           2012/01/30       xjwu2         添加了提示框的管理操作，让提示框依次出现，避免重叠

#import "TipDialog.h"
#import "AppDelegate.h"
#import "NSString+NSStringAddition.h"

#define TIP_MAX_WIDTH 180                           // 提示语区域的最大宽度
#define TIP_DEFAULT_WIDTH       100                 // 提示语区域的默认宽度
#define TIP_DEFAULT_HEIGHT      100                 // 提示语区域默认的高度
#define TIP_TEXT_V_EDGE_SPACE   20                  // 提示文字距离上边界的距离
#define TIP_TEXT_H_EDGE_SPACE   10                  // 提示文字距离横向边界的距离
#define TIP_SHOW_TIME           (0.6/8)             // 提示对话框存在的时间
#define TEXT_LENGTH_CELL        7


@implementation TipDialog

// 存放当当前需要显示和正在显示的提示框
static NSMutableArray * tipDialogMgr = nil;

+ (void)addTipDialog:(TipDialog *)tipDialog
{
    if (nil == tipDialogMgr) 
    {
        tipDialogMgr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [tipDialogMgr addObject:tipDialog];
}

+ (void)removeDialog:(TipDialog *)tipDialog
{
    [tipDialogMgr removeObject:tipDialog];
}

+ (TipDialog *)getFirstTipDialog
{
    if (tipDialogMgr && [tipDialogMgr count]) 
    {
        return [tipDialogMgr objectAtIndex:0];
    }
    return nil;
}

+ (NSInteger)currentTipDialogCount
{
    if (tipDialogMgr) 
    {
        return [tipDialogMgr count];
    }
    return 0;
}

+ (void)releaseTipDialogMgr
{
    [tipDialogMgr release];
}

- (void)done
{
    // 将提示框从tipDialogMgr中移除
    [[self class] removeDialog:self];
    [_window setHidden:YES];
    [self removeFromSuperview];
    
    [_window release];
    _window = nil;
    
    // 显示tipDialogMgr中第一个提示框，如果还有的话
    TipDialog *tipDialog = [[self class] getFirstTipDialog];
    [tipDialog showWithAnimate:YES];
}

- (void)hideUsingAnimation
{
    // Fade out
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.80];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(done)];
    // 0.02 prevents the hud from passing through touches during the animation the hud will get completely hidden
    // in the done method
    self.alpha = 0.02f;
    [UIView commitAnimations];
}

- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void*)context 
{
    // 此处的显示时间需要根据文本的多少进行动态的调整，文本越长，显示的时间相应也越长
    [self performSelector:@selector(hideUsingAnimation) withObject:nil afterDelay:TIP_SHOW_TIME *[_tip length] * _timeRate];
}

+ (void)runTipDialogWithTip:(NSString *)tip
{
    if (nil == tip) 
    {
        return;
    }
    TipDialog *dialog = [[[TipDialog alloc] initWithTip:tip] autorelease];
    [[self class] addTipDialog:dialog];
    if ([[self class] currentTipDialogCount] == 1) 
    {
        [dialog showWithAnimate:YES];
    }
}

+ (void)runTipDialogWithTip:(NSString *)tip defaultStr:(NSString *)defaultStr
{
    NSString *userfulTip = tip;
    if (!userfulTip || [userfulTip stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
    {
        userfulTip = defaultStr;
    }
    [TipDialog runTipDialogWithTip:userfulTip];
}

+ (void)runTipDialogWithTip:(NSString *)tip timeRate:(CGFloat)timeRate
{
    if (nil == tip) 
    {
        return;
    }
    TipDialog *dialog = [[[TipDialog alloc] initWithTip:tip timeRate:timeRate] autorelease];
    [[self class] addTipDialog:dialog];
    if ([[self class] currentTipDialogCount] == 1) 
    {
        [dialog showWithAnimate:YES];
    }
}

+ (void)runTipDialogWithTip:(NSString *)tip needModalStatus:(BOOL)isModal
{
    if (nil == tip) 
    {
        return;
    }
    TipDialog *dialog = [[[TipDialog alloc] initWithTip:tip needModalStatus:isModal] autorelease];
    [dialog showWithAnimate:YES];
}

- (id)init
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    self = [super initWithFrame:rect];
    if (self) 
    {
        _timeRate = 1.0;
        _tipLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _font = [[UIFont systemFontOfSize:16.0f] retain];
        self.userInteractionEnabled = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyBoradShow) name:UIKeyboardDidShowNotification object:nil];
    }
    return self;
}

- (id)initWithTip:(NSString *)tip
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    self = [super initWithFrame:rect];
    if (self) 
    {
        _timeRate = 1.0;
        self.backgroundColor = [UIColor colorWithHex:0 alpha:0.7];
        _tipLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _font = [[UIFont systemFontOfSize:16.0f] retain];
        _tip = [tip copy];
        self.alpha = 0.0f;
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (id)initWithTip:(NSString *)tip timeRate:(CGFloat)timeRate
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    self = [super initWithFrame:rect];
    if (self) 
    {
        _timeRate = timeRate;
        self.backgroundColor = [UIColor colorWithHex:0 alpha:0.7];
        _tipLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _font = [[UIFont systemFontOfSize:16.0f] retain];
        _tip = [tip copy];
        self.alpha = 0.0f;
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (id)initWithTip:(NSString *)tip needModalStatus:(BOOL)isModal
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    self = [super initWithFrame:rect];
    if (self) 
    {
        _timeRate = 1.0;
        self.backgroundColor = [UIColor colorWithHex:0 alpha:0.7];
        _tipLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _font = [[UIFont systemFontOfSize:16.0f] retain];
        _tip = [tip copy];
        self.alpha = 0.0f;
        _isModal = isModal;
        self.userInteractionEnabled = isModal;
    }
    return self;
}
- (void)dealloc
{
    [_window release];
    [_font release];
    [_tip release];
    [_tipLabel release];
    [super dealloc];
}
- (void)layoutSubviews
{
    if (_tip) 
    {
        // 根据文本来重新计算标签的区域
        CGFloat textWidth = [_tip sizeWithFont:_font].width + 20;
        if (textWidth > TIP_MAX_WIDTH) 
        {
            textWidth = TIP_MAX_WIDTH;
        }
        CGFloat oneLineHeight = [NSString heightWithFont:_font];
        // 计算文本的高度
        CGFloat textHeigth = [NSString heightContent:_tip font:_font width:textWidth];
        textHeigth += oneLineHeight + 10;
        // 计算文字显示的区域
        CGRect labelRect = CGRectMake((self.bounds.size.width - textWidth) / 2, (self.bounds.size.height - textHeigth) / 2, textWidth, textHeigth);
        _tipLabel.frame = labelRect;
        _tipLabel.text = _tip;
        _tipLabel.backgroundColor = [UIColor clearColor];
        [_tipLabel setTextColor:[UIColor whiteColor]];
        _tipLabel.textAlignment = UITextAlignmentCenter;
        _tipLabel.numberOfLines = 0;
        [self addSubview:_tipLabel];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (nil == _tip) 
    {
        return;
    }
    CGRect bgRect = _tipLabel.frame;
    bgRect.size.width = _tipLabel.frame.size.width + TIP_TEXT_H_EDGE_SPACE * 2;
    if (TIP_DEFAULT_WIDTH > bgRect.size.width) 
    {
        bgRect.size.width = TIP_DEFAULT_WIDTH;
    }
    if (TIP_DEFAULT_HEIGHT < bgRect.size.height) 
    {
        bgRect.size.height = bgRect.size.height + 2 * TIP_TEXT_V_EDGE_SPACE;
    }
    else
    {
        bgRect.size.height = TIP_DEFAULT_HEIGHT;
    }
    bgRect.origin.x = (self.bounds.size.width - bgRect.size.width) / 2;
    bgRect.origin.y = (self.bounds.size.height - bgRect.size.height) / 2;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Center HUD
    // Draw rounded HUD bacgroud rect
    CGRect boxRect = bgRect;
	// Corner radius
	float radius = 10.0f;
	
    CGContextBeginPath(context);
    CGContextSetGrayFillColor(context, 0.0f, 0.5);
    CGContextMoveToPoint(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect));
    CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMinY(boxRect) + radius, radius, 3 * (float)M_PI / 2, 0, 0);
    CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMaxY(boxRect) - radius, radius, 0, (float)M_PI / 2, 0);
    CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMaxY(boxRect) - radius, radius, (float)M_PI / 2, (float)M_PI, 0);
    CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect) + radius, radius, (float)M_PI, 3 * (float)M_PI / 2, 0);
    CGContextClosePath(context);
    CGContextFillPath(context);
}

- (void)setTip:(NSString *)tip
{
    if (_tip != tip) 
    {
        [_tip release];
        _tip = [tip copy];
    }
}

- (void)showWithAnimate:(BOOL)animate
{
    if (nil == self.superview) 
    {
        if (_window == nil) 
        {
            _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
        }
        _window.windowLevel = UIWindowLevelAlert;
        [_window addSubview:self];
        _window.hidden = NO;
        _window.userInteractionEnabled = _isModal;
    }
    self.alpha = 0.0f;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.20];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished: finished: context:)];
    self.alpha = 1.0f;
    [UIView commitAnimations];
}

@end
