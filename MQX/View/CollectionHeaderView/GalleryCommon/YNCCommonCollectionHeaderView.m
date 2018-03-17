//
//  CHGalleryHeaderView.m
//  SkyViewS
//
//  Created by vrsh on 16/7/4.
//  Copyright © 2016年 Gavin. All rights reserved.
//

#import "YNCCommonCollectionHeaderView.h"

#import "YNCMacros.h"

@implementation YNCCommonCollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureSubViews];
    }
    return self;
}


- (void)configureSubViews
{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:11.0];
    self.titleLabel.textColor = TextBlackColor;
    [self addSubview:_titleLabel];
    
}

@end
