//
//  AbeCmdModel.h
//  testABECamLib
//
//  Created by abe on 2017/7/21.
//  Copyright © 2017年 abe. All rights reserved.
//

#import <Foundation/Foundation.h>

//AbeCmdModel used to send cmd to wifi model

@interface AbeCmdModel : NSObject

+ (instancetype)sharedInstance;

-(BOOL)connect;
-(BOOL)disConnect;
-(void)sendCmd:(unsigned char *)buff leng:(unsigned short)leng;

@end
