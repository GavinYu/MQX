//
//  YNCCameraSettingFooterView.h
//  YuneecApp
//
//  Created by vrsh on 24/03/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YNCCameraSettingFooterViewDelegate <NSObject>

- (void)resetCameraSettings;
- (void)formatSDcardStoreage;
//设置低延时模式
- (void)setLowLatencyMode:(BOOL)on;
//设置图传视频方向
- (void)setVideoDirection:(BOOL)on;

@end

@interface YNCCameraSettingFooterView : UIView

@property (nonatomic, weak) id <YNCCameraSettingFooterViewDelegate> delegate;
+ (instancetype)cameraSettingFooterView;
- (void)configureWithDictionary:(NSDictionary *)dictionary;
//更新低延时模式开关
- (void)updateLowLatencySwitch:(BOOL)on;
//更新图传视频方向开关
- (void)updateVideoDirectionSwitch:(BOOL)on;

@end
