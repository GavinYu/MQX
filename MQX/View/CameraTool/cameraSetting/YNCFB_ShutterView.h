//
//  YNCFB_ShutterView.h
//  YuneecApp
//
//  Created by hank on 08/05/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YNCFB_ShutterViewDelegate <NSObject>

@optional
- (void)dismissShutterView;
- (void)selectPickerViewRow:(NSInteger)row;

@end

@interface YNCFB_ShutterView : UIView

@property (nonatomic, weak) id<YNCFB_ShutterViewDelegate> delegate;
@property (nonatomic, assign) BOOL enableUse;
@property (nonatomic, copy) NSArray *dataSource;
@property (nonatomic, assign) NSInteger selectRow;

- (void)reloadPickerViewIndex:(NSUInteger)index;

@end
