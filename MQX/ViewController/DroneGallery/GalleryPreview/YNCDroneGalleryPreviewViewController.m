//
//  YNCDroneGalleryPreviewViewController.m
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/17.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import "YNCDroneGalleryPreviewViewController.h"

#import "YNCDroneGalleryViewController.h"
#import "YNCDroneNavigationView.h"
#import "YNCDroneNavigationModel.h"
#import "YNCDroneToolView.h"
#import "YNCAVPlayerView.h"
#import "YNCPreviewPhotoCell.h"
#import "YNCPhotosDataBase.h"
#import "YNCPhotosDataBaseModel.h"
#import "YNCCircleProgressView.h"
#import "YNCCircleProgressModel.h"
#import "YNCDroneMediasDownloadManager.h"
#import "YNCDroneGalleryMediasHelper.h"
#import "YNCImageHelper.h"
#import "YNCDroneGalleryTransitionAnimator.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
static NSString *const kDroneGalleryCell = @"droneGalleryCell";

@interface YNCDroneGalleryPreviewViewController () <YNCDroneNavigationViewDelegate, YNCDroneToolViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, YNCPreviewPhotoCellDelegate, UINavigationControllerDelegate, YNCCircleProgressDelegate, AVPlayerViewDelegate>

@property (strong, nonatomic) YNCDroneNavigationView *navigationView;
@property (strong, nonatomic) YNCDroneToolView *toolView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) YNCAVPlayerView *playerView;
@property (nonatomic, strong) NSIndexPath *playIndexPath;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureOnce;
@property (nonatomic, strong) YNCCircleProgressView *circleProgress;
@property (nonatomic, assign) BOOL isClickDownload; // 标记是否点击下载按钮
@property (nonatomic, strong) YNCDroneNavigationModel *droneNavigationModel;
@property (nonatomic, strong) YNCDroneMediasDownloadManager *downloadManager;

@end

@implementation YNCDroneGalleryPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BackgroundColor_Black;
    // Do any additional setup after loading the view from its nib.
    self.droneNavigationModel.currentIndex = 1;
    [self addObservers];
    [self setupNavigationView];
    [self setupToolView];
    [self requestDroneMediasData];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [(YNCPreviewPhotoCell *)cell recoveryOriginFrame];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *currentIndexPath = [collectionView indexPathsForVisibleItems].firstObject;
    if (currentIndexPath != nil) {
        self.droneNavigationModel.currentIndex = currentIndexPath.row + 1;
        [self configureToolViewWithNumber:currentIndexPath.row];
    }
    if (_playIndexPath) {
        if (currentIndexPath.row == _playIndexPath.row) {
            return;
        } else {
            if (_playerView.playerItem) {
                [self releasePlayerView];
            }
        }
    }
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YNCPreviewPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDroneGalleryCell forIndexPath:indexPath];
    cell.delegate = self;
    [cell displayCellWithObject:self.dataArray[indexPath.row]];
    [cell.playeBtn addTarget:self action:@selector(playBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    if (cell.tapGesutreTwice) {
        [self.tapGestureOnce requireGestureRecognizerToFail:cell.tapGesutreTwice];
    }
    return cell;
}


#pragma mark - CustomDelegate
#pragma mark - YNCPreviewPhotoCellDelegate
- (void)hiddenViews
{
    _navigationView.hidden = YES;
    _toolView.hidden = YES;
}

#pragma mark - AVPlayerViewDelegate
- (void)touchPlayerView
{
    if (self.navigationView.hidden) {
        _navigationView.hidden = NO;
        if (_playerView.player.rate == 0) {
            self.toolView.hidden = NO;
        } else {
            self.playerView.backView.hidden = NO;
        }
    } else {
        self.toolView.hidden = YES;
        self.navigationView.hidden = YES;
        self.playerView.backView.hidden = YES;
    }
}


- (void)playComplete
{
    YNCPreviewPhotoCell *cell = (YNCPreviewPhotoCell *)[self.collectionView cellForItemAtIndexPath:_playIndexPath];
    [_playerView.superview bringSubviewToFront:cell.playeBtn];
}

- (void)releasePlayerView
{
    if (self.playerView.playerItem) {
        [_playerView removeTimerObserver];
        _playerView.playerItem = nil;
        [_playerView removeFromSuperview];
    }
}

#pragma mark - YNCDroneNavigationViewDelegate
- (void)back
{
    [self releasePlayerView];
    [YNCUtil saveUserDefaultInfo:@(0) forKey:YNC_DRONEGALLERY_SCROLLPOINTY];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnAction
{
    [self releasePlayerView];
    YNCDroneGalleryViewController *droneGalleryVC = [[YNCDroneGalleryViewController alloc] init];
    droneGalleryVC.dataDictionary = self.dataDictionary;
    droneGalleryVC.dateArray = self.dateArray;
    droneGalleryVC.droneNavigationModel = self.droneNavigationModel;
    NSNumber *contentOffSet_Y = [YNCUtil getUserDefaultInfo:YNC_DRONEGALLERY_SCROLLPOINTY];
    droneGalleryVC.contentOffSet_Y = contentOffSet_Y.intValue;
    [droneGalleryVC configureSubView];
    self.navigationController.delegate = self;
    [self.navigationController pushViewController:droneGalleryVC animated:YES];
}

#pragma mark - YNCDroneToolViewDelegate
- (void)deleteMedia
{
    NSIndexPath *indexPath = [_collectionView indexPathsForVisibleItems].firstObject;
//    YuneecMedia *media = self.dataArray[indexPath.row];
//    YuneecMediaManager *mediaManager = [[YuneecMediaManager alloc] initWithCameraType:YuneecCameraTypeHDRacer];
//    WS(weakSelf);
//    [mediaManager deleteMedia:@[media] withCompletion:^(NSError * _Nullable error) {
//        if (error == nil) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [weakSelf releasePlayerView];
//                if (weakSelf.dataArray.count > indexPath.row) {
//                    [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
//                    [weakSelf deleteMediaInDataArrayWithMedia:media];
//                    [weakSelf.collectionView deleteItemsAtIndexPaths:@[indexPath]];
//                }
//                int index = (int)indexPath.row - 1;
//                NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
//                if (weakSelf.dataArray.count == 0) {
//                    weakSelf.toolView.deleteBtn.enabled = NO;
//                    weakSelf.toolView.downloadBtn.enabled = NO;
//                    weakSelf.toolView.deleteBtn.alpha = 0.6;
//                    weakSelf.toolView.downloadBtn.alpha = 0.6;
//                    weakSelf.droneNavigationModel.totalMediasAmount = weakSelf.dataArray.count;
//                    weakSelf.droneNavigationModel.currentIndex = 0;
//                    return;
//                }
//                if (index < 0) {
//                    [weakSelf.collectionView reloadData];
//                } else {
//                    [weakSelf.collectionView reloadItemsAtIndexPaths:@[newIndexPath]];
//
//                }
//                NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//                if (weakSelf.dataArray.count > 1) {
//                    currentIndexPath = [weakSelf.collectionView indexPathsForVisibleItems].firstObject;
//                }
//                if (currentIndexPath != nil) {
//                    weakSelf.droneNavigationModel.totalMediasAmount = weakSelf.dataArray.count;
//                    weakSelf.droneNavigationModel.currentIndex = currentIndexPath.row + 1;
//                    [weakSelf configureToolViewWithNumber:currentIndexPath.row];
//                }
//            });
//        } else {
//
//        }
//    }];
}

- (void)downloadMedia
{
    [self.view addSubview:self.circleProgress];
    
    NSIndexPath *indexPath = [_collectionView indexPathsForVisibleItems].firstObject;
    if (self.dataArray.count > indexPath.row) {
        YNCCircleProgressModel *progressModel = [[YNCCircleProgressModel alloc] init];
        progressModel.totalDownloadNum = 1;
        [self.circleProgress configureSubviewWithModel:progressModel];
        WS(weakSelf);
//        YuneecMedia *media = self.dataArray[indexPath.row];
//        NSArray *mediasArray = @[media];
//        self.downloadManager.isCancel = NO;
//        [_downloadManager downloadDroneMediasWithMediasArray:mediasArray
//                                               progressBlock:^(NSInteger currentNum, NSString *fileSize, CGFloat progress) {
//                                                   progressModel.currentDownloadNum = currentNum;
//                                                   dispatch_async(dispatch_get_main_queue(), ^{
//                                                       progressModel.fileSize = fileSize;
//                                                       [weakSelf.circleProgress configureSubviewWithModel:progressModel];
//                                                       weakSelf.circleProgress.progress = progress;
//                                                   });
//                                               } completeBlock:^(BOOL complete) {
//                                                   dispatch_async(dispatch_get_main_queue(), ^{
//                                                       weakSelf.circleProgress.progress = 0.0;
//                                                       [weakSelf.circleProgress removeFromSuperview];
//                                                       NSIndexPath *indexPath = [weakSelf.collectionView indexPathsForVisibleItems].firstObject;
//                                                       [weakSelf.collectionView reloadItemsAtIndexPaths:@[indexPath]];
//                                                       weakSelf.isClickDownload = NO;
//                                                   });
//                                               }];
    }
}

#pragma mark - YNCCircleProgressDelegate
- (void)cancelDownload
{
    self.downloadManager.isCancel = YES;
    [self.circleProgress removeFromSuperview];
}


#pragma mark - event response
- (void)handleCameraNotConnectNotification:(NSNotification *)notification
{
    WS(weakSelf);
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf cancelDownload];
        if ([weakSelf.view.subviews containsObject:weakSelf.circleProgress]) {
            [weakSelf.circleProgress removeFromSuperview];
        }
        [weakSelf back];
    });
}

- (void)playBtnAction
{
    [self hiddenViews];
    NSIndexPath *indexPath = [self.collectionView indexPathsForVisibleItems].firstObject;
    YNCPreviewPhotoCell *previewCell = (YNCPreviewPhotoCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    self.playIndexPath = indexPath;
//    YuneecMedia *media = self.dataArray[indexPath.row];
//    NSString *fileName = media.thumbnailMedia.fileName;
//    NSString *createDate = media.thumbnailMedia.createDate;
//    NSString *singleKey = [NSString stringWithFormat:@"%@_%@", createDate, [fileName stringByDeletingPathExtension]];
//    YNCPhotosDataBaseModel *model = [[YNCPhotosDataBase shareDataBase] selectOnePhotoDataBaseModelBySingleKey:singleKey type:YNCMediaTypeDroneVideo];
//    if ([model.singleKey isEqualToString:singleKey]) {
//        NSString *path = [Document_Download stringByAppendingPathComponent:[singleKey stringByAppendingPathExtension:@"mp4"]];
//
//        if (![previewCell.subviews containsObject:self.playerView]) {
//            self.playerView = [YNCAVPlayerView sharedAVPlayerView];
//            self.playerView.backBtn.hidden = YES;
//            self.playerView.delegate = self;
//            _playerView.playerMode = YNCPlayerModeNoFullScreen;
//            [previewCell addSubview:_playerView];
//            [_playerView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.right.bottom.top.equalTo(previewCell);
//            }];
//            [_playerView layoutIfNeeded];
//            [self.playerView setUpSubviews];
//            AVPlayerItem *playerItem_1 = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:path]];
//            _playerView.playerItem = playerItem_1;
//            [_playerView play];
//        } else {
//            [previewCell insertSubview:previewCell.playeBtn
//                          belowSubview:_playerView];
//            [_playerView pause];
//        }
//
//    } else {
//        [[YNCMessageBox instance] show:@"please download media first"];
//    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"droneNavigationModel.currentIndex"]) {
        if (change[@"new"]) {
            [self.navigationView updateCurrentIndexWithModel:self.droneNavigationModel];
        }
    }
}

#pragma mark - tapGestureAciton
- (void)tapGestureOnceAction
{
    if (self.navigationView.hidden) {
        [self showViews];
    } else {
        self.playerView.backView.hidden = YES;
        [self hiddenViews];
    }
}


#pragma mark - private methods
- (void)addObservers
{
    [self addObserver:self forKeyPath:@"droneNavigationModel.currentIndex" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
}


- (void)setupNavigationView
{
    self.navigationView = [YNCDroneNavigationView droneNavigationView];
    [self.view addSubview:_navigationView];
    [_navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(44));
    }];
    self.navigationView.delegate = self;
    _navigationView.type = NavigationViewTypePush;
}

- (void)setupToolView
{
    self.toolView = [YNCDroneToolView droneToolView];
    [self.view addSubview:_toolView];
    [_toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@(44));
    }];
    self.toolView.delegate = self;
    _toolView.deleteBtn.enabled = NO;
    _toolView.downloadBtn.enabled = NO;
    _toolView.deleteBtn.alpha = 0.6;
    _toolView.downloadBtn.alpha = 0.6;
}

- (void)requestDroneMediasData
{
    WS(weakSelf);
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setMinimumDismissTimeInterval:0.5f];
    [SVProgressHUD setContainerView:self.view];
    [SVProgressHUD show];
    [YNCDroneGalleryMediasHelper requestFireBirdDroneInfoDataComplete:^(NSDictionary *dataDictionary,
                                                                           NSArray *dateArray,
                                                                           NSArray *mediaArray,
                                                                           NSInteger videoAmount,
                                                                           NSInteger photoAmount,
                                                                           NSError *error) {
        if (error == nil) {
            weakSelf.dataDictionary = dataDictionary.mutableCopy;
            weakSelf.dateArray = dateArray.mutableCopy;
            weakSelf.droneNavigationModel.videosAmount = videoAmount;
            weakSelf.droneNavigationModel.photosAmount = photoAmount;
            [weakSelf configureData];
            YNCDroneMediasDownloadManager *droneMediasDownloadManager = [[YNCDroneMediasDownloadManager alloc] init];
            [droneMediasDownloadManager downloadMediaThumbnailWithMediaArray:mediaArray
                                                              CompletedBlock:^(BOOL completed) {
                                                                  if (completed) {
                                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                                          [weakSelf configureSubViews];
                                                                          [SVProgressHUD setContainerView:nil];
                                                                          [SVProgressHUD dismiss];
                                                                      });
                                                                  }
                                                              }];
        } else {
            [[YNCMessageBox instance] show:NSLocalizedString(@"gallery_no_files", nil)];
            [SVProgressHUD dismiss];
        }
    }];
}

- (void)configureData
{
    for (NSString *date in self.dateArray) {
        NSArray *mediaArray = self.dataDictionary[date];
        if (mediaArray.count > 0) {
            for (int i = 0; i < mediaArray.count; i++) {
                [self.dataArray addObject:mediaArray[i]];
            }
        }
    }
}

- (void)configureSubViews
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight);
    flowLayout.minimumInteritemSpacing = 0.0;
    flowLayout.minimumLineSpacing = 0.0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView.pagingEnabled = YES;
    [_collectionView registerClass:[YNCPreviewPhotoCell class] forCellWithReuseIdentifier:kDroneGalleryCell];
    if (self.dataArray.count > 0) {
        self.droneNavigationModel.totalMediasAmount = self.dataArray.count;
        self.droneNavigationModel.currentIndex = 1;
        [self configureToolViewWithNumber:0];
        _toolView.deleteBtn.enabled = YES;
        _toolView.downloadBtn.enabled = YES;
        _toolView.deleteBtn.alpha = 1.0;
        _toolView.downloadBtn.alpha = 1.0;
    }
    [self.view insertSubview:_collectionView belowSubview:_navigationView];
    
    self.tapGestureOnce = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureOnceAction)];
    [_collectionView addGestureRecognizer:_tapGestureOnce];
    
    if (self.dateArray.count > 0) {
        if (![YNCImageHelper isOpenAuthority]) {
            [YNCImageHelper showAlertWithTittle:NSLocalizedString(@"gallery_open_photo_limit", nil)
                                        message:NSLocalizedString(@"gallery_open_photo_limit_warning", nil)
                                 showController:self
                                 isSingleAction:NO
                                   leftBtnTitle:NSLocalizedString(@"person_center_cancel", nil)
                                  rightBtnTitle:NSLocalizedString(@"gallery_open_photo_go_open", nil)
                                       complete:^(NSInteger index) {
                                           if (index == 1) {
                                               [YNCImageHelper jumpToSetting];
                                           } else {
                                               
                                           }
                                       }];
            return;
        } else {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                
            }];
        }
    }
}

- (void)scrollToItemAtNumber:(NSInteger)number
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:number inSection:0];
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)configureToolViewWithNumber:(NSInteger)number
{
    if (self.dataArray.count > number) {
//        YuneecMedia *media = self.dataArray[number];
//        NSString *createDate = media.thumbnailMedia.createDate;
//        NSString *fileName = media.thumbnailMedia.fileName;
//        YNCMediaType mediaType = YNCMediaTypeDronePhoto;
//        fileName = [NSString stringWithFormat:@"%@_%@", createDate, fileName];
//        fileName = [fileName stringByDeletingPathExtension];
//        if (media.mediaType == YuneecMediaTypeMP4) {
//            mediaType = YNCMediaTypeDroneVideo;
//        } else if (media.mediaType == YuneecMediaTypeJPEG) {
//        }
//        YNCPhotosDataBaseModel *model = [[YNCPhotosDataBase shareDataBase] selectOnePhotoDataBaseModelBySingleKey:fileName type:mediaType];
//        if (model.singleKey.length > 0) {
//            [_toolView.downloadBtn setImage:[UIImage imageNamed:@"icon_down_finished"] forState:(UIControlStateNormal)];
//            _toolView.downloadBtn.enabled = NO;
//        } else {
//            [_toolView.downloadBtn setImage:[UIImage imageNamed:@"btn_download"] forState:(UIControlStateNormal)];
//            _toolView.downloadBtn.enabled = YES;
//        }
    }
}

- (void)showViews
{
    _navigationView.hidden = NO;
    _toolView.hidden = NO;
}

- (void)deleteMediaInDataArrayWithMedia:(id)media
{
//    NSString *createTime = [media.createDate componentsSeparatedByString:@" "].firstObject;
//    NSArray *separatedDateArray = [createTime componentsSeparatedByString:@":"];
//    NSString *mediaCreateDate = [NSString stringWithFormat:@"%@-%@-%@", separatedDateArray[0], separatedDateArray[1], separatedDateArray[2]];
//    for (NSString *createDate in self.dateArray) {
//        if ([mediaCreateDate isEqualToString:createDate]) {
//            NSMutableArray *dataArray = self.dataDictionary[createDate];
//            [dataArray removeObject:media];
//            if (dataArray.count > 0) {
//                self.dataDictionary[createDate] = dataArray;
//            } else {
//                [self.dataDictionary removeObjectForKey:createDate];
//                [self.dateArray removeObject:createDate];
//            }
//        }
//    }
//    if (media.mediaType == YuneecMediaTypeMP4) {
//        --self.droneNavigationModel.videosAmount;
//    } else if (media.mediaType == YuneecMediaTypeJPEG) {
//        --self.droneNavigationModel.photosAmount;
//    }
}


#pragma mark - getters and setters
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

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

- (YNCDroneNavigationModel *)droneNavigationModel
{
    if (!_droneNavigationModel) {
        self.droneNavigationModel = [[YNCDroneNavigationModel alloc] init];
    }
    return _droneNavigationModel;
}

- (YNCDroneMediasDownloadManager *)downloadManager
{
    if (!_downloadManager) {
        self.downloadManager = [[YNCDroneMediasDownloadManager alloc] init];
    }
    return _downloadManager;
}

- (void)setNumber:(NSInteger)number
{
    _number = number;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:number inSection:0];
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    self.droneNavigationModel.totalMediasAmount = self.dataArray.count;
    self.droneNavigationModel.currentIndex = number + 1;
    [self configureToolViewWithNumber:number];
}


#pragma mark - dealloc
- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"droneNavigationModel.currentIndex"];
    DLog(@"*********%@dealloc", NSStringFromClass([self class]));
}


- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if ([toVC isKindOfClass:[YNCDroneGalleryViewController class]] ||
        [toVC isKindOfClass:[YNCDroneGalleryPreviewViewController class]]) {
        return [YNCDroneGalleryTransitionAnimator new];
    } else {
        return nil;
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