//
//  UIPickerView+YNCPicker.m
//  YuneecApp
//
//  Created by hank on 27/05/2017.
//  Copyright © 2017 yuneec. All rights reserved.
//

#import "UIPickerView+YNCPicker.h"

@implementation UIPickerView (YNCPicker)

- (void)clearSpearatorLine
{
    for (UIView *subView1 in self.subviews)
    {
        if ([subView1 isKindOfClass:[UIPickerView class]])//取出UIPickerView
        {
            for(UIView *subView2 in subView1.subviews)
            {
                if (subView2.frame.size.height < 1)//取出分割线view
                {
                    subView2.hidden = YES;//隐藏分割线
                }
            }
        }
    }
}

@end
