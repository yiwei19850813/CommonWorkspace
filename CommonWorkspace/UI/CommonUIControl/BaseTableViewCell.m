//
//  BaseTableViewCell.m
//  ISingV3
//
//  Created by sbfu on 14/12/31.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface BaseTableViewCell ()

@property (nonatomic, strong)UIView *separator;
@property (nonatomic, strong)NSArray *separatorConstraints;

@end

@implementation BaseTableViewCell

@synthesize separatorHeight = _separatorHeight;
@synthesize separatorColor = _separatorColor;

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self updateSeparatorConstraints];
}

- (UIView *)separator
{
    if (_separator == nil) {
        _separator = [UIView new];
        [self.contentView addSubview:_separator];
    }
    return _separator;
}

- (UIColor *)separatorColor
{
    if (_separatorColor == nil) {
        return [UIColor colorWithR:210 G:210 B:210];
    }
    return _separatorColor;
}

- (NSNumber *)separatorHeight
{
    if (_separatorHeight == nil) {
        return @0.5;
    }
    return _separatorHeight;
}

- (void)setSeparatorColor:(UIColor *)separatorColor
{
    if (_separatorColor == separatorColor) {
        return;
    }
    _separatorColor = separatorColor;
    self.separator.backgroundColor = _separatorColor;
}

- (void)setSeparatorHeight:(NSNumber *)separatorHeight
{
    if (_separatorHeight.floatValue == separatorHeight.floatValue) {
        return;
    }
    _separatorHeight = separatorHeight;
    [self updateSeparatorConstraints];
}

- (void)setIsSeparatorHidden:(BOOL)isSeparatorHidden
{
    if (_isSeparatorHidden == isSeparatorHidden) {
        return;
    }
    _isSeparatorHidden = isSeparatorHidden;
    [self updateSeparatorConstraints];
}

- (void)updateSeparatorConstraints
{
    self.separator.hidden = self.isSeparatorHidden;
    if (!self.isSeparatorHidden) {
        if (_separatorConstraints.count > 0) {
            [self.separator removeConstraints:_separatorConstraints];
        }
        NSMutableArray *temp = [NSMutableArray new];
        [temp addObjectsFromArray:[self.separator autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(self.contentView.height - self.separatorHeight.floatValue, 0, 0, 0)]];
        [temp addObjectsFromArray:[self.separator autoSetDimensionsToSize:CGSizeMake(self.contentView.width, self.separatorHeight.floatValue)]];
        _separatorConstraints = temp;
        
        [self.contentView setNeedsLayout];
        [self.contentView layoutIfNeeded];
        NSLog(@"%@", NSStringFromCGRect(self.contentView.frame));
    }
}


@end











