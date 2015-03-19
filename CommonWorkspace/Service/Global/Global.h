//
//  Global.h
//  MiguMV
//  description:全局相关
/*  
    这里会定义全局的日志开关、消息通知、全局功能还是、常量定义、包含常用头文件
 */
//  Created by xdyang on 14-8-15.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define AppID 714720925

/***********************************************/
#pragma mark  全局功能宏相关:

#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight [UIScreen mainScreen].bounds.size.height
#define KDeviceHeightNoBar [[UIScreen mainScreen] applicationFrame].size.height
#define KDeviceStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height;

#define LogFuctionName DLOG(@"%@", NSStringFromSelector(_cmd))

//设备判断
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//是否是3.5英寸
#define Itch35 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//系统判断
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define ios7   ((([[UIDevice currentDevice].systemVersion floatValue]) == 7.0)?YES:NO)
#define ios7AndLater ((([[UIDevice currentDevice].systemVersion floatValue]) >= 7.0)?YES:NO)
#define beforeiOS6  ((([[UIDevice currentDevice].systemVersion floatValue]) >= 6.0)?YES:NO)

#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))

#define Color(pred, pgreen, pblue, palpha) [UIColor colorWithRed:pred/255.0 \
green:pgreen/255.0 \
blue:pblue/255.0 \
alpha:palpha]

#define AppDownloadURL                      @"http://a.app.qq.com/o/simple.jsp?pkgname=com.iflytek.ihou.chang.app"


/***********************************************/
#pragma mark - 全局消息通知定义



/***********************************************/
#pragma mark - 常量定义

// appstore  该标志位同时标示这个.app是否是越狱的
#define AppStore_Version  1  //是否为appStore版本

#define DefaultCellHightedHexColor  0x20242f

#define User_Location_Province      @"userProvince"
#define User_Location_City          @"userCity"
#define User_Location_Changed       @"userlocationchanged"//针对手动修改城市信息

#define KEYCHAIN_USERNAME       @"keychain.username"
#define KEYCHAIN_SERVICE        @"com.iflytek.miguMV"
#define UserInfo_LoginType      @"UserInfo_LoginType"
#define UserInfo_Openid         @"UserInfo_Openid"
#define UserInfo_Dic_Name       @"userinfodic"
#define UserInfo_MV_Count       @"userinfo_MVcount"
#define Search_KRoom_History    @"Search_KRoom_History"
#define Search_KRoomMember_History  @"Search_KRoomMember_History"
#define Search_MiguUser_History @"Search_MiguUser_History"

#define User_Login_Or_Info_Changed  @"userloginorinfochanged"//登录状态或者用户信息发生变化
#define User_Logout_Notification  @"userlogout"//用户登出
#define User_Info_Changed_Notification @"UserInfoChangedNotification"

#define KRoom_InfoChanged       @"KRoomInfoChanged"
#define KRoomQuit_Or_Dissolve   @"KRoomQuitOrDissolve"

#define MediaPlayerStartPlaying @"MediaPlayerStartPlaying"
#define MediaPlayerStopPlaying  @"MediaPlayerStopPlaying"
#define UserDeletedWork         @"UserDeletedWork"

#define ApplicationDidReceiveRemoteNotification @"ApplicationDidReceiveRemoteNotification"

static int IM_NeedShowTimeButtonInterval = 60;
static int ToolBarHeight = 49;
#define RecommandUploadHeadImageSize 640

/***********************************************/
#pragma mark - 日志开关
/* general debug */
#define DEBUG_GENERAL 1
/* network debug */
#define DEBUG_NETWORK 1
/* database debug */
#define DEBUG_DATABASE 1
/* media debug */
#define DEBUG_MEDIA 1
// 文件日志宏
#define DEBUG_FILE_LOG  1
// 是否开启友盟，1为开启，0为关闭
#define IS_OPEN_UMENG  1
// 当开启友盟后，是否开启友盟 文件日志，1为开启，0为关闭
#define IS_OPEN_UMENG_FILELOG 1
// Socket日志
#define Socket_Log    1

#if (DEBUG_GENERAL == 1)
#define DLOG(...) NSLog(__VA_ARGS__)
#else
#define DLOG(...)
#endif

#if (Socket_Log == 1)
#define SocketLOG(...) NSLog(__VA_ARGS__)
#else
#define SocketLOG(...)
#endif


#if (DEBUG_NETWORK == 1)
#define NDLOG(fmt,...) NSLog((@"%s [line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define NDLOG(...)
#endif

#if (DEBUG_DATABASE == 1)
#define DDLOG(fmt,...) NSLog((@"%s [line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DDLOG(...)
#endif

#if (DEBUG_MEDIA == 1)
#define MDLOG(fmt,...) NSLog((@"%s [line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define MDLOG(...)
#endif

#if (DEBUG_FILE_LOG == 1)
#define FLOG(str)  [FileOperation writeToLogFile:str]
#else
#define FLOG(str)
#endif

#if (IS_OPEN_UMENG == 1 && IS_OPEN_UMENG_FILELOG == 1)
#define UFLOG(str)  [FileOperation writeToLogFile:str]
#else
#define UFLOG(str)
#endif


/***********************************************/
#pragma mark - 全局功能函数



/***********************************************/
#pragma mark - 常用头文件包含

#import "AppDelegate.h"
#import "ColorDefined.h"
#import "EnumDefine.h"
#import "AppStartManager.h"

#import "UIDevice+ScreenSizeV2.h"

#import "AppStartManager.h"
#import "UIBarButtonItem+systemButtons.h"
#import "SocialEngine.h"
#import "DataStoreManager.h"
#import "MobClick.h"

#import "TipDialog.h"

#import "UIView+HintView.h"
#import "UITextField+Addtional.h"
#import "NSString+NSStringAddition.h"
#import "UIStoryboard+Additions.h"
#import "UIImageView+Factory.h"
#import "UIButton+Factory.h"
#import "LargeClickZoneButton.h"

#import "NSData+NSDataAdditions.h"

#import "NSArray+help.h"

#import "UIColor+Additions.h"

#import "UIImage+WriteToFile.h"

#import "FileOperation.h"

#import "NetworkUtility.h"

#import "SelectSongHistoryManager.h"

#import "NSUserDefaultTool.h"

#import "NetworkInterfaceDefine.h"
#import "UINavigationController+setNavigationBarToDefaultStyle.h"
#import "DrawerMenuViewController.h"
#import "BaseTableViewCell.h"
//三方库头文件
#import "UIView+Positioning.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD.h"
#import "SVProgressHUD+Migu.h"
#import "NSString+Convert.h"
#import "JSONKit.h"
#import "UIColor+Hex.h"
#import "UIImage+Additions.h"
#import "NSObject+AssociatedObject.h"
#import "UIAlertView+Blocks.h"
#import "UIActionSheet+Blocks.h"
#import "UIDevice-Helpers.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "PureLayout.h"
#import "JGProgressHUD.h"
#import "UIButton+AFNetworking.h"
#import "UIImage-Helpers.h"
#import "MobClick.h"
#import "JYView.h"
#import "UIView+JYView.h"
//only for temp
#import "EnumDefineTemp.h"

