//
//  YNCDroneGalleryViewController.m
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/17.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import "YNCDroneGalleryViewController.h"

#import "YNCDroneNavigationView.h"
#import "YNCMqxViewController.h"
#import "YNCDroneToolView.h"
#import "YNCDroneGalleryPreviewViewController.h"
#import "YNCDroneGalleryMediasHelper.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "YNCDroneNavigationModel.h"
#import "YNCDroneMediasDownloadManager.h"
#import "YNCCircleProgressModel.h"
#import "YNCCircleProgressView.h"
#import "YNCAppConfig.h"

#define kSelectedArray [self mutableArrayValueForKey:@"selectedArray"]
#define kWeakSelfSelectedArray [weakSelf mutableArrayValueForKey:@"selectedArray"]

@interface YNCDroneGalleryViewController ()<YNCDroneToolViewDelegate,YNCDroneNavigationViewDelegate, YNCCircleProgressDelegate>
@property (weak, nonatomic)  YNCDroneNavigationView *navigationView;
@property (weak, nonatomic)  YNCDroneToolView *toolView;
@property (nonatomic, strong) YNCDroneMediasDownloadManager *droneMediasDownloadManager;
@property (nonatomic, strong) YNCCircleProgressView *circleProgress;
@end

static NSString *const DRONECOLLECTIONVIEWCELL = @"dronecollectioncell";

@implementation YNCDroneGalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BackgroundColor_Black;
    // Do any additional setup after loading the view from its nib.
    
    self.enablePreview = YES;
    self.enableEdit = NO;
}

#pragma mark - CustomDelegate
#pragma mark - YNCDroneNavigationViewDelegate
- (void)back
{
    for (UIViewController *vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:[YNCMqxViewController class]]) {
            [YNCUtil saveUserDefaultInfo:@(0) forKey:YNC_DRONEGALLERY_SCROLLPOINTY];
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

- (void)editDroneGalleryPhotos
{
    self.enableEdit = YES;
    self.enablePreview = NO;
    [self.collectionView reloadData];
}

- (void)cancel
{
    self.enableEdit = NO;
    self.enablePreview = YES;
    [self.collectionView reloadData];
}

- (void)selectAllDroneGalleryPhotos
{
    [self selectAllItems];
}

- (void)unselectAllDroneGalleryPhotos
{
    [self disSelectAllItems];
}

- (void)selectAllItems
{
    [super selectAllItems];
}

- (void)disSelectAllItems
{
    [super disSelectAllItems];
}

#pragma mark - YNCDroneToolViewDelegate
- (void)deleteMedia
{
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setContainerView:self.view];
    [SVProgressHUD setAnimationDelay:1.0];
    [SVProgressHUD showWithStatus:NSLocalizedString(@"gallery_deleting", nil)];
    NSMutableArray *deleteArray = [NSMutableArray arrayWithCapacity:0];
    for (NSIndexPath *indexPath in self.selectedArray) {
        NSString *date = self.dateArray[indexPath.section];
        NSArray *dataArray = self.dataDictionary[date];
//        YuneecMedia *media = dataArray[indexPath.row];
//        [deleteArray addObject:media];
    }
//    YuneecMediaManager *mediaManager = [[YuneecMediaManager alloc] initWithCameraType:YuneecCameraTypeFirebird];
//    WS(weakSelf);
//    [mediaManager deleteMedia:deleteArray withCompletion:^(NSError * _Nullable error) {
//        if (error == nil) {
//            double delayInSeconds = 0.5f;
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (ino64_t)(delayInSeconds * NSEC_PER_SEC));
//            dispatch_after(popTime, dispatch_get_main_queue(), ^{
//                [YNCDroneGalleryMediasHelper requestFireBirdDroneInfoDataComplete:^(NSDictionary *dataDictionary, NSArray *dateArray, NSArray *mediaArray, NSInteger videoAmount, NSInteger photoAmount, NSError *error) {
//                    if (error == nil) {
//                        if (dataDictionary == nil) {
//                            weakSelf.toolView.ableUse = NO;
//                            weakSelf.navigationView.type = NavigationViewTypeEdit;
//                            [weakSelf.navigationView.editBtn setTitleColor:TextGrayColor forState:(UIControlStateNormal)];
//                            weakSelf.navigationView.editBtn.enabled = NO;
//                        }
//                        weakSelf.dataDictionary = dataDictionary.mutableCopy;
//                        weakSelf.dateArray = dateArray.mutableCopy;
//                        weakSelf.droneNavigationModel.photosAmount = photoAmount;
//                        weakSelf.droneNavigationModel.videosAmount = videoAmount;
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [weakSelf.navigationView updateCurrentIndexWithModel:weakSelf.droneNavigationModel];
//                            [weakSelf.collectionView reloadData];
//                            [SVProgressHUD setContainerView:nil];
//                            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"gallery_file_delete", nil)];
//                        });
//                    } else {
//                        if ([error.localizedDescription isEqualToString:@"No meida at SD card"]) {
//                            [weakSelf.dataDictionary removeAllObjects];
//                            [weakSelf.dateArray removeAllObjects];
//                            weakSelf.droneNavigationModel.photosAmount = 0;
//                            weakSelf.droneNavigationModel.videosAmount = 0;
//                            dispatch_async(dispatch_get_main_queue(), ^{
//                                [weakSelf.navigationView updateCurrentIndexWithModel:weakSelf.droneNavigationModel];
//                                [weakSelf.collectionView reloadData];
//                                [SVProgressHUD setContainerView:nil];
//                                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"gallery_file_delete", nil)];
//                            });
//                        } else {
//                            [SVProgressHUD setContainerView:nil];
//                            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"failed--%@", error.localizedDescription]];
//                        }
//                    }
//                }];
//            });
//        } else {
//            [SVProgressHUD setContainerView:nil];
//            [SVProgressHUD showSuccessWithStatus:@"删除失败"];
//        }
//        [kWeakSelfSelectedArray removeAllObjects];
//    }];
    
    
}

- (void)downloadMedia
{
    self.droneMediasDownloadManager.isCancel = NO;
    [self.view addSubview:self.circleProgress];
    YNCCircleProgressModel *progressModel = [[YNCCircleProgressModel alloc] init];
    progressModel.totalDownloadNum = self.selectedArray.count;
    NSMutableArray *mediasArray = [NSMutableArray arrayWithCapacity:0];
    for (NSIndexPath *indexPath in self.selectedArray) {
        NSString *date = self.dateArray[indexPath.section];
        NSArray *array = self.dataDictionary[date];
        [mediasArray addObject:array[indexPath.row]];
    }
    WS(weakSelf);
    [self.droneMediasDownloadManager downloadDroneMediasWithMediasArray:mediasArray
                                                          progressBlock:^(NSInteger currentNum, NSString *fileSize, CGFloat progress) {
                                                              progressModel.currentDownloadNum = currentNum;
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  progressModel.fileSize = fileSize;
                                                                  [weakSelf.circleProgress configureSubviewWithModel:progressModel];
                                                                  weakSelf.circleProgress.progress = progress;
                                                              });
                                                          } completeBlock:^(BOOL complete, NSArray *photoArray, NSArray *videoArray) {
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  [weakSelf.circleProgress removeFromSuperview];
                                                                  weakSelf.circleProgress = nil;
                                                                  [weakSelf.collectionView reloadData];
                                                                  [kWeakSelfSelectedArray removeAllObjects];
                                                              });
                                                          }];
}

#pragma mark - YNCCircleProgressDelegate
- (void)cancelDownload
{
    self.droneMediasDownloadManager.isCancel = YES;
    [self.circleProgress removeFromSuperview];
}

#pragma mark - event response
- (void)handleCameraNotConnectNotification:(NSNotification *)notification
{
    WS(weakSelf);
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf cancelDownload];
        [weakSelf back];
    });
}


#pragma mark - private methods
- (void)configureSubView
{
    self.fd_prefersNavigationBarHidden = YES;
    self.navigationView.delegate = self;
    self.toolView.delegate = self;
    if (self.dateArray.count == 0) {
        [_navigationView.editBtn setTitleColor:TextGrayColor forState:(UIControlStateNormal)];
        _navigationView.editBtn.enabled = NO;
    } else {
        [_navigationView updateCurrentIndexWithModel:_droneNavigationModel];
    }
}

#pragma mark - 监听数组方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"selectedArray"]) {
        NSInteger totalNumber = 0;
        for (NSInteger i = 0; i < [self.collectionView numberOfSections]; i++) {
            totalNumber += [self.collectionView numberOfItemsInSection:i];
        }
        NSUInteger number = self.selectedArray.count;
        if (number == 0) {
            _toolView.ableUse = NO;
        } else {
            _toolView.ableUse = YES;
            if (number == totalNumber) {
                if ([_navigationView.selectedAllBtn.titleLabel.text isEqualToString:NSLocalizedString(@"gallery_unselect_all", nil)]) {
                    return;
                }
                [_navigationView.selectedAllBtn setTitle:NSLocalizedString(@"gallery_unselect_all", nil) forState:(UIControlStateNormal)];
            } else {
                if ([_navigationView.selectedAllBtn.titleLabel.text isEqualToString:NSLocalizedString(@"gallery_select_all", nil)]) {
                    return;
                }
                [_navigationView.selectedAllBtn setTitle:NSLocalizedString(@"gallery_select_all", nil) forState:(UIControlStateNormal)];
            }
        }
        
        if (self.displayType != YNCDisplayTypeDroneMedia && self.displayType != YNCDisplayTypeDroneGallery) {
            //            [self configureObseverInfo:change];
        }
    }
    //    if ([keyPath isEqualToString:@"downloadNumber"]) {
    //        if (self.downloadNumber <= self.selectedArray.count) {
    //            CGFloat progress = self.downloadNumber / (CGFloat)self.selectedArray.count;
    //            self.progressBlock(progress);
    //            if (self.downloadNumber == self.selectedArray.count) {
    //                self.completeBlock(YES);
    //            }
    //        }
    //    }
}


#pragma mark - getters and setters
- (YNCDroneNavigationModel *)droneNavigationModel
{
    if (!_droneNavigationModel) {
        self.droneNavigationModel = [[YNCDroneNavigationModel alloc] init];
    }
    return _droneNavigationModel;
}

- (YNCDisplayType)displayType
{
    return YNCDisplayTypeDroneGallery;
}

- (YNCDroneMediasDownloadManager *)droneMediasDownloadManager
{
    if (!_droneMediasDownloadManager) {
        self.droneMediasDownloadManager = [[YNCDroneMediasDownloadManager alloc] init];
    }
    return _droneMediasDownloadManager;
}

- (YNCCircleProgressView *)circleProgress
{
    if (!_circleProgress) {
        self.circleProgress = [YNCCircleProgressView circleProgress];
        _circleProgress.type = YNCFB_ProgressViewTypeHorizontal;
        _circleProgress.delegate = self;
        _circleProgress.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        [_circleProgress createSubViews];
    }
    return _circleProgress;
}

- (YNCDroneNavigationView *)navigationView
{
    if (!_navigationView) {
        self.navigationView = [YNCDroneNavigationView droneNavigationView];
        [self.view addSubview:_navigationView];
        [_navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.height.equalTo(@(44));
        }];
        _navigationView.type = NavigationViewTypeEdit;
    }
    return _navigationView;
}

- (YNCDroneToolView *)toolView
{
    if (!_toolView) {
        self.toolView = [YNCDroneToolView droneToolView];
        [self.view addSubview:_toolView];
        [_toolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.equalTo(@(44));
        }];
        _toolView.ableUse = NO;
    }
    return _toolView;
}

#pragma mark - dealloc
- (void)dealloc
{
    DLog(@"*********%@dealloc", NSStringFromClass([self class]));
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
