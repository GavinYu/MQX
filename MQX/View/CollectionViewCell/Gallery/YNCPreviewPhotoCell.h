//
//  YNCPreviewPhotoCell.h
//  YuneecApp
//
//  Created by vrsh on 07/03/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <YYKit/YYKit.h>

@protocol YNCPreviewPhotoCellDelegate <NSObject>

- (void)hiddenViews;

@end

@interface YNCPreviewPhotoCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *playeBtn;
@property (nonatomic, strong) YYAnimatedImageView *imageV;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesutreTwice;
@property (nonatomic, weak) id<YNCPreviewPhotoCellDelegate> delegate;
@property (nonatomic, strong) UIScrollView *scrollView;

- (void)displayCellWithObject:(id)object;
// 恢复原来状态
- (void)recoveryOriginFrame;

@end
