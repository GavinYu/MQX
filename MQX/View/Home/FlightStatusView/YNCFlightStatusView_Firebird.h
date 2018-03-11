//
//  YNCFlightStatusView_Firebird.h
//  Demo_hireBird
//
//  Created by vrsh on 20/04/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YNCFlightStatusView_Firebird : UIView

@property (nonatomic, assign) int statusView_roll; // 机翼相对于水平方向的角度
@property (nonatomic, assign) int statusView_pitch; // 机头相对于竖直方向的角度

- (void)hiddenSubView:(BOOL)isHidden withDoubleClickCount:(NSInteger)count;

- (void)hiddenPlateView;
- (void)showPlateView;
+ (instancetype)statusView_Firebird;
- (void)initSubViewsWithSizeMultiple:(CGFloat)sizeMutiple;

@end
