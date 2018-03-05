//
//  YNCPopWindowView.h
//  YuneecApp
//
//  Created by hank on 24/05/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PopWindowViewColorType) {
    PopWindowViewColorTypeBlack,
    PopWindowViewColorTypeOrange,
    PopWindowViewColorTypeAllBlack
};

typedef NS_ENUM(NSInteger, PopWindowViewSizeType) {
    PopWindowViewSizeTypeSmall,
    PopWindowViewSizeTypeBig
};

typedef void(^CompletionBlock)(void);

@interface YNCPopWindowView : UIView

@property (nonatomic, assign) PopWindowViewColorType colorType;
@property (nonatomic, assign) PopWindowViewSizeType sizeType;
@property (nonatomic, assign) BOOL isAddToWindow;

+ (void)showMessage:(NSString *)message
 buttonTitleConfirm:(NSString *)titleConfirm
  buttonTitleCancel:(NSString *)titleCancel
          colorType:(PopWindowViewColorType)colorType
           sizeType:(PopWindowViewSizeType)sizeType
      handleConfirm:(CompletionBlock)confirmBlock
       handleCancel:(CompletionBlock)cancelBlock;

+ (void)showMessage:(NSString *)message
     buttonToastBtn:(NSString *)toastBtnTitle
          colorType:(PopWindowViewColorType)colorType
           sizeType:(PopWindowViewSizeType)sizeType
        handleToast:(CompletionBlock)toastBlock;

+ (instancetype)popWindowView;
- (void)showMessage:(NSString *)message
 buttonTitleConfirm:(NSString *)titleConfirm
  buttonTitleCancel:(NSString *)titleCancel
          colorType:(PopWindowViewColorType)colorType
           sizeType:(PopWindowViewSizeType)sizeType
      handleConfirm:(CompletionBlock)confirmBlock
       handleCancel:(CompletionBlock)cancelBlock;

@end
