//
//  YNCWarningManager.m
//  YuneecApp
//
//  Created by yc-sh-vr-pc05 on 2017/5/20.
//  Copyright © 2017年 yuneec. All rights reserved.
//

#import "YNCWarningManager.h"

#import "YNCWarningView.h"
#import "YNCAppConfig.h"

@interface YNCWarningManager ()

//警告相关的变量
@property (assign, nonatomic) CGFloat currentOriginY;
@property (assign, nonatomic) CGFloat currentOriginLeftY;
@property (assign, nonatomic) CGFloat currentOriginRightY;

@property (assign, nonatomic) YNCModeDisplay currentDisplay;
@property (assign, nonatomic) NSInteger directCode; //0表示原图，1表示fpv左图，2表示fpv右图

@end

@implementation YNCWarningManager

YNCSingletonM(WarningManager)

//MARK: -- lazyload  thirdWarningArray
- (NSMutableArray *)thirdWarningArray {
    if (!_thirdWarningArray) {
        _thirdWarningArray = [NSMutableArray new];
    }
    
    return _thirdWarningArray;
}

//MARK: -- lazyload  leftSecondWarningViewArray
- (NSMutableArray *)leftSecondWarningViewArray {
    if (!_leftSecondWarningViewArray) {
        _leftSecondWarningViewArray = [NSMutableArray new];
    }
    
    return _leftSecondWarningViewArray;
}

//MARK: -- lazyload  rightSecondWarningViewArray
- (NSMutableArray *)rightSecondWarningViewArray {
    if (!_rightSecondWarningViewArray) {
        _rightSecondWarningViewArray = [NSMutableArray new];
    }
    
    return _rightSecondWarningViewArray;
}

//MARK: -- lazyload  secondWarningViewArray
- (NSMutableArray *)secondWarningViewArray {
    if (!_secondWarningViewArray) {
        _secondWarningViewArray = [NSMutableArray new];
    }
    
    return _secondWarningViewArray;
}

//MARK: -- lazyload  thirdWarningViewArray
- (NSMutableArray *)thirdWarningViewArray {
    if (!_thirdWarningViewArray) {
        _thirdWarningViewArray = [NSMutableArray new];
    }
    
    return _thirdWarningViewArray;
}

//MARK: -- lazyload  thirdWarningViewArray
- (NSMutableArray *)leftThirdWarningViewArray {
    if (!_leftThirdWarningViewArray) {
        _leftThirdWarningViewArray = [NSMutableArray new];
    }
    
    return _leftThirdWarningViewArray;
}

//MARK: -- lazyload  thirdWarningViewArray
- (NSMutableArray *)rightThirdWarningViewArray {
    if (!_rightThirdWarningViewArray) {
        _rightThirdWarningViewArray = [NSMutableArray new];
    }
    
    return _rightThirdWarningViewArray;
}

//MARK: -- lazyload  secondWarningMsgDictionary
- (NSMutableDictionary *)secondWarningMsgDictionary {
    if (!_secondWarningMsgDictionary) {
        _secondWarningMsgDictionary = [NSMutableDictionary new];
    }
    
    return _secondWarningMsgDictionary;
}

//MARK: -- get second warning msg
- (NSMutableDictionary *)getSecondWarningMsg {
    if (self.secondWarningMsgDictionary.count > 0) {
        [self.secondWarningViewArray removeAllObjects];
        self.secondWarningViewArray = nil;
        [self.leftSecondWarningViewArray removeAllObjects];
        self.leftSecondWarningViewArray = nil;
        [self.rightSecondWarningViewArray removeAllObjects];
        self.rightSecondWarningViewArray = nil;
    }
    
    return self.secondWarningMsgDictionary;
}

//MARK: -- 根据警告通知，得知警告等级类型
- (YNCWarningLevel)getWarningType:(NSInteger)type {
    YNCWarningLevel tmpLevel;
    switch (type) {
        case YNCWARNING_DEVICE_DISCONNECTED:
        case YNCWARNING_DEVICE_CONNECTED:
        case YNCWARNING_DRONE_DISCONNECTED:
        case YNCWARNING_DRONE_CONNECTED:
        case YNCWARNING_DRONE_WIFI_WEAK:
        case YNCWARNING_DRONE_WIFI_DISCONNECTED:
        case YNCWARNING_ZIGBEE_DISCONNECTED:
        case YNCWARNING_VOLTAGE_1:
        case YNCWARNING_VOLTAGE_2:
        case YNCWARNING_MOTOR_ESC:
        case YNCWARNING_HIGH_TEMPERATURE:
        case YNCWARNING_COMPASS_CALIBRATION:
        case YNCWARNING_FLYAWAY:
        case YNCWARNING_NO_FLY_ZONE:
        case YNCWARNING_ACC_ERROR:
        case YNCWARNING_MEGNETIC_ERROR:
        case YNCWARNING_GYROSCOPE_ERROR:
        case YNCWARNING_GPS_LOST_FIRSTCLASS:
        case YNCWARNING_GPS_ERROR_FIRSTCLASS:
        case YNCWARNING_FIXING_LOW_POWER_STAGE1:
        case YNCWARNING_FIXING_LOW_POWER_STAGE2:
        case YNCWARNING_FLIGHTCONTROL_GYRO_ERROR:
        case YNCWARNING_FLIGHTCONTROL_BAROMETER_ERROR:
        case YNCWARNING_FLIGHTCONTROL_GEOMAGNETISM_ERROR:
        case YNCWARNING_FLIGHTCONTROL_GPS_ERROR:
        case YNCWARNING_FLIGHTCONTROL_EEPROM_ERROR:
            
            tmpLevel = YNCWarningLevelFirst;
            break;
            
        case YNCWARNING_AUTO_LANDING:
        case YNCWARNING_BACK_CIRCLEDING:
        case YNCWARNING_MAGNETIC_STRONG:
        case YNCWARNING_DRONE_LOST_CONNECTED:
        case YNCWARNING_CAMERA_INIT_FAILED:
        case YNCWARNING_CONTROL_VOLTAGE_LOW:
        case YNCWARNING_FLYING_LOST_GPS:
        case YNCWARNING_RETURN_TO_HOME:
        case YNCWARNING_FIXING_LOW_POWER_STAGE1_HINT_AIR:
        case YNCWARNING_FIXING_LOW_POWER_STAGE2_HINT_NOHOME:
        case YNCWARNING_FIXING_LOW_POWER_STAGE2_HINT_WITHHOME:
        case YNCWARNING_FIXING_LOW_POWER_STAGE3_HINT_GROUND:
        case YNCWARNING_FLIGHTCONTROL_NO_SETTING_HOME:
            
            tmpLevel = YNCWarningLevelSecond;
            break;
            
        case YNCWARNING_CAMERA_NOT_TAKEPHOTO:
        case YNCWARNING_CAMERA_NOT_VIDEO:
        case YNCWARNING_CAMERA_TAKE_PHOTO_FAILED:
        case YNCWARNING_CAMERA_START_VIDEO_FAILED:
        case YNCWARNING_CAMERA_STOP_VIDEO_FAILED:
        case YNCWARNING_CAMERA_SWITCH_MODE_FAILED:
        case YNCWARNING_CAMERA_SET_FICKER_FAILED:
        case YNCWARNING_CAMERA_SET_EV_FAILED:
        case YNCWARNING_CAMERA_SET_WB_FAILED:
        case YNCWARNING_CAMERA_SD_FORMAT_FAILED:
        case YNCWARNING_CAMERA_SD_FORMAT_SUCCEED:
        case YNCWARNING_COMMEND_TIME_OUT:
        case YNCWARNING_BIND_COMMEDN_TIME_OUT:
        case YNCWARNING_SETTING_COMMAND_FAIL:
        case YNCWARNING_CAMERA_BUSY:
        case YNCWARNING_CAMERA_STOP_TAKE_PHOTO_FAILED:
        case YNCWARNING_PHOTO_MODE_BURST_FAILED:
        case YNCWARNING_PHOTO_MODE_TIMELAPSE_FAILED:
        case YNCWARNING_METER_MODE_FAILED:
        case YNCWARNING_IMAGE_QUALITY_MODE_FAILED:
        case YNCWARNING_PHOTO_FORMAT_FAILED:
        case YNCWARNING_PHOTO_RESOLUTION_FAILED:
        case YNCWARNING_VIDEO_FILE_FORMAT_FAILED:
        case YNCWARNING_VIDEO_RESOLUTION_FAILED:
        case YNCWARNING_PHOTO_QUALITY_FAILED:
        case YNCWARNING_RESET_ALL_SETTINGS_FAILED:
        case YNCWARNING_ISO_SETTINGS_FAILED:
        case YNCWARNING_SHUTTER_MODE_FAILED:
        case YNCWARNING_EXPOSURE_MODE_FAILED:
            
        case YNCWARNING_CAMERA_NO_SDCARD:
        case YNCWARNING_CAMERA_ISRECORDING:
        case YNCWARNING_CAMERA_ISINTERVALPHOTO:
        case YNCWARNING_CAMERA_SEND_COMMAND_FAILED:
        case YNCWARNING_CAMERA_SDCARD_NO_SPACE:
            
        case YNCWARNING_VIDEO_RESOLUTION_NO_SUPPORT_PHOTO_MODE:
        case YNCWARNING_SHOT_MODE_NO_SUPPORT_VIDEO_MODE:
        case YNCWARNING_CAMERA_MODE_NO_SUPPORT_IN_RECORDING:
        case YNCWARNING_CAMERA_DISCONNECT_CAN_NOT_TAKINGPHOTO:
        case YNCWARNING_PHOTO_MODE_TIMELAPSE_CAN_NOT_SETTING_CAMERA_MODE:
        case YNCWARNING_CAMERA_LOW_LATENCY_MODE_FAILED:
        case YNCWARNING_CAMERA_VIDEO_DIRECTION_FAILED:
            
            tmpLevel = YNCWarningLevelThird;
            break;
            
        default:
            tmpLevel = YNCWarningLevelUnknown;
            break;
    }
    
    return tmpLevel;
}

//MARK: -- 移除二级警告视图
- (void)removeSecondWarningView:(id)object {
    WS(weakSelf);
    
    [self.secondWarningMsgDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        int tmpWarningCode = [object[@"msgid"] intValue];
        if ([key intValue] == tmpWarningCode) {
            [weakSelf dismissWarningView:tmpWarningCode withWarningViewIsHidden:[object[@"isHidden"]boolValue]];
            *stop = YES;
        }
    }];
}

//MARK: -- 显示警告
- (void)showWarningViewInViewWithObject:(id)object withModeDisplay:(YNCModeDisplay)display withDirectCode:(NSInteger)directCode {
    WS(weakSelf);
    BOOL tmpResult = NO;
    
    //    self.currentDisplay = display;
    display = directCode==0?YNCModeDisplayNormal:YNCModeDisplayGlass;
    self.directCode = directCode;
    
    NSString *showMsg = @"";
    int warningCode = [object[@"msgid"] intValue];
    YNCWarningLevel warningType = [self getWarningType:warningCode];
    
    switch (warningType) {
        case YNCWarningLevelFirst:
            break;
            
        case YNCWarningLevelSecond:
        {
            switch (warningCode) {
                case YNCWARNING_AUTO_LANDING:
                    showMsg = NSLocalizedString(@"flight_interface_warning_LANDING", nil);
                    break;
                    
                case YNCWARNING_BACK_CIRCLEDING:
                    showMsg = NSLocalizedString(@"flight_interface_mode_FIXWING_LOITER", nil);
                    break;
                    
                case YNCWARNING_MAGNETIC_STRONG:
                    showMsg = NSLocalizedString(@"person_center_male", nil);
                    break;
                    
                case YNCWARNING_DRONE_LOST_CONNECTED:
                    showMsg = NSLocalizedString(@"flight_interface_mode_FIXWING_LOITER", nil);
                    break;
                    
                case YNCWARNING_CAMERA_INIT_FAILED:
                    showMsg = NSLocalizedString(@"flight_interface_warning_CAMERA_INIT_FAIL", nil);
                    break;
                    
                case YNCWARNING_CONTROL_VOLTAGE_LOW:
                    showMsg = NSLocalizedString(@"flight_interface_warning_CONTROL_VOLTAGE_LOW", nil);
                    break;
                    
                case YNCWARNING_FLYING_LOST_GPS:
                    showMsg = NSLocalizedString(@"flight_interface_mode_FIXWING_LOST_SINGAL", nil);
                    break;
                    
                case YNCWARNING_RETURN_TO_HOME:
                    showMsg = NSLocalizedString(@"flight_interface_warning_RETURN_TO_HOME", nil);
                    break;
                    
                case YNCWARNING_FIXING_LOW_POWER_STAGE3_HINT_GROUND:
                    showMsg = NSLocalizedString(@"flight_interface_warning_FIXING_LOW_POWER_STAGE3_hint_ground", nil);
                    break;
                    
                case YNCWARNING_FIXING_LOW_POWER_STAGE2_HINT_WITHHOME:
                    showMsg = NSLocalizedString(@"flight_interface_warning_FIXING_LOW_POWER_STAGE2_hint_withhome", nil);
                    break;
                    
                case YNCWARNING_FIXING_LOW_POWER_STAGE2_HINT_NOHOME:
                    showMsg = NSLocalizedString(@"flight_interface_warning_FIXING_LOW_POWER_STAGE2_hint_nohome", nil);
                    break;
                    
                case YNCWARNING_FIXING_LOW_POWER_STAGE1_HINT_AIR:
                    showMsg = NSLocalizedString(@"flight_interface_warning_FIXING_LOW_POWER_STAGE1_hint_air", nil);
                    break;
                    
                case YNCWARNING_FLIGHTCONTROL_NO_SETTING_HOME:
                    showMsg = NSLocalizedString(@"flight_interface_warning_no_setting_home", nil);
                    break;
                    
                default:
                    break;
            }
            
            YNCWarningView *secondView = [YNCWarningView instanceWarningView];
            secondView.tag = warningCode;
            secondView.closeButton.userInteractionEnabled = display == YNCModeDisplayGlass?NO:YES;
            
            [secondView setContainerView:_containerView];
            
            if ([object[@"isHidden"] boolValue] == NO) {
                [secondView initSubView:showMsg withWarningType:YNCWarningLevelSecond withModeDisplay:display];
                [secondView showInViewWithOriginY:NAVGATIONBARHEIGHT];
                
                [self updateWarningViewFrame:NO];
            }
            
            if (directCode == 1) {
                self.currentOriginLeftY = NAVGATIONBARHEIGHT*0.5 + secondView.bounds.size.height + 8*0.5;
                [self.leftSecondWarningViewArray insertObject:secondView atIndex:0];
                
                [secondView setCloseBtnBlock:^(YNCWarningView *warningView){
                    [weakSelf.leftSecondWarningViewArray removeObject:warningView];
                    weakSelf.directCode = 1;
                    [weakSelf updateWarningViewFrame:YES];
                }];
                
            } else if (directCode == 2) {
                self.currentOriginRightY = NAVGATIONBARHEIGHT*0.5 + secondView.bounds.size.height + 8*0.5;
                [self.rightSecondWarningViewArray insertObject:secondView atIndex:0];
                
                [secondView setCloseBtnBlock:^(YNCWarningView *warningView){
                    [weakSelf.rightSecondWarningViewArray removeObject:warningView];
                    weakSelf.directCode = 2;
                    [weakSelf updateWarningViewFrame:YES];
                }];
            } else if (directCode == 0) {
                self.currentOriginY = NAVGATIONBARHEIGHT + secondView.bounds.size.height+ 8;
                [self.secondWarningViewArray insertObject:secondView atIndex:0];
                //保存二级警告内容
                if (![[self.secondWarningMsgDictionary allKeys] containsObject:object[@"msgid"]]) {
                    [self.secondWarningMsgDictionary setValue:object forKey:object[@"msgid"]];
                }
                
                [secondView setCloseBtnBlock:^(YNCWarningView *warningView){
                    [weakSelf dismissWarningView:warningView.tag withWarningViewIsHidden:NO];
                }];
            }
        }
            break;
            
        case YNCWarningLevelThird:
        {
            
            switch (warningCode) {
                case YNCWARNING_CAMERA_NOT_TAKEPHOTO:
                    showMsg = NSLocalizedString(@"flight_interface_warning_NO_ENOUGH_MEMERY_PHOTO", nil);
                    break;
                    
                case YNCWARNING_CAMERA_NOT_VIDEO:
                    showMsg = NSLocalizedString(@"flight_interface_warning_NO_ENOUGH_MEMERY_RECORD", nil);
                    break;
                    
                case YNCWARNING_CAMERA_TAKE_PHOTO_FAILED:
                    showMsg = NSLocalizedString(@"flight_interface_warning_TAKE_PHOTO_COMMEND_FAIL", nil);
                    break;
                    
                case YNCWARNING_CAMERA_START_VIDEO_FAILED:
                    showMsg = NSLocalizedString(@"flight_interface_warning_START_RECORD_COMMEND_FAIL", nil);
                    break;
                    
                case YNCWARNING_CAMERA_STOP_VIDEO_FAILED:
                    showMsg = NSLocalizedString(@"flight_interface_warning_STOP_RECORD_COMMEND_FAIL", nil);
                    break;
                    
                case YNCWARNING_CAMERA_SWITCH_MODE_FAILED:
                    showMsg = NSLocalizedString(@"flight_interface_warning_CAMERA_MODE_CHANGE_FAIL", nil);
                    break;
                    
                case YNCWARNING_CAMERA_SET_FICKER_FAILED:
                    showMsg = NSLocalizedString(@"camera_setting_setting_failed", nil);
                    break;
                    
                case YNCWARNING_CAMERA_SET_EV_FAILED:
                    showMsg = NSLocalizedString(@"camera_setting_setting_failed", nil);
                    break;
                    
                case YNCWARNING_CAMERA_SET_WB_FAILED:
                    showMsg = NSLocalizedString(@"camera_setting_setting_failed", nil);
                    break;
                    
                case YNCWARNING_CAMERA_SD_FORMAT_FAILED:
                    showMsg = NSLocalizedString(@"camera_setting_sd_format_failed", nil);
                    break;
                    
                case YNCWARNING_CAMERA_SD_FORMAT_SUCCEED:
                {
                    showMsg = NSLocalizedString(@"camera_setting_sd_format_succeed", nil);
                    tmpResult = YES;
                }
                    break;
                    
                case YNCWARNING_COMMEND_TIME_OUT:
                    showMsg = NSLocalizedString(@"flight_interface_warning_COMMEND_TIME_OUT", nil);
                    break;
                    
                case YNCWARNING_BIND_COMMEDN_TIME_OUT:
                    showMsg = NSLocalizedString(@"flight_interface_warning_BIND_COMMEDN_TIME_OUT", nil);
                    break;
                    
                case YNCWARNING_SETTING_COMMAND_FAIL:
                    showMsg = NSLocalizedString(@"camera_setting_setting_failed", nil);
                    break;
                    
                case YNCWARNING_CAMERA_BUSY:
                    showMsg = NSLocalizedString(@"flight_interface_warning_CAMERA_BUZZY", nil);
                    break;
                    
                case YNCWARNING_CAMERA_STOP_TAKE_PHOTO_FAILED:
                    showMsg = NSLocalizedString(@"camera_setting_stop_take_photo_failed", nil);
                    break;
                    
                case YNCWARNING_PHOTO_MODE_BURST_FAILED:
                    showMsg = NSLocalizedString(@"camera_setting_setting_failed", nil);
                    break;
                    
                case YNCWARNING_PHOTO_MODE_TIMELAPSE_FAILED:
                    showMsg = NSLocalizedString(@"camera_setting_setting_failed", nil);
                    break;
                    
                case YNCWARNING_METER_MODE_FAILED:
                    showMsg = NSLocalizedString(@"camera_setting_setting_failed", nil);
                    break;
                    
                case YNCWARNING_IMAGE_QUALITY_MODE_FAILED:
                    showMsg = NSLocalizedString(@"camera_setting_setting_failed", nil);
                    break;
                    
                case YNCWARNING_PHOTO_FORMAT_FAILED:
                    showMsg = NSLocalizedString(@"camera_setting_setting_failed", nil);
                    break;
                    
                case YNCWARNING_PHOTO_RESOLUTION_FAILED:
                    showMsg = NSLocalizedString(@"camera_setting_setting_failed", nil);
                    break;
                    
                case YNCWARNING_VIDEO_FILE_FORMAT_FAILED:
                    showMsg = NSLocalizedString(@"camera_setting_setting_failed", nil);
                    break;
                    
                case YNCWARNING_VIDEO_RESOLUTION_FAILED:
                    showMsg = NSLocalizedString(@"camera_setting_setting_failed", nil);
                    break;
                    
                case YNCWARNING_PHOTO_QUALITY_FAILED:
                    showMsg = NSLocalizedString(@"camera_setting_setting_failed", nil);
                    break;
                    
                case YNCWARNING_RESET_ALL_SETTINGS_FAILED:
                    showMsg = NSLocalizedString(@"camera_setting_reset_all_failed", nil);
                    break;
                    
                case YNCWARNING_ISO_SETTINGS_FAILED:
                    showMsg = NSLocalizedString(@"camera_setting_setting_failed", nil);
                    break;
                    
                case YNCWARNING_SHUTTER_MODE_FAILED:
                    showMsg = NSLocalizedString(@"camera_setting_setting_failed", nil);
                    break;
                    
                case YNCWARNING_EXPOSURE_MODE_FAILED:
                    showMsg = NSLocalizedString(@"camera_setting_setting_failed", nil);
                    break;
                    
                case YNCWARNING_CAMERA_ISRECORDING:
                    showMsg = NSLocalizedString(@"flight_interface_warning_CAMERA_ISRECORDING", nil);
                    break;
                    
                case YNCWARNING_CAMERA_ISINTERVALPHOTO:
                    showMsg = NSLocalizedString(@"flight_interface_warning_CAMERA_ISINTERVALPHOTO", nil);
                    break;
                    
                case YNCWARNING_CAMERA_SDCARD_NO_SPACE:
                    showMsg = NSLocalizedString(@"flight_interface_warning_NO_ENOUGH_MEMERY", nil);
                    break;
                    
                case YNCWARNING_CAMERA_SEND_COMMAND_FAILED:
                    showMsg = NSLocalizedString(@"flight_interface_warning_SEND_COMMAND_FAILED", nil);
                    break;
                    
                case YNCWARNING_CAMERA_NO_SDCARD:
                    showMsg = NSLocalizedString(@"flight_interface_warning_CAMERA_NO_SDCARD", nil);
                    break;
                    
                case YNCWARNING_VIDEO_RESOLUTION_NO_SUPPORT_PHOTO_MODE:
                    showMsg = NSLocalizedString(@"camera_setting_photo_video_size_tip", nil);
                    break;
                    
                case YNCWARNING_SHOT_MODE_NO_SUPPORT_VIDEO_MODE:
                    showMsg = NSLocalizedString(@"camera_setting_video_photo_mode_tip", nil);
                    break;
                    
                case YNCWARNING_CAMERA_MODE_NO_SUPPORT_IN_RECORDING:
                    showMsg = NSLocalizedString(@"flight_interface_warning_CAN_NOT_TAKINGPHOTO", nil);

                case YNCWARNING_CAMERA_LOW_LATENCY_MODE_FAILED:
                    showMsg = NSLocalizedString(@"camera_setting_setting_failed", nil);
                    break;
                case YNCWARNING_CAMERA_DISCONNECT_CAN_NOT_TAKINGPHOTO:
                    showMsg = NSLocalizedString(@"flight_interface_warning_connect_wifi", nil);
                    break;
                case YNCWARNING_PHOTO_MODE_TIMELAPSE_CAN_NOT_SETTING_CAMERA_MODE:
                    showMsg = NSLocalizedString(@"camera_setting_setting_timelapse_failed", nil);
                    break;
                    
                case YNCWARNING_CAMERA_VIDEO_DIRECTION_FAILED:
                    showMsg = NSLocalizedString(@"camera_setting_setting_failed", nil);

                    break;
                    
                default:
                    break;
            }
            
            YNCWarningView *thirdView = [YNCWarningView instanceWarningView];
            thirdView.tag = warningCode;
    
            [thirdView initSubView:showMsg withWarningType:YNCWarningLevelThird withModeDisplay:display];
            
            [thirdView setContainerView:_containerView];
            
            //更新警告框
            if (tmpResult) {
                [thirdView setWarningViewIconAndTitleColor:tmpResult];
            }
            
            if (directCode == 0) {
                if (_secondWarningViewArray.count > 0) {
                    YNCWarningView *tmpView = _secondWarningViewArray[_secondWarningViewArray.count - 1];
                    self.currentOriginY = tmpView.frame.origin.y + tmpView.bounds.size.height + 8;
                } else {
                    self.currentOriginY = NAVGATIONBARHEIGHT;
                }
                
                
                [thirdView showInViewWithOriginY:self.currentOriginY];
                
            } else if (directCode == 1) {
                if (_leftSecondWarningViewArray.count > 0) {
                    YNCWarningView *tmpView = _leftSecondWarningViewArray[_leftSecondWarningViewArray.count - 1];
                    self.currentOriginLeftY = tmpView.frame.origin.y + tmpView.bounds.size.height + 8*0.5;
                } else {
                    self.currentOriginLeftY = NAVGATIONBARHEIGHT*0.5;
                }
                
                [thirdView showInViewWithOriginY:self.currentOriginLeftY*2];
            } else {
                if (_rightSecondWarningViewArray.count > 0) {
                    YNCWarningView *tmpView = _rightSecondWarningViewArray[_rightSecondWarningViewArray.count - 1];
                    self.currentOriginRightY = tmpView.frame.origin.y + tmpView.bounds.size.height + 8*0.5;
                } else {
                    self.currentOriginRightY = NAVGATIONBARHEIGHT*0.5;
                }
                
                [thirdView showInViewWithOriginY:self.currentOriginRightY*2];
            }
            
            [self.thirdWarningArray addObject:[NSNumber numberWithInt:warningCode]];
            
            [thirdView setCloseBtnBlock:^(YNCWarningView *warningView){
                DLog(@"相机切换移除前:%@", self.thirdWarningArray);
                [weakSelf.thirdWarningArray removeObject:[NSNumber numberWithInteger:[object[@"msgid"] integerValue]]];
                DLog(@"相机切换移除后:%@", self.thirdWarningArray);
                
                [weakSelf.thirdWarningViewArray removeObject:warningView];
                [weakSelf updateViewArrayFrame:weakSelf.thirdWarningViewArray withIsClosed:YES withWarningType:YNCWarningLevelThird];
            }];
            
            if (directCode == 0) {
                if (self.secondWarningViewArray.count > 0) {
                    self.currentOriginY = self.currentOriginY + thirdView.bounds.size.height + 8;
                } else {
                    if (self.thirdWarningViewArray.count > 0) {
                        self.currentOriginY = NAVGATIONBARHEIGHT + thirdView.bounds.size.height+ 8;
                    }
                }
                
                [self updateViewArrayFrame:self.thirdWarningViewArray withIsClosed:NO withWarningType:YNCWarningLevelThird];
                
                [self.thirdWarningViewArray insertObject:thirdView atIndex:0];
            } else if (directCode == 1) {
                if (self.leftSecondWarningViewArray.count > 0) {
                    self.currentOriginLeftY = self.currentOriginLeftY + thirdView.bounds.size.height + 8*0.5;
                } else {
                    if (self.leftThirdWarningViewArray.count > 0) {
                        self.currentOriginLeftY = NAVGATIONBARHEIGHT*0.5 + thirdView.bounds.size.height + 8*0.5;
                    }
                }
                
                [self updateViewArrayFrame:self.leftThirdWarningViewArray withIsClosed:NO withWarningType:YNCWarningLevelThird];
                
                [self.leftThirdWarningViewArray insertObject:thirdView atIndex:0];
            } else {
                if (self.rightSecondWarningViewArray.count > 0) {
                    self.currentOriginRightY = self.currentOriginRightY + thirdView.bounds.size.height + 8*0.5;
                } else {
                    if (self.rightThirdWarningViewArray.count > 0) {
                        self.currentOriginRightY = NAVGATIONBARHEIGHT*0.5 + thirdView.bounds.size.height + 8*0.5;
                    }
                }
                
                [self updateViewArrayFrame:self.rightThirdWarningViewArray withIsClosed:NO withWarningType:YNCWarningLevelThird];
                
                [self.rightThirdWarningViewArray insertObject:thirdView atIndex:0];
            }
            
        }
            break;
            
        default:
            break;
    }
}
//MARK: -- update warningView frame
- (void)updateWarningViewFrame:(BOOL)isClosed {
    if (self.directCode == 0) {
        if (self.secondWarningViewArray.count > 0) {
            [self updateViewArrayFrame:self.secondWarningViewArray withIsClosed:isClosed withWarningType:YNCWarningLevelSecond];
        }
        
        if (self.thirdWarningViewArray.count > 0) {
            [self updateViewArrayFrame:self.thirdWarningViewArray withIsClosed:isClosed withWarningType:YNCWarningLevelThird];
        }
    } else if (self.directCode == 1) {
        if (self.leftSecondWarningViewArray.count > 0) {
            [self updateViewArrayFrame:self.leftSecondWarningViewArray withIsClosed:isClosed withWarningType:YNCWarningLevelSecond];
        }
        
        if (self.thirdWarningViewArray.count > 0) {
            [self updateViewArrayFrame:self.thirdWarningViewArray withIsClosed:isClosed withWarningType:YNCWarningLevelThird];
        }
    } else {
        if (self.rightSecondWarningViewArray.count > 0) {
            [self updateViewArrayFrame:self.rightSecondWarningViewArray withIsClosed:isClosed withWarningType:YNCWarningLevelSecond];
        }
        
        if (self.thirdWarningViewArray.count > 0) {
            [self updateViewArrayFrame:self.thirdWarningViewArray withIsClosed:isClosed withWarningType:YNCWarningLevelThird];
        }
    }
}

- (void)updateViewArrayFrame:(NSMutableArray *)array withIsClosed:(BOOL)isClosed withWarningType:(YNCWarningLevel)warningType {
    WS(weakSelf);
    if (isClosed) {
        if (self.directCode == 0) {
            if (warningType == YNCWarningLevelThird) {
                if (self.secondWarningViewArray.count > 0) {
                    YNCWarningView *tmpView = _secondWarningViewArray[_secondWarningViewArray.count - 1];
                    self.currentOriginY = tmpView.frame.origin.y + tmpView.bounds.size.height + 8;
                } else {
                    self.currentOriginY = NAVGATIONBARHEIGHT;
                }
            } else {
                self.currentOriginY = NAVGATIONBARHEIGHT;
            }
        } else if (self.directCode == 1) {
            if (warningType == YNCWarningLevelThird) {
                if (self.leftSecondWarningViewArray.count > 0) {
                    YNCWarningView *tmpView = _leftSecondWarningViewArray[_leftSecondWarningViewArray.count - 1];
                    self.currentOriginLeftY = tmpView.frame.origin.y + tmpView.bounds.size.height + 8*0.5;
                } else {
                    self.currentOriginLeftY = NAVGATIONBARHEIGHT*0.5;
                }
            } else {
                self.currentOriginLeftY = NAVGATIONBARHEIGHT*0.5;
            }
        } else {
            if (warningType == YNCWarningLevelThird) {
                if (self.rightSecondWarningViewArray.count > 0) {
                    YNCWarningView *tmpView = self.rightSecondWarningViewArray[self.rightSecondWarningViewArray.count - 1];
                    self.currentOriginRightY = tmpView.frame.origin.y + tmpView.bounds.size.height + 8*0.5;
                } else {
                    self.currentOriginRightY = NAVGATIONBARHEIGHT*0.5;
                }
            } else {
                self.currentOriginRightY = NAVGATIONBARHEIGHT*0.5;
            }
        }
    }
    
    for (int i = 0; i < array.count; ++i) {
        YNCWarningView *tmpView = array[i];
        [UIView animateWithDuration:yAnimationDuration animations:^{
            if (weakSelf.directCode == 0) {
                tmpView.frame = CGRectMake(tmpView.frame.origin.x, weakSelf.currentOriginY, tmpView.bounds.size.width, tmpView.bounds.size.height);
                weakSelf.currentOriginY = weakSelf.currentOriginY + tmpView.bounds.size.height + 8;
            } else if (weakSelf.directCode == 1) {
                tmpView.frame = CGRectMake(tmpView.frame.origin.x, weakSelf.currentOriginLeftY, tmpView.bounds.size.width, tmpView.bounds.size.height);
                weakSelf.currentOriginLeftY = weakSelf.currentOriginLeftY + tmpView.bounds.size.height + 8 * 0.5;
            } else {
                tmpView.frame = CGRectMake(tmpView.frame.origin.x, weakSelf.currentOriginRightY, tmpView.bounds.size.width, tmpView.bounds.size.height);
                weakSelf.currentOriginRightY = weakSelf.currentOriginRightY + tmpView.bounds.size.height + 8 * 0.5;
            }
            
        }];
    }
}

- (void)dismissWarningView:(NSInteger)tag withWarningViewIsHidden:(BOOL)isHidden {
    WS(weakSelf);
    if (self.secondWarningViewArray.count > 0) {
        [self.secondWarningViewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YNCWarningView *itemView = (YNCWarningView *)obj;
            if (itemView.tag == tag) {
                [itemView disMissWarningView:yAnimationDuration];
                [weakSelf.secondWarningViewArray removeObject:itemView];
                weakSelf.directCode = 0;
                [weakSelf updateWarningViewFrame:YES];
                
                if (isHidden) {
                    [weakSelf.secondWarningMsgDictionary removeObjectForKey:[NSNumber numberWithInteger:tag]];
                }
                
                *stop = YES;
            }
        }];
    }
    
    if (self.leftSecondWarningViewArray.count > 0) {
        [self.leftSecondWarningViewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YNCWarningView *itemView = (YNCWarningView *)obj;
            if (itemView.tag == tag) {
                [itemView disMissWarningView:yAnimationDuration];
                [weakSelf.leftSecondWarningViewArray removeObject:itemView];
                weakSelf.directCode = 1;
                [weakSelf updateWarningViewFrame:YES];
                
                *stop = YES;
            }
        }];
    }
    
    if (self.rightSecondWarningViewArray.count > 0) {
        [self.rightSecondWarningViewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YNCWarningView *itemView = (YNCWarningView *)obj;
            if (itemView.tag == tag) {
                [itemView disMissWarningView:yAnimationDuration];
                [weakSelf.rightSecondWarningViewArray removeObject:itemView];
                weakSelf.directCode = 2;
                [weakSelf updateWarningViewFrame:YES];
                
                *stop = YES;
            }
        }];
    }
}

//MARK: -- HD Racer 根据警告errorFlag转换成 "警告系统"对应的WarningCode
+ (int)HDRacerErrorFlagConvertWarningCode:(int)errorFlag {
    int tmpWarningCode = 0;
    switch (errorFlag) {
            //飞机一级低电量警报
        case 1:
            tmpWarningCode = YNCWARNING_FIXING_LOW_POWER_STAGE1;
            break;
            
            //飞机二级低电量警报
        case 3:
            tmpWarningCode = YNCWARNING_FIXING_LOW_POWER_STAGE2;
            break;
            
            //flight mode is FLIGHT_MODE_WAITING_FOR_RC, value is 17---飞机2.4G掉信号
        case 17:
            tmpWarningCode = YNCWARNING_ZIGBEE_DISCONNECTED;
            break;
            
        default:
            break;
    }
    
    return tmpWarningCode;
}
//MARK: -- 移除所有的二级警告信息及视图
- (void)removeAllSecondWarningMsgAndWarningView {
    [self.secondWarningMsgDictionary removeAllObjects];
    
    WS(weakSelf);
    if (self.secondWarningViewArray.count > 0) {
        [self.secondWarningViewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YNCWarningView *itemView = (YNCWarningView *)obj;
            [itemView disMissWarningView:yAnimationDuration];
            [weakSelf.secondWarningViewArray removeObject:itemView];
            weakSelf.directCode = 0;
            [weakSelf updateWarningViewFrame:YES];
            
            if (self.secondWarningViewArray.count == 0) {
                *stop = YES;
            }
        }];
    }
    
    if (self.leftSecondWarningViewArray.count > 0) {
        [self.leftSecondWarningViewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YNCWarningView *itemView = (YNCWarningView *)obj;
            
            [itemView disMissWarningView:yAnimationDuration];
            [weakSelf.leftSecondWarningViewArray removeObject:itemView];
            weakSelf.directCode = 1;
            [weakSelf updateWarningViewFrame:YES];
            
            if (self.leftSecondWarningViewArray.count == 0) {
                *stop = YES;
            }
        }];
    }
    
    if (self.rightSecondWarningViewArray.count > 0) {
        [self.rightSecondWarningViewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YNCWarningView *itemView = (YNCWarningView *)obj;
            
            [itemView disMissWarningView:yAnimationDuration];
            [weakSelf.rightSecondWarningViewArray removeObject:itemView];
            weakSelf.directCode = 2;
            [weakSelf updateWarningViewFrame:YES];
            
            if (self.rightSecondWarningViewArray.count == 0) {
                *stop = YES;
            }
        }];
    }
}

//MARK: -- Setter
- (void)setContainerView:(UIView *)containerView {
    if (_containerView) {
        _containerView = nil;
    }
    _containerView = containerView;
}

@end
