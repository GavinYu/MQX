//
//  YNCFB_ShutterCell.m
//  YuneecApp
//
//  Created by hank on 08/05/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import "YNCFB_ShutterCell.h"

#import "YNCFB_ShutterView.h"
#import "YNCAppConfig.h"

@interface YNCFB_ShutterCell ()<YNCFB_ShutterViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet YNCFB_ShutterView *shutterView;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageV;
@property (weak, nonatomic) IBOutlet UIView *leftCoverView;
@property (weak, nonatomic) IBOutlet UIView *rightCoverView;

@end

@implementation YNCFB_ShutterCell

- (void)setEnableUse:(BOOL)enableUse
{
    _enableUse = enableUse;
    _selectImageV.hidden = enableUse;
    _leftCoverView.hidden = !enableUse;
    _rightCoverView.hidden = !enableUse;
    _shutterView.enableUse = enableUse;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titleLabel.text = NSLocalizedString(@"camera_setting_shutter", nil);
    _titleLabel.font = [UIFont tenFontSize];
    _titleLabel.textColor = [UIColor grayishColor];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"YNCFB_ShutterTimeValue" ofType:@"plist"];
    _shutterView.dataSource = [NSArray arrayWithContentsOfFile:path];
    _shutterView.delegate = self;
 
    [self addObservers];
//    _shutterView.selectRow = index;
}

- (void)addObservers
{
    [self addObserver:self forKeyPath:@"cameraManager.current_shutterTimeRa.denominator" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"cameraManager.current_shutterTimeRa.denominator"]) {
        if (![change[@"new"] isEqualToNumber:change[@"old"]]) {
            DLog(@"******************%@ __%@", change[@"new"], [NSThread currentThread]);
            WS(weakSelf);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf updateShutterWithDenominator:((NSNumber *)change[@"new"]).integerValue];
            });
        }
    }
}

- (void)updateShutter
{
//    [self updateShutterWithDenominator:denominator];
}

- (void)updateShutterWithDenominator:(NSInteger)denominator
{
    NSInteger index = 0;
    if ([_shutterView.dataSource containsObject:@(denominator)]) {
        index = [_shutterView.dataSource indexOfObject:@(denominator)];
    }
    [_shutterView reloadPickerViewIndex:index];
}


#pragma mark -YNCFB_ShutterViewDelegate
- (void)selectPickerViewRow:(NSInteger)row
{
    NSNumber *denominator = _shutterView.dataSource[row];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"cameraManager.current_shutterTimeRa.denominator"];
}

@end
