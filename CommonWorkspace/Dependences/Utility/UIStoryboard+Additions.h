//
//  UIStoryboard+Additions.h
//  MiguMV
//
//  Created by sbfu on 14-8-18.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIStoryboard (Additions)

+ (instancetype)messageStoryboard;

+ (instancetype) systemSettingStoryboard;

+ (instancetype)loginAndRegisterStoryboard;

+ (instancetype)userCenterStoryboard;

+ (instancetype)menuStoryboard;

+ (instancetype)mainStoryboard;

+(instancetype) myTagStoryboard;

+ (instancetype)createMVStoryboard;

+ (instancetype)myMVStoryboard;

+ (instancetype)appreciateStoryboard;

+ (instancetype)discoveryStoryboard;

+ (instancetype)activityStoryboard;

+ (instancetype)selectSongStoryboard;

+ (instancetype)kRoomStoryboard;

//根据类获取view controller instance, 前提是Storyboard ID是用的类名
- (UIViewController *)instanceWithClass:(Class)c;


@end
