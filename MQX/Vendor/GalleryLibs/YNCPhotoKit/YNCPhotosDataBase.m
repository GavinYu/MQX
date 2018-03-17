//
//  YNCPhotosDataBase.m
//  MediaEditor
//
//  Created by vrsh on 21/02/2017.
//  Copyright © 2017 Yuneec. All rights reserved.
//

#import "YNCPhotosDataBase.h"
#import <sqlite3.h>
#import "YNCPhotosDataBaseModel.h"

@implementation YNCPhotosDataBase

static YNCPhotosDataBase *single = nil;

// 创建单例的接口
+ (YNCPhotosDataBase *)shareDataBase
{
    @synchronized(self) {
        if (!single) {
            single = [[YNCPhotosDataBase alloc] init];
            [single creatTable];
        }
    }
    return single;
}

// 设计数据库存储路径
- (NSString *)dataBasePath
{
    NSString *dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"PhotosDB.sqlite"];
    return dbPath;
}

// 定义全局静态区数据库指针
static sqlite3 *database = nil;

// 打开数据库的
- (void)openDataBase
{
    // 1. 数据库的文件路径
    NSString *dbPath = [self dataBasePath];
    // UTF8String 将OC中的字符串转换为C语言中的字符串
    // 如果执行成功就会在文件的路径下创建数据库文件,并打开;如果数据库文件已经存在了,就直接打开
    int result = sqlite3_open([dbPath UTF8String], &database);
    if (result != SQLITE_OK) {
//        NSLog(@"打开失败");
    }
}

// 关闭数据库
- (void)closeDataBase
{
    int result = sqlite3_close(database);
    if (result != SQLITE_OK) {
//        NSLog(@"关闭失败");
    }
}

// 创建表GalleryItemModel
- (void)creatTable
{
    // 1. 打开数据库
    [self openDataBase];
    // 2. 准备SQL语句
    NSString *sqlString_photo = @"create table if not exists YNCPhotoDataBase(photo_id integer primary key autoincrement,singleKey text, createDate text, author text, location text, device text, mermory text, width integer, height integer, type integer)";
    NSString *sqlString_video = @"create table if not exists YNCVideoDataBase(photo_id integer primary key autoincrement,singleKey text, createDate text, author text, location text, device text, mermory text, width integer, height integer, type integer)";
    NSString *sqlString_edit = @"create table if not exists YNCEidtDataBase(photo_id integer primary key autoincrement,singleKey text, createDate text, author text, location text, device text, mermory text, width integer, height integer, type integer)";
    // 3. 执行SQL语句
    int result_photo = sqlite3_exec(database, [sqlString_photo UTF8String], NULL, NULL, NULL);
    int result_video = sqlite3_exec(database, [sqlString_video UTF8String], NULL, NULL, NULL);
    int result_edit = sqlite3_exec(database, [sqlString_edit UTF8String], NULL, NULL, NULL);
    // 关闭数据库
    if (!result_photo && !result_video && !result_edit) {
        [self closeDataBase];
    } else {
//        NSLog(@"建表失败");
    }
}

// 插入新数据
- (void)insertOnePhotoDataBase:(YNCPhotosDataBaseModel *)itemModel
{
    // 1. 打开数据库
    [self openDataBase];
    // 2. 准备插入的SQL语句
    NSString *sqlString = nil;
    switch (itemModel.mediaType) {
        case YNCMediaTypeSystemPhoto:
        case YNCMediaTypeDronePhoto:
            sqlString = @"insert into YNCPhotoDataBase(singleKey, createDate, author, location, device, mermory, width, height, type)values(?, ?, ?, ?, ?, ?, ?, ?, ?)";
            break;
        case YNCMediaTypeSystemVideo:
        case YNCMediaTypeDroneVideo:
            sqlString = @"insert into YNCVideoDataBase(singleKey, createDate, author, location, device, mermory, width, height, type)values(?, ?, ?, ?, ?, ?, ?, ?, ?)";
            break;
        case YNCMediaTypeEditedPhoto:
        case YNCMediaTypeEditedVideo:
            sqlString = @"insert into YNCEidtDataBase(singleKey, createDate, author, location, device, mermory, width, height, type)values(?, ?, ?, ?, ?, ?, ?, ?, ?)";
            break;
    }
    
    // 3. 创建数据库指令集(句柄)
    sqlite3_stmt *stmt = nil;
    // 4. 编译SQL语句
    // 参数1. 数据库指针
    // 参数2. SQL语句
    // 参数3. SQL语句的长度,写成-1,自动计算SQL语句的长度,如果不写自己计算
    // 参数4. 数据库指令集
    // 参数5. 预留参数
    // 编译成功之后,我们要操作的数据库地址和操作的指令就会存储到指令集stmt中,在下面的函数中通过这个指令集就会知道我们要操作的是哪个数据库,以及要对这个数据库做什么操作
    int result = sqlite3_prepare(database, [sqlString UTF8String], -1, &stmt, NULL);
    if (result == SQLITE_OK) { // 编译成功
//        NSLog(@"编译成功");
        // 绑定要插入的数据
        // 参数1: 句柄
        // 参数2: 问号在SQL语句中的位置,位置是从1开始
        // 参数3: 要绑定的数据
        // 参数4: 计算绑定数据的长度
        sqlite3_bind_text(stmt, 1, [itemModel.singleKey UTF8String], -1, NULL);
        // 绑定文件拍摄日期
        sqlite3_bind_text(stmt, 2, [itemModel.createDate UTF8String], -1, NULL);
        // 绑定文件标题
        sqlite3_bind_text(stmt, 3, [itemModel.author UTF8String], -1, NULL);
        // 绑定缩略图的下载路径
        sqlite3_bind_text(stmt, 4, [itemModel.location UTF8String], -1, NULL);
        // 绑定资源下载路径
        sqlite3_bind_text(stmt, 5, [itemModel.device UTF8String], -1, NULL);
        // 绑定下载文件类型
        sqlite3_bind_text(stmt, 6, [itemModel.mermory UTF8String], -1, NULL);
        // 绑定文件拍摄日期
        sqlite3_bind_int(stmt, 7, itemModel.width);
        // 绑定文件标题
        sqlite3_bind_int(stmt, 8, itemModel.height);
        // 绑定缩略图的下载路径
        sqlite3_bind_int(stmt, 9, itemModel.mediaType);
        // 执行SQL语句
        sqlite3_step(stmt);
    } else {
//        NSLog(@"编译失败");
    }
    // 结束SQL语句
    sqlite3_finalize(stmt);
    // 关闭数据库
    [self closeDataBase];
}

// 根据标题删除数据的接口
- (void)deleteOnePhotoDataBaseModelBySingleKey:(NSString *)singleKey type:(YNCMediaType)type
{
    // 1. 打开数据库
    [self openDataBase];
    // 2. 准备SQL语句
    NSString *sqlString = nil;
    switch (type) {
        case YNCMediaTypeSystemPhoto:
        case YNCMediaTypeDronePhoto:
            sqlString = @"delete from YNCPhotoDataBase where singleKey = ?";
            break;
        case YNCMediaTypeSystemVideo:
        case YNCMediaTypeDroneVideo:
            sqlString = @"delete from YNCVideoDataBase where singleKey = ?";
            break;
        case YNCMediaTypeEditedPhoto:
        case YNCMediaTypeEditedVideo:
            sqlString = @"delete from YNCEidtDataBase where singleKey = ?";
            break;
    }
    // 3. 创建句柄
    sqlite3_stmt *stmt = nil;
    // 4. 编译SQL语句
    int result = sqlite3_prepare(database, [sqlString UTF8String], -1, &stmt, NULL);
    if (result == SQLITE_OK) {
//        NSLog(@"编译语句编译成功");
        // 5. 绑定参数
        sqlite3_bind_text(stmt, 1, [singleKey UTF8String], -1, NULL);
        // 6. 执行SQL语句
        sqlite3_step(stmt);
    }else {
//        NSLog(@"编译语句编译失败");
    }
    // 停止SQL语句
    sqlite3_finalize(stmt);
    // 关闭数据库
    [self closeDataBase];
}

// 根据标题查找一个下载资源的接口
- (YNCPhotosDataBaseModel *)selectOnePhotoDataBaseModelBySingleKey:(NSString *)singleKey type:(YNCMediaType)type
{
    [self openDataBase];
    NSString *sqlString = nil;
    switch (type) {
        case YNCMediaTypeSystemPhoto:
        case YNCMediaTypeDronePhoto:
            sqlString = @"select * from YNCPhotoDataBase where singleKey = ?";
            break;
        case YNCMediaTypeSystemVideo:
        case YNCMediaTypeDroneVideo:
            sqlString = @"select * from YNCVideoDataBase where singleKey = ?";
            break;
        case YNCMediaTypeEditedPhoto:
        case YNCMediaTypeEditedVideo:
            sqlString = @"select * from YNCEidtDataBase where singleKey = ?";
            break;
    }
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare(database, [sqlString UTF8String], -1, &stmt, NULL);
    YNCPhotosDataBaseModel *photoModel = [[YNCPhotosDataBaseModel alloc] init];
    if (result == SQLITE_OK) {
//        NSLog(@"查找成功");
        // 5. 绑定参数
        sqlite3_bind_text(stmt, 1, [singleKey UTF8String], -1, NULL);
        // 6. 执行SQL语句
        // 查询时只要找到就直接可以赋值了,根据主键查询while只走一次
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const unsigned char *k_singleKey = sqlite3_column_text(stmt, 1);
            NSString *new_singleKey = nil;
            if (k_singleKey) {
                new_singleKey = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
            }
            const unsigned char *k_createDate = sqlite3_column_text(stmt, 2);
            NSString *createDate = nil;
            if (k_createDate) {
                createDate = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            }
            const unsigned char *k_author = sqlite3_column_text(stmt, 3);
            NSString *author = nil;
            if (k_author) {
                author = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
            }
            const unsigned char *k_location = sqlite3_column_text(stmt, 4);
            NSString *location = nil;
            if (k_location) {
                location = [NSString stringWithUTF8String:( const char *)sqlite3_column_text(stmt, 4)];
            }
            const unsigned char *k_device = sqlite3_column_text(stmt, 5);
            NSString *device = nil;
            if (k_device) {
                device = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 5)];
            }
            const unsigned char *k_mermory = sqlite3_column_text(stmt, 6);
            NSString *mermory = nil;
            if (k_mermory) {
                mermory = [NSString stringWithUTF8String:( const char *)sqlite3_column_text(stmt, 6)];
            }
            int width = sqlite3_column_int(stmt, 7);
            int height = sqlite3_column_int(stmt, 8);
            int type = sqlite3_column_int(stmt, 9);
            photoModel.singleKey = new_singleKey;
            photoModel.createDate = createDate;
            photoModel.author = author;
            photoModel.location = location;
            photoModel.device = device;
            photoModel.mermory = mermory;
            photoModel.width = width;
            photoModel.height = height;
            photoModel.mediaType = type;
        }
    }else {
//        NSLog(@"查找失败");
    }
    sqlite3_finalize(stmt);
    [self closeDataBase];
    return photoModel;
}

// 获取全部图片模型的接口
- (NSArray *)selectAllPhotosDataBaseModelWithType:(YNCMediaType)type
{
    // 1. 打开数据库
    [self openDataBase];
    // 2. 准备要插入的SQL语句
    NSString *sqlString = nil;
    switch (type) {
        case YNCMediaTypeSystemPhoto:
        case YNCMediaTypeDronePhoto:
            sqlString = @"select * from YNCPhotoDataBase";
            break;
            
        case YNCMediaTypeSystemVideo:
        case YNCMediaTypeDroneVideo:
            sqlString = @"select * from YNCVideoDataBase";
            break;
        case YNCMediaTypeEditedPhoto:
        case YNCMediaTypeEditedVideo:
            sqlString = @"select * from YNCEidtDataBase";
            break;
    }
    // 3. 创建句柄
    sqlite3_stmt *stmt = nil;
    // 4. 编译SQL语句
    int result = sqlite3_prepare(database, [sqlString UTF8String], -1, &stmt, NULL);
    // 创建存放的数组
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    if (result == SQLITE_OK) {
        //NSLog(@"查询语句编译成功");
        // SQLIFE_ROW 如果sqlite3_step()的返回值和SQLITE_ROW值相等,说明下面还有一行数据,循环继续,如果不相等,说明下面没有数据了,循环结束
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const unsigned char *k_singleKey = sqlite3_column_text(stmt, 1);
            NSString *singleKey = nil;
            if (k_singleKey) {
                singleKey = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                ;
            }
            const unsigned char *k_createDate = sqlite3_column_text(stmt, 2);
            NSString *createDate = nil;
            if (k_createDate) {
                createDate = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
            }
            const unsigned char *k_author = sqlite3_column_text(stmt, 3);
            NSString *author = nil;
            if (k_author) {
                author = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
            }
            const unsigned char *k_location = sqlite3_column_text(stmt, 4);
            NSString *location = nil;
            if (k_location) {
                location = [NSString stringWithUTF8String:( const char *)sqlite3_column_text(stmt, 4)];
            }
            const unsigned char *k_device = sqlite3_column_text(stmt, 5);
            NSString *device = nil;
            if (k_device) {
                device = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 5)];
            }
            const unsigned char *k_mermory = sqlite3_column_text(stmt, 6);
            NSString *mermory = nil;
            if (k_mermory) {
                mermory = [NSString stringWithUTF8String:( const char *)sqlite3_column_text(stmt, 6)];
            }
            int width = sqlite3_column_int(stmt, 7);
            int height = sqlite3_column_int(stmt, 8);
            int type = sqlite3_column_int(stmt, 9);
            // 根据取出来得数据初始化对象
            YNCPhotosDataBaseModel *photoModel = [YNCPhotosDataBaseModel photoDataBaseModelWithSingleKey:singleKey createDate:createDate author:author location:location device:device mermory:mermory width:width height:height type:type];
            // 把对象添加到数组
            [array addObject:photoModel];
        }
    }else {
//        NSLog(@"查询语句编译失败");
    }
    // 结束数据库语句
    sqlite3_finalize(stmt);
    // 关闭数据库
    [self closeDataBase];
    // 返回数组
    return array;
}


@end
