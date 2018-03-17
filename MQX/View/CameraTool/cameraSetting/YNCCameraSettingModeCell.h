//
//  YNCCameraSettingModeCell.h
//  YuneecApp
//
//  Created by vrsh on 22/03/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YNCCameraSettingModel;

@interface YNCCameraSettingModeCell : UITableViewCell

@property (strong, nonatomic) UIColor *titleColor;
@property (assign, nonatomic) BOOL isShowRightArrowImage;

- (void)configureWithModel:(YNCCameraSettingModel *)model;

@end
