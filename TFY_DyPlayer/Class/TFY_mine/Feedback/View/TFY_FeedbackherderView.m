//
//  TFY_FeedbackherderView.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/18.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_FeedbackherderView.h"
#import "TFY_TextView.h"


@interface TFY_FeedbackherderView ()
@property(nonatomic , strong)TFY_TextView *textView;
@end

@implementation TFY_FeedbackherderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor = [UIColor tfy_colorWithHex:LCColor_B5];
        
        [self addSubview:self.textView];
        
    }
    return self;
}

-(TFY_TextView *)textView{
    if (!_textView) {
        _textView = [[TFY_TextView alloc] initWithFrame:CGRectMake(15, 0, Width_W-30, 150)];
        _textView.placeholder = @"请填写你的反馈意见!";
        _textView.textFont = [UIFont systemFontOfSize:15];
    }
    return _textView;
}

@end
