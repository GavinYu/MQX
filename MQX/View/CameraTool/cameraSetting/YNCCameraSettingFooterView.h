//
//  YNCCameraSettingFooterView.h
//  YuneecApp
//
//  Created by vrsh on 24/03/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YNCCameraSettingFooterViewDelegate <NSObject>

- (void)resetCameraSettings;
- (void)formatSDcardStoreage;

@end

@interface YNCCameraSettingFooterView : UIView

@property (nonatomic, weak) id <YNCCameraSettingFooterViewDelegate> delegate;
+ (instancetype)cameraSettingFooterView;
- (void)configureWithDictionary:(NSDictionary *)dictionary;

@end
