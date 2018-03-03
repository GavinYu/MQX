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
    mode1080
};

typedef NS_ENUM(NSInteger, fileType) {
    kRecord = 0,//视频文件类型 video type
    kPicture = 2,//照片文件类型 picture type
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
-(void)recordWriteFrame;
-(void)recordStop;

//当前视频转换为图像格式 current video to uiimage
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

//Returns YES than you can execution connectedTalkSession，openVideo
-(BOOL)checkWIFI;//返回YES方可执行connectedTalkSession，openVideo

// confirm talksession is connected correctly
-(BOOL)checkTalkSeesion;

-(void)connectedTalkSession;
-(void)disconnectedTalkSession;

/**
 The heartbeat packets.After the connectedTalkSession is successful(callback: talkSessonDidConnected),you must call when every 20 seconds
 */
- (BOOL)sendHeartBeatCMDWithTimeout:(NSTimeInterval)timeout;//连接成功后20秒左右调用一次,必须调用

/**
 In the main thread calls，you should call openLiveVideoResult: first.call when cmdResultBlock success , or openVideo fail
 */

-(BOOL)openVideo:(wifiMode)mode;//需在主线程调用此方法，先调用- (void)openLiveVideoResult:(cmdResultBlock)block
//，返回成功再open，否则会打开失败

/**
 Press the HOME button, jump to other interface, be sure to close the video.
 closeVideo need wait to openvideo returns success or failure, Interval at least more than 2 seconds, or errors may be unknown, call a open need to call a close, the record also is such
 */
-(void)closeVideo;// 按下HOME键，跳转到其他界面，一定要关闭视频


//add only once in a ViewControll life cycle , disconnect the reconnection don't perform
-(BOOL)addLiveViewToSuperView:(UIView *)v Rect:(CGRect) r dualView:(BOOL)dual;//在ViewControll生命周期中只添加一次，断开重连不要执行

-(void)setDualViewStatus:(BOOL)status;

-(void)changeDualViewLength:(CGFloat)len;//len 0~1
-(void)removeLiveView;//退出视图控制器执行 call when exit the ViewControll
-(void)clearFrame;//清除当前显示画面 Remove the currently displayed image

//手机本地录像 recording to iphone, not the wifi model
-(BOOL)startRecordWithPath:(NSString *)p;//先调用-(void)getStreamInfo:(cmdResultBlock)block;
//返回成功再open，否则会打开失败 phone record. p is the full path (contains The file suffix).

-(void)closeRecord;//录像完成后一定要执行 phone stop record.ensure call after start
- (UIImage*)getCurrentPicture;//手机拍照保存到手机，确定连接正常才调用 phone screenshot. return UIImage.

-(void)stopDownloadFileTask;//下载视频或照片时，中断下载任务 phone screenshot. return UIImage.

#pragma mark - talksession - 以下函数通过发送指令控制WIFI模块，使用前先确保talksession连接正常，调用-(BOOL)checkTalkSeesion方法
/**The following function send a command to control WIFI module，Make sure that talksession connection correct，call checkTalkSeesion and return YES.//以下函数需连接成功才能调用，严禁一次调用多个函数
 */
//视频镜像 status @0 或者 @1 //video mirror image. status @0 or @1
-(void)setMirrorWithStatus:(NSNumber *)status result:(cmdResultBlock)block;
//视频翻转 status @0 或者 @1//video flip status @0 or @1
- (void)setFlipWithStatus:(NSNumber *)status result:(cmdResultBlock)block;

//获取SD卡信息 get SD card info
-(void)getSDSpaceResult:(cmdResultBlockWithData)block;

//获取视频信息 get video stream info
-(void)getStreamInfo:(cmdResultBlock)block;


//start or stop SD card record. status @0:stop record.  @1:start record
//设置SD卡录像状态 status @0 或者 @1
- (void)setRecordStatus:(NSNumber *)status result:(cmdResultBlock)block;


//SD卡保存拍照
//Take Picture save to SD card.
- (void)sdCardTakePictureWithResult:(cmdResultBlock)block;
- (void)sdCardTakePictureWithCount:(NSNumber *)count result:(cmdResultBlock)block;
//同步WIFI模块时间 Synchronization time with WIFI module
- (void)syncTime:(NSDate *)date result:(cmdResultBlock)block;
//获取设备信息 get device info
-(void)getDeviceParameterResult:(cmdResultBlockWithData)block;
//获取视频列表 Data保存的是文本类型列表文件 get video list , data is a text type
- (void)getVideoListResult:(indexResultBlock)block;
//获取图片列表 Data保存的是文本类型列表文件 get image list, data is a text type
- (void)getGetIndexFileWithList:(NSNumber *)list result:(indexResultBlock)block;
//打开实时视频 open the real-time video
- (void)openLiveVideoResult:(cmdResultBlock)block;
//关闭实时视频 close the real-time video
- (void)closeLiveVideoResult:(cmdResultBlock)block;
//下载文件 path为完整保存路径,包括MP4后缀(默认path存在，调用者需使用NSFileManager类创建path成功) 如 //Doc/../p/****.mp4 fileName为视频或者图片列表中的文件，包含后缀格式 filetype参考enum类型
//pos为下载起始点，可以实现断点续传功能（1080模块不带此功能，POS传入为0，下载失败先把文件删掉再从0开始下载） progressBlock 下载进度 fileDLResultBlock 下载结束回调
/**
 Download file，path is the full path,contains .MP4 suffix(Make sure that path is exist) filetype reference enum type.
 
 pos is the download starting point，Can realize the breakpoint continuingly（1080p module have not this function，pos 0，download Failed， delete first and starting from 0 to download again） progressBlock: Download progress. fileDLResultBlock download callback
 */
- (void)downloadFileToPath:(NSString *)path fileName:(NSString *)fileName FileType:(NSNumber *)fileType pos:(NSNumber *)pos progressBlock:(dlProgressBlock)progressBlock resultblock:(fileDLResultBlock)resultblock;
//下载完成必须调用此方法 call after download complete
- (void)downloadFinishWithFileName:(NSString *)fileName FileType:(NSNumber *)fileType result:(cmdResultBlock)block;
//删除SD卡中视频 delete the file in sd/tf card
- (void)deleteWithFileName:(NSString *)fileName FileType:(NSNumber *)fileType result:(cmdResultBlock)block;


@end
