//
//  YNCCameraSettingModeCell.m
//  YuneecApp
//
//  Created by vrsh on 22/03/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import "YNCCameraSettingModeCell.h"

#import "YNCCameraSettingModel.h"

#import "UIFont+YNCFont.h"

@interface YNCCameraSettingModeCell ()

@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrowImageView;

@end

@implementation YNCCameraSettingModeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _itemLabel.font = [UIFont thirteenFontSize];
    _statusLabel.font = [UIFont tenFontSize];
}

//MARK: -- config Cell
- (void)configureWithModel:(YNCCameraSettingModel *)model
{
    self.itemLabel.text = NSLocalizedString(model.item, nil);
    self.statusLabel.text = NSLocalizedString(model.status, nil);
}
//MARK: -- setter titleColor
- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    _itemLabel.textColor = _titleColor;
}

//MARK: -- setter isShowRightArrowImage
- (void)setIsShowRightArrowImage:(BOOL)isShowRightArrowImage {
    _isShowRightArrowImage = isShowRightArrowImage;
    _rightArrowImageView.hidden = !_isShowRightArrowImage;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
