//
//  YNCGalleryBaseViewController.m
//  YuneecApp
//
//  Created by hank on 01/12/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import "YNCGalleryBaseViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface YNCGalleryBaseViewController ()

@end

@implementation YNCGalleryBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    // Do any additional setup after loading the view.
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
