//
//  UIButton+YNCButton.h
//  YuneecApp
//
//  Created by yc-sh-vr-pc05 on 2017/3/11.
//  Copyright © 2017年 yuneec. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (YNCButton)

/*--------------------------- Add by GavinYu Start ----------------------------*/
//设置带有文字和图片的按钮
+ (void)setButtonTitleAndImage:(UIButton *)sender;
//设置按钮圆角
+ (void)setButtonFillet:(UIButton *)sender withCornerRadius:(CGFloat)cornerRadius withBorderWidth:(CGFloat)borderWidth withBorderColor:(nullable UIColor *)borderColor;
//设置按钮阴影效果
+ (void)setButtonShadow:(UIButton *)sender withShadowOffset:(CGSize)shadowOffset withShadowOpacity:(CGFloat)shadowOpacity withShadowColor:(UIColor *)shadowColor;
//设置按钮图片在normal和selected状态下
+ (void)setButtonImageForState:(UIButton *)sender withImageName:(NSString *)name;
/*--------------------------- Add by GavinYu End ----------------------------*/

@end

NS_ASSUME_NONNULL_END
