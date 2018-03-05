//
//  YNCFB_TimeLapseCell.m
//  YuneecApp
//
//  Created by hank on 23/06/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import "YNCFB_TimeLapseCell.h"

#import "YNCAppConfig.h"

@interface YNCFB_TimeLapseCell()
@property (weak, nonatomic) IBOutlet UIButton *timeTwoBtn;
@property (weak, nonatomic) IBOutlet UIButton *timeFiveBtn;
@property (weak, nonatomic) IBOutlet UIButton *timeSevenBtn;
@property (weak, nonatomic) IBOutlet UIButton *timeFifteenBtn;
@property (weak, nonatomic) IBOutlet UIButton *timeTwentyBtn;

@end

@implementation YNCFB_TimeLapseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _timeTwoBtn.tag = 402;
    _timeFiveBtn.tag = 405;
    _timeSevenBtn.tag = 410;
    _timeFifteenBtn.tag = 415;
    _timeTwentyBtn.tag = 420;
    _timeTwoBtn.titleLabel.font = [UIFont thirteenFontSize];
    _timeFiveBtn.titleLabel.font = [UIFont thirteenFontSize];
    _timeSevenBtn.titleLabel.font = [UIFont thirteenFontSize];
    _timeFifteenBtn.titleLabel.font = [UIFont thirteenFontSize];
    _timeTwentyBtn.titleLabel.font = [UIFont thirteenFontSize];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)timeBtnAction:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(timeLapseBtnAction:)]) {
        [_delegate timeLapseBtnAction:sender];
    }
}

- (void)changeTimeBtnTitleColor:(NSInteger)timeNum
{
    if (timeNum == 2000) {
        [_timeTwoBtn setTitleColor:[UIColor yncGreenColor] forState:UIControlStateNormal];
        [_timeFiveBtn setTitleColor:[UIColor yncGreenColor] forState:UIControlStateNormal];
        [_timeSevenBtn setTitleColor:[UIColor yncGreenColor] forState:UIControlStateNormal];
        [_timeFifteenBtn setTitleColor:[UIColor yncGreenColor] forState:UIControlStateNormal];
        [_timeTwentyBtn setTitleColor:[UIColor yncGreenColor] forState:UIControlStateNormal];
    } else if (timeNum == 5000) {
        [_timeTwoBtn setTitleColor:[UIColor yncGreenColor] forState:UIControlStateNormal];
        [_timeFiveBtn setTitleColor:[UIColor yncGreenColor] forState:UIControlStateNormal];
        [_timeSevenBtn setTitleColor:[UIColor yncGreenColor] forState:UIControlStateNormal];
        [_timeFifteenBtn setTitleColor:[UIColor yncGreenColor] forState:UIControlStateNormal];
        [_timeTwentyBtn setTitleColor:[UIColor yncGreenColor] forState:UIControlStateNormal];
    } else if (timeNum == 10000) {
        [_timeTwoBtn setTitleColor:[UIColor yncGreenColor] forState:UIControlStateNormal];
        [_timeFiveBtn setTitleColor:[UIColor yncGreenColor] forState:UIControlStateNormal];
        [_timeSevenBtn setTitleColor:[UIColor yncGreenColor] forState:UIControlStateNormal];
        [_timeFifteenBtn setTitleColor:[UIColor yncGreenColor] forState:UIControlStateNormal];
        [_timeTwentyBtn setTitleColor:[UIColor yncGreenColor] forState:UIControlStateNormal];
    } else if (timeNum == 15000) {
        [_timeTwoBtn setTitleColor:[UIColor yncGreenColor] forState:UIControlStateNormal];
        [_timeFiveBtn setTitleColor:[UIColor yncGreenColor] forState:UIControlStateNormal];
        [_timeSevenBtn setTitleColor:[UIColor yncGreenColor] forState:UIControlStateNormal];
        [_timeFifteenBtn setTitleColor:[UIColor yncGreenColor] forState:UIControlStateNormal];
        [_timeTwentyBtn setTitleColor:[UIColor yncGreenColor] forState:UIControlStateNormal];
    } else if (timeNum == 20000) {
        [_timeTwoBtn setTitleColor:[UIColor yncGreenColor] forState:UIControlStateNormal];
        [_timeFiveBtn setTitleColor:[UIColor yncGreenColor] forState:UIControlStateNormal];
        [_timeSevenBtn setTitleColor:[UIColor yncGreenColor] forState:UIControlStateNormal];
        [_timeFifteenBtn setTitleColor:[UIColor yncGreenColor] forState:UIControlStateNormal];
        [_timeTwentyBtn setTitleColor:[UIColor yncGreenColor] forState:UIControlStateNormal];
    }
}

@end
