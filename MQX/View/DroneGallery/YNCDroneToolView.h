//
//  YNCDroneToolView.h
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/17.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YNCDroneToolViewDelegate <NSObject>

- (void)deleteMedia;
- (void)downloadMedia;

@end

@interface YNCDroneToolView : UIView

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
@property (nonatomic, weak) id<YNCDroneToolViewDelegate> delegate;
@property (nonatomic, assign) BOOL ableUse;
+ (instancetype)droneToolView;

@end
