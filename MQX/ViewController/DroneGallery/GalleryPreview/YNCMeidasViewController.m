//
//  YNCMeidasViewController.m
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/17.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import "YNCMeidasViewController.h"

#import "YNCCommonCollectionHeaderView.h"
#import "YNCCommonCollectionCell.h"
#import "YNCDroneGalleryPreviewViewController.h"

static NSString *const kDroneGalleryCommonCell = @"droneGalleryCommonCell";
static NSString *const kDroneGalleryHeaderView = @"droneGalleryHeaderView";
static NSString *const kDroneGalleryFooterView = @"droneGalleryFooterView";

#define kSelectedArray [self mutableArrayValueForKey:@"selectedArray"]
#define kWeakSelfSelectedArray [weakSelf mutableArrayValueForKey:@"selectedArray"]

@interface YNCMeidasViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation YNCMeidasViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupCollectionView];
    [self addObservers];
}

// 配置CollectionView的方法
- (void)setupCollectionView
{
    // item之间的间距
    float distance = 2.0;
    // 每个item的长宽
    float width = 0.0;
    // 距离屏幕边缘距离
    float edgeInset = 3.0f;
    int itemNum = 3;
    if (self.displayType == YNCDisplayTypeDroneGallery) {
        edgeInset = 24.0f;
        itemNum = 5;
    }
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    width = (SCREENWIDTH - distance * (itemNum - 1) - 2 * edgeInset) / itemNum;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, edgeInset, 0, edgeInset);
    flowLayout.itemSize = CGSizeMake(width, width);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = distance;
    CGFloat collectionViewHeight = self.view.frame.size.height;
    CGFloat collectionViewWidth = self.view.frame.size.width;
    if (self.displayType == YNCDisplayTypeDroneGallery) {
        collectionViewHeight = SCREENHEIGHT;
    }
    // 创建CollectionView对象
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, collectionViewWidth, collectionViewHeight) collectionViewLayout:flowLayout];
    // 配置属性
    if (self.displayType == YNCDisplayTypeDroneGallery) {
        collectionView.backgroundColor = BackgroundColor_Black;
    } else {
        collectionView.backgroundColor = [UIColor whiteColor];
    }
    // 设置数据源代理
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:collectionView];
    // 注册cell
    [collectionView registerClass:[YNCCommonCollectionCell class] forCellWithReuseIdentifier:kDroneGalleryCommonCell];
    // 注册页眉
    [collectionView registerClass:[YNCCommonCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kDroneGalleryHeaderView];
    // 注册页脚
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kDroneGalleryFooterView];
    // 给属性_collectionView赋值
    self.collectionView = collectionView;
    if (self.displayType == YNCDisplayTypeDroneGallery) {
        self.collectionView.contentOffset = CGPointMake(0, self.contentOffSet_Y);
    }
}

- (void)addObservers
{
    if (self.selectedArray) {
        [self addObserver:self forKeyPath:@"selectedArray" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
}

- (void)selectAllItems
{
    [kSelectedArray removeAllObjects];
    for (int i = 0; i < [self.collectionView numberOfSections]; i++) {
        for (int j = 0; j < [self.collectionView numberOfItemsInSection:i]; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            [kSelectedArray addObject:indexPath];
        }
    }
    [self.collectionView reloadData];
}

- (void)disSelectAllItems
{
    [kSelectedArray removeAllObjects];
    [self.collectionView reloadData];
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YNCCommonCollectionCell *cell = (YNCCommonCollectionCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    if (self.enableEdit) {
        cell.selectBtn.hidden = NO;
        if ([self.selectedArray containsObject:indexPath]) {
            if (self.displayType == YNCDisplayTypeVideoMake) {
                
            } else {
                [kSelectedArray removeObject:indexPath];
                [cell.selectBtn setImage:[UIImage imageNamed:@"icon_normal"] forState:UIControlStateNormal];
            }
        } else {
            if (self.displayType == YNCDisplayTypeVideoMake) {
                if (self.selectedArray.count > 0) {
                    NSIndexPath *previousIndexPath = self.selectedArray.firstObject;
                    YNCCommonCollectionCell *previousCell = (YNCCommonCollectionCell *)[self.collectionView cellForItemAtIndexPath:previousIndexPath];
                    [previousCell.selectBtn setImage:[UIImage imageNamed:@"icon_normal"] forState:UIControlStateNormal];
                    [kSelectedArray removeAllObjects];
                }
                [kSelectedArray addObject:indexPath];
                [cell.selectBtn setImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateNormal];
                
            } else {
                [kSelectedArray addObject:indexPath];
                [cell.selectBtn setImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateNormal];
            }
        }
    } else {
        cell.selectBtn.hidden = YES;
    }
    if (self.enablePreview) {
        NSInteger number = 0;
        for (int i = 0; i < indexPath.section; i++) {
            number += [_collectionView numberOfItemsInSection:i];
        }
        number += indexPath.row;
        if (self.displayType == YNCDisplayTypeDroneGallery) {
            for (UIViewController *vc in self.navigationController.childViewControllers) {
                if ([vc isKindOfClass:[YNCDroneGalleryPreviewViewController class]]) {
                    YNCDroneGalleryPreviewViewController *droneGalleryVC = (YNCDroneGalleryPreviewViewController *)vc;
                    droneGalleryVC.number = number;
                    [self.navigationController popToViewController:droneGalleryVC animated:YES];
                }
            }
        }
    }
}

#pragma mark - dataSourceDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.dataDictionary.count == 0) {
        return 0;
    } else {
        NSString *key = self.dateArray[section];
        NSArray *array = self.dataDictionary[key];
        return array.count;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dateArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YNCCommonCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDroneGalleryCommonCell forIndexPath:indexPath];
    NSString *key = self.dateArray[indexPath.section];
    NSArray *array = self.dataDictionary[key];
    if (self.enableEdit) {
        cell.selectBtn.hidden = NO;
    }else {
        cell.selectBtn.hidden = YES;
    }
    //    if ([array[indexPath.row] isKindOfClass:[PHAsset class]]) {
    //        [cell displayCellWithAsset:array[indexPath.row]];
    //    } else if ([array[indexPath.row] isKindOfClass:[YNCDronePhotoInfo class]]) { // 编辑图片
    //        [cell displayCellWithModel:array[indexPath.row]];
    //    } else { // 飞机图库资源
    [cell displayCellWithMedia:array[indexPath.row]];
    //    }
    if ([self.selectedArray containsObject:indexPath]) {
        [cell.selectBtn setImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateNormal];
    } else {
        [cell.selectBtn setImage:[UIImage imageNamed:@"icon_normal"] forState:UIControlStateNormal];
    }
    return cell;
}


// 重用页眉
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) { // 重用页眉
        YNCCommonCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kDroneGalleryHeaderView forIndexPath:indexPath];
        if (self.displayType == YNCDisplayTypeDroneGallery) {
            headerView.backgroundColor = BackgroundColor_Black;
            headerView.titleLabel.textColor = TextLittleGrayColor;
            if (indexPath.section == 0) {
                [headerView.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(headerView).offset(25);
                    make.left.equalTo(headerView).offset(24.5);
                    make.height.equalTo(@20);
                    make.width.equalTo(@200);
                }];
            } else {
                [headerView.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(headerView).offset(3);
                    make.left.equalTo(headerView).offset(24.5);
                    make.height.equalTo(@20);
                    make.width.equalTo(@200);
                }];
            }
        } else {
            [headerView.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(headerView).offset(3);
                make.left.equalTo(headerView).offset(4);
                make.height.equalTo(@20);
                make.width.equalTo(@200);
            }];
        }
        headerView.titleLabel.text = self.dateArray[indexPath.section];
        return headerView;
    } else {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kDroneGalleryFooterView forIndexPath:indexPath];
        if (self.displayType == YNCDisplayTypeDroneGallery) {
            footerView.backgroundColor = BackgroundColor_Black;
        } else {
            footerView.backgroundColor = [UIColor whiteColor];
        }
        return footerView;
    }
}

// 动态设置页眉的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (self.displayType == YNCDisplayTypeDroneGallery) {
        if (section == 0) {
            return CGSizeMake(0, 74);
        } else {
            return CGSizeMake(0, 30);
        }
    } else {
        return CGSizeMake(0, 30);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == [self.collectionView numberOfSections] - 1) {
        return CGSizeMake(0, 50);
    } else {
        return CGSizeMake(0, 0);
    }
}



#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.displayType == YNCDisplayTypeDroneGallery) {
        CGFloat endPointY = scrollView.contentOffset.y;
        [YNCUtil saveUserDefaultInfo:@(endPointY) forKey:YNC_DRONEGALLERY_SCROLLPOINTY];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.displayType == YNCDisplayTypeDroneGallery) {
        if (!decelerate) {
            CGFloat endPointY = scrollView.contentOffset.y;
            [YNCUtil saveUserDefaultInfo:@(endPointY) forKey:YNC_DRONEGALLERY_SCROLLPOINTY];
        }
    }
}


#pragma mark - getters & setters
// 总的数据源
- (NSMutableDictionary *)dataDictionary
{
    if (!_dataDictionary) {
        self.dataDictionary = [NSMutableDictionary dictionary];
    }
    return _dataDictionary;
}

- (NSMutableArray *)dateArray
{
    if (!_dateArray) {
        self.dateArray = [NSMutableArray array];
    }
    return _dateArray;
}

- (NSMutableArray *)selectedArray
{
    if (!_selectedArray) {
        self.selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}

- (void)setEnableEdit:(BOOL)enableEdit
{
    _enableEdit = enableEdit;
    if (_enableEdit) {
        [kSelectedArray removeAllObjects];
    }
}

- (YNCDisplayType)displayType
{
    return 0;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"selectedArray"];
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
