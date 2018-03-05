//
//  YNMessageBox.m
//  SkyViewS
//
//  Created by kenny on 16/8/1.
//  Copyright © 2016年 Gavin. All rights reserved.
//

#import "YNCMessageBox.h"

#import "YNCAppConfig.h"

static YNCMessageBox * sharedInstance = nil;
#define UIColorWithRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface YNCMessageBox()

@property (assign, nonatomic) YNMessageBoxStyle style;
@property (nonatomic, strong) UILabel *warningLabel;
@property (nonatomic, strong) UILabel *rightWarningLabel;

@end

@implementation YNCMessageBox


+ (YNCMessageBox *)instance {
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        sharedInstance = [[self alloc]init];
    });
    
    return sharedInstance;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.animateDuration = 1.0;
    }
    return self;
}

- (UIView *)warningView
{
    if (!_warningView) {
        _warningView = [[UIView alloc] init];
        _warningView.layer.masksToBounds = YES;
        _warningView.layer.cornerRadius = 3;
    }
    return _warningView;
}

- (UILabel *)warningLabel
{
    if (!_warningLabel) {
        _warningLabel = [[UILabel alloc]init];
        _warningLabel.numberOfLines = 0;
        [_warningLabel setTextColor:[UIColor whiteColor]];
        [_warningLabel setTextAlignment:NSTextAlignmentLeft];
        _warningLabel.preferredMaxLayoutWidth = SCREENWIDTH / 2.0 - 30;
    }
    return _warningLabel;
}

- (UILabel *)rightWarningLabel
{
    if (!_rightWarningLabel) {
        _rightWarningLabel = [[UILabel alloc]init];
        _rightWarningLabel.numberOfLines = 0;
        [_rightWarningLabel setTextColor:[UIColor whiteColor]];
        [_rightWarningLabel setTextAlignment:NSTextAlignmentLeft];
        _rightWarningLabel.preferredMaxLayoutWidth = SCREENWIDTH / 2.0 - 30;
    }
    return _rightWarningLabel;
}

- (UIView *)rightWarningView
{
    if (!_rightWarningView) {
        _rightWarningView = [[UIView alloc] init];
        _rightWarningView.layer.masksToBounds = YES;
        _rightWarningView.layer.cornerRadius = 3;
    }
    return _rightWarningView;
}



- (void)setStyle:(YNMessageBoxStyle)style {
    _style = style;
    switch (_style) {
        case YNMessageBoxStyleClear:
            [self.warningView setBackgroundColor:[UIColor colorWithRed:24.0 / 255.0 green:24 / 255.0 blue:24 / 255.0 alpha:0.8]];
            [self.rightWarningView setBackgroundColor:[UIColor colorWithRed:24.0 / 255.0 green:24 / 255.0 blue:24 / 255.0 alpha:0.8]];
            break;
        case YNMessageBoxStyleGray:
            [self.warningView setBackgroundColor:UIColorWithRGB(7, 73, 94)];
            break;
        case YNMessageBoxStyleRed:
            [self.warningView setBackgroundColor:UIColorWithRGB(232, 115, 112)];
            break;
        case YNMessageBoxStyleBlue:
            [self.warningView setBackgroundColor:UIColorWithRGB(141, 201, 240)];
            break;
        default:
            break;
    }
}

-(void)show:(NSString *)text
{
    WS(weakSelf);
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf show:text dismissing:YES];
    });
}

//-(void)show:(NSString *)text withDisplayModel:(YCModeDisplay)displayModel
//{
//    if (self.currentDisplayModel != displayModel) {
//        [self.warningLabel removeFromSuperview];
//        [self.rightWarningLabel removeFromSuperview];
//        self.warningLabel = nil;
//        self.rightWarningLabel = nil;
//        [self.warningView removeFromSuperview];
//        [self.rightWarningView removeFromSuperview];
//        self.warningView = nil;
//        self.rightWarningView = nil;
//        
//    }
//    self.currentDisplayModel = displayModel;
//    
//    [self show:text dismissing:YES];
//}

-(void)show:(NSString *)text dismissing:(BOOL)dismissing
{
    [self show:text style:YNMessageBoxStyleClear dismissing:dismissing];
}

- (void)show:(NSString *)text style:(YNMessageBoxStyle)style dismissing:(BOOL)dismissing
{
    self.style = style;
    [self warningMessage:text dismissing:dismissing];
    [self addWarningView];
}

-(void)addWarningView
{
    
    if (_currentDisplayModel == YCModeDisplayNormal) {
        
        self.warningView.alpha = 1.0;
        [[UIApplication sharedApplication].keyWindow addSubview:self.warningView];
        [_warningView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo([UIApplication sharedApplication].keyWindow);
            make.bottom.equalTo([UIApplication sharedApplication].keyWindow).offset(-60  );
        }];
        
        [self.warningView addSubview:self.warningLabel];
        [_warningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.warningView).offset(8);
            make.left.equalTo(self.warningView).offset(12);
            make.bottom.equalTo(self.warningView).offset(-8);
            make.right.equalTo(self.warningView).offset(-12);
        }];
        
        
    } else {
        self.warningView.alpha = 1.0;
        [[UIApplication sharedApplication].keyWindow addSubview:self.warningView];
        [_warningView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo([UIApplication sharedApplication].keyWindow).offset(-SCREENWIDTH*0.25);
            make.centerY.equalTo([UIApplication sharedApplication].keyWindow).offset(SCREENHEIGHT * 0.25 - 40  );
        }];
        [self.warningView addSubview:self.warningLabel];
        [_warningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.warningView).offset(8   * 0.5);
            make.left.equalTo(self.warningView).offset(12   * 0.5);
            make.bottom.equalTo(self.warningView).offset(-8   * 0.5);
            make.right.equalTo(self.warningView).offset(-12   * 0.5);
            
        }];
        
        self.rightWarningView.alpha = 1.0;
        [[UIApplication sharedApplication].keyWindow addSubview:self.rightWarningView];
        [self.rightWarningView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo([UIApplication sharedApplication].keyWindow).offset(SCREENWIDTH*0.25);
            make.centerY.equalTo([UIApplication sharedApplication].keyWindow).offset(SCREENHEIGHT * 0.25 - 40  );
        }];
        [self.rightWarningView addSubview:self.rightWarningLabel];
        [self.rightWarningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.rightWarningView).offset(8   * 0.5);
            make.left.equalTo(self.rightWarningView).offset(12   * 0.5);
            make.bottom.equalTo(self.rightWarningView).offset(-8   * 0.5);
            make.right.equalTo(self.rightWarningView).offset(-12   * 0.5);
        }];
    }
}

- (void)removeWarningView
{
    if (_warningView != nil) {
        [_warningLabel removeFromSuperview];
        [_warningView removeFromSuperview];
    }
    
    if (_rightWarningView != nil) {
        [_rightWarningLabel removeFromSuperview];
        [_rightWarningView removeFromSuperview];
    }
}

- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(SCREENWIDTH / 2.0 - 30, 8000)//限制最大的宽度和高度
                                       options:NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传入的字体字典
                                       context:nil];
    return rect.size;
}

- (void)warningMessage:(NSString *)msg dismissing:(BOOL)dismissing
{
    self.warningLabel.text = msg;
    if (_currentDisplayModel == YCModeDisplayGlass) {
        _warningLabel.font = [UIFont systemFontOfSize:15 * 0.5  ];
    } else {
        _warningLabel.font = [UIFont systemFontOfSize:15  ];
    }
    
    CGSize warningLabelSize =  [self sizeWithString:_warningLabel.text font:_warningLabel.font];
    _warningLabel.bounds = CGRectMake(0, 0, warningLabelSize.width, warningLabelSize.height);
    if (_currentDisplayModel == YCModeDisplayGlass) {
        self.rightWarningLabel.text = msg;
        _rightWarningLabel.font = [UIFont systemFontOfSize:15 * 0.5  ];
        CGSize rightWarningLabelSize =  [self sizeWithString:_rightWarningLabel.text font:_rightWarningLabel.font];
        _rightWarningLabel.bounds = CGRectMake(0, 0, rightWarningLabelSize.width, rightWarningLabelSize.height);
    }
    
    if (self.animateDuration == 0.1) {
        
    } else {
        if (dismissing) {
            [UIView animateWithDuration:self.animateDuration
                             animations:^{
                                 self.warningView.alpha = 0.0;
                                 self.rightWarningView.alpha = 0.0;
                             }
                             completion:^(BOOL finished) {
                                 if (finished) {
                                     [_warningView removeFromSuperview];
                                     [_rightWarningView removeFromSuperview];
                                 }
                             }];
        }
    }
    
}

- (void)removeFPVWarningView
{
    [_warningView removeFromSuperview];
    [_rightWarningView removeFromSuperview];
}


@end

