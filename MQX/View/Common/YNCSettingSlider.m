//
//  YNCSettingSlider.m
//  YuneecApp
//
//  Created by vrsh on 28/03/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import "YNCSettingSlider.h"

#import "YNCAppConfig.h"

#define kCircleCenterX (center.x + translation.x)

@interface YNCSettingSlider ()

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *animationLine;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGesture;
@property (weak, nonatomic) IBOutlet UIView *backLineView;
- (IBAction)panGestureAction:(UIPanGestureRecognizer *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *animationLineWidth;

@end


@implementation YNCSettingSlider

- (void)setEnableUse:(BOOL)enableUse
{
    _enableUse = enableUse;
    _panGesture.enabled = !enableUse;
    if (enableUse) {
        self.sliderColor = YNCSettingSliderColorGray;
    } else {
        self.sliderColor = YNCSettingSliderColorGreen;
    }
}

- (void)setValue:(CGFloat)value
{
    _value = value;
    
    if (_value > 1) {
        value = 1;
    } else if (value < 0) {
        value = 0;
    }
    if (_sliderType == YNCSettingSliderTypeFlightSetting) {
        _animationLineWidth.constant = (213.0) * value;
    } else {
        _animationLineWidth.constant = (106.0) * value;
    }
}


- (void)setSliderColor:(YNCSettingSliderColor)sliderColor
{
    _sliderColor = sliderColor;
    switch (sliderColor) {
        case YNCSettingSliderColorBlack:
            _touchImageView.image = [UIImage imageNamed:@"btn_shenhuise"];
            _animationLine.backgroundColor = [UIColor lightGrayishColor];
            _backLineView.backgroundColor = [UIColor lightGrayishColor];
            _touchImageView.userInteractionEnabled = YES;
            break;
        case YNCSettingSliderColorRed:
            _touchImageView.image = [UIImage imageNamed:@"btn_hongse"];
            _animationLine.backgroundColor = [UIColor orangeColor];
            _backLineView.backgroundColor = [UIColor lightGrayishColor];
            _panGesture.enabled = YES;
            break;
        case YNCSettingSliderColorGreen:
            _touchImageView.image = [UIImage imageNamed:@"icon_greenCircle"];
            _animationLine.backgroundColor = [UIColor greenColor];
            _backLineView.backgroundColor = [UIColor lightGrayishColor];
            _touchImageView.userInteractionEnabled = YES;
            _panGesture.enabled = YES;
            break;
        case YNCSettingSliderColorGray:
            _touchImageView.image = [UIImage imageNamed:@"icon_grayCircle"];
            _panGesture.enabled = NO;
            _animationLine.backgroundColor = [UIColor lightGrayishColor];
            _backLineView.backgroundColor = [UIColor lightGrayishColor];
            break;
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"YNCSettingSlider" owner:self options:nil];
    [self layoutIfNeeded];
    [self addSubview:_contentView];
    _contentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)panGestureAction:(UIPanGestureRecognizer *)sender {
//    DLog(@"---------------sliderPan: %.2f", self.backLineView.bounds.size.width);
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            self.touchImageView.image = [UIImage imageNamed:@"huatiaodian"];
            break;
        case UIGestureRecognizerStateEnded:
            if (_sliderColor == YNCSettingSliderColorBlack) {
                _touchImageView.image = [UIImage imageNamed:@"btn_shenhuise"];
            } else if (_sliderColor == YNCSettingSliderColorRed) {
                _touchImageView.image = [UIImage imageNamed:@"btn_hongse"];
            } else if (_sliderColor == YNCSettingSliderColorGreen) {
                _touchImageView.image = [UIImage imageNamed:@"icon_greenCircle"];
            } else if (_sliderColor == YNCSettingSliderColorGray) {
                _touchImageView.image = [UIImage imageNamed:@"icon_grayCircle"];
            }
            break;
        default:
            break;
    }
    CGFloat progress;
    CGFloat max_X = CGRectGetMaxX(self.backLineView.frame);
    CGFloat min_X = CGRectGetMinX(self.backLineView.frame);
    [sender.view.superview bringSubviewToFront:sender.view];
    CGPoint center = sender.view.center;
    CGPoint translation = [sender translationInView:self];
    if (kCircleCenterX >= min_X && kCircleCenterX <= max_X) {
//        sender.view.center = CGPointMake(kCircleCenterX, center.y);
//        self.animationLine.frame = CGRectMake(self.animationLine.frame.origin.x, self.animationLine.frame.origin.y, kCircleCenterX - self.animationLine.frame.origin.x, self.animationLine.frame.size.height);
        
        self.animationLineWidth.constant = kCircleCenterX - self.animationLine.frame.origin.x;
//        NSLog(@"----%.2f", self.animationLineWidth.constant);
        progress = (kCircleCenterX - self.animationLine.frame.origin.x) / self.backLineView.frame.size.width;
        if ([_delegate respondsToSelector:@selector(sliderValue:sender:)]) {
            [_delegate sliderValue:progress sender:sender];
        }
    }
    [sender setTranslation:CGPointZero inView:self];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(self.touchImageView.frame, point)) {
        return self.touchImageView;
    } else {
        return self;
    }
}

@end
