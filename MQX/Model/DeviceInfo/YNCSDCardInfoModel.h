//
//  YNCSDCardInfoModel.h
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/17.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YNCSDCardInfoModel : NSObject
@property (assign, nonatomic) NSInteger errorcode;
@property (assign, nonatomic) NSInteger sdspace;
@property (copy, nonatomic) NSString *sdspace_decimals;
@property (assign, nonatomic) NSInteger totalspace;
@property (copy, nonatomic) NSString *totalspace_decimals;
@property (copy, nonatomic) NSString *type;
@end
