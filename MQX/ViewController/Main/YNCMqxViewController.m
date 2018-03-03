//
//  YNCMqxViewController.m
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/3.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import "YNCMqxViewController.h"

#import "YNCVideoPreviewViewController.h"
#import "YNCAppConfig.h"

@interface YNCMqxViewController ()

@end

@implementation YNCMqxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self videoPreview];
    
}

//MARK: -- lazyload videoPreview
- (UIView *)videoPreview {
    if (!_videoPreview) {
        UIStoryboard *tmpMainBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        YNCVideoPreviewViewController *videoPreviewViewController = [tmpMainBoard instantiateViewControllerWithIdentifier:@"VideoPreviewController"];
        [self addChildViewController:videoPreviewViewController];
        [self.view insertSubview:videoPreviewViewController.view atIndex:0];
        [videoPreviewViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.size.equalTo(self.view);
        }];
        [videoPreviewViewController didMoveToParentViewController:self];
        
        _videoPreview = videoPreviewViewController.view;
        
        [self.view layoutIfNeeded];
    }
    
    return _videoPreview;
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
