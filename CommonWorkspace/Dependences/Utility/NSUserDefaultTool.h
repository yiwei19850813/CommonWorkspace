//
//  NSUserDefaultTool.h
//  nextSing
//
//  Created by chester.lee on 14-3-12.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  add User Default Keys Here!
 */

#define AppUid      @"AppUid"       //APPID，ISingManager 使用
#define ISing_IMEI  @"iSing_imei"   //UIDevice_IMEI TOOLS 使用
#define LastCity    @"LastCity"     //最新一次的GPS信息，主页登录。LocationManager使用

#define UserDefault_UID @"userdefault_uid"  //UID，第一次启动需要更新

#define LastVersion @"LastVersionKey"


#pragma mark - 启动页图片配置url
#define HOME_PIC_URL_KEY @"homepicurl" //当前已配置下载好的启动也图片URL


#define NSUserDefaultKey_LaunchTimes  @"ISing_Launch_Times"             // ISing启动次数，NSNumber类
#define NSUserDefaultKey_LastGradeDate @"BegForGrade_Last_Grade_Date"   // 上次打分日期，NSDate类
#define ISing_AppleID @"714720925"   // 苹果ID，
#pragma 消息推送相关Key
//===============================
// device token 对应的key
#define DeviceToken         @"token"
// 版本号 对应的key
#define Version             @"version"
// 渠道号 对应的key
#define DownFrom            @"downfrom"
// 应用程序号 对应的key
#define AppId               @"appid"
//===============================

//===============================

#pragma mark - 系统设置相关  BOOL

//限制在Wifi下 下载，播放，上传。
#define SettingWifiRestriction @"WifiRestriction"
//屏幕常亮
#define SettingScreenBumSteady @"ScreenBumSteady"
//消息提示音
#define SettingCautionSound @"SettingCautionSound"
//消息弹框提示
#define SettingShowCautionView @"SettingShowCautionView"
//显示私信提示
#define SettingShowPrivateMessage @"SettingPrivateMessage"
//显示评论或回复
#define SettingShowCommentAndReply @"SettingShowCommentAndReply"
//显示被收藏
#define SettingShowBeenCollected @"SettingShowCollected"
//显示新粉丝
#define SettingShowNewFans @"SettingShowNewFans"
//显示收到鲜花
#define SettingShowFlower @"SettingShowFlower"

//当前系统已登出
#define SettingHasLogOut @"SettingHasLogOut"

/**
    User Default对应的存储工具区域，请注意：
    如果要定义当前UserDefault的key，就都在这里统一定义。
    新增的内容，请添加静态接口
 */

@interface NSUserDefaultTool : NSObject

/**
 *  向User Default中添加对应的数据
 *
 *  @param object    对象
 *  @param keyString key
 *
 *  @return 操作是否成功
 */
+ (BOOL)updateObject:(id)object forKey:(NSString *)keyString;



/**
 *  返回User Default中key对应的数据
 *
 *  @param keyString key
 *
 *  @return 对象
 */
+ (id)ObjectForKey:(NSString *)keyString;

+ (BOOL)updateBool:(BOOL)value  forKey:(NSString *)keyString;
+ (BOOL)boolForKey:(NSString *)keyString;

@end
