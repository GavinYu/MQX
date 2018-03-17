//
//  YNCMeidasViewController.h
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/17.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YNCDroneGalleryBaseViewController.h"

@interface YNCMeidasViewController : YNCDroneGalleryBaseViewController

// 是否允许选择
@property (nonatomic, assign) BOOL enableEdit;
// 是否允许预览
@property (nonatomic, assign) BOOL enablePreview;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableDictionary *dataDictionary;
@property (nonatomic, strong) NSMutableArray *dateArray;
@property (nonatomic, strong) NSMutableArray *selectedArray; // 选中的indexPath
@property (nonatomic, assign) int contentOffSet_Y;

- (YNCDisplayType)displayType;
- (void)selectAllItems;
- (void)disSelectAllItems;

@end
