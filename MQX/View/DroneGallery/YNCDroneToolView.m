//
//  YNCDroneToolView.m
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/17.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import "YNCDroneToolView.h"

#import "YNCPopWindowView.h"
#import "YNCMacros.h"

@implementation YNCDroneToolView
+ (instancetype)droneToolView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
}

- (IBAction)deleteBtnAction:(UIButton *)sender {
    WS(weakSelf);
    [YNCPopWindowView showMessage:NSLocalizedString(@"gallery_delete_file_sure", nil)
               buttonTitleConfirm:NSLocalizedString(@"person_center_sure", nil)
                buttonTitleCancel:NSLocalizedString(@"person_center_cancel", nil)
                        colorType:PopWindowViewColorTypeOrange
                         sizeType:PopWindowViewSizeTypeBig
                    handleConfirm:^{
                        if ([weakSelf.delegate respondsToSelector:@selector(deleteMedia)]) {
                            [weakSelf.delegate deleteMedia];
                        }
                    } handleCancel:^{
                        
                    }];
}

- (IBAction)downloadBtnAction:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(downloadMedia)]) {
        [_delegate downloadMedia];
    }
}

- (void)setAbleUse:(BOOL)ableUse
{
    _ableUse = ableUse;
    if (ableUse) {
        self.downloadBtn.alpha = 1.0;
        self.downloadBtn.enabled = YES;
        self.deleteBtn.alpha = 1.0;
        self.deleteBtn.enabled = YES;
    } else {
        self.downloadBtn.alpha = 0.6;
        self.downloadBtn.enabled = NO;
        self.deleteBtn.alpha = 0.6;
        self.deleteBtn.enabled = NO;
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
