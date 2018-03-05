//
//  YNCCameraCommonSettingView.h
//  YuneecApp
//
//  Created by vrsh on 22/03/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YNCCameraSettingView.h"

#import "YNCEnum.h"

@protocol YNCCameraCommonSettingViewDelegate <NSObject>

@optional
- (void)cameraSettingView_didSelectedIndexPath:(NSIndexPath *)indexPath;
- (void)whiteBalanceView_didSelectedIndexPath:(NSIndexPath *)indexPath;
- (void)cameraModeView_didSelectedIndexPath:(NSIndexPath *)indexPath;
- (void)meteringModeView_didSelectedIndexPath:(NSIndexPath *)indexPath;
- (void)sceneModeView_didSelectedIndexPath:(NSIndexPath *)indexPath;
- (void)videoFormatView_didSelectedIndexPath:(NSIndexPath *)indexPath;
- (void)videoResolutionView_didSelectedIndexPath:(NSIndexPath *)indexPath;
- (void)photoFormatView_didSelectedIndexPath:(NSIndexPath *)indexPath;
- (void)photoResolutionView_didSelectedIndexPath:(NSIndexPath *)indexPath;
- (void)photoQualityView_didSelectedIndexPath:(NSIndexPath *)indexPath;
- (void)fickerModeView_didSelectedIndexPath:(NSIndexPath *)indexPath;
- (void)back;
- (void)footerView_resetCameraSettings;
- (void)footerView_formatSDcardStoreage;
// 拍照模式代理
- (void)fb_photoModeBurstNumber:(UIButton *)btn;
- (void)fb_photoModeTimeLapse:(UIButton *)btn;

@end


@interface YNCCameraCommonSettingView : UIView

@property (nonatomic, assign) YNCCameraSettingViewType cameraSettingViewType;
@property (nonatomic, weak) id<YNCCameraCommonSettingViewDelegate> delegate;
@property (nonatomic, assign) BOOL showBackBtn;
@property (nonatomic, assign) BOOL hasFooterView;
// 配置完视图之后在设置数据
@property (nonatomic, copy) NSMutableDictionary *dataDictionary;
@property (nonatomic, strong) NSIndexPath *previousIndexPath;
@property (nonatomic, strong) NSIndexPath *originIndexPath;

- (void)updateFooterViewStorage;
- (void)whiteBalance_changeCellStyleWithIndexPath:(NSIndexPath *)indexPath;
- (void)videoMode_changeCellStyleWithIndexPath:(NSIndexPath *)indexPath;
- (void)cameraMode_changeCellStyleWithIndexPath:(NSIndexPath *)indexPath;
- (void)reloadCellWithIndexPaths:(NSArray *)indexPaths;
- (void)reloadTableView;

/**
 改变连拍按钮颜色
 
 @param num 3、5、7
 */
- (void)changeBurstCellBtnTitleColor:(NSInteger)num;


/**
 改变延时拍照按钮延时
 
 @param num 2、5、10、15、20
 */
- (void)changeTimeLapseCellBtnTitleColor:(NSInteger)num;
@end
