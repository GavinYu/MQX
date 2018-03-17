//
//  YNCCircleProgressView.m
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/17.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import "YNCCircleProgressView.h"

#import "YNCCircleProgress.h"
#import "YNCCircleProgressModel.h"
#import "YNCPopWindowView.h"
#import "YNCAppConfig.h"

#define kProgressViewWidth 60

@interface YNCCircleProgressView ()
@property (weak, nonatomic) IBOutlet UILabel *currentDownloadLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *taskSizeLabel;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) YNCCircleProgress *circleProgress;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@end

@implementation YNCCircleProgressView
- (void)setType:(YNCFB_ProgressViewType)type
{
    _type = type;
    if (type == YNCFB_ProgressViewTypeHorizontal) {
        _widthConstraint.constant = 375;
    } else {
        _widthConstraint.constant = 300;
    }
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    WS(weakSelf);
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.circleProgress.progress = progress;
        NSString *str = [NSString stringWithFormat:@"%.f%%", progress * 100];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
        NSUInteger length = str.length;
        [attrStr addAttribute:NSFontAttributeName value:SystemFont_19 range:NSMakeRange(0, length - 1)];
        [attrStr addAttribute:NSFontAttributeName value:SystemFont_13 range:NSMakeRange(length - 1, 1)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:TextWhiteColor range:NSMakeRange(0, length)];
        weakSelf.progressLabel.attributedText = attrStr;
    });
}

+ (instancetype)circleProgress
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)createSubViews
{
    [self layoutIfNeeded];
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    _backView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    self.circleProgress = [[YNCCircleProgress alloc] init];
    [self addSubview:_circleProgress];
    [_circleProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.equalTo(@(kProgressViewWidth));
    }];
    [self layoutIfNeeded];
    [_circleProgress createLayer];
    
    self.progressLabel = [[UILabel alloc] init];
    _progressLabel.backgroundColor = [UIColor clearColor];
    _progressLabel.textAlignment = NSTextAlignmentCenter;
    _progressLabel.textColor = TextWhiteColor;
    [self addSubview:_progressLabel];
    [_progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(@(70));
        make.height.equalTo(@(30));
    }];
}

- (void)configureSubviewWithModel:(YNCCircleProgressModel *)model
{
    NSString *str = NSLocalizedString(@"person_center_downloading", nil);
    NSString *currentNumStr = [NSString stringWithFormat:@"%ld", model.currentDownloadNum];
    NSString *totalNumStr = [NSString stringWithFormat:@"%ld", model.totalDownloadNum];
    NSUInteger length = str.length;
    NSUInteger currentNumStrLength = currentNumStr.length;
    NSUInteger totalNumStrLength = totalNumStr.length;
    str = [str stringByAppendingString:[NSString stringWithFormat:@"(%ld/%ld)", model.currentDownloadNum, model.totalDownloadNum]];
    
    //创建NSMutableAttributedString
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
    
    //设置字体和设置字体的范围
    [attrStr addAttribute:NSFontAttributeName value:SystemFont_17 range:NSMakeRange(0, str.length)];
    //添加文字颜色
    [attrStr addAttribute:NSForegroundColorAttributeName value:TextWhiteColor range:NSMakeRange(0, length + 1)];
    //添加文字背景颜色
    [attrStr addAttribute:NSForegroundColorAttributeName value:TextOrangeColor range:NSMakeRange(length + 1, currentNumStrLength)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:TextWhiteColor range:NSMakeRange(length + 1 + currentNumStrLength, 2 + totalNumStrLength)];
    _currentDownloadLabel.attributedText = attrStr;
    
    _taskSizeLabel.text = [NSString stringWithFormat:@"大小:%@", model.fileSize];
    _taskSizeLabel.textColor = TextWhiteColor;
    _taskSizeLabel.font = SystemFont_13;
}

- (IBAction)cancelBtnAction:(UIButton *)sender {
    WS(weakSelf);
    [YNCPopWindowView showMessage:@"确认取消下载？"
               buttonTitleConfirm:NSLocalizedString(@"person_center_sure", nil)
                buttonTitleCancel:NSLocalizedString(@"person_center_cancel", nil)
                        colorType:PopWindowViewColorTypeOrange
                         sizeType:PopWindowViewSizeTypeBig
                    handleConfirm:^{
                        if ([weakSelf.delegate respondsToSelector:@selector(cancelDownload)]) {
                            [weakSelf.delegate cancelDownload];
                        }
                    } handleCancel:^{
                        
                    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
