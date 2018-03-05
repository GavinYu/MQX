//
//  YNCFB_PhotoModeCell.h
//  YuneecApp
//
//  Created by hank on 29/06/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YNCFB_PhotoModeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoModeImageV;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoModeImageV_rightConstant;

- (void)configureSubviewsWithDic:(NSDictionary *)dic;

@end
