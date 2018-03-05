//
//  YNCFB_PhotoModeCell.m
//  YuneecApp
//
//  Created by hank on 29/06/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import "YNCFB_PhotoModeCell.h"

#import "YNCAppConfig.h"

@implementation YNCFB_PhotoModeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _descriptionLabel.font = [UIFont thirteenFontSize];
    _numLabel.font = [UIFont tenFontSize];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureSubviewsWithDic:(NSDictionary *)dic
{
    self.descriptionLabel.text = NSLocalizedString(dic[@"item"], nil);
    if ([dic[@"status"] isEqualToString:@"camera_setting_camera_mode_singleShot"]) {
        self.numLabel.hidden = YES;
        _photoModeImageV.hidden = NO;
        self.photoModeImageV_rightConstant.constant = 25;
        self.photoModeImageV.image = [UIImage imageNamed:@"btn_singleNormal"];
    } else if ([dic[@"status"] isEqualToString:@"camera_setting_camera_mode_multiple"]) {
        self.numLabel.hidden = NO;
        _photoModeImageV.hidden = NO;
        self.photoModeImageV_rightConstant.constant = 38;
        self.photoModeImageV.image = [UIImage imageNamed:@"btn_burstNormal"];
//        self.numLabel.text = [NSString stringWithFormat:@"%ld", [YNCCameraManager sharedCameraManager].currentBurstAmount];
    } else if ([dic[@"status"] isEqualToString:@"camera_setting_camera_mode_timelapse"]) {
        _photoModeImageV.hidden = NO;
        self.numLabel.hidden = NO;
        self.photoModeImageV_rightConstant.constant = 45;
        self.photoModeImageV.image = [UIImage imageNamed:@"btn_timeLaspeNormal"];
//        self.numLabel.text = [NSString stringWithFormat:@"%ds", (int)[YNCCameraManager sharedCameraManager].currentMillisecond / 1000];
    } else {
        self.numLabel.hidden = NO;
        self.photoModeImageV.hidden = YES;
        self.numLabel.text = NSLocalizedString(dic[@"status"], nil);
    }
}

@end
