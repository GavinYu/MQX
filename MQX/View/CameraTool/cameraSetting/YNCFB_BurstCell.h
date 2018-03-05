//
//  YNCFB_BurstCell.h
//  YuneecApp
//
//  Created by hank on 23/06/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YNCFB_BurstCellDelegate <NSObject>

@optional
- (void)numberBtnAction:(UIButton *)btn;

@end

@interface YNCFB_BurstCell : UITableViewCell

@property (nonatomic, weak) id <YNCFB_BurstCellDelegate>delegate;

- (void)changeBtnTitleColor:(NSInteger)numb;

@end
