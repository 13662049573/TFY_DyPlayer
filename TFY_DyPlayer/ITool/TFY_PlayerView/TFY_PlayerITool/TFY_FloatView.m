//
//  TFY_FloatView.m
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/6/30.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_FloatView.h"

@implementation TFY_FloatView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initilize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initilize];
    }
    return self;
}

- (void)initilize {
    self.safeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(doMoveAction:)];
    [self addGestureRecognizer:panGestureRecognizer];
}

- (void)setParentView:(UIView *)parentView {
    _parentView = parentView;
    [parentView addSubview:self];
}

#pragma mark - Action

- (void)doMoveAction:(UIPanGestureRecognizer *)recognizer {
    /// 手势在self.view中移动的位置。
    CGPoint translation = [recognizer translationInView:self.parentView];
    CGPoint newCenter = CGPointMake(recognizer.view.center.x + translation.x,
                                    recognizer.view.center.y + translation.y);
    
    //有限的屏幕范围：
    //最高保证金限额。
    newCenter.y = MAX(recognizer.view.frame.size.height/2 + self.safeInsets.top, newCenter.y);
    
    // 下限保证金。
    newCenter.y = MIN(self.parentView.frame.size.height - self.safeInsets.bottom - recognizer.view.frame.size.height/2, newCenter.y);
    
    // 左边距限制。
    newCenter.x = MAX(recognizer.view.frame.size.width/2, newCenter.x);
    
    // 右边距限制。
    newCenter.x = MIN(self.parentView.frame.size.width - recognizer.view.frame.size.width/2,newCenter.x);
    
    // 设置中心点。
    recognizer.view.center = newCenter;
    
    // 将手势坐标设置为0，否则将加起来。
    [recognizer setTranslation:CGPointZero inView:self.parentView];
}



@end
