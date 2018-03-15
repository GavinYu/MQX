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

#import "YNCFB_SwitchCell.h"
#import "YNCAppConfig.h"

#define kCell @"commonSettingViewcell"
#define kTableViewCell @"commonSettingTableViewCell"

static NSString *SHTTERCELL = @"shuttercell";
static NSString *EXPOSURECELL = @"exposurecell";
static NSString *ISOCELL = @"isocell";
static NSString *SWITCHCELL = @"switchcell";

static NSString *PHOTOMODECELL = @"photoModeCell";

@interface YNCCameraCommonSettingView ()<UITableViewDelegate, UITableViewDataSource, YNCFB_SwitchCellDelegate, YNCCameraSettingFooterViewDelegate>

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
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YNCFB_SwitchCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:SWITCHCELL];

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
}

#pragma mark - 改变timelapseCell btn字体颜色
- (void)changeTimeLapseCellBtnTitleColor:(NSInteger)num
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    
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
