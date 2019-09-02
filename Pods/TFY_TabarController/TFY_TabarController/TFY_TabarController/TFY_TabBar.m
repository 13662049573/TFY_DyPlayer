//
//  TFY_TabBar.m
//  TFY_AutoLayoutModelTools
//
//  Created by 田风有 on 2019/5/14.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import "TFY_TabBar.h"
#import "TFY_TabBarItem.h"

@interface TFY_TabBar ()
@property(nonatomic , assign)BOOL isMenuShow;
@property(nonatomic , assign)CGFloat itemWidth;
@end

@implementation TFY_TabBar

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (void)commonInitialization {
    
    self.backgroundView = [[UIView alloc] init];
    [self addSubview:self.backgroundView];
    
    [self setTranslucent:NO];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01) {
        return nil;
    }
    /**
     *  此注释掉的方法用来判断点击是否在父View Bounds内，
     *  如果不在父view内，就会直接不会去其子View中寻找HitTestView，return 返回
     */
    if ([self pointInside:point withEvent:event]) {
        for (UIView *subview in [self.subviews reverseObjectEnumerator]) {
            CGPoint convertedPoint = [subview convertPoint:point fromView:self];
            UIView *hitTestView = [subview hitTest:convertedPoint withEvent:event];
            if (hitTestView) {
                return hitTestView;
            }
        }
        return self;
    }else{
        for (UIView *subview in [self.subviews reverseObjectEnumerator]) {
            CGPoint convertedPoint = [subview convertPoint:point fromView:self];
            UIView *hitTestView = [subview hitTest:convertedPoint withEvent:event];
            if (hitTestView) {
                return hitTestView;
            }
        }
        return nil;
    }
    return nil;
}

- (void)layoutSubviews {
    CGSize frameSize = self.frame.size;
    CGFloat minimumContentHeight = [self minimumContentHeight];
    
    [[self backgroundView] setFrame:CGRectMake(0, frameSize.height - minimumContentHeight, frameSize.width, frameSize.height)];
    
    [self setItemWidth:roundf((frameSize.width - [self contentEdgeInsets].left - [self contentEdgeInsets].right) / [[self items] count])];
    
    NSInteger index = 0;
    
    for (TFY_TabBarItem *item in [self items]) {
        CGFloat itemHeight = [item itemHeight];
        
        if (!itemHeight) {
            itemHeight = frameSize.height;
        }
        [item setFrame:CGRectMake(self.contentEdgeInsets.left + (index * self.itemWidth), roundf(frameSize.height - itemHeight) - self.contentEdgeInsets.top, self.itemWidth, itemHeight - self.contentEdgeInsets.bottom)];
        [item setNeedsDisplay];
        
        index++;
    }
}

#pragma mark - Configuration

- (void)setItemWidth:(CGFloat)itemWidth {
    if (itemWidth > 0) {
        _itemWidth = itemWidth;
    }
}

- (void)setItems:(NSArray *)items {
    for (TFY_TabBarItem *item in items) {
        [item removeFromSuperview];
    }
    _items = [items copy];
    for (TFY_TabBarItem *item in items) {
        [item addTarget:self action:@selector(tabBarItemWasSelected:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:item];
        NSInteger index = [items indexOfObject:item];
        if (index==0) {
            self.selectedItem=item;
            self.selectedItem.selected=YES;
        }
    }
    
}

- (void)setHeight:(CGFloat)height {
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), height)];
}

- (CGFloat)minimumContentHeight {
    CGFloat minimumTabBarContentHeight = CGRectGetHeight([self frame]);
    
    for (TFY_TabBarItem *item in [self items]) {
        CGFloat itemHeight = [item itemHeight];
        if (itemHeight && (itemHeight < minimumTabBarContentHeight)) {
            minimumTabBarContentHeight = itemHeight;
        }
    }
    return minimumTabBarContentHeight;
}

#pragma mark - Item selection

- (void)tabBarItemWasSelected:(id)sender {
    self.isMenuShow?(self.isMenuShow=NO):(self.isMenuShow=YES);
    if ([[self delegate] respondsToSelector:@selector(tabBar:shouldSelectItemAtIndex:tabBarItem:addWithisMenuShow:)]) {
        NSInteger index = [self.items indexOfObject:sender];
        if (![[self delegate] tabBar:self shouldSelectItemAtIndex:index tabBarItem:self.selectedItem addWithisMenuShow:_isMenuShow]) {
            return;
        }
        
    }
    [self setSelectedItem:sender];
    
    if ([[self delegate] respondsToSelector:@selector(tabBar:didSelectItemAtIndex:tabBarItem:addWithisMenuShow:)]) {
        NSInteger index = [self.items indexOfObject:self.selectedItem];
        
        [[self delegate] tabBar:self didSelectItemAtIndex:index tabBarItem:self.selectedItem addWithisMenuShow:_isMenuShow];
    }
}

- (void)setSelectedItem:(TFY_TabBarItem *)selectedItem {
    if (selectedItem == _selectedItem){return;}
    
    [_selectedItem setSelected:NO];
    
    _selectedItem = selectedItem;
    [_selectedItem setSelected:YES];
}

#pragma mark - Translucency

- (void)setTranslucent:(BOOL)translucent {
    _translucent = translucent;
    
    CGFloat alpha = (_translucent ? 0.9 : 1.0);
    
    [self.backgroundView setBackgroundColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:alpha]];
}


@end
