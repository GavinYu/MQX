//
//  YNCFB_ISOCell.m
//  YuneecApp
//
//  Created by hank on 08/05/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import "YNCFB_ISOCell.h"

#import "YNCSettingSlider.h"
#import "YNCAppConfig.h"

@interface YNCFB_ISOCell ()<YNCSettingSliderDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *animationLabel;
@property (weak, nonatomic) IBOutlet UILabel *minLabel;
@property (weak, nonatomic) IBOutlet YNCSettingSlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *maxLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, assign) CGFloat space;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *animationLabelLeftConstraint;

@end

@implementation YNCFB_ISOCell

- (void)setEnableUse:(BOOL)enableUse
{
    _enableUse = enableUse;
    _slider.enableUse = enableUse;
    if (enableUse) {
        _animationLabel.textColor = [UIColor yncGreenColor];
    } else {
        _animationLabel.textColor = [UIColor yncGreenColor];
    }
}

- (void)setTextValue:(NSString *)textValue
{
    _textValue = textValue;
    _titleLabel.font = [UIFont tenFontSize];
    _minLabel.font = [UIFont tenFontSize];
    _maxLabel.font = [UIFont tenFontSize];
    _animationLabel.font = [UIFont thirteenFontSize];
    _animationLabel.text = textValue;
    int value = textValue.intValue;
    CGFloat index = 0.0;
    if (value >= 100 && value < 200) {
        index = 0.5;
    } else if (value >= 200 && value < 400) {
        index = 1.5;
    } else if (value >= 400 && value < 800) {
        index = 2.5;
    } else if (value >= 800 && value < 1600) {
        index = 3.5;
    } else if (value >= 1600 && value < 3200) {
        index = 4.5;
    } else if (value >= 3200 && value < 6400) {
        index = 5.5;
    } else if (value >= 6400 ) {
        index = 6.5;
        _animationLabel.text = @"6400";
    } else if (value < 100) {
        index = 0.5;
        _animationLabel.text = @"100";
    }
    _slider.value = index / 7.0;
    self.animationLabelLeftConstraint.constant = -25 + 106 * _slider.value;
}

- (NSArray *)dataArray
{
    if (!_dataArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"YNCFB_ISOValue" ofType:@"plist"];
        self.dataArray = [NSArray arrayWithContentsOfFile:path];
    }
    return _dataArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _titleLabel.text = NSLocalizedString(@"camera_setting_iso", nil);
    _titleLabel.textColor = [UIColor yncGreenColor];
    _minLabel.textColor = [UIColor yncGreenColor];
    _maxLabel.textColor = [UIColor yncGreenColor];
    _animationLabel.textColor = [UIColor yncGreenColor];
    _slider.delegate = self;
    _slider.sliderColor = YNCSettingSliderColorGreen;
    _slider.sliderType = YNCSettingSliderTypeCameraSetting;
    _slider.value = 0.0;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - YNCSettingSliderDelegate
- (void)sliderValue:(CGFloat)value sender:(UIPanGestureRecognizer *)sender
{
    CGPoint center = sender.view.center;
    CGPoint newCenter = [self.backView convertPoint:center fromView:_slider];
    _animationLabel.center = CGPointMake(newCenter.x, _animationLabel.center.y);
    
    if (!self.space) {
        self.space = _slider.frame.size.width / (self.dataArray.count);
    }
    CGFloat length = value * _slider.frame.size.width;
    int number = (int)(length / _space);
    if (number >= self.dataArray.count) {
        number = number - 1;
    }
    _animationLabel.text = [NSString stringWithFormat:@"%@", self.dataArray[number]];
    
//    NSLog(@"----%.2f---%.2f ----%.2f---%d ---%@", _slider.frame.size.width, _space, length, number, self.dataArray[number]);
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSNumber *isoValue = self.dataArray[number];
//        [[YNCCameraManager sharedCameraManager] setISOValue:isoValue.integerValue block:^(NSError * _Nullable error) {
//            if (error) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:YNC_CAMEAR_WARNING_NOTIFICATION object:nil userInfo:@{@"msgid":[NSNumber numberWithInt:YNCWARNING_ISO_SETTINGS_FAILED], @"isHidden":[NSNumber numberWithBool:NO]}];
//            } else {
//#ifdef OPENTOAST_HANK
//                [[YNCMessageBox instance] show:@"setISO_success"];
//#endif
//            }
//        }];
    }
}

@end
