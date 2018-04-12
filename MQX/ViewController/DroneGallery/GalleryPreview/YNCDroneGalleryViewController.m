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
#import "YNCDronePhotoInfoModel.h"

#define kSelectedArray [self mutableArrayValueForKey:@"selectedArray"]
#define kWeakSelfSelectedArray [weakSelf mutableArrayValueForKey:@"selectedArray"]

@interface YNCDroneGalleryViewController ()<YNCDroneToolViewDelegate,YNCDroneNavigationViewDelegate, YNCCircleProgressDelegate>
@property (weak, nonatomic)  YNCDroneNavigationView *navigationView;
@property (weak, nonatomic)  YNCDroneToolView *toolView;
@property (nonatomic, strong) YNCDroneMediasDownloadManager *droneMediasDownloadManager;
@property (nonatomic, strong) YNCCircleProgressView *circleProgress;
@property (nonatomic, strong) NSMutableArray *deleteArray;

@property (nonatomic, strong) NSMutableArray *photoArray;
@property (nonatomic, strong) NSMutableArray *videoArray;

@property (nonatomic, strong) NSMutableDictionary *deleteIndexSetDic;
@property (nonatomic, assign) NSUInteger deletePhotosNum;
@property (nonatomic, assign) NSUInteger deleteVideosNum;

@end

static NSString *const DRONECOLLECTIONVIEWCELL = @"dronecollectioncell";

@implementation YNCDroneGalleryViewController

//MARK: -- lazyload deleteArray
- (NSMutableArray *)deleteArray {
    if (!_deleteArray) {
        _deleteArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _deleteArray;
}

//MARK: -- lazyload photoArray
- (NSMutableArray *)photoArray {
    if (!_photoArray) {
        _photoArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _photoArray;
}

//MARK: -- lazyload videoArray
- (NSMutableArray *)videoArray {
    if (!_videoArray) {
        _videoArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _videoArray;
}

//MARK: -- lazyload deleteIndexSetDic
- (NSMutableDictionary *)deleteIndexSetDic {
    if (!_deleteIndexSetDic) {
        _deleteIndexSetDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _deleteIndexSetDic;
}

//MARK: -- View lifecycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BackgroundColor_Black;
    // Do any additional setup after loading the view from its nib.
    self.fd_interactivePopDisabled = YES;
    self.enablePreview = YES;
    self.enableEdit = NO;
}

#pragma mark - CustomDelegate
#pragma mark - YNCDroneNavigationViewDelegate
- (void)back
{
    [YNCUtil saveUserDefaultInfo:@(0) forKey:YNC_DRONEGALLERY_SCROLLPOINTY];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
    
    for (NSIndexPath *indexPath in self.selectedArray) {
        NSString *date = self.dateArray[indexPath.section];
        NSArray *dataArray = self.dataDictionary[date];
        YNCDronePhotoInfoModel *media = dataArray[indexPath.row];
        [self.deleteArray addObject:media];
        if ([self.deleteIndexSetDic.allKeys containsObject:date]) {
            NSMutableIndexSet *indexSet = self.deleteIndexSetDic[date];
            [indexSet addIndex:indexPath.row];
            self.deleteIndexSetDic[date] = indexSet;
        } else {
            NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSetWithIndex:indexPath.row];
            self.deleteIndexSetDic[date] = indexSet;
        }
        if (media.mediaType == YNCMediaTypeDronePhoto) {
            self.deletePhotosNum ++;
        } else {
            self.deleteVideosNum ++;
        }
    }

    [self deleteFileWithNumber:0];
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
            [_toolView.downloadBtn setImage:[UIImage imageNamed:@"icon_down_finished"] forState:(UIControlStateNormal)];
            _toolView.downloadBtn.enabled = NO;
            
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
//MARK: -- 递归删除图库
- (void)deleteFileWithNumber:(NSInteger)number
{
    YNCDronePhotoInfoModel *media = self.deleteArray[number];
    WS(weakSelf);
    NSNumber *tmpType = media.mediaType==YNCMediaTypeDroneVideo?@(kRecord):@(kPicture);
    
    __block NSInteger blockNumber = number;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[AbeCamHandle sharedInstance] deleteWithFileName:media.title FileType:tmpType result:^(BOOL succeeded) {
            if (succeeded) {
                NSFileManager *defaultFileManager  = [NSFileManager defaultManager];
                if ([defaultFileManager fileExistsAtPath:media.filePath]) {
                    [defaultFileManager removeItemAtPath:media.filePath error:nil];
                }
                
                ++blockNumber;
                if (blockNumber < weakSelf.deleteArray.count) {
                    [weakSelf deleteFileWithNumber:blockNumber];
                } else {
                    for (NSString *date in self.deleteIndexSetDic.allKeys) {
                        NSMutableArray *array = self.dataDictionary[date];
                        [array removeObjectsAtIndexes:self.deleteIndexSetDic[date]];
                        if (array.count > 0) {
                            self.dataDictionary[date] = array;
                        } else {
                            [self.dateArray removeObject:date];
                            [self.dataDictionary removeObjectForKey:date];
                        }
                    }
                    if (self.dataDictionary.allKeys == 0) {
                        weakSelf.toolView.ableUse = NO;
                        weakSelf.navigationView.type = NavigationViewTypeEdit;
                        [weakSelf.navigationView.editBtn setTitleColor:TextGrayColor forState:(UIControlStateNormal)];
                        weakSelf.navigationView.editBtn.enabled = NO;
                    }
                    weakSelf.droneNavigationModel.photosAmount -= weakSelf.deletePhotosNum;
                    weakSelf.droneNavigationModel.videosAmount -= weakSelf.deleteVideosNum;
                    
                    [kWeakSelfSelectedArray removeAllObjects];
                    [weakSelf.deleteArray removeAllObjects];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.navigationView updateCurrentIndexWithModel:weakSelf.droneNavigationModel];
                        [weakSelf.collectionView reloadData];
                        [SVProgressHUD setContainerView:nil];
                        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"gallery_file_delete", nil)];
                    });
                }
            } else {
                
            }
        }];
    });
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
