//
//  YNCDroneNavigationView.m
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/17.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import "YNCDroneNavigationView.h"

#import "YNCDroneNavigationModel.h"
#import "YNCMacros.h"

@interface YNCDroneNavigationView ()

@property (weak, nonatomic) IBOutlet UILabel *imageNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentIndexLabel;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *imageCollectionBtn;

@end

@implementation YNCDroneNavigationView

- (void)setType:(NavigationViewType)type
{
    _type = type;
    if (type == NavigationViewTypePush) {
        _editBtn.hidden = YES;
        _selectedAllBtn.hidden = YES;
        _imageCollectionBtn.hidden = NO;
    } else if (type == NavigationViewTypeEdit) {
        _editBtn.hidden = NO;
        [_editBtn setTitle:NSLocalizedString(@"gallery_edit", nil) forState:(UIControlStateNormal)];
        [_editBtn setTitleColor:UICOLOR_FROM_HEXRGB(0xF6F6F6) forState:(UIControlStateNormal)];
        _selectedAllBtn.hidden = YES;
        _imageCollectionBtn.hidden = YES;
        _currentIndexLabel.hidden = YES;
    } else {
        _selectedAllBtn.hidden = NO;
        [_selectedAllBtn setTitleColor:UICOLOR_FROM_HEXRGB(0xF6F6F6) forState:(UIControlStateNormal)];
        [_editBtn setTitle:NSLocalizedString(@"person_center_cancel", nil) forState:(UIControlStateNormal)];
        [_editBtn setTitleColor:TextOrangeColor forState:(UIControlStateNormal)];
        [_selectedAllBtn setTitle:NSLocalizedString(@"gallery_select_all", nil) forState:(UIControlStateNormal)];
    }
}

+ (instancetype)droneNavigationView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _imageNumLabel.textColor = TextLittleGrayColor;
    _videoNumLabel.textColor = TextLittleGrayColor;
    _imageNumLabel.font = SystemFont_11;
    _videoNumLabel.font = SystemFont_11;
    _currentIndexLabel.textColor = TextWhiteColor;
    self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
}

- (void)updateCurrentIndexWithModel:(YNCDroneNavigationModel *)model
{
    self.currentIndexLabel.text = [NSString stringWithFormat:@"%ld/%ld", model.currentIndex, model.totalMediasAmount];
    _imageNumLabel.text = [NSString stringWithFormat:@"%ld", model.photosAmount];
    _videoNumLabel.text = [NSString stringWithFormat:@"%ld", model.videosAmount];
}


- (IBAction)backBtnAction:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(back)]) {
        [_delegate back];
    }
}

- (IBAction)enterImageCollectionAction:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(rightBtnAction)]) {
        [_delegate rightBtnAction];
    }
}

- (IBAction)editBtnAction:(UIButton *)sender {
    if ([_editBtn.titleLabel.text isEqualToString:NSLocalizedString(@"gallery_edit", nil)]) {
        if ([_delegate respondsToSelector:@selector(editDroneGalleryPhotos)]) {
            self.type = NavigationViewTypeSelectedAll;
            [_delegate editDroneGalleryPhotos];
        }
    } else if ([_editBtn.titleLabel.text isEqualToString:NSLocalizedString(@"person_center_cancel", nil)]) {
        if ([_delegate respondsToSelector:@selector(cancel)]) {
            self.type = NavigationViewTypeEdit;
            [_delegate cancel];
        }
    }
}

- (IBAction)selectedAllBtn:(UIButton *)sender {
    if ([_selectedAllBtn.titleLabel.text isEqualToString:NSLocalizedString(@"gallery_select_all", nil)]) {
        [_selectedAllBtn setTitle:NSLocalizedString(@"gallery_unselect_all", nil) forState:(UIControlStateNormal)];
        if ([_delegate respondsToSelector:@selector(selectAllDroneGalleryPhotos)]) {
            [_delegate selectAllDroneGalleryPhotos];
        }
    } else if ([_selectedAllBtn.titleLabel.text isEqualToString:NSLocalizedString(@"gallery_unselect_all", nil)]) {
        [_selectedAllBtn setTitle:NSLocalizedString(@"gallery_select_all", nil) forState:(UIControlStateNormal)];
        if ([_delegate respondsToSelector:@selector(unselectAllDroneGalleryPhotos)]) {
            [_delegate unselectAllDroneGalleryPhotos];
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
