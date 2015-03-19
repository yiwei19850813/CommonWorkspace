//
//  CountTipView.m
//  iSing
//
//  Created by bwzhu on 13-9-9.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//

#import "CountTipView.h"

@implementation CountTipView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init
{
    if (self = [super init])
    {
        _countLabel = [[[UILabel alloc] init] autorelease];
        _countLabel.backgroundColor = [UIColor clearColor];
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.font = [UIFont boldSystemFontOfSize:8];
        [_countLabel sizeToFit];
        
        _img = [[[UIImage imageNamed:@"new_followed.png"] stretchableImageWithLeftCapWidth:8 topCapHeight:0] retain];
        [self addSubview:_countLabel];
    }
    return self;
}

- (id)initWithCount:(int)count origalPoint:(CGPoint)point
{
    if (self = [self init])
    {
        _countLabel.text = [NSString stringWithFormat:@"%d",count];        
        self.frame = CGRectMake(point.x, point.y, _countLabel.frame.size.width + 12, 15);
        [self addSubview:_countLabel];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [_img release];
    
    [super dealloc];
}


- (void)setCount:(int)count
{
    self.hidden = count == 0;
    _countLabel.text = [NSString stringWithFormat:@"%d",count];
    [_countLabel sizeToFit];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [_countLabel sizeToFit];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, _countLabel.frame.size.width + 12, 15);
    _countLabel.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5 - 1);
    self.image = _img;
    self.hidden = _countLabel.text.intValue == 0;
}

@end
