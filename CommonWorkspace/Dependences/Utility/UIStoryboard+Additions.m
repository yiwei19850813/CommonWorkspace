//
//  UIStoryboard+Additions.m
//  MiguMV
//
//  Created by sbfu on 14-8-18.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import "UIStoryboard+Additions.h"

@implementation UIStoryboard (Additions)

+ (instancetype)storyboardWithID:(NSString *)ID
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:ID bundle:[NSBundle mainBundle]];
    return storyboard;
}

+ (instancetype)messageStoryboard
{
    return [UIStoryboard storyboardWithID:@"Message"];
}


+(instancetype)systemSettingStoryboard
{
    return [UIStoryboard storyboardWithID: @"SystemSetting"];
}

+ (instancetype)loginAndRegisterStoryboard
{
    return [UIStoryboard storyboardWithID:@"LoginAndRegister"];
}

+ (instancetype)userCenterStoryboard
{
    return [UIStoryboard storyboardWithID:@"UserCenter"];
}

+ (instancetype)menuStoryboard
{
    return [UIStoryboard storyboardWithID:@"MenuStoryboard"];
}

+ (instancetype)mainStoryboard
{
    return [UIStoryboard storyboardWithID:@"MainStoryboard"];
}

+ (instancetype)createMVStoryboard
{
    return [UIStoryboard storyboardWithID:@"CreateMV"];
}

+ (instancetype)myMVStoryboard
{
    return [UIStoryboard storyboardWithID:@"MyMV"];
}

+(instancetype) myTagStoryboard
{
    return [UIStoryboard storyboardWithID: @"MyTag"];
}

+ (instancetype)appreciateStoryboard
{
    return [UIStoryboard storyboardWithID:@"Appreciate"];
}

- (UIViewController *)instanceWithClass:(Class)c
{
    return [self instantiateViewControllerWithIdentifier:NSStringFromClass(c)];
}

+ (instancetype)discoveryStoryboard
{
    return [UIStoryboard storyboardWithID: @"Find"];
}

+ (instancetype)activityStoryboard
{
    return [UIStoryboard storyboardWithID: @"Activity"];
}

+ (instancetype)selectSongStoryboard
{
    return [UIStoryboard storyboardWithID:@"SelectSong"];
}

+ (instancetype)kRoomStoryboard
{
    return [UIStoryboard storyboardWithID: @"KRoom"];
}

@end
