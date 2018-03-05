//
//  YNCCameraSettingHeaderView.h
//  YuneecApp
//
//  Created by vrsh on 27/03/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YNCCameraSettingHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
+ (instancetype)cameraSetttingHeaderView;

@end
