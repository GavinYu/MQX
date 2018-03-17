//
//  YNCDownloadManager.m
//  MediaEditor
//
//  Created by vrsh on 28/02/2017.
//  Copyright © 2017 Yuneec. All rights reserved.
//



#import "YNCDownloadManager.h"

#import "YNCMacros.h"

// 保存文件名
#define FileName(url) [self fileStrWithURL:url]
// 文件的存放路径(caches)
#define FileFullpath(url) [Document_Download stringByAppendingPathComponent:FileName(url)]
// 文件的已下载长度
#define DownloadLength(url)  [[[NSFileManager defaultManager] attributesOfItemAtPath:FileFullpath(url) error:nil][NSFileSize] integerValue]
// 存储文件总长度的文件路径(caches)
#define TotalLengthFulllpath [Document_Download stringByAppendingPathComponent:@"totalLength.plist"]


@interface YNCDownloadManager ()<NSCopying, NSURLSessionDataDelegate>

/** 保存所有任务(注: 用下载地址md5后作为key) **/
@property (nonatomic, strong) NSMutableDictionary *tasks;

/** 保存所有下载相关信息 **/
@property (nonatomic, strong) NSMutableDictionary *sessionModels;

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation YNCDownloadManager

#pragma mark - 将后缀为2nd的转换为MP4格式
- (NSString *)fileStrWithURL:(NSString *)url
{
    NSString *str =[[url componentsSeparatedByString:@"/"] lastObject];
    if ([str hasSuffix:@".2nd"]) {
        NSString *string = [str substringToIndex:str.length - 4];
        string = [string stringByAppendingString:@".mp4"];
        return string;
    }
    return [[url componentsSeparatedByString:@"/"] lastObject];
}

- (NSMutableDictionary *)tasks
{
    if (!_tasks) {
        _tasks = [NSMutableDictionary dictionary];
    }
    return _tasks;
}

- (NSMutableDictionary *)sessionModels
{
    if (!_sessionModels) {
        self.sessionModels = [NSMutableDictionary dictionary];
    }
    return _sessionModels;
}

static YNCDownloadManager *_downloadManager;
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _downloadManager = [super allocWithZone:zone];
    });
    return _downloadManager;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone
{
    return _downloadManager;
}

+ (instancetype)sharedDownloadManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _downloadManager = [[self alloc] init];
    });
    return _downloadManager;
}

/**
 * 创建缓存目录文件
 */
- (void)createCacheDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:Document_Download]) {
        [fileManager createDirectoryAtPath:Document_Download withIntermediateDirectories:YES attributes:nil error:NULL];
    }
}


/**
 * 开启单个任务下载资源
 */
- (void)download:(NSString *)url progress:(void (^)(NSInteger, NSInteger, CGFloat))progressBlock state:(void (^)(DownloadState))stateBlock
{
    if (!url) return;
    // 该资源下载完成
    if ([self isCompletion:url]) {
        stateBlock(DownloadStateCompleted);
        return;
    }
    // 暂停
    if ([self.tasks valueForKey:FileName(url)]) {
        [self handle:url];
        return;
    }
    // 创建缓存目录文件
    [self createCacheDirectory];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:queue];
    // 创建流
    NSOutputStream *stream = [NSOutputStream outputStreamToFileAtPath:FileFullpath(url) append:YES];
    // 创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    // 设置请求头
    NSString *range = [NSString stringWithFormat:@"bytes=%zd-", DownloadLength(url)];
    [request setValue:range forHTTPHeaderField:@"Range"];
    // 创建一个Data任务
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request];
    NSUInteger taskIdentifier = arc4random() % ((arc4random() % 10000 + arc4random() % 10000));
    [task setValue:@(taskIdentifier) forKeyPath:@"taskIdentifier"];
    // 保存任务
    [self.tasks setValue:task forKey:FileName(url)];
    YNCSessionModel *sessionModel = [[YNCSessionModel alloc] init];
    // 下载地址
    sessionModel.url = url;
    sessionModel.progressBlock = progressBlock;
    sessionModel.stateBlock = stateBlock;
    sessionModel.stream = stream;
    [self.sessionModels setValue:sessionModel forKey:@(task.taskIdentifier).stringValue];
    [self start:url];
}

- (void)handle:(NSString *)url
{
    NSURLSessionDataTask *task = [self getTask:url];
    if (task.state == NSURLSessionTaskStateRunning) {
        [self pasue:url];
    } else {
        [self start:url];
    }
}

/**
 * 开始下载
 */
- (void)start:(NSString *)url
{
    NSURLSessionDataTask *task = [self getTask:url];
    [task resume];
    [self getSessionModel:task.taskIdentifier].stateBlock(DownloadStateStart);
}

/**
 * 暂停下载
 */
- (void)pasue:(NSString *)url
{
    NSURLSessionDataTask *task = [self getTask:url];
    [task suspend];
    [self getSessionModel:task.taskIdentifier].stateBlock(DownloadStateSupended);
}


/**
 * 根据url获得对应的下载任务
 */
- (NSURLSessionDataTask *)getTask:(NSString *)url
{
    return (NSURLSessionDataTask *)[self.tasks valueForKey:FileName(url)];
}

/**
 * 根据url获得对应的下载任务
 */
- (YNCSessionModel *)getSessionModel:(NSUInteger)taskIdentifier
{
    return [self.sessionModels valueForKey:@(taskIdentifier).stringValue];
}

/**
 * 判断该文件是否下载完成
 */
- (BOOL)isCompletion:(NSString *)url
{
    if ([self fileTotalLength:url]&& DownloadLength(url) == [self fileTotalLength:url]) {
        return YES;
    }
    return NO;
}

/**
 * 查询该资源的下载进度值
 */
- (CGFloat)progress:(NSString *)url
{
    return [self fileTotalLength:url] == 0 ? 0.0 : 1.0 * DownloadLength(url) / [self fileTotalLength:url];
}

/**
 * 获取该资源的总大小
 */
- (NSInteger)fileTotalLength:(NSString *)url
{
    return [[NSDictionary dictionaryWithContentsOfFile:TotalLengthFulllpath][FileName(url)] integerValue];
}

#pragma mark - 删除
/**
 * 删除该资源
 */
- (void)deleteFile:(NSString *)url
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:FileFullpath(url)]) {
        // 删除沙盒中的资源
        [fileManager removeItemAtPath:FileFullpath(url) error:nil];
        // 删除任务
        [self.tasks removeObjectForKey:FileName(url)];
        [self.sessionModels removeObjectForKey:@([self getTask:url].taskIdentifier).stringValue];
        // 删除资源总长度
        if ([fileManager fileExistsAtPath:TotalLengthFulllpath]) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:TotalLengthFulllpath];
            [dict removeObjectForKey:FileName(url)];
            [dict writeToFile:TotalLengthFulllpath atomically:YES];
        }
    }
}

/**
 * 清空所有下载资源
 */
- (void)deleteAllFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:Document_Download ]) {
        // 删除沙盒中所有资源
        [fileManager removeItemAtPath:Document_Download error:nil];
        // 删除任务
        [[self.tasks allValues] makeObjectsPerformSelector:@selector(cancel)];
        [self.tasks removeAllObjects];
        
        for (YNCSessionModel *sessionModel in [self.sessionModels allValues]) {
            [sessionModel.stream close];
        }
        [self.sessionModels removeAllObjects];
        // 删除资源总长度
        if ([fileManager fileExistsAtPath:TotalLengthFulllpath]) {
            [fileManager removeItemAtPath:TotalLengthFulllpath error:nil];
        }
    }
}

#pragma mark - 代理
#pragma mark - NSURLSessionDataDelegate
/**
 * 接收到响应
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    YNCSessionModel *sessionModel = [self getSessionModel:dataTask.taskIdentifier];
    // 打开流
    [sessionModel.stream open];
    // 获得服务器这次请求, 返回数据的总长度
    NSInteger totalLength = [response.allHeaderFields[@"Content-Length"] integerValue] + DownloadLength(sessionModel.url);
    sessionModel.totalLength = totalLength;
    // 存储长度
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:TotalLengthFulllpath];
    if (dict == nil) dict = [NSMutableDictionary dictionary];
    dict[FileName(sessionModel.url)] = @(totalLength);
    [dict writeToFile:TotalLengthFulllpath atomically:YES];
    // 接收这个请求, 允许接收服务器的数据
    completionHandler(NSURLSessionResponseAllow);
}

/**
 * 接收到服务器返回的数据
 */
// 一直在读取
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    YNCSessionModel *sessionModel = [self getSessionModel:dataTask.taskIdentifier];
    // 写入数据
    [sessionModel.stream write:data.bytes maxLength:data.length];
    // 下载进度
    NSUInteger receivedSize = DownloadLength(sessionModel.url);
    NSUInteger expectedSize = sessionModel.totalLength;
    CGFloat progress = 1.0 * receivedSize / expectedSize;
    sessionModel.progressBlock(receivedSize, expectedSize, progress);
}

/**
 * 请求完毕(成功|失败)
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    YNCSessionModel *sessionModel = [self getSessionModel:task.taskIdentifier];
    if (!sessionModel) return;
    if ([self isCompletion:sessionModel.url]) {
        // 保存数据到数据库
        //        [self saveDataToDataBaseWithSessionModel:sessionModel];
        // 下载完成
        sessionModel.stateBlock(DownloadStateCompleted);
        [self.session finishTasksAndInvalidate];
    } else if (error) {
        // 下载失败
        sessionModel.stateBlock(DownloadStateFailed);
    }
    // 关闭流
    [sessionModel.stream close];
    sessionModel.stream = nil;
    // 清除任务
    [self.tasks removeObjectForKey:FileName(sessionModel.url)];
    [self.sessionModels removeObjectForKey:@(task.taskIdentifier).stringValue];
}

#pragma mark - 保存数据到数据库
//- (void)saveDataToDataBaseWithSessionModel:(CHSessionModel *)sessionModel
//{
//    // 保存数据
//    CHGalleryDataBaseModel *galleryModel = [[CHGalleryDataBaseModel alloc] init];
//    /** 下载任务的文件名 **/
//    NSString *fileTitle = [[sessionModel.url componentsSeparatedByString:@"/"] lastObject];
//    galleryModel.title = fileTitle;
//    /** 下载任务的后缀名 **/
//    NSString *fileType = [[fileTitle componentsSeparatedByString:@"."] lastObject];
//    /** 下载任务的拍摄日期 **/
//    if ([fileType isEqualToString:@"JPG"]) {
//        NSNumber *number = @1;
//        galleryModel.fileType = number.stringValue;
//        // 保存文件路径
//        galleryModel.fileStr = FileName(sessionModel.url);
//        // 保存缩略图路径
//        NSString *thmStr = [sessionModel.url substringToIndex:sessionModel.url.length - 4];
//        thmStr = [thmStr stringByAppendingString:@".thm"];
//        thmStr = [[thmStr componentsSeparatedByString:@"/"] lastObject];
//        // 获取本地原图
//        UIImage *image = [UIImage imageWithContentsOfFile:FileFullpath(sessionModel.url)];
//        // 将本地图片压缩后存放到指定路径
//        [UIImage compressImage:image targetWidth:120.0 path:FileFullpath(thmStr)];
//        galleryModel.thmPath = thmStr;
//        // 将图片移到系统图库
//        [UIImage saveToPhotosAlbum: FileFullpath(sessionModel.url)];
//    } else {
//        NSNumber *number = @2;
//        galleryModel.fileType = number.stringValue;
//
//        if ([sessionModel.url hasSuffix:@".2nd"]) {
//            // 保存文件路径
//            galleryModel.fileStr = FileName(sessionModel.url);
//            // 保存视频的缩略图路径
//            NSString *thmStr = [sessionModel.url substringToIndex:sessionModel.url.length - 4];
//            thmStr = [thmStr stringByAppendingString:@".thm"];
//            thmStr = [[thmStr componentsSeparatedByString:@"/"] lastObject];
//            [UIImage getImageWithUrl:FileFullpath(sessionModel.url) targetWitdth:200.0 saveToPath:FileFullpath(thmStr)];
//            galleryModel.thmPath = thmStr;
//        }
//        // 将视频移到系统图库
//        [UIImage saveVideoToPhotos:FileFullpath(sessionModel.url)];
//    }
//    galleryModel.date = [sessionModel.date substringToIndex:11];
//    [[CHDataBase shareDataBase] insertOneGalleryDataBaseModel:galleryModel];
//}

- (void)dealloc
{
    [self.session invalidateAndCancel];
}

@end
