//
//  YNCMqxViewController.h
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/3.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YNCMqxViewController : UIViewController

@property (nonatomic, weak) UIView *videoPreview;

- (IBAction)clickTakePhotoButton:(UIButton *)sender;
- (IBAction)clickStartRecordButton:(UIButton *)sender;
- (IBAction)clickStopRecordButton:(UIButton *)sender;
- (IBAction)clickFPVButton:(UIButton *)sender;
- (IBAction)clickConvertButton:(UIButton *)sender;


@end
