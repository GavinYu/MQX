//
//  WTAboutInfoCell.m
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/23.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import "WTAboutInfoCell.h"

#import "YNCCameraSettingModel.h"
#import "YNCAppConfig.h"

@implementation WTAboutInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_versionTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(5);
        make.size.mas_equalTo(CGSizeMake(140, self.bounds.size.height));
    }];
    [_versionNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_versionTypeLabel);
        make.left.equalTo(_versionTypeLabel.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(self.bounds.size.width-CGRectGetMaxX(_versionTypeLabel.frame), self.bounds.size.height));
    }];
}

//MARK: -- config Cell
- (void)configureWithModel:(YNCCameraSettingModel *)model
{
    _versionTypeLabel.text = NSLocalizedString(model.item, nil);
    CGFloat width = [YNCUtil getTextWidthWithContent:_versionTypeLabel.text withContentSizeOfHeight:CGRectGetHeight(_versionTypeLabel.bounds) withAttribute:@{NSFontAttributeName:_versionTypeLabel.font}];
    
    [_versionTypeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(width+10, _versionTypeLabel.bounds.size.height));
    }];
    
    _versionNumberLabel.text = model.status;
    [_versionNumberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_versionTypeLabel.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(self.bounds.size.width-CGRectGetMaxX(_versionTypeLabel.frame), _versionNumberLabel.bounds.size.height));
    }];
    
    [self layoutIfNeeded];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
