//
//  FileOperation.h
//  iSing
//
//  Created by cui xiaoqian on 13-4-22.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>


//常量定义
#define DownloadResourceDir          @"DownloadReource"
#define DownloadResourceCacheDir     @"DownloadReource/cache"
#define DownloadResourceStoreDir     @"DownloadReource/store"

#define UploadResourceDir            @"UploadResource"

#define LocalWorkDir                  @"LocalWork"

#define RecordPath                   @"Record"         //用户自己唱歌产生的歌曲

#define TempPcmPath                   @"TempPcmPath.mp3"   //零时的mp3路径



@interface FileOperation : NSObject

/*****************************************************/
#pragma mark -文件操作工具
//文件是否存在
+ (BOOL)isExsitFile:(NSString *)filePath;
//创建文件
+ (BOOL)createFile:(NSString *)filePath deleteOld:(BOOL)flag;
//删除文件
+ (BOOL)deleteFile:(NSString *)filePath;
+ (BOOL)deleteAllFile:(NSString *)dir;
//修改文件名
+ (BOOL)renameFile:(NSString*)srcFilePath dstFilePath:(NSString*)dstFilePath;

// 把一个移动到另外一个位置，或更改文件名
+ (BOOL)moveFile:(NSString *)srcFilePath toFilePath:(NSString *)destFilePath;

//拷贝文件
+ (BOOL)copyFile:(NSString *)srcFilePath toFilePath:(NSString *)destFilePath;

//文件大小
+ (unsigned long long)fileSizeWithPath:(NSString *)filePath;

//获取Application/document路径
+ (NSString*)documentPath;
// 临时路径
+ (NSString *) tempPath;
// 获取documet/xxx.xx、document/path 路径
+ (NSString*)filePathInDocument:(NSString*)fileName;
+ (NSString*)dirPathInDocument:(NSString*)dirName;
// get applicatoin/library/cache path
+ (NSString*)cachePath;
//获取bundle下的资源
+ (NSData*)dataFromMainBundle:(NSString*)fileName;
// 获取资源文件的路径
+ (NSString *)getFileResourcePath:(NSString *)fileName;

#pragma mark - 防止icloud备份
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

+ (void)addSkipBackupAttributeToPath:(NSString*)path;

#pragma mark 日志
+ (void)writeToLogFile:(NSString *)logStr;

#pragma mark 覆盖安装
// 获取软件的唯一标识
+ (NSString *)getAppUid;


/************************************************************/
#pragma mark -业务逻辑相关文件操作
+ (BOOL)createDefaultDirectory;

#pragma mark - 下载相关文件接口
+ (NSString *)getDownloadCachePath;
+ (NSString *)getDownloadCachePathForFilename:(NSString *)fileName;
+ (BOOL)isFileExitInDownloadCachePathForFilename:(NSString *)fileName;
+ (unsigned long long)fileSizeInDownloadCachePathForFilename:(NSString *)fileName;

+ (NSString *)getDownloadStorePath;
+ (NSString *)getDownloadStorePathForFilename:(NSString *)fileName;
+ (BOOL)isFileExitInDownloadStorePathForFilename:(NSString *)fileName;

#pragma mark - 歌词解密明文
+ (NSString *)getGlobalLyricPath;

#pragma mark - 唱评相关
// 创建唱评临时文件路径
+ (NSString *)singTmpDir;

// 录音文件路径
+ (NSString *) recordWorksPath;

#pragma mark -本地作品保存相关
+ (NSString *)getLocalWorkStorePath;

//为某个作品获取存取目录,如果存在则直接返回绝对路径，如果不存在则先新建一个文件夹，再返回绝对路径
+ (NSString *)getLcalWorkPathForWorkID:(NSString *)workid;

#pragma mark - 零时文件相关
//获取零时pcm文件路径,mp3解码后使用
+ (NSString *)getTempPcmPath;

#pragma mark - 获取相片选择的零时保存路径
+ (NSString *)getTempAlbumPathWithHash:(NSUInteger)hash;

#pragma mark - 获取点歌历史相关
//获取歌手点歌历史记录路径
+ (NSString *)getSingerSelectHistoryDir;

//获取搜索历史此提案记录路径
+ (NSString *)getSearchHistoryDir;

@end
