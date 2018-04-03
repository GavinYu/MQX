//
//  YNCAVPlayerView.m
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/17.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import "YNCAVPlayerView.h"

#define kCircleCenterX (center.x + translation.x)

#define kTimeString @"00:00:00"

@interface YNCAVPlayerView ()

@property (nonatomic, assign) BOOL isPlay;
@property (weak, nonatomic) IBOutlet UIView *progressLineView;
@property (weak, nonatomic) IBOutlet UIView *backLineView;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;
@property (weak, nonatomic) IBOutlet UILabel *label_currentTime;
@property (weak, nonatomic) IBOutlet UILabel *label_totalTime;
@property (weak, nonatomic) IBOutlet UIImageView *dragImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressLineViewWidth;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, assign) CGFloat total;
@property (nonatomic, strong) id timeObserver_id;
@property (nonatomic, assign) CGFloat progress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalTimeConstraint;

@end

@implementation YNCAVPlayerView

- (void)setPlayerMode:(YNCPlayerMode)playerMode
{
    _playerMode = playerMode;
    if (playerMode == YNCPlayerModeFullScreen) {
        _fullScreenBtn.hidden = NO;
        _totalTimeConstraint.constant = 8;
    } else {
        _fullScreenBtn.hidden = YES;
        _totalTimeConstraint.constant = -20;// (-28刚好在屏幕边缘)
    }
}

+ (instancetype)sharedAVPlayerView
{
    static YNCAVPlayerView *playerView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playerView = [YNCAVPlayerView fb_avPlayerView];
    });
    return playerView;
}

+ (instancetype)fb_avPlayerView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)setUpSubviews
{
    self.isComplete = NO;
    self.player = [[AVPlayer alloc] init];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    _playerLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.layer insertSublayer:_playerLayer atIndex:0];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    UITapGestureRecognizer *tapGesutre = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tapGesutre];
    [self addObserver:self forKeyPath:@"player.rate" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:nil];
}

- (void)setPlayerItem:(AVPlayerItem *)playerItem
{
    _playerItem = playerItem;
    self.total = CMTimeGetSeconds(playerItem.asset.duration);
    int totalMinutes;
    int totalSec;
    int totalHours;
    totalSec = (int)_total % 60;
    totalMinutes = ((int)_total / 60) % 60;
    totalHours = (int)_total / 3600;
    AVAsset *asset = playerItem.asset;
    [self.player replaceCurrentItemWithPlayerItem:_playerItem];
    //    self.label_totalTime.text = [NSString stringWithFormat:@"%.2d:%.2d", totalMinutes, totalSec];
    self.label_totalTime.text = [NSString stringWithFormat:@"%.2d:%.2d:%.2d", totalHours, totalMinutes, totalSec];
    for (AVAssetTrack *track in asset.tracks) {
        if ([track.mediaType isEqualToString:@"vide"]) {
            
        }
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"player.rate"]) {
        NSNumber *number = change[@"new"];
        if (number.integerValue == 0) {
            NSLog(@"pause");
            self.playBtn.hidden = NO;
            [self.playOrPauseBtn setImage:[UIImage imageNamed:@"btn_play_big"] forState:(UIControlStateNormal)];
        } else {
            NSLog(@"play");
            self.playBtn.hidden = YES;
            [self.playOrPauseBtn setImage:[UIImage imageNamed:@"btn_stop_big"] forState:(UIControlStateNormal)];
        }
    }
}

// 添加进度监听
- (void)addProgressObserver
{
    __block CGFloat current;
    __block int currentMinutes;
    __block int currentSec;
    __block int currentHours;
    __weak typeof(self) weakSelf = self;
    [self layoutIfNeeded];
    if (_player.rate != 0) {
        self.timeObserver_id = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0)
                                                                     queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) usingBlock:^(CMTime time) {
                                                                         current = CMTimeGetSeconds(time);
                                                                         currentSec = (int)current % 60;
                                                                         currentMinutes = ((int)current / 60) % 60;
                                                                         currentHours = (int)current / 3600;
                                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                                             weakSelf.label_currentTime.text = [NSString stringWithFormat:@"%.2d:%.2d:%.2d", currentHours, currentMinutes, currentSec];
                                                                             //                weakSelf.label_currentTime.text = [NSString stringWithFormat:@"%.2d:%.2d", currentMinutes, currentSec];
                                                                             weakSelf.progress = current / weakSelf.total;
                                                                             //                weakSelf.progressLineView.frame = CGRectMake(weakSelf.progressLineView.frame.origin.x,
                                                                             //                                                             weakSelf.progressLineView.frame.origin.y,
                                                                             //                                                             progress * self.backLineView.frame.size.width,
                                                                             //                                                             weakSelf.progressLineView.frame.size.height);
                                                                             //                weakSelf.dragImageView.center = CGPointMake(CGRectGetMaxX(weakSelf.progressLineView.frame),
                                                                             //                                                            weakSelf.progressLineView.center.y);
                                                                             weakSelf.progressLineViewWidth.constant = weakSelf.progress * self.backLineView.frame.size.width;
                                                                             if (current == weakSelf.total) {
                                                                                 [weakSelf.playOrPauseBtn setImage:[UIImage imageNamed:@"btn_play_small"] forState:(UIControlStateNormal)];
                                                                                 weakSelf.label_currentTime.text = kTimeString;
                                                                                 weakSelf.progress = 0.0;
                                                                                 
                                                                                 weakSelf.isComplete = YES;
                                                                                 if ([weakSelf.delegate respondsToSelector:@selector(playComplete)]) {
                                                                                     [weakSelf.delegate playComplete];
                                                                                 }
                                                                                 [[AVAudioSession sharedInstance] setActive:NO
                                                                                                                withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation
                                                                                                                      error:nil];
                                                                                 //                    weakSelf.progressLineView.frame = CGRectMake(weakSelf.progressLineView.frame.origin.x,
                                                                                 //                                                                 weakSelf.progressLineView.frame.origin.y,
                                                                                 //                                                                 progress * self.backLineView.frame.size.width,
                                                                                 //                                                                 weakSelf.progressLineView.frame.size.height);
                                                                                 //                    weakSelf.dragImageView.center = CGPointMake(CGRectGetMaxX(weakSelf.progressLineView.frame),
                                                                                 //                                                                weakSelf.progressLineView.center.y);
                                                                                 weakSelf.progressLineViewWidth.constant = weakSelf.progress * self.backLineView.frame.size.width;
                                                                             }
                                                                         });
                                                                     }];
    }
}

- (void)layoutProgressLine
{
    self.progressLineViewWidth.constant = self.progress * self.backLineView.frame.size.width;
}

- (void)removeTimerObserver
{
    [_player removeTimeObserver:self.timeObserver_id];
}

- (IBAction)backbtnAction:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(backBtnAction)]) {
        [_delegate backBtnAction];
    }
}

- (void)play
{
    [self.player play];
    // 添加进度监听
    [self addProgressObserver];
}

- (void)pause
{
    if (self.player.rate == 0) {
        if (self.isComplete) {
            self.isComplete = NO;
            float seconds = 0.0;
            CMTime startTime = CMTimeMakeWithSeconds(seconds, self.playerItem.currentTime.timescale);
            //让视频从指定处播放
            [self.player seekToTime:startTime completionHandler:^(BOOL finished) {
                
            }];
        }
        //        [self.superview insertSubview:button belowSubview:self];
        [self.player play];
        //        [self.playOrPauseBtn setImage:[UIImage imageNamed:@"btn_stop_small"] forState:(UIControlStateNormal)];
    } else {
        //        [self.superview insertSubview:button aboveSubview:self];
        [self.player pause];
        //        [self.playOrPauseBtn setImage:[UIImage imageNamed:@"btn_play_small"] forState:(UIControlStateNormal)];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (IBAction)playOrPauseAction:(UIButton *)sender {
    [self pause];
    if ([_delegate respondsToSelector:@selector(playOrPause)]) {
        [_delegate playOrPause];
    }
}

- (IBAction)fullScreenAciton:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(fullScreen)]) {
        [_delegate fullScreen];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _playerLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)willRemoveSubview:(UIView *)subview
{
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
}

- (void)didMoveToSuperview
{
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(self.backView.frame, point)) {
        CGPoint newPoint = [self convertPoint:point toView:self.backView];
        if (CGRectContainsPoint(CGRectMake(self.dragImageView.frame.origin.x - 3, self.dragImageView.frame.origin.y - 3, self.dragImageView.frame.size.width + 6, self.dragImageView.frame.size.height + 6), newPoint)) {
            return self.dragImageView;
        } else if (CGRectContainsPoint(CGRectMake(self.playOrPauseBtn.frame.origin.x - 5, self.playOrPauseBtn.frame.origin.y - 5, self.playOrPauseBtn.frame.size.width + 10, self.playOrPauseBtn.frame.size.height + 10), newPoint)) {
            return self.playOrPauseBtn;
        } else if (CGRectContainsPoint(CGRectMake(self.fullScreenBtn.frame.origin.x - 5, self.fullScreenBtn.frame.origin.y - 5, self.fullScreenBtn.frame.size.width + 10, self.fullScreenBtn.frame.size.height + 10), newPoint)){
            return self.fullScreenBtn;
        }
        return self.backView;
    } else if (CGRectContainsPoint(self.backBtn.frame, point) && !self.backBtn.hidden) {
        return self.backBtn;
    } else if (CGRectContainsPoint(self.playBtn.frame, point) && !self.playBtn.hidden) {
        return self.playBtn;
    }
    return self;
}

- (void)tap:(UITapGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:sender.view];
    if (CGRectContainsPoint(self.backView.frame, point)) {
        return;
    }
    
    if ([_delegate respondsToSelector:@selector(touchPlayerView)]) {
        [_delegate touchPlayerView];
    }
}

- (IBAction)panGestureAction:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [_player pause];
    }
    CGFloat progress;
    CGFloat max_X = CGRectGetMaxX(self.backLineView.frame);
    CGFloat min_X = CGRectGetMinX(self.backLineView.frame);
    [sender.view.superview bringSubviewToFront:sender.view];
    CGPoint center = sender.view.center;
    CGPoint translation = [sender translationInView:self];
    if (kCircleCenterX >= min_X && kCircleCenterX <= max_X) {
        sender.view.center = CGPointMake(kCircleCenterX, center.y);
        self.progressLineView.frame = CGRectMake(self.progressLineView.frame.origin.x, self.progressLineView.frame.origin.y, kCircleCenterX - self.progressLineView.frame.origin.x, self.progressLineView.frame.size.height);
        progress = (kCircleCenterX - self.progressLineView.frame.origin.x) / self.backLineView.frame.size.width;
        CGFloat seconds = progress * _total;
        CMTime startTime = CMTimeMakeWithSeconds(seconds, self.playerItem.currentTime.timescale);
        
        if (sender.state == UIGestureRecognizerStateEnded) {
            [self.player seekToTime:startTime completionHandler:^(BOOL finished) {
                if (finished) {
                    [_player play];
                }
            }];
        }
    }
    [sender setTranslation:CGPointZero inView:self];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
