//
//  FileOperation.m
//  iSing
//
//  Created by cui xiaoqian on 13-4-22.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//

#import "FileOperation.h"
#import "sys/xattr.h"

@implementation FileOperation

/*****************************************************/
#pragma mark -文件操作工具
//文件是否存在
+ (BOOL)isExsitFile:(NSString *)filePath{
    if (!filePath || filePath.length == 0)
    {
        return NO;
    }
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        return YES;
    }
    return NO;
}

//创建文件
+ (BOOL)createFile:(NSString *)filePath deleteOld:(BOOL)flag{
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:filePath]) {
        return [manager createFileAtPath:filePath contents:nil attributes:nil];
    }else{
        if (flag) {
            if ([manager removeItemAtPath:filePath error:nil]) {
                return [manager createFileAtPath:filePath contents:nil attributes:nil];
            }else{
                return NO;
            }
        }else{
            return YES;
        }
    }
}

//删除文件
+ (BOOL)deleteFile:(NSString *)filePath{
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:filePath]) {
        return YES;
    }
    if ([manager removeItemAtPath:filePath error:nil]) {
        return YES;
    }
    return NO;
}

+ (BOOL)deleteAllFile:(NSString *)dir
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *err = nil;
    NSArray *allFiles = [manager contentsOfDirectoryAtPath:dir error:&err];
    if (err) {
        MDLOG(@"Failed to get all files in directory:%@ \n. The error is:%@\n", dir, err);
        return FALSE;
    } else {
        for (NSString *fileName in allFiles) {
            if (![self deleteFile:[dir stringByAppendingPathComponent:fileName]]) {
                return FALSE;
            }
        }
    }

    return TRUE;
}

+ (BOOL)renameFile:(NSString*)srcFilePath dstFilePath:(NSString*)dstFilePath
{
    NSError *err = nil;
    return [[NSFileManager defaultManager] moveItemAtPath:srcFilePath toPath:dstFilePath error:&err];
}

//把一个移动到另外一个位置，或修改文件名
+ (BOOL)moveFile:(NSString *)srcFilePath toFilePath:(NSString *)destFilePath
{
    if(!srcFilePath || srcFilePath.length <= 0 || !destFilePath || destFilePath.length <= 0){
        return NO;
    }
    
    NSError *err = nil;
    return [[NSFileManager defaultManager] moveItemAtPath:srcFilePath toPath:destFilePath error:&err];
}

//拷贝文件
+ (BOOL)copyFile:(NSString *)srcFilePath toFilePath:(NSString *)destFilePath
{
    if(!srcFilePath || srcFilePath.length <= 0 || !destFilePath || destFilePath.length <= 0){
        return NO;
    }
    
    NSError *err = nil;
    return [[NSFileManager defaultManager] copyItemAtPath:srcFilePath toPath:destFilePath error:&err];
}

//文件大小
+ (unsigned long long)fileSizeWithPath:(NSString *)filePath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

//获取document路径
+ (NSString*)documentPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

// 临时路径(唱评需要)
+ (NSString *) tempPath
{
    return NSTemporaryDirectory();
}

+ (NSString*)filePathInDocument:(NSString*)fileName
{
    return [[FileOperation documentPath] stringByAppendingPathComponent:fileName];
}

+ (NSString*)dirPathInDocument:(NSString*)dirName
{
    return [[FileOperation documentPath] stringByAppendingPathComponent:dirName];
}

//
+ (NSString*)cachePath
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

//获取bundle下的资源
+ (NSData*)dataFromMainBundle:(NSString*)fileName
{
    if ([fileName length]==0||fileName==nil) {
        return nil;
    }
    
    NSArray *retArr = [fileName componentsSeparatedByString:@"."];
    if ([retArr count]!=2) {
        return nil;
    }
    
    NSString *name = [retArr objectAtIndex:0];
    NSString *type = [retArr objectAtIndex:1];
    
    return [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:type]];
}

+ (NSString *)getFileResourcePath:(NSString *)fileName{
    
    if (nil == fileName || [fileName length] == 0){
        return nil;
    }
    // 获取资源目录路径
    NSString *resourceDir = [[NSBundle mainBundle] resourcePath];
    return [resourceDir stringByAppendingPathComponent:fileName];
}

#pragma mark 防止icloud备份
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

+ (void)addSkipBackupAttributeToPath:(NSString*)path {
    u_int8_t b = 1;
    setxattr([path fileSystemRepresentation], "com.apple.MobileBackup", &b, 1, 0, 0);
}

#pragma mark 日志
+ (void)writeToLogFile:(NSString *)logStr
{
    if (!logStr)
    {
        logStr = @"NULL数据";
    }
    logStr = [NSString stringWithFormat:@"时间：%@ \nLog:%@\n",[NSDate date],logStr];
    if (!log)
    {
        return;
    }
    NSString *logFile = [FileOperation filePathInDocument:@"iSingLog.txt"];
    if (![FileOperation isExsitFile:logFile])
    {
        [FileOperation createFile:logFile deleteOld:NO];
        [FileOperation addSkipBackupAttributeToPath:logFile];
    }
    // 写入到文件中
    NSOutputStream *outPutStream = [[NSOutputStream alloc] initToFileAtPath:logFile append:YES];
    [outPutStream open];
    const char *cStr = [logStr UTF8String];
    NSUInteger length = strlen(cStr);
    [outPutStream write:cStr maxLength:length];
    [outPutStream close];
}

#pragma mark 覆盖安装
// 获取软件的唯一标识
+ (NSString *)getAppUid
{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSArray *pathCompents = [path pathComponents];
    if ([pathCompents count] >= 2)
    {
        return [pathCompents objectAtIndex:[pathCompents count] - 2];
    }
    return nil;
}


/************************************************************/
#pragma mark -业务逻辑相关文件操作
+ (NSString*)getDefaultDirectoryPath:(NSString*)dirname
{
    return [FileOperation dirPathInDocument:dirname];
}

+ (BOOL)createDefaultDirectory
{
    NSString *defaultResourceDir = [FileOperation getDefaultDirectoryPath:DownloadResourceDir];
    NSString *defaultUploadResourceDir = [FileOperation getDefaultDirectoryPath:UploadResourceDir];
    NSString *localWorkDir = [FileOperation getDefaultDirectoryPath:LocalWorkDir];

    BOOL isDownloadResource, isUploadResource, isLocalWorkDir;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:defaultResourceDir isDirectory:&isDownloadResource]   && isDownloadResource &&
        [[NSFileManager defaultManager] fileExistsAtPath:localWorkDir isDirectory:&isLocalWorkDir]   && isLocalWorkDir &&
        [[NSFileManager defaultManager] fileExistsAtPath:defaultUploadResourceDir isDirectory:&isUploadResource]   && isUploadResource) {

        return YES;
    }

    //创建下载资源目录
    [[NSFileManager defaultManager] createDirectoryAtPath:defaultResourceDir withIntermediateDirectories:YES attributes:nil error:nil];
      //同时创建缓存目录和存储目录
      NSString *downloadReCache = [FileOperation getDefaultDirectoryPath:DownloadResourceCacheDir];
      NSString *downloadReStore = [FileOperation getDefaultDirectoryPath:DownloadResourceStoreDir];
      [[NSFileManager defaultManager] createDirectoryAtPath:downloadReCache withIntermediateDirectories:YES attributes:nil error:nil];
      [[NSFileManager defaultManager] createDirectoryAtPath:downloadReStore withIntermediateDirectories:YES attributes:nil error:nil];
    
    //创建作品保存目录
    [[NSFileManager defaultManager] createDirectoryAtPath:localWorkDir withIntermediateDirectories:YES attributes:nil error:nil];
    
    //创建上传目录
    [[NSFileManager defaultManager] createDirectoryAtPath:defaultUploadResourceDir withIntermediateDirectories:YES attributes:nil error:nil];

    [FileOperation addSkipBackupAttributeToPath:defaultResourceDir];

    return YES;
}

#pragma mark - 下载相关文件接口
+ (NSString *)getDownloadCachePath
{
    NSString *downloadReCache = [FileOperation getDefaultDirectoryPath:DownloadResourceCacheDir];
    return downloadReCache;
}

+ (NSString *)getDownloadCachePathForFilename:(NSString *)fileName
{
    NSString *filePath = [FileOperation getDownloadCachePath];
    filePath = [NSString stringWithFormat:@"%@/%@", filePath, fileName];
    return filePath;
}

+ (BOOL)isFileExitInDownloadCachePathForFilename:(NSString *)fileName
{
    NSString *filePath = [FileOperation getDownloadCachePathForFilename:fileName];
    return [FileOperation isExsitFile:filePath];
}

+ (unsigned long long)fileSizeInDownloadCachePathForFilename:(NSString *)fileName
{
    if (IsStrEmpty(fileName)) {
        return 0;
    }else{
        return [FileOperation fileSizeWithPath:[FileOperation getDownloadCachePathForFilename:fileName]];
    }
}

+ (NSString *)getDownloadStorePath
{
    NSString *downloadReStore = [FileOperation getDefaultDirectoryPath:DownloadResourceStoreDir];
    return downloadReStore;
}

+ (NSString *)getDownloadStorePathForFilename:(NSString *)fileName
{
    NSString *filePath = [FileOperation getDownloadStorePath];
    filePath = [NSString stringWithFormat:@"%@/%@", filePath, fileName];
    return filePath;
}

+ (BOOL)isFileExitInDownloadStorePathForFilename:(NSString *)fileName
{
    NSString *filePath = [FileOperation getDownloadStorePathForFilename:fileName];
    return [FileOperation isExsitFile:filePath];
}

#pragma mark - 歌词解密明文
+ (NSString *)getGlobalLyricPath
{
    return [NSString stringWithFormat:@"%@/tempFileGlobal", [self documentPath]];
}

#pragma mark - 唱评相关
// 创建唱评临时文件路径
+ (NSString *)singTmpDir
{
    NSString *tmp = [FileOperation cachePath];
    NSString *singTmp = [tmp stringByAppendingPathComponent:@"singTmp"];
    
    if (![FileOperation isExsitFile:singTmp])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:singTmp
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    
    return singTmp;
}

+ (NSString *)recordWorksPath
{
    NSString *cachePath = [FileOperation cachePath];
    NSString *recordPath = [cachePath stringByAppendingPathComponent:RecordPath];
    
    BOOL isDir;
    if (!([[NSFileManager defaultManager] fileExistsAtPath:recordPath isDirectory:&isDir] && isDir))
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:recordPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return recordPath;
}

#pragma mark -本地作品保存相关
+ (NSString *)getLocalWorkStorePath
{
    NSString *localWorkDir = [FileOperation getDefaultDirectoryPath:LocalWorkDir];
    return localWorkDir;
}

//为某个作品获取存取目录,如果存在则直接返回绝对路径，如果不存在则先新建一个文件夹，再返回绝对路径
+ (NSString *)getLcalWorkPathForWorkID:(NSString *)workid
{
    if(!workid){
        return nil;
    }
    
    NSString *path = [[FileOperation getLocalWorkStorePath] stringByAppendingPathComponent:workid];
    
    BOOL isDir;
    if (!([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] && isDir))
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return path;
}

#pragma mark - 零时文件相关
//获取零时pcm文件路径,mp3解码后使用
+ (NSString *)getTempPcmPath
{
    NSString *tempPath = [FileOperation tempPath];
    tempPath = [tempPath stringByAppendingPathComponent:TempPcmPath];
    return tempPath;
}

#pragma mark - 获取相片选择的零时保存路径
+ (NSString *)getTempAlbumPathWithHash:(NSUInteger)hash
{
    NSString *path = [[FileOperation tempPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d", hash]];
    
    BOOL isDir;
    if (!([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] && isDir))
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return path;
}

#pragma mark - 获取点歌历史相关
//获取歌手点歌历史记录路径
+ (NSString *)getSingerSelectHistoryDir
{
    NSString *path = [FileOperation documentPath];
    path = [path stringByAppendingPathComponent:@"singerHistory"];
    if(![FileOperation isExsitFile:path]){
        
        [FileOperation createFile:path deleteOld:YES];
    }
    
    return path;
}

//获取搜索历史此提案记录路径
+ (NSString *)getSearchHistoryDir
{
    NSString *path = [FileOperation documentPath];
    path = [path stringByAppendingPathComponent:@"searchHistory"];
    if(![FileOperation isExsitFile:path]){
        
        [FileOperation createFile:path deleteOld:YES];
    }
    
    return path;
}

@end
