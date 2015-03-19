//
//  BaseTableViewCell.h
//  ISingV3
//
//  Created by sbfu on 14/12/31.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell

//Default:NO
@property (nonatomic, assign)BOOL isSeparatorHidden;
//Default:210 210 210
@property (nonatomic, strong)UIColor *separatorColor;
//Default:0.5
@property (nonatomic, strong)NSNumber *separatorHeight;

@end
