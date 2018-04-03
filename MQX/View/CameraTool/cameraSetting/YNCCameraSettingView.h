//
//  YNCCameraSettingView.h
//  YuneecApp
//
//  Created by vrsh on 20/03/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YNCCameraSettingViewDelegate <NSObject>
- (void)popView;
@end

@interface YNCCameraSettingView : UIView

@property (nonatomic, weak) id<YNCCameraSettingViewDelegate> delegate;
- (void)createUI;

- (void)updateCameraSettingView;
@end
