//
//  YNCCameraSettingHeaderView.m
//  YuneecApp
//
//  Created by vrsh on 27/03/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import "YNCCameraSettingHeaderView.h"

@implementation YNCCameraSettingHeaderView


+ (instancetype)cameraSetttingHeaderView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
