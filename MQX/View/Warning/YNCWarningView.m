//
//  YNCWarningView.m
//  YuneecApp
//
//  Created by yc-sh-vr-pc05 on 2017/3/20.
//  Copyright © 2017年 yuneec. All rights reserved.
//

#import "YNCWarningView.h"

#import "YNCAppConfig.h"

@interface YNCWarningView ()
{
    YNCWarningLevel _warningLevel;
    CGFloat _sizeMultiple;
}
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UIImageView *closeImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (assign, nonatomic) YNCWarningLevel currentWarningType;

@end

@implementation YNCWarningView

@synthesize warningLevel = _warningLevel;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (YNCWarningView *)instanceWarningView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"YNCWarningView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)setWarningType:(YNCWarningLevel)warningLevel {
    if (_warningLevel != warningLevel) {
        _warningLevel = warningLevel;
    }
}

//MARK: -- 初始化子视图
- (void)initSubView:(NSString *)message withWarningType:(YNCWarningLevel)warningLevel withModeDisplay:(YNCModeDisplay)display {
    WS(weakSelf);
    
    _sizeMultiple = display == YNCModeDisplayGlass?0.5:1.0;
    
    self.frame = CGRectMake(0, 0, self.bounds.size.width*_sizeMultiple, self.bounds.size.height*_sizeMultiple);
    
    self.messageLabel.font = [UIFont systemFontOfSize:14*_sizeMultiple];
    self.messageLabel.text = message;
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(weakSelf);
        make.size.mas_equalTo(weakSelf);
    }];
    
    [self.closeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).offset(-6*_sizeMultiple);
        make.top.equalTo(weakSelf).offset(6*_sizeMultiple);
        make.size.mas_equalTo(CGSizeMake(15*_sizeMultiple, 15*_sizeMultiple));
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(35*_sizeMultiple, 35*_sizeMultiple));
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(15);
        make.centerY.equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(15*_sizeMultiple, 15*_sizeMultiple));
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(5*_sizeMultiple);
        make.centerY.equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(150*_sizeMultiple, 40*_sizeMultiple));
    }];
    
    self.closeButton.tag = self.tag;
    
    self.currentWarningType = warningLevel;

    CGFloat textWidth = warningLevel==YNCWarningLevelThird?(self.messageLabel.bounds.size.width + CGRectGetWidth(self.closeButton.bounds) - 10):self.messageLabel.bounds.size.width;
    
    CGFloat textHeight = [YNCUtil getTextHeightWithContent:message withContentSizeOfWidth:textWidth withAttribute:@{NSFontAttributeName:self.messageLabel.font}];
    textHeight = textHeight > self.messageLabel.bounds.size.height?textHeight:self.messageLabel.bounds.size.height;
    [self.messageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(textWidth*_sizeMultiple, textHeight*_sizeMultiple));
    }];
    
    if (textHeight > self.messageLabel.bounds.size.height) {
        CGFloat tmpDiff = textHeight - self.messageLabel.bounds.size.height;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, self.bounds.size.height + tmpDiff);
        [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(weakSelf);
            make.size.mas_equalTo(weakSelf);
        }];
    }
    
    switch (warningLevel) {
        case YNCWarningLevelFirst:
            break;
            
        case YNCWarningLevelSecond:
        {
            self.closeButton.hidden = NO;
            self.closeImageView.hidden = NO;
            self.messageLabel.textColor = [UIColor yncFirebirdYellowColor];
        }
            break;
            
        case YNCWarningLevelThird:
        {
            self.closeButton.hidden = YES;
            self.closeImageView.hidden = YES;
            self.messageLabel.textColor = [UIColor yncFirebirdWhiteColor];
        }
            break;
            
        default:
            break;
    }
}

- (IBAction)clickCloseButton:(UIButton *)sender {
    if (sender) {
        if (_closeBtnBlock) {
            _closeBtnBlock(self);
        }
    }
    
    [self disMissWarningView:yAnimationDuration];
    
}

//MARK: -- remove warningView
- (void)disMissWarningView:(NSTimeInterval)duration {
    WS(weakSelf);
    
    [UIView animateWithDuration:duration animations:^{
        weakSelf.frame = CGRectMake(-weakSelf.bounds.size.width, weakSelf.frame.origin.y, weakSelf.bounds.size.width, weakSelf.bounds.size.height);
        [weakSelf removeFromSuperview];
        _containerView = nil;
    }];
}

//MARK: -- show warningView
- (void)showInViewWithOriginY:(CGFloat)originY {
    WS(weakSelf);
    
    self.frame = CGRectMake(0, originY*_sizeMultiple, self.bounds.size.width, self.bounds.size.height);
    [_containerView addSubview:self];
    self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;

    [UIView animateWithDuration:yAnimationDuration animations:^{
        weakSelf.frame = CGRectMake(0, self.frame.origin.y, self.bounds.size.width, self.bounds.size.height);
    }];
    
    if (self.currentWarningType == YNCWarningLevelThird) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(yAutoDismissDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (_closeBtnBlock) {
                _closeBtnBlock(weakSelf);
            }
            [weakSelf disMissWarningView:yAnimationDuration];
        });
    } else if (self.currentWarningType == YNCWarningLevelSecond) {
    }
}
//MARK: -- 更新警告图标和字体颜色
- (void)setWarningViewIconAndTitleColor:(BOOL)isSucceed {
    _iconImageView.image = [UIImage imageNamed: isSucceed==YES?@"icon_tips_normal":@"icon_tips_abnormal"];
    _messageLabel.textColor = isSucceed==YES?[UIColor yncFirebirdGreenColor]:[UIColor yncFirebirdYellowColor];
}


- (void)dealloc {
    DLog(@"YNCWarningView call dealloc");
    if (_containerView) {
        _containerView = nil;
    }
}

//MARK: -- Setter
- (void)setContainerView:(UIView *)containerView {
    if (_containerView) {
        _containerView = nil;
    }
    _containerView = containerView;
}

@end
