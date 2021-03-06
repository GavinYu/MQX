//
//  YNCFB_SwitchCell.m
//  YuneecApp
//
//  Created by vrsh on 26/04/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import "YNCFB_SwitchCell.h"

#import "YNCAppConfig.h"
#import "YNCCameraSettingModel.h"

@interface YNCFB_SwitchCell ()

@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation YNCFB_SwitchCell

- (void)setShowLine:(BOOL)showLine
{
    _showLine = showLine;
    _lineView.hidden = !showLine;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _textL.font = [UIFont thirteenFontSize];
    _lineView.backgroundColor = [UIColor lightGrayishColor];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureTextLabel:(YNCCameraSettingModel *)dataModel
{
    _textL.text = NSLocalizedString(dataModel.item, nil);
    _textL.textColor = [UIColor atrousColor];
    _switchBtn.on = [NSLocalizedString(dataModel.status, nil) boolValue];
}

- (IBAction)switchAction:(UISwitch *)sender {
    if ([_delegate respondsToSelector:@selector(switchBtnAction:)]) {
        [_delegate switchBtnAction:sender];
    }
}


@end
