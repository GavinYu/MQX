//
//  YNCStoreViewController.m
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/15.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import "YNCStoreViewController.h"

#import "YNCMacros.h"

@interface YNCStoreViewController ()
{
    BOOL _isFinishedLoading;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation YNCStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self navigationController] setNavigationBarHidden:NO];
    [self setTitle:NSLocalizedString(@"homepage_mall", nil)];
    [self loadRequest];
}

- (void)dealloc {
    NSLog(@"%@", NSStringFromClass([self class]));
    if (_timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)loadRequest {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:YNC_STORE_LINK]];
    [self.webView loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    _progressView.progress = 0;
    _isFinishedLoading = NO;
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.01667 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    _isFinishedLoading = YES;
}

- (void)timerCallback {
    if (_isFinishedLoading) {
        if (_progressView.progress >= 1) {
            _progressView.hidden = YES;
            [_timer invalidate];
            _timer = nil;
        } else {
            _progressView.progress += 0.1;
        }
    } else {
        _progressView.progress += 0.05;
        if (_progressView.progress >= 0.95) {
            _progressView.progress = 0.95;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
