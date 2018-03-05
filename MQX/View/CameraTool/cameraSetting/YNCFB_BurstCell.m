//
//  YNCFB_BurstCell.m
//  YuneecApp
//
//  Created by hank on 23/06/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import "YNCFB_BurstCell.h"

#import "YNCAppConfig.h"

@interface YNCFB_BurstCell()

@property (weak, nonatomic) IBOutlet UIButton *nubThreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *nubFiveBtn;
@property (weak, nonatomic) IBOutlet UIButton *nubSevenBtn;


@end

@implementation YNCFB_BurstCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _nubThreeBtn.tag = 203;
    _nubFiveBtn.tag = 205;
    _nubSevenBtn.tag = 207;
    _nubThreeBtn.titleLabel.font = [UIFont thirteenFontSize];
    _nubFiveBtn.titleLabel.font = [UIFont thirteenFontSize];
    _nubSevenBtn.titleLabel.font = [UIFont thirteenFontSize];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)nubBtnsAction:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(numberBtnAction:)]) {
        [_delegate numberBtnAction:sender];
    }
}

- (void)changeBtnTitleColor:(NSInteger)numb
{
    if (numb == 3) {
        [_nubThreeBtn setTitleColor:[UIColor yncGreenColor] forState:UIControlStateNormal];
        [_nubFiveBtn setTitleColor:[UIColor yncGreenColor] forState:UIControlStateNormal];
        [_nubSevenBtn setTitleColor:[UIColor yncGreenColor] forState:UIControlStateNormal];
    } else if (numb == 5) {
        [_nubThreeBtn setTitleColor:[UIColor yncGreenColor] forState:UIControlStateNormal];
        [_nubFiveBtn setTitleColor:[UIColor yncGreenColor] forState:UIControlStateNormal];
        [_nubSevenBtn setTitleColor:[UIColor yncGreenColor] forState:UIControlStateNormal];
    } else if (numb == 7) {
        [_nubThreeBtn setTitleColor:[UIColor yncGreenColor] forState:UIControlStateNormal];
        [_nubFiveBtn setTitleColor:[UIColor yncGreenColor] forState:UIControlStateNormal];
        [_nubSevenBtn setTitleColor:[UIColor yncGreenColor] forState:UIControlStateNormal];
    }
}

@end
