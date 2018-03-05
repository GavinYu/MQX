//
//  YNCFB_ShutterView.m
//  YuneecApp
//
//  Created by hank on 08/05/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import "YNCFB_ShutterView.h"
#import "UIPickerView+YNCPicker.h"
#import "YNCAppConfig.h"

@interface YNCFB_ShutterView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, assign) BOOL isSelectRow;
@property (nonatomic, assign) BOOL isFirstTime;

@end

@implementation YNCFB_ShutterView

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
}

- (void)setEnableUse:(BOOL)enableUse
{
    _enableUse = enableUse;
    _pickerView.userInteractionEnabled = !enableUse;
    NSInteger row = [_pickerView selectedRowInComponent:0];
    UILabel *label = (UILabel *)[_pickerView viewForRow:row forComponent:0];
    label.font = [UIFont thirteenFontSize];
    if (enableUse) {
        label.textColor = [UIColor yncGreenColor];
    } else {
        label.textColor = [UIColor yncGreenColor];
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [self addSubview:_contentView];
    _contentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.isFirstTime = YES;
    [self createUI];
}

- (void)createUI
{
    CGFloat y = (self.frame.size.height - self.frame.size.width) / 2.0;
    CGFloat x = (self.frame.size.width - self.frame.size.height) / 2.0;
    //NSLog(@"-------x%.2f =====%.2f", self.frame.size.width, self.frame.size.height);
    self.pickerView.frame = CGRectMake(x, y, self.frame.size.height, self.frame.size.width);
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    _pickerView.showsSelectionIndicator = NO;
    [self addSubview:_pickerView];
    _pickerView.transform = CGAffineTransformMakeRotation(M_PI_2);
    // 解决pickerView的分割线
    UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, (_pickerView.frame.size.height - 60) / 2.0, _pickerView.frame.size.width, 60)];
    selectView.backgroundColor = [UIColor clearColor];
    [_pickerView addSubview:selectView];
//    [_pickerView selectRow:self.selectRow inComponent:0 animated:YES];
//    [self pickerView:self.pickerView didSelectRow:self.selectRow inComponent:0];
}

- (void)reloadPickerViewIndex:(NSUInteger)index
{
    self.selectRow = index;
    [_pickerView selectRow:index inComponent:0 animated:YES];
    [_pickerView reloadAllComponents];
}


- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shutterNotificationAction:) name:YNC_CAMERA_SHUTTER_NOTIFICATION object:nil];
}

- (void)shutterNotificationAction:(NSNotification *)sender
{
    
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataSource.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 60;
}


#pragma mark - UIPickerViewDelegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    UILabel *label = (UILabel *)view;
    if (label == nil) {
        label = [[UILabel alloc] init];
        label.text = [NSString stringWithFormat:@"1/%@", self.dataSource[row]];
        if (row == self.selectRow && !self.enableUse) {
//            self.isFirstTime = NO;
            label.textColor = [UIColor yncGreenColor];
            label.font = [UIFont thirteenFontSize];
        } else {
            label.font = [UIFont tenFontSize];
            label.textColor = [UIColor yncGreenColor];
        }
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }
    // 隐藏pickView的边框
    ((UIView *)[self.pickerView.subviews objectAtIndex:2]).hidden = YES;
    ((UIView *)[self.pickerView.subviews objectAtIndex:3]).hidden = YES;
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    UILabel *label = (UILabel *)[pickerView viewForRow:row forComponent:0];
    label.textColor = [UIColor yncGreenColor];
    label.font = [UIFont thirteenFontSize];
    if (self.selectRow != row) {
        NSInteger selectedRow = [pickerView selectedRowInComponent:0];
        UILabel *selectedLabel = (UILabel *)[_pickerView viewForRow:selectedRow forComponent:0];
        selectedLabel.font = [UIFont thirteenFontSize];
        selectedLabel.textColor = [UIColor yncGreenColor];
    }
    self.selectRow = row;
    if ([_delegate respondsToSelector:@selector(selectPickerViewRow:)]) {
        [_delegate selectPickerViewRow:row];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YNC_CAMERA_SHUTTER_NOTIFICATION object:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
