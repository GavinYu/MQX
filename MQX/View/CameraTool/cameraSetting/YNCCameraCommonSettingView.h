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
- (void)back;
- (void)footerView_resetCameraSettings;
- (void)footerView_formatSDcardStoreage;

@end

@interface YNCCameraCommonSettingView : UIView

@property (nonatomic, assign) YNCCameraSettingViewType cameraSettingViewType;
@property (nonatomic, weak) id<YNCCameraCommonSettingViewDelegate> delegate;
@property (nonatomic, assign) BOOL showBackBtn;
// 配置完视图之后在设置数据
@property (nonatomic, copy) NSMutableDictionary *dataDictionary;
@property (nonatomic, strong) NSIndexPath *previousIndexPath;
@property (nonatomic, strong) NSIndexPath *originIndexPath;

- (void)updateFooterViewStorage;
- (void)reloadCellWithIndexPaths:(NSArray *)indexPaths;
- (void)reloadTableView;
@end
