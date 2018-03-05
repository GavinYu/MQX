//
//  YNCFB_TimeLapseCell.h
//  YuneecApp
//
//  Created by hank on 23/06/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YNCFB_TimeLapseCellDelegate <NSObject>

@optional
- (void)timeLapseBtnAction:(UIButton *)btn;

@end

@interface YNCFB_TimeLapseCell : UITableViewCell

@property (nonatomic, weak) id <YNCFB_TimeLapseCellDelegate> delegate;
- (void)changeTimeBtnTitleColor:(NSInteger)timeNum;

@end
