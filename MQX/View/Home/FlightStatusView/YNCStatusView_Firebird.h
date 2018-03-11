//
//  testView.h
//  Demo_hireBird
//
//  Created by vrsh on 06/04/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YNCStatusView_Firebird : UIView

@property (nonatomic, assign) int value;
@property (nonatomic, assign) BOOL centerMode;
@property (nonatomic, assign) CGFloat sizeMutiple;

- (void)createUI;

@end
