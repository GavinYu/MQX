//
//  YNCDroneNavigationView.h
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/17.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YNCDroneNavigationModel;

typedef NS_ENUM(NSInteger, NavigationViewType) {
    NavigationViewTypePush,
    NavigationViewTypeEdit,
    NavigationViewTypeSelectedAll
};

@protocol YNCDroneNavigationViewDelegate <NSObject>

@optional
- (void)back;
- (void)rightBtnAction;
- (void)editDroneGalleryPhotos;
- (void)cancel;
- (void)selectAllDroneGalleryPhotos;
- (void)unselectAllDroneGalleryPhotos;

@end

@interface YNCDroneNavigationView : UIView

@property (nonatomic, weak) id<YNCDroneNavigationViewDelegate> delegate;
@property (nonatomic, assign) NavigationViewType type;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectedAllBtn;
+ (instancetype)droneNavigationView;
- (void)updateCurrentIndexWithModel:(YNCDroneNavigationModel *)model;

@end
