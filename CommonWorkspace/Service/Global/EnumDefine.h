//
//  EnumDefine.h
//  MiguMV
//  description:全局类型定义
//  Created by xdyang on 14-8-16.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^BtnClickCallBack)(void);
typedef void (^BtnClickCallBackWithInfo)(id info);
typedef void (^BtnClickCallBackWithInfoAndStopInfo)(id info, BOOL *stop);

#define NoScore @"noScore"

// 唱评资源类型
typedef enum
{
    CoverPitchRes   = 0x01,         // 评测标注资源
    CoverOffline    = 0x02,         // 离线作品
    CoverChorus     = 0x04,         // 合唱作品
    CoverMvRes      = 0x08,          // MV 资源
    CoverWithoutScore = 0x10,        //不打分唱频
    CoverWithoutMakeup = 0x20,       //清唱
    Cover_OneDimensional = 0x40       //客户端2.0一维打分
    
}CoverResType;

//作品类型的本地标示
typedef enum
{
    NormalWorkType   = 0x01,         //正常演唱作品
    ActivityWorkType    = 0x02,      //活动演唱作品
    KroomWorkType     = 0x04,        //移动K歌房演唱作品
    TuanweiWorkType   = 0x08,        //团委活动
    
}LocalWorkType;

// 请求类型
typedef enum
{
    Req_Refresh,                // 刷新
    Req_LoadMore,               // 更多
    Req_RefreshAfterCache,      // 先加载缓存，再刷新
    Req_GetNew,                 // 自动刷新时，获取最新的数据
    Req_NoCache,                
}RequestType;

// 性别
typedef enum
{
    Secret_Sex = 0,             // 保密
    Male_Sex,                   // 男
    Famale_Sex,                 // 女
    Unknown_Sex                 // 未知
}SexType;

typedef enum
{
    Not_Need_Update = 0,        //0：不需要
    User_Select_Update,         //1：用户选择
    Force_Update,               //2：强制用户升级
    BG_Update                   //3：直接后台升级
}UpdateType;

//A 是用户，B是好友
typedef enum
{
    No_Relation = 0,            // 无关系
    I_Follow_Y,                 // A关注b
    Y_Follow_Me,
    Follow_Each_Other
}FollowRelationType;

typedef enum
{
    TagType_SelfDef,   //自定义标签
    TagType_Location,  //位置标签
}TagType;

//显示的结语类型
typedef enum
{
    HintView_NoNetwork = 0,        //无网络
    HintView_Loading,              //正在加载
}HintViewType;

/**
 *  登录类型
 */
typedef enum
{
    LoginByQQ = 0,           // QQ登录
    LoginByWeibo,            // 微博登录
    LoginByPhoneAccount,      // 用户手机登录
    LoginByEmailAccount       // 用户邮箱登录
}LoginType;

//获取验证码和校验验证码的时候都需要填写类型
typedef enum
{
    AccountBindServiceType = 101,       //账号绑定/换绑
    ActivateServiceType,                //激活账号验证码
    ResetPasswdServiceType,             //重置密码，忘记密码找回
    UserRegisterServiceType             //用户注册
}CodeServiceType;

typedef enum                        //K歌房信息更新类型
{
    KRoomMemNumChanged = 1,
    KRoomSignatureChanged,
    KRoomPosterChanged,
    KRoomRefreshData
}KRoomInfoChangedType;
typedef enum
{
    KRoomJoinedOrQuitRoom = 1,
    KRoomDissolveOrCreateRoom,
    KRoomOtherAction
}KRoomJoinOrDissolve ;

typedef enum
{
    SinaFriend = 0,
    TelephoneFriend,
    QQFriend,
    WeichatFriend,
    MiguFriend,
    QQZoneFriend,
    PengyouquanFriend,
}FriendType;

/**
 *绑定类型
 */
typedef enum
{
    BindingByPhone = 0,     //手机号绑定
    BindingByEmail,
    BindingBySinaWeibo,
    BindingByQQ
}BindingType;
typedef enum
{
    SingMode_Normal  = 0,     //普通一维打分
    SingMode_Chorus,          //参与合唱
    SingMode_NoScore,         //不打分唱评
    SingMode_Offline,         //离线唱评，已经废弃
    SingMode_NonAccompaniment //清唱
} SingMode;
