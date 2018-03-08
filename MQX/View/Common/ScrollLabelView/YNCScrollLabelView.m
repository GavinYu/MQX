//
//  YNCScrollLabelView.m
//  YuneecApp
//
//  Created by yc-sh-vr-pc05 on 2017/12/12.
//  Copyright © 2017年 yuneec. All rights reserved.
//

#import "YNCScrollLabelView.h"

static void each_object(NSArray *objects, void (^block)(id object))
{
    for(id obj in objects){
        block(obj);
    }
}
//宏定义 给Label的属性赋值
#define EACH_LABEL(ATTRIBUTE, VALUE) each_object(self.labels, ^(UILabel *label) {label.ATTRIBUTE = VALUE; })

@interface YNCScrollLabelView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *labels;
@property (nonatomic, strong) UILabel *mainLabel; /**< 没滚动就能看到的Label*/

@property (nonatomic, assign) CGFloat sizeMultiple;

//标识label 文字是否需要滚动
@property (assign, nonatomic) BOOL isScrollText;

@end

@implementation YNCScrollLabelView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    if(self = [super init])
    {
        [self initData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self initData];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        [self initData];
    }
    return self;
}

- (void)initData
{
    self.textFont = [UIFont systemFontOfSize:18];
    self.textColor = [UIColor whiteColor];
    self.textAlignment = NSTextAlignmentCenter;
    
    self.velocity = 5.0;
    self.space = 15;
    self.pauseTimeIntervalBeforeScroll = 0;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self addSubview:self.scrollView];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -- 滚动设置

- (void)setText:(NSString *)theText
{
    if([self.text isEqualToString:theText]) return;
    
    _text = theText;
    EACH_LABEL(text, theText);
    EACH_LABEL(font, self.textFont);
    EACH_LABEL(textColor, self.textColor);
    EACH_LABEL(textAlignment, self.textAlignment);
    
    [self refreshLabelsFrame:theText];
}

/**
 *  根据Label的内容更新Label的frame
 */
- (void)refreshLabelsFrame:(NSString *)labelText
{
    if(labelText.length == 0) return;
    
    CGSize labelSize = [labelText boundingRectWithSize:CGSizeMake(MAXFLOAT, self.bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.textFont} context:nil].size;
    __block CGFloat offset = 0;
    
    each_object(self.labels, ^(UILabel *label) {
        label.hidden = NO;
        CGFloat labelWidth = (labelSize.width+10*_sizeMultiple) > self.bounds.size.width ? labelSize.width + self.space : self.bounds.size.width;
        label.frame = CGRectMake(offset, 0, labelWidth, self.bounds.size.height);
        offset += labelWidth;
    });
    
    self.scrollView.contentSize = CGSizeZero;
    [self.scrollView.layer removeAllAnimations];
    
    if(labelSize.width + 10*_sizeMultiple > self.bounds.size.width)
    {
        _isScrollText = YES;
        self.scrollView.contentSize = CGSizeMake(self.bounds.size.width + self.space + CGRectGetWidth(self.mainLabel.frame), self.bounds.size.height);
        
        [self scrollLabelIfNeed];
    }
    else
    {
        _isScrollText = NO;
        EACH_LABEL(hidden, (self.mainLabel != label));
        self.scrollView.contentSize = self.bounds.size;
        [self.scrollView.layer removeAllAnimations];
    }
}

/**
 *  循环滚动Label
 */
- (void)scrollLabelIfNeed
{
    if (_isScrollText) {
        NSTimeInterval duration = (CGRectGetWidth(self.mainLabel.frame) - self.bounds.size.width)/self.velocity;
        [self.scrollView.layer removeAllAnimations];
        //重置contentOffset 否则不会循环滚动
        self.scrollView.contentOffset = CGPointZero;
        
        [UIView animateWithDuration:duration delay:self.pauseTimeIntervalBeforeScroll options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear animations:^{
            
            self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.mainLabel.frame), 0);
        } completion:^(BOOL finished) {
            if(finished)
            {
                [self performSelector:@selector(scrollLabelIfNeed) withObject:nil];
            }
        }];
    }
}

#pragma mark -- 进入后台 前台

- (void)addObaserverNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //活跃状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollLabelIfNeed) name:UIApplicationDidBecomeActiveNotification object:nil];
    //即将进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollLabelIfNeed) name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark --  getter

- (UIScrollView *)scrollView
{
    if(!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (NSMutableArray *)labels
{
    if(!_labels)
    {
        _labels = [[NSMutableArray alloc] init];
        for(int i=0; i<2; i++)
        {
            UILabel *label = [[UILabel alloc] init];
            label.textAlignment = self.textAlignment;
            label.backgroundColor = [UIColor clearColor];
            [self.labels addObject:label];
            [self.scrollView addSubview:label];
        }
    }
    return _labels;
}

- (UILabel *)mainLabel
{
    return self.labels[0];
}

- (void)setCurrentDisplayMode:(YNCModeDisplay)currentDisplayMode {
    _sizeMultiple = (currentDisplayMode==YNCModeDisplayGlass?0.5:1.0);

    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, CGRectGetWidth(self.bounds) * _sizeMultiple, CGRectGetHeight(self.bounds) * _sizeMultiple);
    self.scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
}

@end
