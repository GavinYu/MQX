//
//  YNCCameraSettingModeCell.h
//  YuneecApp
//
//  Created by vrsh on 22/03/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YNCCameraSettingDataModel;
@interface YNCCameraSettingModeCell : UITableViewCell

- (void)configureWithModel:(YNCCameraSettingDataModel *)model;

@end
