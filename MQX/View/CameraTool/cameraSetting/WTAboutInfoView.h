//
//  WTAboutInfoView.h
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/23.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTAboutInfoView : UIView

@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, assign) BOOL showBtn;
@property (nonatomic, assign) BOOL showRightL;

+ (instancetype)aboutInfoView;
- (void)setUpSubViews;

@end
