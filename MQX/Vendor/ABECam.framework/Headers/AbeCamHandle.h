//
//  AbeCamHandle.h
//  ABECam
//
//  Created by pony on 2016/7/23.
//  Copyright © 2016年 abe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, wifiMode) {
    notDefine,
//    modeVGA=0,
    mode30,
    mode720,
    mode7218,
    mode5G720,
    mode1080
};

typedef NS_ENUM(NSInteger, fileType) {
    kRecord = 0,//视频文件类型
    kPicture = 2,//照片文件类型
    kUndefined = 3,
};

@protocol AbeCamHandleDelegate <NSObject>


@required
-(void)checkWifiError;

-(void)liveStreamDidConnected;
-(void)liveStreamDidDisconnected;
-(void)liveStreamDidRcvFrm;
-(void)liveStreamRcvErrData;

-(void)talkSessonDidConnected;
-(void)talkSessonDidDisconnected;


-(void)recordStart;
-(void)recordWriteFrame;//此回调证明录像在写数据
-(void)recordStop;

@optional
//当前视频转换为图像格式
-(void)getCurrentVideoToImg:(UIImage *)img;

@end
//

//
typedef void (^cmdResultBlock)(BOOL succeeded);
typedef void (^cmdResultBlockWithData)(BOOL succeeded, NSData *data);
typedef void (^indexResultBlock)(BOOL succeeded, NSData *data);
typedef void (^fileDLResultBlock)(BOOL succeeded, NSString *path);
typedef void (^dlProgressBlock)(float percentDone);

@interface AbeCamHandle : NSObject
@property (nonatomic,weak)id<AbeCamHandleDelegate> delegate;


+ (instancetype)sharedInstance;


-(BOOL)checkWIFI;//返回YES方可执行connectedTalkSession，openVideo
-(BOOL)checkTalkSeesion;        //执行talk session 方法需要先确认talksession是否连接正常

-(void)connectedTalkSession;
-(void)disconnectedTalkSession;

- (BOOL)sendHeartBeatCMDWithTimeout:(NSTimeInterval)timeout;//连接成功后20秒左右调用一次,必须调用

//close 需等待openvideo返回打开成功或者失败 间隔至少2秒以上，否则可能发生未知错误，调用一次open需调用一次close，录像也是如此
-(BOOL)openVideo:(wifiMode)mode;//需在主线程调用此方法，先调用- (void)openLiveVideoResult:(cmdResultBlock)block
//，返回成功再open，否则会打开失败
-(void)closeVideo;// 按下HOME键，跳转到其他界面，一定要关闭视频
-(BOOL)addLiveViewToSuperView:(UIView *)v Rect:(CGRect) r dualView:(BOOL)dual;//在ViewControll生命周期中只添加一次，断开重连不要执行

-(void)setDualViewStatus:(BOOL)status;
-(void)getCurrentVideoToImageOrNot:(BOOL)b;
-(void)changeDualViewLength:(CGFloat)len;//len 0~1
-(void)removeLiveView;//退出视图控制器执行
-(void)clearFrame;//清除当前显示画面

//手机本地录像
-(BOOL)startRecordWithPath:(NSString *)p;//先调用-(void)getStreamInfo:(cmdResultBlock)block;
//返回成功再open，否则会打开失败

-(void)closeRecord;//录像完成后一定要执行
- (UIImage*)getCurrentPicture;//手机拍照保存到手机，确定连接正常才调用

-(void)stopDownloadFileTask;//下载视频或照片时，中断下载任务

#pragma mark - talksession - 以下函数通过发送指令控制WIFI模块，使用前先确保talksession连接正常，调用-(BOOL)checkTalkSeesion方法
//以下函数需连接成功才能调用，严禁一次调用多个函数
//设备复位
-(void)deviceResetToDefault:(cmdResultBlock)block;

//视频镜像 status @0 或者 @1
-(void)setMirrorWithStatus:(NSNumber *)status result:(cmdResultBlock)block;
//视频翻转 status @0 或者 @1
- (void)setFlipWithStatus:(NSNumber *)status result:(cmdResultBlock)block;

//获取SD卡信息
-(void)getSDSpaceResult:(cmdResultBlockWithData)block;
//格式化SD卡
-(void)setSDFormat:(cmdResultBlockWithData)block;

//获取视频信息
-(void)getStreamInfo:(cmdResultBlock)block;
//设置SD卡录像状态 status @0 或者 @1
- (void)setRecordStatus:(NSNumber *)status result:(cmdResultBlock)block;
//SD卡保存拍照
- (void)sdCardTakePictureWithResult:(cmdResultBlock)block;
- (void)sdCardTakePictureWithCount:(NSNumber *)count result:(cmdResultBlock)block;
//同步WIFI模块时间
- (void)syncTime:(NSDate *)date result:(cmdResultBlock)block;
//获取设备信息
-(void)getDeviceParameterResult:(cmdResultBlockWithData)block;
//获取视频列表 Data保存的是文本类型列表文件
- (void)getVideoListResult:(indexResultBlock)block;
//获取图片列表 Data保存的是文本类型列表文件
- (void)getGetIndexFileWithList:(NSNumber *)list result:(indexResultBlock)block;
//打开实时视频
- (void)openLiveVideoResult:(cmdResultBlock)block;
//关闭实时视频
- (void)closeLiveVideoResult:(cmdResultBlock)block;
//下载文件 path为完整保存路径,包括MP4后缀(默认path存在，调用者需使用NSFileManager类创建path成功) 如 //Doc/../p/****.mp4 fileName为视频或者图片列表中的文件，包含后缀格式 filetype参考enum类型
//pos为下载起始点，可以实现断点续传功能（1080模块不带此功能，POS传入为0，下载失败先把文件删掉再从0开始下载） progressBlock 下载进度 fileDLResultBlock 下载结束回调
- (void)downloadFileToPath:(NSString *)path fileName:(NSString *)fileName FileType:(NSNumber *)fileType pos:(NSNumber *)pos progressBlock:(dlProgressBlock)progressBlock resultblock:(fileDLResultBlock)resultblock;
//下载完成必须调用此方法
- (void)downloadFinishWithFileName:(NSString *)fileName FileType:(NSNumber *)fileType result:(cmdResultBlock)block;
//删除SD卡中视频（删除iOS设备本地文件需要开发者自行处理）
- (void)deleteWithFileName:(NSString *)fileName FileType:(NSNumber *)fileType result:(cmdResultBlock)block;


@end
