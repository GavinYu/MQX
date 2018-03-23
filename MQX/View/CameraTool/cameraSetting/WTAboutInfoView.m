//
//  WTAboutInfoView.m
//  MQX
//
//  Created by yc-sh-vr-pc05 on 2018/3/23.
//  Copyright © 2018年 YunEEC. All rights reserved.
//

#import "WTAboutInfoView.h"

#import "WTAboutInfoCell.h"
#import "YNCAppConfig.h"

#define kAbout_tableCell @"about_tableCell"

@interface WTAboutInfoView ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@end

@implementation WTAboutInfoView
- (void)setShowRightL:(BOOL)showRightL
{
    _showRightL = showRightL;
    _rightLabel.hidden = !showRightL;
}

- (void)setShowBtn:(BOOL)showBtn
{
    _showBtn = showBtn;
}

+ (instancetype)aboutInfoView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)setUpSubViews
{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"YNCAboutInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kAbout_tableCell];
    _rightLabel.textColor = [UIColor grayishColor];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WTAboutInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kAbout_tableCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArray.count > indexPath.row) {
        cell.versionTypeLabel.text = self.dataArray[indexPath.row];
    }
    if (indexPath.row == 0) {

        
    } else if (indexPath.row == 1) {
        
    } else {
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

//MARK:转换遥控器版本信息
- (NSString *)convertRCVersion:(NSString *)rcVersion
{
    NSArray *strArray = [rcVersion componentsSeparatedByString:@"_"];
    NSString *str1 = strArray[1];
    str1 = [str1 substringFromIndex:5];
    return [NSString stringWithFormat:@"%@_%@_%@", strArray[0], str1, strArray[2]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
