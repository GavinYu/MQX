//
//  YNCCameraSettingFooterView.m
//  YuneecApp
//
//  Created by vrsh on 24/03/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import "YNCCameraSettingFooterView.h"

#import "YNCAppConfig.h"

@interface YNCCameraSettingFooterView ()

@property (weak, nonatomic) IBOutlet UIButton *formatBtn;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;

@end

@implementation YNCCameraSettingFooterView


+ (instancetype)cameraSettingFooterView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}


- (void)configureWithDictionary:(NSDictionary *)dictionary
{
    _formatBtn.titleLabel.font = [UIFont thirteenFontSize];
    _resetBtn.titleLabel.font = [UIFont thirteenFontSize];
    [_formatBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_formatBtn setTitleColor:[UIColor yncGreenColor] forState:(UIControlStateNormal)];
    [_formatBtn setTitle:NSLocalizedString(dictionary[@"title"], nil) forState:(UIControlStateNormal)];
    [_resetBtn setTitleColor:[UIColor yncGreenColor] forState:(UIControlStateNormal)];
    [_resetBtn setTitle:NSLocalizedString(@"camera_setting_restore_default_settings", nil) forState:(UIControlStateNormal)];
    self.statusLabel.text = NSLocalizedString(dictionary[@"status"], nil);
    self.statusLabel.textColor = [UIColor yncGreenColor];
    _statusLabel.font = [UIFont tenFontSize];
}

- (IBAction)resetBtnAction:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(resetCameraSettings)]) {
        [_delegate resetCameraSettings];
    }
}

- (IBAction)formatBtnAction:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(formatSDcardStoreage)]) {
        [_delegate formatSDcardStoreage];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
