//
//  CountTipView.h
//  iSing
//
//  Created by bwzhu on 13-9-9.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountTipView : UIImageView
{
    UILabel             *_countLabel;
    UIImage             *_img;
}

- (id)initWithCount:(int)count origalPoint:(CGPoint)point;

- (void)setCount:(int)count;

@end
