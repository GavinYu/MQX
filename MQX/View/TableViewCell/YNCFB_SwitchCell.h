//
//  YNCFB_SwitchCell.h
//  YuneecApp
//
//  Created by vrsh on 26/04/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YNCCameraSettingModel;

@protocol YNCFB_SwitchCellDelegate <NSObject>

@optional
- (void)switchBtnAction:(UISwitch *)btn;

@end

@interface YNCFB_SwitchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@property (nonatomic, assign) BOOL showLine;
@property (nonatomic, weak) id<YNCFB_SwitchCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *textL;

- (void)configureTextLabel:(YNCCameraSettingModel *)dataModel;

@end
