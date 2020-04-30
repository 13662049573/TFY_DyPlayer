//
//  UIView+TFY_Frame.m
//  TFY_AutoLayoutModelTools
//
//  Created by 田风有 on 2019/4/30.
//  Copyright © 2019 恋机科技. All rights reserved.
//  https://github.com/13662049573/TFY_AutoLayoutModelTools

#import "UIView+TFY_Frame.h"

@implementation TFY_CLASS_VIEW (TFY_Frame)

#if TARGET_OS_IPHONE || TARGET_OS_TV
-(CGFloat)tfy_swidth{
    return CGRectGetWidth([UIScreen mainScreen].bounds);
}

-(CGFloat)tfy_sheight{
    return CGRectGetHeight([UIScreen mainScreen].bounds);
}
#elif TARGET_OS_MAC
- (CGFloat)tfy_swidth {
    return CGRectGetWidth([NSScreen mainScreen].frame);
}

- (CGFloat)tfy_sheight {
    return CGRectGetHeight([NSScreen mainScreen].frame);
}
#endif

-(void)setTfy_width:(CGFloat)tfy_width{
    CGRect rect = self.frame;
    rect.size.width = tfy_width;
    self.frame = rect;
}
- (CGFloat)tfy_width{
    return CGRectGetWidth(self.frame);
}

-(void)setTfy_height:(CGFloat)tfy_height{
    CGRect rect = self.frame;
    rect.size.height = tfy_height;
    self.frame = rect;
}
- (CGFloat)tfy_height{
    return CGRectGetHeight(self.frame);
}

- (void)setTfy_x:(CGFloat)tfy_x{
    CGRect rect = self.frame;
    rect.origin.x = tfy_x;
    self.frame = rect;
}
-(CGFloat)tfy_x{
    return CGRectGetMinX(self.frame);
}

-(void)setTfy_y:(CGFloat)tfy_y{
    CGRect rect = self.frame;
    rect.origin.y = tfy_y;
    self.frame = rect;
}
-(CGFloat)tfy_y{
    return CGRectGetMinY(self.frame);
}

-(void)setTfy_maxX:(CGFloat)tfy_maxX{
    self.tfy_width = tfy_maxX - self.tfy_x;
}
- (CGFloat)tfy_maxX{
    return CGRectGetMaxX(self.frame);
}

-(void)setTfy_maxY:(CGFloat)tfy_maxY{
    self.tfy_width = tfy_maxY - self.tfy_y;
}
-(CGFloat)tfy_maxY{
    return CGRectGetMaxY(self.frame);
}

-(void)setTfy_midX:(CGFloat)tfy_midX{
    self.tfy_width = tfy_midX * 2;
}
-(CGFloat)tfy_midX{
    return CGRectGetMinX(self.frame) + CGRectGetWidth(self.frame) / 2;
}

-(void)setTfy_midY:(CGFloat)tfy_midY{
    self.tfy_height = tfy_midY * 2;
}
-(CGFloat)tfy_midY{
    return CGRectGetMinY(self.frame) + CGRectGetHeight(self.frame) / 2;
}

#if TARGET_OS_IPHONE || TARGET_OS_TV

-(void)setTfy_cx:(CGFloat)tfy_cx{
    CGPoint center = self.center;
    center.x = tfy_cx;
    self.center = center;
}
-(CGFloat)tfy_cx{
    return self.center.x;
}

-(void)setTfy_cy:(CGFloat)tfy_cy{
    CGPoint center = self.center;
    center.y = tfy_cy;
    self.center = center;
}
- (CGFloat)tfy_cy{
    return self.center.y;
}
#endif

-(void)setTfy_xy:(CGPoint)tfy_xy{
    CGRect rect = self.frame;
    rect.origin = tfy_xy;
    self.frame = rect;
}
- (CGPoint)tfy_xy{
    return self.frame.origin;
}

-(void)setTfy_se:(CGSize)tfy_se{
    CGRect rect = self.frame;
    rect.size = tfy_se;
    self.frame = rect;
}

-(CGSize)tfy_se{
    return self.frame.size;
}

@end
