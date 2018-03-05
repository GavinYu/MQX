//
//  YNCSettingSlider.h
//  YuneecApp
//
//  Created by vrsh on 28/03/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YNCEnum.h"

@protocol YNCSettingSliderDelegate <NSObject>

- (void)sliderValue:(CGFloat)value sender:(UIPanGestureRecognizer *)sender;

@end

@interface YNCSettingSlider : UIView

@property (weak, nonatomic) IBOutlet UIImageView *touchImageView;
@property (nonatomic, weak) id<YNCSettingSliderDelegate> delegate;
// 0.0~1.0
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, assign) BOOL enableUse;
@property (nonatomic, assign) YNCSettingSliderColor sliderColor;
@property (nonatomic, assign) YNCSettingSliderType sliderType;

@end
