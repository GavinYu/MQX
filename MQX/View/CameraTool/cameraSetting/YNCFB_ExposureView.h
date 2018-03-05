//
//  YNCFB_ExposureView.h
//  YuneecApp
//
//  Created by hank on 08/05/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YNCFB_MaskView;
@interface YNCFB_ExposureView : UIView

@property (nonatomic, assign) CGFloat value;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet YNCFB_MaskView *customMaskView;

@end
