//
//  YNCCameraSettingModeCell.m
//  YuneecApp
//
//  Created by vrsh on 22/03/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import "YNCCameraSettingModeCell.h"

#import "YNCCameraSettingViewModel.h"

#import "UIFont+YNCFont.h"

@interface YNCCameraSettingModeCell ()

@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation YNCCameraSettingModeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _itemLabel.font = [UIFont thirteenFontSize];
    _statusLabel.font = [UIFont tenFontSize];
}


- (void)configureWithModel:(YNCCameraSettingViewModel *)model
{
    self.itemLabel.text = NSLocalizedString(model.item, nil);
    self.statusLabel.text = NSLocalizedString(model.status, nil);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
