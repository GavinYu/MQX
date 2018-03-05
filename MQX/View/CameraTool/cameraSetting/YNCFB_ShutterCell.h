//
//  YNCFB_ShutterCell.h
//  YuneecApp
//
//  Created by hank on 08/05/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YNCFB_ShutterCell : UITableViewCell

@property (nonatomic, assign) BOOL enableUse;

- (void)updateShutter;

@end
