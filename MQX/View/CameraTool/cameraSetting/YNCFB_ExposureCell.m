//
//  YNCFB_ExposureCell.m
//  YuneecApp
//
//  Created by hank on 08/05/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import "YNCFB_ExposureCell.h"

#import "YNCFB_ExposureView.h"
#import "YNCFB_MaskView.h"
#import "UIColor+YNCColor.h"
#import "UIFont+YNCFont.h"

@interface YNCFB_ExposureCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet YNCFB_ExposureView *maskImageView;
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end

@implementation YNCFB_ExposureCell

- (void)setValue:(CGFloat)value
{
    _value = value;
    _maskImageView.value = value;
}

- (void)setEnableUse:(BOOL)enableUse
{
    _enableUse = enableUse;
    _reduceBtn.hidden = !enableUse;
    _addBtn.hidden = !enableUse;
    _maskImageView.valueLabel.textColor = [UIColor yncGreenColor];
    UIImage *image = [UIImage imageNamed:@"icon_ExposureShow"];
    if (!enableUse) {
        _maskImageView.valueLabel.textColor = [UIColor grayColor];
        image = [UIImage imageNamed:@"icon_ExposureUnable"];
    }
    _maskImageView.customMaskView.maskLayer.contents = (__bridge id _Nullable)(image.CGImage);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleLabel.textColor = [UIColor grayColor];
    _titleLabel.text = NSLocalizedString(@"camera_setting_exposure", nil);
    _titleLabel.font = [UIFont tenFontSize];
}

- (IBAction)reduceBtnAction:(UIButton *)sender {
    if (_maskImageView.value == -3.0) {
        return;
    }
}

- (IBAction)addBtnAction:(UIButton *)sender {
    if (_maskImageView.value == 3.0) {
        return;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
