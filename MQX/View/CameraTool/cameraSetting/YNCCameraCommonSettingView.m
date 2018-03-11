//
//  YNCCameraCommonSettingView.m
//  YuneecApp
//
//  Created by vrsh on 22/03/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import "YNCCameraCommonSettingView.h"
#import "YNCCameraSettingModeCell.h"
#import "YNCCameraSettingDataModel.h"
#import "YNCCameraSettingFooterView.h"
#import "YNCCameraSettingHeaderView.h"
#import "YNCFB_ShutterCell.h"
#import "YNCFB_ExposureCell.h"
#import "YNCFB_ISOCell.h"
#import "YNCFB_SwitchCell.h"
#import "YNCFB_BurstCell.h"
#import "YNCFB_TimeLapseCell.h"
#import "YNCFB_PhotoModeCell.h"
#import "YNCAppConfig.h"

#define kCell @"commonSettingViewcell"
#define kTableViewCell @"commonSettingTableViewCell"

static NSString *SHTTERCELL = @"shuttercell";
static NSString *EXPOSURECELL = @"exposurecell";
static NSString *ISOCELL = @"isocell";
static NSString *SWITCHCELL = @"switchcell";
static NSString *BURSTCELL = @"burstCell";
static NSString *TIMELAPSECELL = @"timeLapseCell";
static NSString *PHOTOMODECELL = @"photoModeCell";

@interface YNCCameraCommonSettingView ()<UITableViewDelegate, UITableViewDataSource, YNCFB_SwitchCellDelegate, YNCCameraSettingFooterViewDelegate, YNCFB_BurstCellDelegate, YNCFB_TimeLapseCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) YNCCameraSettingFooterView *footerView;
@property (nonatomic, strong) YNCCameraSettingHeaderView *headerView;
@property (nonatomic, assign) BOOL SW_On; // 记录switch状态
@property (nonatomic, strong) NSMutableArray *currentStatusArray;

@end

@implementation YNCCameraCommonSettingView

#pragma mark - setter
- (void)setDataDictionary:(NSMutableDictionary *)dataDictionary
{
    _dataDictionary = dataDictionary;
    self.dataArray = dataDictionary[@"content"];
    _headerView.titleLabel.text = NSLocalizedString(self.dataDictionary[@"title"], nil);
    if (_footerView) {
        [self updateFooterViewStorage];
    }
    [self.tableView reloadData];
}

- (void)setShowBackBtn:(BOOL)showBackBtn
{
    _showBackBtn = showBackBtn;
    self.headerView.backBtn.hidden = !showBackBtn;
    if (showBackBtn) {
        [self.headerView.backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setHasFooterView:(BOOL)hasFooterView
{
    _hasFooterView = hasFooterView;
    if (hasFooterView) {
        self.footerView = [YNCCameraSettingFooterView cameraSettingFooterView];
        _footerView.frame = CGRectMake(0, 0, 100, 80);
        _tableView.tableFooterView = _footerView;
        _footerView.delegate = self;
    }
}

- (void)setOriginIndexPath:(NSIndexPath *)originIndexPath
{
    if (_originIndexPath != originIndexPath) {
        _originIndexPath = originIndexPath;
        if (_cameraSettingViewType == YNCCameraSettingViewTypeWhiteBlance) {
            [self whiteBalance_changeCellStyleWithIndexPath:originIndexPath];
        } else if (_cameraSettingViewType == YNCCameraSettingViewTypeCameraMode) {
            [self.tableView reloadData];
            [self cameraMode_changeCellStyleWithIndexPath:originIndexPath];
        } else {
            [self videoMode_changeCellStyleWithIndexPath:originIndexPath];
        }
    }
}

- (NSArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)currentStatusArray
{
    if (!_currentStatusArray) {
        self.currentStatusArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _currentStatusArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    self.headerView = [YNCCameraSettingHeaderView cameraSetttingHeaderView];
    _headerView.backgroundColor = [UIColor yncViewBackgroundColor];
    _headerView.frame = CGRectMake(0, 0, self.frame.size.width, 45);
    _headerView.titleLabel.textColor = [UIColor yncGreenColor];
    _headerView.titleLabel.font = [UIFont fourteenFontSize];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor yncViewBackgroundColor];
    [self addSubview:_tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"YNCCameraSettingModeCell" bundle:nil] forCellReuseIdentifier:kCell];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YNCFB_ShutterCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:SHTTERCELL];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YNCFB_ExposureCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:EXPOSURECELL];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YNCFB_ISOCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:ISOCELL];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YNCFB_SwitchCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:SWITCHCELL];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YNCFB_BurstCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:BURSTCELL];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YNCFB_TimeLapseCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:TIMELAPSECELL];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YNCFB_PhotoModeCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:PHOTOMODECELL];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableViewCell];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.cameraSettingViewType == YNCCameraSettingViewTypeCameraSetting) {
        return self.dataArray.count + 4;
    } else if (self.cameraSettingViewType == YNCCameraSettingViewTypeCameraMode) {
//        if ([YNCCameraManager sharedCameraManager].photoMode == YuneecCameraPhotoModeTimeLapse || [YNCCameraManager sharedCameraManager].photoMode == YuneecCameraPhotoModeBurst) {
//            return  self.dataArray.count + 1;
//        }
    }
    return self.dataArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    switch (self.cameraSettingViewType) {
//        case YNCCameraSettingViewTypeCameraSetting:
//        {
////            YNCCameraManager *cameraManager = [YNCCameraManager sharedCameraManager];
//            switch (indexPath.row) {
//                case 0:
//                {
//                    YNCFB_SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:SWITCHCELL];
//                    cell.leftConstraint.constant = 10;
//                    cell.rightConstraint.constant = 10;
//                    _SW_On = NO;
//                    cell.showLine = NO;
//                    cell.delegate = self;
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
////                    if (cameraManager.current_aeMode == YuneecCameraAEModeAuto) {
////                        _SW_On = YES;
////                    } else if (cameraManager.current_aeMode == YuneecCameraAEModeManual) {
////                        _SW_On = NO;
////                    }
//                    cell.switchBtn.on = _SW_On;
//                    [cell configureTextLabel:NSLocalizedString(@"camera_setting_auto", nil) on:_SW_On];
//                    return cell;
//                }
//                    break;
//                case 1:
//                {
//                    YNCFB_ISOCell *cell = [tableView dequeueReusableCellWithIdentifier:ISOCELL];
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
////                    cell.textValue = [NSString stringWithFormat:@"%ld", (long)[YNCCameraManager sharedCameraManager].current_isoValue];
////                    if (cameraManager.current_aeMode == YuneecCameraAEModeAuto) {
////                        _SW_On = YES;
////                    } else if (cameraManager.current_aeMode == YuneecCameraAEModeManual) {
////                        _SW_On = NO;
////                    }
//                    cell.enableUse = _SW_On;
//                    return cell;
//                }
//                    break;
//                case 2:
//                {
//                    YNCFB_ShutterCell *cell = [tableView dequeueReusableCellWithIdentifier:SHTTERCELL];
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
////                    if (cameraManager.current_aeMode == YuneecCameraAEModeAuto) {
////                        _SW_On = YES;
////                    } else if (cameraManager.current_aeMode == YuneecCameraAEModeManual) {
////                        _SW_On = NO;
////                    }
//                    [cell updateShutter];
//                    cell.enableUse = _SW_On;
//                    return cell;
//                }
//                    break;
//                case 3:
//                {
//                    YNCFB_ExposureCell *cell = [tableView dequeueReusableCellWithIdentifier:EXPOSURECELL];
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
////                    YuneecRational *rational = [YNCCameraManager sharedCameraManager].current_exposureValueRa;
////                    if (rational) {
////                        cell.value = rational.numerator / (CGFloat)rational.denominator;
////                    } else {
////                        cell.value = 0;
////                    }
////                    if (cameraManager.current_aeMode == YuneecCameraAEModeAuto) {
////                        _SW_On = YES;
////                    } else if (cameraManager.current_aeMode == YuneecCameraAEModeManual) {
////                        _SW_On = NO;
////                    }
//                    cell.enableUse = _SW_On;
//                    return cell;
//                }
//                    break;
//                case 5:
//                {
//                    YNCFB_PhotoModeCell *photoModeCell = [tableView dequeueReusableCellWithIdentifier:PHOTOMODECELL];
//                    photoModeCell.selectionStyle = UITableViewCellSelectionStyleNone;
//                    NSDictionary *dic = self.dataArray[indexPath.row - 4];
//                    [photoModeCell configureSubviewsWithDic:dic];
//                    return photoModeCell;
//                }
//                    break;
//                default:
//                {
//                    YNCCameraSettingModeCell *cell = [tableView dequeueReusableCellWithIdentifier:kCell forIndexPath:indexPath];
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                    YNCCameraSettingDataModel *model = [[YNCCameraSettingDataModel alloc] init];
//                    NSDictionary *dic = self.dataArray[indexPath.row - 4];
//                    [model setValuesForKeysWithDictionary:dic];
//                    [cell configureWithModel:model];
//                    return cell;
//                }
//                    break;
//            }
//        }
//            break;
//        case YNCCameraSettingViewTypeWhiteBlance:
//        {
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCell];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            NSMutableDictionary *dic = self.dataArray[indexPath.row];
//            NSString *imageName = dic[@"imageName"];
//            imageName = [imageName stringByAppendingString:@"Normal"];
//            cell.imageView.image = [UIImage imageNamed:imageName];
//            cell.textLabel.text = NSLocalizedString(dic[@"title"], nil);
//            cell.textLabel.font = [UIFont thirteenFontSize];
//            cell.textLabel.textColor = [UIColor atrousColor];
//            return cell;
//        }
//        case YNCCameraSettingViewTypeCameraMode:
//        {
////            if ([YNCCameraManager sharedCameraManager].photoMode == YuneecCameraPhotoModeBurst) {
////                if (indexPath.row == 2) {
////                    YNCFB_BurstCell *burstCell = [tableView dequeueReusableCellWithIdentifier:BURSTCELL];
////                    burstCell.delegate = self;
////                    [burstCell changeBtnTitleColor:[YNCCameraManager sharedCameraManager].currentBurstAmount];
////                    DLog(@"amout:%ld", [YNCCameraManager sharedCameraManager].currentBurstAmount);
////                    burstCell.selectionStyle = UITableViewCellSelectionStyleNone;
////                    return burstCell;
////                } else {
////                    return [self createTableViewCellWithIndexPath:indexPath tableView:tableView];
////                }
////            } else if ([YNCCameraManager sharedCameraManager].photoMode == YuneecCameraPhotoModeTimeLapse) {
////                if (indexPath.row == 3) {
////                    YNCFB_TimeLapseCell *timeLapseCell = [tableView dequeueReusableCellWithIdentifier:TIMELAPSECELL];
////                    timeLapseCell.delegate = self;
////                    [timeLapseCell changeTimeBtnTitleColor:[YNCCameraManager sharedCameraManager].currentMillisecond];
////                    DLog(@"millisecond:%ld", [YNCCameraManager sharedCameraManager].currentMillisecond);
////                    timeLapseCell.selectionStyle = UITableViewCellSelectionStyleNone;
////                    return timeLapseCell;
////                } else {
////                    return [self createTableViewCellWithIndexPath:indexPath tableView:tableView];
////                }
////            } else if ([YNCCameraManager sharedCameraManager].photoMode == YuneecCameraPhotoModeSingle) {
////                return [self createTableViewCellWithIndexPath:indexPath tableView:tableView];
////            } else {
////                return [self createTableViewCellWithIndexPath:indexPath tableView:tableView];
////            }
//
//        }
//            break;
//        case YNCCameraSettingViewTypeMeteringMode:
//        case YNCCameraSettingViewTypeScenesMode:
//        case YNCCameraSettingViewTypeVideoFormat:
//        case YNCCameraSettingViewTypeVideoResolution:
//        case YNCCameraSettingViewTypePhotoFormat:
//        case YNCCameraSettingViewTypePhotoResolution:
//        case YNCCameraSettingViewTypePhotoQuality:
//        case YNCCameraSettingViewTypeFlickerMode:
//        {
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCell];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
//            cell.selectedBackgroundView.backgroundColor = [UIColor yncGreenColor];
//            NSDictionary *dic = self.dataArray[indexPath.row];
//            cell.textLabel.text = NSLocalizedString(dic[@"title"], nil);
//            cell.textLabel.textColor = [UIColor atrousColor];
//            cell.textLabel.font = [UIFont thirteenFontSize];
//            cell.textLabel.numberOfLines = 0;
//            return cell;
//        }
//            break;
//        default:
//            return nil;
//            break;
//    }
  
  return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.cameraSettingViewType) {
        case YNCCameraSettingViewTypeCameraSetting:
            if ([_delegate respondsToSelector:@selector(cameraSettingView_didSelectedIndexPath:)]) {
                [_delegate cameraSettingView_didSelectedIndexPath:indexPath];
            }
            break;
            
        case YNCCameraSettingViewTypeWhiteBlance:
            if ([_delegate respondsToSelector:@selector(whiteBalanceView_didSelectedIndexPath:)]) {
                [_delegate whiteBalanceView_didSelectedIndexPath:indexPath];
            }
            break;
        case YNCCameraSettingViewTypeCameraMode:
        {
            if ([_delegate respondsToSelector:@selector(cameraModeView_didSelectedIndexPath:)]) {
                [_delegate cameraModeView_didSelectedIndexPath:indexPath];
            }
        }
            
            break;
        case YNCCameraSettingViewTypeMeteringMode:
            if ([_delegate respondsToSelector:@selector(meteringModeView_didSelectedIndexPath:)]) {
                [_delegate meteringModeView_didSelectedIndexPath:indexPath];
            }
            break;
        case YNCCameraSettingViewTypeScenesMode:
            if ([_delegate respondsToSelector:@selector(sceneModeView_didSelectedIndexPath:)]) {
                [_delegate sceneModeView_didSelectedIndexPath:indexPath];
            }
            break;
        case YNCCameraSettingViewTypeVideoFormat:
            if ([_delegate respondsToSelector:@selector(videoFormatView_didSelectedIndexPath:)]) {
                [_delegate videoFormatView_didSelectedIndexPath:indexPath];
            }
            break;
        case YNCCameraSettingViewTypeVideoResolution:
            if ([_delegate respondsToSelector:@selector(videoResolutionView_didSelectedIndexPath:)]) {
                [_delegate videoResolutionView_didSelectedIndexPath:indexPath];
            }
            break;
        case YNCCameraSettingViewTypePhotoFormat:
            if ([_delegate respondsToSelector:@selector(photoFormatView_didSelectedIndexPath:)]) {
                [_delegate photoFormatView_didSelectedIndexPath:indexPath];
            }
            break;
        case YNCCameraSettingViewTypePhotoResolution:
            if ([_delegate respondsToSelector:@selector(photoResolutionView_didSelectedIndexPath:)]) {
                [_delegate photoResolutionView_didSelectedIndexPath:indexPath];
            }
            break;
        case YNCCameraSettingViewTypePhotoQuality:
            if ([_delegate respondsToSelector:@selector(photoQualityView_didSelectedIndexPath:)]) {
                [_delegate photoQualityView_didSelectedIndexPath:indexPath];
            }
            break;
        case YNCCameraSettingViewTypeFlickerMode:
            if ([_delegate respondsToSelector:@selector(fickerModeView_didSelectedIndexPath:)]) {
                [_delegate fickerModeView_didSelectedIndexPath:indexPath];
            }
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cameraSettingViewType == YNCCameraSettingViewTypeCameraSetting) {
        switch (indexPath.row) {
            case 0:
                return 35;
                break;
            case 1:
                return 90;
                break;
            case 2:
                return 80;
                break;
            case 3:
                return 60;
                break;
            default:
                return 42;
                break;
        }
    } else if (self.cameraSettingViewType == YNCCameraSettingViewTypeCameraMode) {
      return 42;
//        if ([YNCCameraManager sharedCameraManager].photoMode == YuneecCameraPhotoModeTimeLapse) {
//            if (indexPath.row == 3) {
//                return 100;
//            } else {
//                return 42;
//            }
//        } else {
//            return 42;
//        }
    } else if (self.cameraSettingViewType == YNCCameraSettingViewTypeVideoResolution) {
        return 55;
    }
    else {
        return 42;
    }
}

- (UITableViewCell *)createTableViewCellWithIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *imageName;
    NSString *title;
    if (indexPath.row > self.dataArray.count - 1) {
        NSMutableDictionary *dic = self.dataArray[indexPath.row - 1];
        imageName = dic[@"imageName"];
        title = NSLocalizedString(dic[@"title"], nil);
    } else {
        NSMutableDictionary *dic = self.dataArray[indexPath.row];
        imageName = dic[@"imageName"];
        title = NSLocalizedString(dic[@"title"], nil);
    }
    imageName = [imageName stringByAppendingString:@"Normal"];
    cell.imageView.image = [UIImage imageNamed:imageName];
    cell.textLabel.text = title;
    cell.textLabel.font = [UIFont thirteenFontSize];
    cell.textLabel.textColor = [UIColor atrousColor];
    return cell;
}

- (void)updateFooterViewStorage
{
//    NSString *storageStr = [NSString stringWithFormat:@"%@/%@", [YNCCameraManager sharedCameraManager].freeStorage, [YNCCameraManager sharedCameraManager].totalStorage];
//    NSMutableDictionary *dictionary = self.dataDictionary[@"footer"];
//    dictionary[@"status"] = storageStr;
//    [_footerView configureWithDictionary:self.dataDictionary[@"footer"]];
}

#pragma mark - 处理白平衡选中的样式
- (void)whiteBalance_changeCellStyleWithIndexPath:(NSIndexPath *)indexPath
{
    if (self.previousIndexPath) {
        if (self.previousIndexPath == indexPath) {
            return;
        }
    }
    // 处理选中的cell
    NSMutableDictionary *dic = self.dataArray[indexPath.row];
    NSString *imageName = dic[@"imageName"];
    imageName = [imageName stringByAppendingString:@"Selected"];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor yncGreenColor];
    cell.imageView.image = [UIImage imageNamed:imageName];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    // 处理之前选中的cell
    if (_previousIndexPath) {
        NSMutableDictionary *previousDic = self.dataArray[_previousIndexPath.row];
        NSString *previousImageName = previousDic[@"imageName"];
        previousImageName = [previousImageName stringByAppendingString:@"Normal"];
        UITableViewCell *previousCell = [self.tableView cellForRowAtIndexPath:_previousIndexPath];
        previousCell.imageView.image = [UIImage imageNamed:previousImageName];
        previousCell.textLabel.textColor = [UIColor atrousColor];
        previousCell.backgroundColor = [UIColor whiteColor];
    }
    self.previousIndexPath = indexPath;
}

#pragma mark - 处理拍照模式选中样式的更改
- (void)cameraMode_changeCellStyleWithIndexPath:(NSIndexPath *)indexPath
{
    NSInteger previousIndex = indexPath.row;
    if (self.previousIndexPath) {
        if (self.previousIndexPath == indexPath) {
            return;
        }
        if (self.previousIndexPath.row == 2) {
//            if ([YNCCameraManager sharedCameraManager].photoMode == YuneecCameraPhotoModeBurst) {
//                self.previousIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
//                previousIndex = 3 - 1;
//            }
        }
    }
    // 处理选中的cell
    NSMutableDictionary *dic = self.dataArray[indexPath.row];
    NSString *imageName = dic[@"imageName"];
    imageName = [imageName stringByAppendingString:@"Selected"];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor yncGreenColor];
    cell.imageView.image = [UIImage imageNamed:imageName];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    // 处理之前选中的cell
    if (_previousIndexPath) {
        NSMutableDictionary *previousDic = self.dataArray[previousIndex];
        NSString *previousImageName = previousDic[@"imageName"];
        previousImageName = [previousImageName stringByAppendingString:@"Normal"];
        UITableViewCell *previousCell = [self.tableView cellForRowAtIndexPath:_previousIndexPath];
        previousCell.imageView.image = [UIImage imageNamed:previousImageName];
        previousCell.textLabel.textColor = [UIColor atrousColor];
        previousCell.backgroundColor = [UIColor whiteColor];
    }
    self.previousIndexPath = indexPath;
}

#pragma mark - 处理视频选中的样式
- (void)videoMode_changeCellStyleWithIndexPath:(NSIndexPath *)indexPath
{
    if (self.previousIndexPath) {
        if (self.previousIndexPath == indexPath) {
            return;
        }
    }
    // 处理选中的cell
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor yncGreenColor];
    
    // 处理之前选中的cell
    if (_previousIndexPath) {
        UITableViewCell *previousCell = [self.tableView cellForRowAtIndexPath:_previousIndexPath];
        previousCell.textLabel.textColor = [UIColor atrousColor];
        previousCell.backgroundColor = [UIColor whiteColor];
    }
    self.previousIndexPath = indexPath;
}


#pragma mark - BtnAction
- (void)backBtnAction:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(back)]) {
        [_delegate back];
    }
}

#pragma mark - YNCFB_SwitchCellDelegate
- (void)switchBtnAction:(UISwitch *)btn
{
    WS(weakSelf);
    if (btn.on) {
//        [[YNCCameraManager sharedCameraManager] setAEMode:YuneecCameraAEModeAuto block:^(NSError * _Nullable error) {
//            if (error == nil) {
//#ifdef OPENTOAST_HANK
//                [[YNCMessageBox instance] show:@"AEModeAuto_success"];
//#endif
//                [weakSelf switchIsOn:YES];
//                btn.on = YES;
//            } else {
//                [weakSelf postCameraNotificationWithNumber:YNCWARNING_CAMERA_SET_EV_FAILED];
//                btn.on = NO;
//            }
//        }];
    } else {
//        [[YNCCameraManager sharedCameraManager] setAEMode:YuneecCameraAEModeManual block:^(NSError * _Nullable error) {
//            if (error == nil) {
//#ifdef OPENTOAST_HANK
//                [[YNCMessageBox instance] show:@"AEModeManual_success"];
//#endif
//                [weakSelf switchIsOn:NO];
//                btn.on = NO;
//            } else {
//                [weakSelf postCameraNotificationWithNumber:YNCWARNING_CAMERA_SET_EV_FAILED];
//                btn.on = YES;
//            }
//        }];
    }
}

- (void)switchIsOn:(BOOL)isOn
{
    _SW_On = isOn;
    NSIndexPath *indexPath_1 = [NSIndexPath indexPathForRow:1 inSection:0];
    YNCFB_ISOCell *cell_1 = [_tableView cellForRowAtIndexPath:indexPath_1];
    cell_1.enableUse = isOn;
    
    NSIndexPath *indexPath_2 = [NSIndexPath indexPathForRow:2 inSection:0];
    YNCFB_ShutterCell *cell_2 = [_tableView cellForRowAtIndexPath:indexPath_2];
    cell_2.enableUse = isOn;
    
    NSIndexPath *indexPath_3 = [NSIndexPath indexPathForRow:3 inSection:0];
    YNCFB_ExposureCell *cell_3 = [_tableView cellForRowAtIndexPath:indexPath_3];
    cell_3.enableUse = isOn;
}

- (void)reloadCellWithIndexPaths:(NSArray *)indexPaths
{
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:(UITableViewRowAnimationNone)];
}

#pragma mark - YNCCameraSettingFooterViewDelegate
- (void)resetCameraSettings
{
    if ([_delegate respondsToSelector:@selector(footerView_resetCameraSettings)]) {
        [_delegate footerView_resetCameraSettings];
    }
}

- (void)formatSDcardStoreage
{
//    if ([[YNCCameraManager sharedCameraManager].totalStorage isEqualToString:@"0MB"]) {
//        [[YNCMessageBox instance] show:[NSString stringWithFormat:@"%@", NSLocalizedString(@"flight_interface_warning_CAMERA_NO_SDCARD", nil)]];
//        return;
//    }
    if ([_delegate respondsToSelector:@selector(footerView_formatSDcardStoreage)]) {
        [_delegate footerView_formatSDcardStoreage];
    }
}


#pragma mark - YNCFB_BurstCellDelegate
- (void)numberBtnAction:(UIButton *)btn
{
    if ([_delegate respondsToSelector:@selector(fb_photoModeBurstNumber:)]) {
        [_delegate fb_photoModeBurstNumber:btn];
    }
}

#pragma mark - YNCFB_TimeLapseCellDelegate
- (void)timeLapseBtnAction:(UIButton *)btn
{
    if ([_delegate respondsToSelector:@selector(fb_photoModeTimeLapse:)]) {
        [_delegate fb_photoModeTimeLapse:btn];
    }
}

#pragma mark - 改变burstCell btn字体颜色
- (void)changeBurstCellBtnTitleColor:(NSInteger)num
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    YNCFB_BurstCell *burstCell = (YNCFB_BurstCell *)[_tableView cellForRowAtIndexPath:indexPath];
    [burstCell changeBtnTitleColor:num];
}

#pragma mark - 改变timelapseCell btn字体颜色
- (void)changeTimeLapseCellBtnTitleColor:(NSInteger)num
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    YNCFB_TimeLapseCell *timeLapseCell = (YNCFB_TimeLapseCell *)[_tableView cellForRowAtIndexPath:indexPath];
    [timeLapseCell changeTimeBtnTitleColor:num];
}

- (void)reloadTableView
{
    [self.tableView reloadData];
}

- (void)postCameraNotificationWithNumber:(int)number
{
    [[NSNotificationCenter defaultCenter] postNotificationName:YNC_CAMEAR_WARNING_NOTIFICATION object:nil userInfo:@{@"msgid":[NSNumber numberWithInt:number], @"isHidden":[NSNumber numberWithBool:NO]}];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
