//
//  AbeCmdModel.h
//  testABECamLib
//
//  Created by abe on 2017/7/21.
//  Copyright © 2017年 abe. All rights reserved.
//

#import <Foundation/Foundation.h>
//#include "rvs_def.h"

@protocol AbeCmdModelDelegate <NSObject>

// 手到rvs回传数据，APP做出相关操作（拍照、录像）
//- (void)abeCmdModelDidReceiveRvsCallback:(RVST_UINT16)u16Cmd;

@end

@interface AbeCmdModel : NSObject

@property (nonatomic, weak) id<AbeCmdModelDelegate> delegate;
@property (nonatomic, assign) BOOL isCallback;

+ (instancetype)sharedInstance;

-(BOOL)connect;
-(BOOL)disConnect;
-(void)sendCmd:(unsigned char *)buff leng:(unsigned short)leng;

@end
