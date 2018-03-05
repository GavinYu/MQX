//
//  YNCPopWindowView.m
//  YuneecApp
//
//  Created by hank on 24/05/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import "YNCPopWindowView.h"

#import "UIColor+YNCColor.h"

#define kReduceMultiple 0.8
#define kSmallTypeBackViewWidth (375 * kReduceMultiple)
#define kSmallTypeBackViewHeight (200 * kReduceMultiple)
#define kBigTypeBackViewWidth 375
#define kBigTypeBackViewHeight 200

@interface YNCPopWindowView ()
{
    CompletionBlock cancelCompletionBlock;
    CompletionBlock confirmCompletionBlock;
    CompletionBlock toastCompletionBlock;
}
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *toastBtn;
@property (weak, nonatomic) IBOutlet UIView *verticalLineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewWidthConstraint;

@end

@implementation YNCPopWindowView

- (void)setColorType:(PopWindowViewColorType)colorType
{
    _colorType = colorType;
    if (colorType == PopWindowViewColorTypeBlack) {
        [_confirmBtn setTitleColor:[UIColor atrousColor] forState:(UIControlStateNormal)];
        [_cancelBtn setTitleColor:[UIColor grayishColor] forState:(UIControlStateNormal)];
        [_messageLabel setTextColor:[UIColor atrousColor]];
        
        [_toastBtn setTitleColor:[UIColor atrousColor] forState:(UIControlStateNormal)];
    } else if (colorType == PopWindowViewColorTypeAllBlack) {
        [_confirmBtn setTitleColor:[UIColor atrousColor] forState:(UIControlStateNormal)];
        [_cancelBtn setTitleColor:[UIColor atrousColor] forState:(UIControlStateNormal)];
        [_messageLabel setTextColor:[UIColor atrousColor]];
        
        [_toastBtn setTitleColor:[UIColor atrousColor] forState:(UIControlStateNormal)];
    } else {
        [_confirmBtn setTitleColor:[UIColor yncGreenColor] forState:(UIControlStateNormal)];
        [_cancelBtn setTitleColor:[UIColor atrousColor] forState:(UIControlStateNormal)];
        [_messageLabel setTextColor:[UIColor atrousColor]];
        
        [_toastBtn setTitleColor:[UIColor yncGreenColor] forState:(UIControlStateNormal)];
    }
}

- (void)setSizeType:(PopWindowViewSizeType)sizeType
{
    if (sizeType == PopWindowViewSizeTypeSmall) {
        self.backViewWidthConstraint.constant = kSmallTypeBackViewWidth;
        self.backViewHeightConstraint.constant = kSmallTypeBackViewHeight;
    } else {
        self.backViewWidthConstraint.constant = kBigTypeBackViewWidth;
        self.backViewHeightConstraint.constant = kBigTypeBackViewHeight;
    }
}

+ (YNCPopWindowView *)sharedView
{
    static dispatch_once_t once;
    static YNCPopWindowView *sharedView;
    dispatch_once(&once, ^ {
        sharedView = [self popWindowView];
        sharedView.isAddToWindow = YES;
        sharedView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        [[UIApplication sharedApplication].keyWindow addSubview:sharedView];
    });
    return sharedView;
}

+ (void)showMessage:(NSString *)message
 buttonTitleConfirm:(NSString *)titleConfirm
  buttonTitleCancel:(NSString *)titleCancel
          colorType:(PopWindowViewColorType)colorType
           sizeType:(PopWindowViewSizeType)sizeType
      handleConfirm:(CompletionBlock)confirmBlock
       handleCancel:(CompletionBlock)cancelBlock
{
    [self sharedView].cancelBtn.hidden = NO;
    [self sharedView].confirmBtn.hidden = NO;
    [self sharedView].verticalLineView.hidden = NO;
    [self sharedView].toastBtn.hidden = YES;
    [self sharedView].frame = [UIScreen mainScreen].bounds;
    [self sharedView].colorType = colorType;
    [self sharedView].sizeType = sizeType;
    [[self sharedView] handleCancel:cancelBlock
                      handleConfirm:confirmBlock];
    [[self sharedView] initWithMessage:message
                         buttonConfirm:titleConfirm
                          buttonCancel:titleCancel];
}


+ (void)showMessage:(NSString *)message
     buttonToastBtn:(NSString *)toastBtnTitle
          colorType:(PopWindowViewColorType)colorType
           sizeType:(PopWindowViewSizeType)sizeType
        handleToast:(CompletionBlock)toastBlock
{
    [self sharedView].cancelBtn.hidden = YES;
    [self sharedView].confirmBtn.hidden = YES;
    [self sharedView].verticalLineView.hidden = YES;
    [self sharedView].toastBtn.hidden = NO;
    [self sharedView].frame = [UIScreen mainScreen].bounds;
    [self sharedView].colorType = colorType;
    [self sharedView].sizeType = sizeType;
    [[self sharedView] handleToast:toastBlock];
    [[self sharedView] initWithMessage:message
                           buttonToast:toastBtnTitle];
}


- (void)showMessage:(NSString *)message
 buttonTitleConfirm:(NSString *)titleConfirm
  buttonTitleCancel:(NSString *)titleCancel
          colorType:(PopWindowViewColorType)colorType
           sizeType:(PopWindowViewSizeType)sizeType
      handleConfirm:(CompletionBlock)confirmBlock
       handleCancel:(CompletionBlock)cancelBlock
{
    self.cancelBtn.hidden = NO;
    self.confirmBtn.hidden = NO;
    self.verticalLineView.hidden = NO;
    self.toastBtn.hidden = YES;
    self.frame = [UIScreen mainScreen].bounds;
    self.colorType = colorType;
    self.sizeType = sizeType;
    [self handleCancel:cancelBlock
         handleConfirm:confirmBlock];
    [self initWithMessage:message
            buttonConfirm:titleConfirm
             buttonCancel:titleCancel];
}


+ (instancetype)popWindowView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}


- (void)handleCancel:(CompletionBlock)cancelBlock handleConfirm:(CompletionBlock)confirmBlock
{
    cancelCompletionBlock = [cancelBlock copy];
    confirmCompletionBlock = [confirmBlock copy];
}

- (void)initWithMessage:(NSString *)message
          buttonConfirm:(NSString *)confirm
           buttonCancel:(NSString *)cancel
{
    if (self.isAddToWindow) {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    self.messageLabel.text = message;
    [self.confirmBtn setTitle:confirm forState:(UIControlStateNormal)];
    [self.cancelBtn setTitle:cancel forState:(UIControlStateNormal)];
}

- (void)handleToast:(CompletionBlock)toastBlock
{
    toastCompletionBlock = [toastBlock copy];
}

- (void)initWithMessage:(NSString *)message buttonToast:(NSString *)toast
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.messageLabel.text = message;
    [self.toastBtn setTitle:toast forState:(UIControlStateNormal)];
}

- (IBAction)confirmBtnAction:(UIButton *)sender {
    [self dismissView];
    if (confirmCompletionBlock) {
        confirmCompletionBlock();
    }
}

- (IBAction)cancelBtnAction:(UIButton *)sender {
    [self dismissView];
    if (cancelCompletionBlock) {
        cancelCompletionBlock();
    }
}

- (IBAction)toastBtnAction:(UIButton *)sender {
    [self dismissView];
    if (toastCompletionBlock) {
        toastCompletionBlock();
    }
}

- (void)dismissView
{
    [self removeFromSuperview];
}


@end
