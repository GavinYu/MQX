//
//  WTAboutInfoCell.h
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/23.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YNCCameraSettingModel;

@interface WTAboutInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *versionTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionNumberLabel;

//MARK: -- config Cell
- (void)configureWithModel:(YNCCameraSettingModel *)model;

@end
