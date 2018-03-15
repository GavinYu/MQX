//
//  YNCCameraSettingView.m
//  YuneecApp
//
//  Created by vrsh on 20/03/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import "YNCCameraSettingView.h"
#import "YNCCameraCommonSettingView.h"
#import "YNCPopWindowView.h"
#import "YNCAppConfig.h"

#define kAnimationTime 0.3
#define kViewWidth 210.0

@interface YNCCameraSettingView ()<YNCCameraCommonSettingViewDelegate>

@property (nonatomic, copy) NSDictionary *dataDictionary;
@property (nonatomic, strong) YNCCameraCommonSettingView *cameraSettingView; // 相机设置主页
@property (nonatomic, assign) YNCCameraSettingViewType type;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSIndexPath *previousIndexPath;

@end

@implementation YNCCameraSettingView

- (NSDictionary *)dataDictionary
{
    if (!_dataDictionary) {
        self.dataDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _dataDictionary;
}

- (void)createUI
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.frame.size.width - kViewWidth-10, 16, kViewWidth, self.frame.size.height - 32)];
    _scrollView.contentSize = CGSizeMake(kViewWidth * 2, self.frame.size.height - 32);
    _scrollView.scrollEnabled = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.alpha = 0.9;
    [self addSubview:_scrollView];
    
    self.cameraSettingView = [[YNCCameraCommonSettingView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, _scrollView.frame.size.height)];
    [_scrollView addSubview:_cameraSettingView];
    _cameraSettingView.delegate = self;
    _cameraSettingView.cameraSettingViewType = YNCCameraSettingViewTypeCameraSetting;
    _cameraSettingView.showBackBtn = NO;
    _cameraSettingView.hasFooterView = YES;
    _cameraSettingView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
    self.type = YNCCameraSettingViewTypeCameraSetting;
}

#pragma mark - YNCCameraCommonSettingViewDelegate
- (void)cameraSettingView_didSelectedIndexPath:(NSIndexPath *)indexPath
{
    
}

// MARK:推出动画
- (void)pushView
{
    [UIView animateWithDuration:0.2 animations:^{
        _scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    }];
}

- (void)popView:(UIView *)view
{
    __block UIView *newView = view;
    [UIView animateWithDuration:0.2 animations:^{
        _scrollView.contentOffset = CGPointMake(0, 0);
    } completion:^(BOOL finished) {
        self.type = YNCCameraSettingViewTypeCameraSetting;
        [newView removeFromSuperview];
        newView = nil;
    }];
}

// MARK:消失动画
- (void)back
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.type + 3 inSection:0];
    if (self.type == YNCCameraSettingViewTypeVideoResolution) {
        WS(weakSelf);
        double delayInSeconds = 0.5f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (ino64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
//                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.type + 3 inSection:0];
//                DLog(@"_________________indexPath.row:%ld, type:%ld", indexPath.row, weakSelf.type);
                [weakSelf.cameraSettingView reloadCellWithIndexPaths:@[indexPath]];
            });
        });
    } else {
        [self.cameraSettingView reloadCellWithIndexPaths:@[indexPath]];
    }
}

- (void)updataShutterView
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    [self.cameraSettingView reloadCellWithIndexPaths:@[indexPath]];
}

#pragma mark - 恢复默认设置
- (void)footerView_resetCameraSettings
{
    WS(weakSelf);
    
    [YNCPopWindowView showMessage:NSLocalizedString(@"camera_setting_reset_tip", nil)
               buttonTitleConfirm:NSLocalizedString(@"person_center_sure", nil)
                buttonTitleCancel:NSLocalizedString(@"person_center_cancel", nil)
                        colorType:PopWindowViewColorTypeOrange
                         sizeType:PopWindowViewSizeTypeBig
                    handleConfirm:^{

    } handleCancel:^{
        
    }];
}

#pragma mark - 格式化内存卡
- (void)footerView_formatSDcardStoreage
{
    WS(weakSelf);
    [YNCPopWindowView showMessage:NSLocalizedString(@"camera_setting_do_you_want_to_format_sd_card", nil)
               buttonTitleConfirm:NSLocalizedString(@"person_center_sure", nil)
                buttonTitleCancel:NSLocalizedString(@"person_center_cancel", nil)
                        colorType:PopWindowViewColorTypeOrange
                         sizeType:PopWindowViewSizeTypeSmall
                    handleConfirm:^{

    } handleCancel:^{
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    if (!CGRectContainsPoint(self.scrollView.frame, point)&&[_delegate respondsToSelector:@selector(popView)]) {
        [_delegate popView];
    } else {
        
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    WS(weakSelf);
    if ([keyPath isEqualToString:@"cameraManager.freeStorage"]) {
        if ([change.allKeys containsObject:@"new"] && [change.allKeys containsObject:@"old"]) {
            if (change[@"new"] != NULL && change[@"old"] != NULL) {
                if (![change[@"new"] isEqualToString:change[@"old"]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.cameraSettingView updateFooterViewStorage];
                    });
                }
            }
        }
    }
}

- (void)postNotificationWithNumber:(int)number
{
    [[NSNotificationCenter defaultCenter] postNotificationName:YNC_CAMEAR_WARNING_NOTIFICATION object:nil userInfo:@{@"msgid":[NSNumber numberWithInt:number], @"isHidden":[NSNumber numberWithBool:NO]}];
}

- (void)dealloc
{
//    [self removeObserver:self forKeyPath:@"cameraManager.freeStorage"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
