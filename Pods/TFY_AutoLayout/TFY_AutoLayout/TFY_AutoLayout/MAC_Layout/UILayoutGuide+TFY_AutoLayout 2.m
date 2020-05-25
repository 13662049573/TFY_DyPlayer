//
//  UILayoutGuide+TFY_AutoLayout.m
//  TFY_AutoLayoutModelTools
//
//  Created by 田风有 on 2019/5/1.
//  Copyright © 2019 恋机科技. All rights reserved.
//  https://github.com/13662049573/TFY_AutoLayoutModelTools

#import "UILayoutGuide+TFY_AutoLayout.h"
#import <objc/runtime.h>

static inline TFY_CLASS_LGUIDE * layout_guide(TFY_VIEW * view) {
    if (view && [view isKindOfClass:TFY_CLASS_LGUIDE.self]) {
        return (TFY_CLASS_LGUIDE *)view;
    }
    return nil;
}

static inline TFY_CLASS_VIEW * view(TFY_VIEW * view) {
    if (view && [view isKindOfClass:TFY_CLASS_VIEW.self]) {
        return (TFY_CLASS_VIEW *)view;
    }
    return nil;
}

static inline TFY_CLASS_VIEW * owningView(TFY_VIEW * view) {
    if (view) {
        if ([view isKindOfClass:TFY_CLASS_VIEW.self]) {
            return (TFY_CLASS_VIEW *)view;
        }
        if ([view isKindOfClass:TFY_CLASS_LGUIDE.self]) {
            return ((TFY_CLASS_LGUIDE *)view).owningView;
        }
    }
    return nil;
}

@interface TFY_LGData: NSObject
@property (nonatomic, assign) BOOL isSameSuper;
@property (nonatomic, strong) TFY_CLASS_VIEW * superView;
@end

@implementation TFY_LGData
@end


@implementation TFY_CLASS_LGUIDE (TFY_AutoLayout)

- (LGLessOrEqual)tfy_LessOrEqual {
    WS(mySelf);
    return ^() {
        [mySelf tfy_HandleConstraintsRelation:NSLayoutRelationLessThanOrEqual];
        return mySelf;
    };
}

- (LGGreaterOrEqual)tfy_GreaterOrEqual {
    WS(mySelf);
    return ^() {
        [mySelf tfy_HandleConstraintsRelation:NSLayoutRelationGreaterThanOrEqual];
        return mySelf;
    };
}

- (LGResetConstraintAttribute)tfy_ResetConstraint {
    WS(mySelf);
    return ^() {
        [mySelf tfy_ResetConstraints];
        return mySelf;
    };
}

- (LGRemoveConstraintAttribute)tfy_RemoveLayoutAttrs {
    WS(mySelf);
    return ^(NSLayoutAttribute attributes, ...) {
        va_list attrs;
        va_start(attrs, attributes);
        NSLayoutAttribute maxAttr = [mySelf tfy_GetMaxLayoutAttribute];
        while(attributes > NSLayoutAttributeNotAnAttribute && attributes <= maxAttr) {
            if (attributes > 0) {
                [mySelf tfy_SwitchRemoveAttr:attributes view:owningView(mySelf) to:nil removeSelf:YES];
                
            }
            attributes = va_arg(attrs, NSLayoutAttribute);
        }
        va_end(attrs);
        return mySelf;
    };
}

- (LGRemoveConstraintFromViewAttribute)tfy_RemoveFromLayoutAttrs {
    WS(mySelf);
    return ^(TFY_CLASS_VIEW * view,NSLayoutAttribute attributes, ...) {
        va_list attrs;
        va_start(attrs, attributes);
        NSLayoutAttribute maxAttr = [mySelf tfy_GetMaxLayoutAttribute];
        while(attributes > NSLayoutAttributeNotAnAttribute && attributes <= maxAttr) {
            if (attributes > 0) {
                [mySelf tfy_SwitchRemoveAttr:attributes view:view to:nil removeSelf:NO];
            }
            attributes = va_arg(attrs, NSLayoutAttribute);
        }
        va_end(attrs);
        return mySelf;
    };
}

- (LGRemoveConstraintToViewAttribute)tfy_RemoveToLayoutAttrs {
    WS(mySelf);
    return ^(TFY_VIEW * toView, NSLayoutAttribute attributes, ...) {
        va_list attrs;
        va_start(attrs, attributes);
        NSLayoutAttribute maxAttr = [self tfy_GetMaxLayoutAttribute];
        while(attributes > NSLayoutAttributeNotAnAttribute && attributes <= maxAttr) {
            if (attributes > 0) {
                [mySelf tfy_SwitchRemoveAttr:attributes view:owningView(mySelf) to:toView removeSelf:NO];
            }
            attributes = va_arg(attrs, NSLayoutAttribute);
        }
        va_end(attrs);
        return mySelf;
    };
}

- (LGClearConstraintAttribute)tfy_ClearLayoutAttr {
    WS(mySelf);
    return ^() {
        [mySelf tfy_ClearLayoutAttrs];
        return mySelf;
    };
}

-(LGPriorityLow)tfy_PriorityLow{
    WS(mySelf);
    return ^(){
        [mySelf tfy_priorityLow];
        return mySelf;
    };
}

-(LGPriorityHigh)tfy_PriorityHigh{
    WS(mySelf);
    return ^(){
        [mySelf tfy_priorityHigh];
        return mySelf;
    };
}

-(LGPriorityRequired)tfy_PriorityRequired{
    WS(mySelf);
    return ^(){
        [mySelf tfy_priorityRequired];
        return mySelf;
    };
}

-(LGPriorityFitting)tfy_PriorityFitting{
    WS(mySelf);
    return ^(){
        [mySelf tfy_priorityFitting];
        return mySelf;
    };
}

-(LGPriorityValue)tfy_Priority{
    WS(mySelf);
    return ^(CGFloat value){
        [mySelf tfy_priority:value];
        return mySelf;
    };
}

-(LGLeftSpace)tfy_LeftSpace{
    WS(mySelf);
    return ^(CGFloat space){
        [mySelf tfy_LeftSpace:space];
        return mySelf;
    };
}

-(LGLeftSpaceToView)tfy_LeftSpaceToView{
    WS(mySelf);
    return ^(CGFloat space,TFY_VIEW *toVView){
        [mySelf tfy_LeftSpace:space toView:toVView];
        return mySelf;
    };
}

-(LGLeftSpaceEqualView)tfy_LeftSpaceEqualView{
    WS(mySelf);
    return ^(TFY_VIEW *view){
        [mySelf tfy_LeftSpaceEqualView:view];
        return mySelf;
    };
}

-(LGLeftSpaceEqualViewOffset)tfy_LeftSpaceEqualViewOffset{
    WS(mySelf);
    return ^(TFY_VIEW *view,CGFloat offset){
        [mySelf tfy_LeftSpaceEqualView:view offset:offset];
        return mySelf;
    };
}

-(LGLeadingSpace)tfy_LeadingSpace{
    WS(mySelf);
    return ^(CGFloat space){
        [mySelf tfy_LeadingSpace:space];
        return mySelf;
    };
}

-(LGLeadingSpaceToView)tfy_LeadingSpaceToView{
    WS(mySelf);
    return ^(CGFloat value,TFY_VIEW *toView){
        [mySelf tfy_LeadingSpace:value toView:toView];
        return mySelf;
    };
}

-(LGLeadingSpaceEqualView)tfy_LeadingSpaceEqualView{
    WS(mySelf);
    return ^(TFY_VIEW *view){
        [mySelf tfy_LeadingSpaceEqualView:view];
        return mySelf;
    };
}

-(LGLeadingSpaceEqualViewOffset)tfy_LeadingSpaceEqualViewOffset{
    WS(mySelf);
    return ^(TFY_VIEW *view,CGFloat offset){
        [mySelf tfy_LeadingSpaceEqualView:view offset:offset];
        return mySelf;
    };
}

-(LGTrailingSpace)tfy_TrailingSpace{
    WS(mySelf);
    return ^(CGFloat space){
        [mySelf tfy_TrailingSpace:space];
        return mySelf;
    };
}

-(LGTrailingSpaceToView)tfy_TrailingSpaceToView{
    WS(mySelf);
    return ^(CGFloat value,TFY_VIEW *toView){
        [mySelf tfy_TrailingSpace:value toView:toView];
        return mySelf;
    };
}

-(LGTrailingSpaceEqualView)tfy_TrailingSpaceEqualView{
    WS(mySelf);
    return ^(TFY_VIEW *view){
        [mySelf tfy_TrailingSpaceEqualView:view];
        return mySelf;
    };
}

-(LGTrailingSpaceEqualViewOffset)tfy_TrailingSpaceEqualViewOffset{
    WS(mySelf);
    return ^(TFY_VIEW *view,CGFloat offset){
        [mySelf tfy_TrailingSpaceEqualView:view offset:offset];
        return mySelf;
    };
}


#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
- (LGBaseLineSpace)tfy_FirstBaseLine {
    WS(mySelf);
    return ^(CGFloat space) {
        [mySelf tfy_FirstBaseLine:space];
        return mySelf;
    };
}

- (LGBaseLineSpaceToView)tfy_FirstBaseLineToView {
    WS(mySelf);
    return ^(CGFloat value , TFY_VIEW * toView) {
        [mySelf tfy_FirstBaseLine:value toView:toView];
        return mySelf;
    };
}

- (LGBaseLineSpaceEqualView)tfy_FirstBaseLineEqualView {
    WS(mySelf);
    return ^(TFY_VIEW * view) {
        [mySelf tfy_FirstBaseLineEqualView:view];
        return mySelf;
    };
}

- (LGBaseLineSpaceEqualViewOffset)tfy_FirstBaseLineEqualViewOffset {
    WS(mySelf);
    return ^(TFY_VIEW * view, CGFloat offset) {
        [mySelf tfy_FirstBaseLineEqualView:view offset:offset];
        return mySelf;
    };
}

#endif

- (LGBaseLineSpace)tfy_LastBaseLine {
    WS(mySelf);
    return ^(CGFloat space) {
        [mySelf tfy_LastBaseLine:space];
        return mySelf;
    };
}

- (LGBaseLineSpaceToView)tfy_LastBaseLineToView {
    WS(mySelf);
    return ^(CGFloat value , TFY_VIEW * toView) {
        [mySelf tfy_LastBaseLine:value toView:toView];
        return mySelf;
    };
}

- (LGBaseLineSpaceEqualView)tfy_LastBaseLineEqualView {
    WS(mySelf);
    return ^(TFY_VIEW * view) {
        [mySelf tfy_LastBaseLineEqualView:view];
        return mySelf;
    };
}

- (LGBaseLineSpaceEqualViewOffset)tfy_LastBaseLineEqualViewOffset {
    WS(mySelf);
    return ^(TFY_VIEW * view, CGFloat offset) {
        [mySelf tfy_LastBaseLineEqualView:view offset:offset];
        return mySelf;
    };
}

- (LGRightSpace)tfy_RightSpace {
    WS(mySelf);
    return ^(CGFloat space) {
        [mySelf tfy_RightSpace:space];
        return mySelf;
    };
}

- (LGRightSpaceToView)tfy_RightSpaceToView {
    WS(mySelf);
    return ^(CGFloat value , TFY_VIEW * toView) {
        [mySelf tfy_RightSpace:value toView:toView];
        return mySelf;
    };
}

- (LGRightSpaceEqualView)tfy_RightSpaceEqualView {
    WS(mySelf);
    return ^(TFY_VIEW * toView) {
        [mySelf tfy_RightSpaceEqualView:toView];
        return mySelf;
    };
}

- (LGRightSpaceEqualViewOffset)tfy_RightSpaceEqualViewOffset {
    WS(mySelf);
    return ^(TFY_VIEW * toView, CGFloat offset) {
        [mySelf tfy_RightSpaceEqualView:toView offset:offset];
        return mySelf;
    };
}

- (LGTopSpace)tfy_TopSpace {
    WS(mySelf);
    return ^(CGFloat space) {
        [mySelf tfy_TopSpace:space];
        return mySelf;
    };
}

- (LGTopSpaceToView)tfy_TopSpaceToView {
    WS(mySelf);
    return ^(CGFloat value , TFY_VIEW * toView) {
        [mySelf tfy_TopSpace:value toView:toView];
        return mySelf;
    };
}

- (LGTopSpaceEqualView)tfy_TopSpaceEqualView {
    WS(mySelf);
    return ^(TFY_VIEW * view) {
        [mySelf tfy_TopSpaceEqualView:view];
        return mySelf;
    };
}

- (LGTopSpaceEqualViewOffset)tfy_TopSpaceEqualViewOffset {
    WS(mySelf);
    return ^(TFY_VIEW * view, CGFloat offset) {
        [mySelf tfy_TopSpaceEqualView:view offset:offset];
        return mySelf;
    };
}

- (LGBottomSpace)tfy_BottomSpace {
    WS(mySelf);
    return ^(CGFloat space) {
        [mySelf tfy_BottomSpace:space];
        return mySelf;
    };
}

- (LGBottomSpaceToView)tfy_BottomSpaceToView {
    WS(mySelf);
    return ^(CGFloat value , TFY_VIEW * toView) {
        [mySelf tfy_BottomSpace:value toView:toView];
        return mySelf;
    };
}

- (LGBottomSpaceEqualView)tfy_BottomSpaceEqualView {
    WS(mySelf);
    return ^(TFY_VIEW * toView) {
        [mySelf tfy_BottomSpaceEqualView:toView];
        return mySelf;
    };
}

- (LGBottomSpaceEqualViewOffset)tfy_BottomSpaceEqualViewOffset {
    WS(mySelf);
    return ^(TFY_VIEW * toView, CGFloat offset) {
        [mySelf tfy_BottomSpaceEqualView:toView offset:offset];
        return mySelf;
    };
}

- (LGWidth)tfy_Width {
    WS(mySelf);
    return ^(CGFloat value) {
        [mySelf tfy_Width:value];
        return mySelf;
    };
}

- (LGWidthAuto)tfy_WidthAuto {
    WS(mySelf);
    return ^() {
        [mySelf tfy_AutoWidth];
        return mySelf;
    };
}

- (LGWidthEqualView)tfy_WidthEqualView {
    WS(mySelf);
    return ^(TFY_VIEW * view) {
        [mySelf tfy_WidthEqualView:view];
        return mySelf;
    };
}

- (LGWidthEqualViewRatio)tfy_WidthEqualViewRatio {
    WS(mySelf);
    return ^(TFY_VIEW * view , CGFloat value) {
        [mySelf tfy_WidthEqualView:view ratio:value];
        return mySelf;
    };
}

- (LGWidthHeightRatio)tfy_WidthHeightRatio {
    WS(mySelf);
    return ^(CGFloat value) {
        [mySelf tfy_WidthHeightRatio:value];
        return mySelf;
    };
}

- (LGHeight)tfy_Height {
    WS(mySelf);
    return ^(CGFloat value) {
        [mySelf tfy_Height:value];
        return mySelf;
    };
}

- (LGHeightAuto)tfy_HeightAuto {
    WS(mySelf);
    return ^() {
        [mySelf tfy_AutoHeight];
        return mySelf;
    };
}

- (LGHeightEqualView)tfy_HeightEqualView {
    WS(mySelf);
    return ^(TFY_VIEW * view) {
        [mySelf tfy_HeightEqualView:view];
        return mySelf;
    };
}

- (LGHeightEqualViewRatio)tfy_HeightEqualViewRatio {
    WS(mySelf);
    return ^(TFY_VIEW * view , CGFloat value) {
        [mySelf tfy_HeightEqualView:view ratio:value];
        return mySelf;
    };
}

- (LGHeightWidthRatio)tfy_HeightWidthRatio {
    WS(mySelf);
    return ^(CGFloat value) {
        [mySelf tfy_HeightWidthRatio:value];
        return mySelf;
    };
}

- (LGCenterX)tfy_CenterX {
    WS(mySelf);
    return ^(CGFloat value) {
        [mySelf tfy_CenterX:value];
        return mySelf;
    };
}

- (LGCenterXToView)tfy_CenterXToView {
    WS(mySelf);
    return ^(CGFloat value,TFY_VIEW * toView) {
        [mySelf tfy_CenterX:value toView:toView];
        return mySelf;
    };
}

- (LGCenterY)tfy_CenterY {
    WS(mySelf);
    return ^(CGFloat value) {
        [mySelf tfy_CenterY:value];
        return mySelf;
    };
}

- (LGCenterYToView)tfy_CenterYToView {
    WS(mySelf);
    return ^(CGFloat value,TFY_VIEW * toView) {
        [mySelf tfy_CenterY:value toView:toView];
        return mySelf;
    };
}

- (LGCenter)tfy_Center {
    WS(mySelf);
    return ^(CGFloat x, CGFloat y) {
        [mySelf tfy_Center:CGPointMake(x, y)];
        return mySelf;
    };
}

- (LGCenterToView)tfy_CenterToView {
    WS(mySelf);
    return ^(CGPoint center,TFY_VIEW * toView) {
        [mySelf tfy_Center:center toView:toView];
        return mySelf;
    };
}

- (LGsize)tfy_Size {
    WS(mySelf);
    return ^(CGFloat width, CGFloat height) {
        [mySelf tfy_Size:CGSizeMake(width, height)];
        return mySelf;
    };
}

- (LGSizeEqual)tfy_SizeEqualView {
    WS(mySelf);
    return ^(TFY_VIEW * view) {
        [mySelf tfy_SizeEqualView:view];
        return mySelf;
    };
}

- (LGFrameEqual)tfy_FrameEqualView {
    WS(mySelf);
    return ^(TFY_VIEW * view) {
        [mySelf tfy_FrameEqualView:view];
        return mySelf;
    };
}


- (TFY_CLASS_LGUIDE * _Nonnull)tfy_LeftSpace:(CGFloat)leftSpace {
    return [self tfy_ConstraintWithItem:[self getSview] attribute:NSLayoutAttributeLeft constant:leftSpace];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_LeftSpace:(CGFloat)leftSpace toView:(TFY_VIEW * _Nonnull)toView {
    NSLayoutAttribute toAttribute = NSLayoutAttributeRight;
    TFY_LGData * data = [self sameSuperviewWithView1:toView view2:self];
    if (!data.isSameSuper) {
        toAttribute = NSLayoutAttributeLeft;
    }
    return [self tfy_ConstraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:toView attribute:toAttribute multiplier:1 constant:leftSpace];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_LeftSpaceEqualView:(TFY_VIEW * _Nonnull)view {
    return [self tfy_LeftSpaceEqualView:view offset:0];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_LeftSpaceEqualView:(TFY_VIEW * _Nonnull)view offset:(CGFloat)offset {
    return [self tfy_ConstraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1 constant:offset];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_RightSpace:(CGFloat)rightSpace {
    return [self tfy_ConstraintWithItem:[self getSview] attribute:NSLayoutAttributeRight constant:0.0 - rightSpace];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_RightSpace:(CGFloat)rightSpace toView:(TFY_VIEW * _Nonnull)toView {
    NSLayoutAttribute toAttribute = NSLayoutAttributeLeft;
    TFY_LGData * data = [self sameSuperviewWithView1:toView view2:self];
    if (!data.isSameSuper) {
        toAttribute = NSLayoutAttributeRight;
    }
    return [self tfy_ConstraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:toView attribute:toAttribute multiplier:1 constant:0.0 - rightSpace];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_RightSpaceEqualView:(TFY_VIEW * _Nonnull)view {
    return [self tfy_RightSpaceEqualView:view offset:0];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_RightSpaceEqualView:(TFY_VIEW * _Nonnull)view offset:(CGFloat)offset {
    return [self tfy_ConstraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1 constant:0.0 - offset];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_LeadingSpace:(CGFloat)leadingSpace {
    return [self tfy_ConstraintWithItem:[self getSview] attribute:NSLayoutAttributeLeading constant:leadingSpace];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_LeadingSpace:(CGFloat)leadingSpace toView:(TFY_VIEW * _Nonnull)toView {
    NSLayoutAttribute toAttribute = NSLayoutAttributeTrailing;
    TFY_LGData * data = [self sameSuperviewWithView1:toView view2:self];
    if (!data.isSameSuper) {
        toAttribute = NSLayoutAttributeLeading;
    }
    return [self tfy_ConstraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:toView attribute:toAttribute multiplier:1 constant:leadingSpace];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_LeadingSpaceEqualView:(TFY_VIEW * _Nonnull)view {
    return [self tfy_LeadingSpaceEqualView:view offset:0];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_LeadingSpaceEqualView:(TFY_VIEW * _Nonnull)view offset:(CGFloat)offset {
    return [self tfy_ConstraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeading multiplier:1 constant:offset];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_TrailingSpace:(CGFloat)trailingSpace {
    return [self tfy_ConstraintWithItem:[self getSview] attribute:NSLayoutAttributeTrailing constant:0.0 - trailingSpace];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_TrailingSpace:(CGFloat)trailingSpace toView:(TFY_VIEW * _Nonnull)toView {
    NSLayoutAttribute toAttribute = NSLayoutAttributeLeading;
    TFY_LGData * data = [self sameSuperviewWithView1:toView view2:self];
    if (!data.isSameSuper) {
        toAttribute = NSLayoutAttributeTrailing;
    }
    return [self tfy_ConstraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:toView attribute:toAttribute multiplier:1 constant:0.0 - trailingSpace];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_TrailingSpaceEqualView:(TFY_VIEW * _Nonnull)view {
    return [self tfy_TrailingSpaceEqualView:view offset:0];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_TrailingSpaceEqualView:(TFY_VIEW * _Nonnull)view offset:(CGFloat)offset {
    return [self tfy_ConstraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0.0 - offset];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_TopSpace:(CGFloat)topSpace {
    return [self tfy_ConstraintWithItem:[self getSview] attribute:NSLayoutAttributeTop constant:topSpace];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_TopSpace:(CGFloat)topSpace toView:(TFY_VIEW * _Nonnull)toView {
    NSLayoutAttribute toAttribute = NSLayoutAttributeBottom;
    TFY_LGData * data = [self sameSuperviewWithView1:toView view2:self];
    if (!data.isSameSuper) {
        toAttribute = NSLayoutAttributeTop;
    }
    return [self tfy_ConstraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:toView attribute:toAttribute multiplier:1 constant:topSpace];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_TopSpaceEqualView:(TFY_VIEW * _Nonnull)view {
    return [self tfy_TopSpaceEqualView:view offset:0];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_TopSpaceEqualView:(TFY_VIEW * _Nonnull)view offset:(CGFloat)offset {
    return [self tfy_ConstraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:offset];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_BottomSpace:(CGFloat)bottomSpace {
    return [self tfy_ConstraintWithItem:[self getSview] attribute:NSLayoutAttributeBottom constant:0.0 - bottomSpace];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_BottomSpace:(CGFloat)bottomSpace toView:(TFY_VIEW * _Nonnull)toView {
    return [self tfy_ConstraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:toView attribute:NSLayoutAttributeTop multiplier:1 constant:bottomSpace];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_BottomSpaceEqualView:(TFY_VIEW * _Nonnull)view {
    return [self tfy_BottomSpaceEqualView:view offset:0];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_BottomSpaceEqualView:(TFY_VIEW * _Nonnull)view offset:(CGFloat)offset {
    return [self tfy_ConstraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1 constant:0.0 - offset];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_Width:(CGFloat)width{
    return [self tfy_ConstraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:width];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_WidthEqualView:(TFY_VIEW * _Nonnull)view {
    return [self tfy_ConstraintWithItem:view attribute:NSLayoutAttributeWidth constant:0];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_WidthEqualView:(TFY_VIEW * _Nonnull)view ratio:(CGFloat)ratio {
    return [self tfy_ConstraintWithItem:view attribute:NSLayoutAttributeWidth constant:0 multiplier:ratio];
    
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_RemoveFrom:(TFY_CLASS_VIEW * _Nonnull)view layoutAttrs:(NSLayoutAttribute)attributes, ... {
    va_list attrs;
    va_start(attrs, attributes);
    NSLayoutAttribute maxAttr = [self tfy_GetMaxLayoutAttribute];
    while(attributes > NSLayoutAttributeNotAnAttribute && attributes <= maxAttr) {
        if (attributes > 0) {
            [self tfy_SwitchRemoveAttr:attributes view:view to:nil removeSelf:NO];
        }
        attributes = va_arg(attrs, NSLayoutAttribute);
    }
    va_end(attrs);
    return self;
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_RemoveFrom:(TFY_CLASS_LGUIDE * _Nonnull)view layoutAttr:(NSLayoutAttribute)attribute {
    return [self tfy_RemoveFrom:view layoutAttrs:attribute];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_RemoveLayoutAttr:(NSLayoutAttribute)attributes, ... {
    va_list attrs;
    va_start(attrs, attributes);
    NSLayoutAttribute maxAttr = [self tfy_GetMaxLayoutAttribute];
    while(attributes > NSLayoutAttributeNotAnAttribute && attributes <= maxAttr) {
        if (attributes > 0) {
            [self tfy_SwitchRemoveAttr:attributes view:self.owningView to:nil removeSelf:YES];
        }
        attributes = va_arg(attrs, NSLayoutAttribute);
    }
    va_end(attrs);
    return self;
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_RemoveLayoutOneAttr:(NSLayoutAttribute)attribute {
    NSLayoutAttribute maxAttr = [self tfy_GetMaxLayoutAttribute];
    if (attribute > NSLayoutAttributeNotAnAttribute && attribute <= maxAttr) {
        [self tfy_SwitchRemoveAttr:attribute view:self.owningView to:nil removeSelf:YES];
    }
    return self;
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_RemoveTo:(TFY_VIEW * _Nonnull)view attr:(NSLayoutAttribute)attribute {
    return [self tfy_RemoveTo:view layoutAttrs:attribute];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_RemoveTo:(TFY_VIEW * _Nonnull)view layoutAttrs:(NSLayoutAttribute)attributes, ... {
    va_list attrs;
    va_start(attrs, attributes);
    NSLayoutAttribute maxAttr = [self tfy_GetMaxLayoutAttribute];
    while(attributes > NSLayoutAttributeNotAnAttribute && attributes <= maxAttr) {
        if (attributes > 0) {
            [self tfy_SwitchRemoveAttr:attributes view:self.owningView to:view removeSelf:NO];
        }
        attributes = va_arg(attrs, NSLayoutAttribute);
    }
    va_end(attrs);
    return self;
}



- (TFY_CLASS_LGUIDE * _Nonnull)tfy_AutoWidth {
    #if TARGET_OS_IPHONE || TARGET_OS_TV
    if ([self isKindOfClass:[UILabel class]]) {
        UILabel * selfLabel = (UILabel *)self;
        if (selfLabel.numberOfLines == 0) {
            selfLabel.numberOfLines = 1;
        }
    }
    #endif
    if ([self widthConstraint] != nil ||
        [self widthLessConstraint] != nil) {
        return self.tfy_Width(0).tfy_GreaterOrEqual();
    }
    return [self tfy_ConstraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_WidthHeightRatio:(CGFloat)ratio {
    return [self tfy_ConstraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:ratio constant:0];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_Height:(CGFloat)height{
    return [self tfy_ConstraintWithItem:nil attribute:NSLayoutAttributeHeight constant:height];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_HeightEqualView:(TFY_VIEW * _Nonnull)view {
    return [self tfy_ConstraintWithItem:view attribute:NSLayoutAttributeHeight constant:0];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_HeightEqualView:(TFY_VIEW * _Nonnull)view ratio:(CGFloat)ratio {
    return [self tfy_ConstraintWithItem:view attribute:NSLayoutAttributeHeight constant:0 multiplier:ratio];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_AutoHeight {
    #if TARGET_OS_IPHONE || TARGET_OS_TV
    if ([self isKindOfClass:[UILabel class]]) {
        if (((UILabel *)self).numberOfLines != 0) {
            ((UILabel *)self).numberOfLines = 0;
        }
    }
    #endif
    if ([self heightConstraint] != nil || [self heightLessConstraint] != nil) {
        return self.tfy_Height(0).tfy_GreaterOrEqual();
    }
    return [self tfy_ConstraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_HeightWidthRatio:(CGFloat)ratio {
    return [self tfy_ConstraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:ratio constant:0];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_CenterX:(CGFloat)centerX {
    return [self tfy_ConstraintWithItem:self.owningView attribute:NSLayoutAttributeCenterX constant:centerX];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_CenterX:(CGFloat)centerX toView:(TFY_VIEW * _Nonnull)toView {
    return [self tfy_ConstraintWithItem:toView attribute:NSLayoutAttributeCenterX constant:centerX];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_CenterY:(CGFloat)centerY {
    return [self tfy_ConstraintWithItem:self.owningView attribute:NSLayoutAttributeCenterY constant:centerY];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_CenterY:(CGFloat)centerY toView:(TFY_VIEW * _Nonnull)toView {
    return [self tfy_ConstraintWithItem:toView attribute:NSLayoutAttributeCenterY constant:centerY];
}

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
- (TFY_VIEW * _Nonnull)tfy_FirstBaseLine:(CGFloat)space {
    return [self tfy_ConstraintWithItem:self.owningView attribute:NSLayoutAttributeFirstBaseline constant:0.0 - space];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_FirstBaseLine:(CGFloat)space toView:(TFY_VIEW * _Nonnull)toView {
    NSLayoutAttribute toAttribute = NSLayoutAttributeLastBaseline;
    TFY_LGData * data = [self sameSuperviewWithView1:toView view2:self];
    if (!data.isSameSuper) {
        toAttribute = NSLayoutAttributeFirstBaseline;
    }
    return [self tfy_ConstraintWithItem:self attribute:NSLayoutAttributeFirstBaseline relatedBy:NSLayoutRelationEqual toItem:toView attribute:toAttribute multiplier:1 constant:space];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_FirstBaseLineEqualView:(TFY_VIEW * _Nonnull)view {
    return [self tfy_FirstBaseLineEqualView:view offset:0];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_FirstBaseLineEqualView:(TFY_VIEW * _Nonnull)view offset:(CGFloat)offset {
    return [self tfy_ConstraintWithItem:view attribute:NSLayoutAttributeFirstBaseline constant:0.0 - offset];
}

#endif

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_LastBaseLine:(CGFloat)space {
    return [self tfy_ConstraintWithItem:self.owningView attribute:NSLayoutAttributeLastBaseline constant:0.0 - space];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_LastBaseLine:(CGFloat)space toView:(TFY_VIEW * _Nonnull)toView {
    #if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
    NSLayoutAttribute toAttribute = NSLayoutAttributeFirstBaseline;
    #else
    NSLayoutAttribute toAttribute = NSLayoutAttributeTop;
    #endif
    TFY_LGData * data = [self sameSuperviewWithView1:toView view2:self];
    if (!data.isSameSuper) {
        toAttribute = NSLayoutAttributeLastBaseline;
    }
    return [self tfy_ConstraintWithItem:self attribute:NSLayoutAttributeLastBaseline relatedBy:NSLayoutRelationEqual toItem:toView attribute:toAttribute multiplier:1 constant:0.0 - space];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_LastBaseLineEqualView:(TFY_VIEW * _Nonnull)view {
    return [self tfy_LastBaseLineEqualView:view offset:0];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_LastBaseLineEqualView:(TFY_VIEW * _Nonnull)view offset:(CGFloat)offset {
    return [self tfy_ConstraintWithItem:view attribute:NSLayoutAttributeLastBaseline constant:0.0 - offset];
}


- (TFY_CLASS_LGUIDE * _Nonnull)tfy_Center:(CGPoint)center {
    [self tfy_CenterX:center.x];
    return [self tfy_CenterY:center.y];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_Center:(CGPoint)center toView:(TFY_VIEW * _Nonnull)toView {
    [self tfy_CenterX:center.x toView:toView];
    return [self tfy_CenterY:center.y toView:toView];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_Frame:(CGFloat)left top:(CGFloat)top width:(CGFloat)width height:(CGFloat)height {
    [self tfy_LeftSpace:left];
    [self tfy_TopSpace:top];
    [self tfy_Width:width];
    return [self tfy_Height:height];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_Size:(CGSize)size {
    [self tfy_Width:size.width];
    return [self tfy_Height:size.height];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_SizeEqualView:(TFY_VIEW * _Nonnull)view {
    [self tfy_WidthEqualView: view];
    return [self tfy_HeightEqualView: view];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_FrameEqualView:(TFY_VIEW * _Nonnull)view {
    [self tfy_LeftSpaceEqualView: view];
    [self tfy_TopSpaceEqualView: view];
    return [self tfy_SizeEqualView:view];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_Frame:(CGFloat)left top:(CGFloat)top width:(CGFloat)width height:(CGFloat)height toView:(TFY_VIEW * _Nonnull)toView {
    [self tfy_LeftSpace:left toView:toView];
    [self tfy_TopSpace:top toView:toView];
    [self tfy_Width:width];
    return [self tfy_Height:height];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_AutoSize:(CGFloat)left top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom {
    [self tfy_LeftSpace:left];
    [self tfy_TopSpace:top];
    [self tfy_RightSpace:right];
    return [self tfy_BottomSpace:bottom];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_AutoWidth:(CGFloat)left top:(CGFloat)top right:(CGFloat)right height:(CGFloat)height {
    [self tfy_LeftSpace:left];
    [self tfy_TopSpace:top];
    [self tfy_RightSpace:right];
    return [self tfy_Height:height];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_AutoHeight:(CGFloat)left top:(CGFloat)top width:(CGFloat)width bottom:(CGFloat)bottom {
    [self tfy_LeftSpace:left];
    [self tfy_TopSpace:top];
    [self tfy_Width:width];
    return [self tfy_BottomSpace:bottom];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_AutoSize:(CGFloat)left top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom toView:(TFY_VIEW * _Nonnull)toView {
    [self tfy_LeftSpace:left toView:toView];
    [self tfy_TopSpace:top toView:toView];
    [self tfy_RightSpace:right toView:toView];
    return [self tfy_BottomSpace:bottom toView:toView];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_AutoWidth:(CGFloat)left top:(CGFloat)top right:(CGFloat)right height:(CGFloat)height toView:(TFY_VIEW * _Nonnull)toView {
    [self tfy_LeftSpace:left toView:toView];
    [self tfy_TopSpace:top toView:toView];
    [self tfy_RightSpace:right toView:toView];
    return [self tfy_Height:height];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_AutoHeight:(CGFloat)left top:(CGFloat)top width:(CGFloat)width bottom:(CGFloat)bottom toView:(TFY_VIEW * _Nonnull)toView {
    [self tfy_LeftSpace:left toView:toView];
    [self tfy_TopSpace:top toView:toView];
    [self tfy_Width:width];
    return [self tfy_BottomSpace:bottom toView:toView];
}

- (TFY_CLASS_LGUIDE *)tfy_ConstraintWithItem:(TFY_VIEW *)item attribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant {
    return [self tfy_ConstraintWithItem:self attribute:attribute toItem:item attribute:attribute constant:constant];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_ConstraintWithItem:(TFY_VIEW * _Nonnull)item attribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant multiplier:(CGFloat)multiplier {
    return [self tfy_ConstraintWithItem:self attribute:attribute toItem:item attribute:attribute constant:constant multiplier:multiplier];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_ConstraintWithItem:(TFY_VIEW * _Nonnull)item attribute:(NSLayoutAttribute)attribute toItem:(TFY_VIEW * _Nonnull)toItem attribute:(NSLayoutAttribute)toAttribute constant:(CGFloat)constant {
    return [self tfy_ConstraintWithItem:item attribute:attribute relatedBy:NSLayoutRelationEqual toItem:toItem attribute:toAttribute multiplier:1 constant:constant];
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_ConstraintWithItem:(TFY_VIEW * _Nonnull)item attribute:(NSLayoutAttribute)attribute toItem:(TFY_VIEW * _Nonnull)toItem attribute:(NSLayoutAttribute)toAttribute constant:(CGFloat)constant multiplier:(CGFloat)multiplier {
    return [self tfy_ConstraintWithItem:item attribute:attribute relatedBy:NSLayoutRelationEqual toItem:toItem attribute:toAttribute multiplier:multiplier constant:constant];
}

- (TFY_CLASS_LGUIDE *)tfy_ConstraintWithItem:(TFY_VIEW *)item attribute:(NSLayoutAttribute)attribute relatedBy:(NSLayoutRelation)related toItem:(TFY_VIEW *)toItem attribute:(NSLayoutAttribute)toAttribute multiplier:(CGFloat)multiplier constant:(CGFloat)constant {
    
    if (!toItem) toAttribute = NSLayoutAttributeNotAnAttribute;
    if (!item) attribute = NSLayoutAttributeNotAnAttribute;
    if (item) {
        if ([item isKindOfClass:TFY_CLASS_VIEW.self]) {
            view(item).translatesAutoresizingMaskIntoConstraints = NO;
        }
    }
    switch (attribute) {
        case NSLayoutAttributeLeft: {
            NSLayoutConstraint * leading = [self leadingConstraint];
            if (leading) {
                [self removeCacheConstraint:leading];
                [self setLeadingConstraint:nil];
            }
            leading = [self leadingLessConstraint];
            if (leading) {
                [self removeCacheConstraint:leading];
                [self setLeadingLessConstraint:nil];
            }
            leading = [self leadingGreaterConstraint];
            if (leading) {
                [self removeCacheConstraint:leading];
                [self setLeadingGreaterConstraint:nil];
            }
            NSLayoutConstraint * left = [self leftConstraintRelation:related];
            if (left) {
                if (left.firstAttribute == attribute &&
                    left.secondAttribute == toAttribute &&
                    left.firstItem == item &&
                    left.secondItem == toItem &&
                    left.relation == related &&
                    left.multiplier == multiplier) {
                    left.constant = constant;
                    return self;
                }
                [self removeCacheConstraint:left];
                [self setLeftConstraint:nil relation:related];
            }
        }
            break;
        case NSLayoutAttributeRight: {
            NSLayoutConstraint * trailing = [self trailingConstraint];
            if (trailing) {
                [self removeCacheConstraint:trailing];
                [self setTrailingConstraint:nil];
            }
            trailing = [self trailingLessConstraint];
            if (trailing) {
                [self removeCacheConstraint:trailing];
                [self setTrailingLessConstraint:nil];
            }
            trailing = [self trailingGreaterConstraint];
            if (trailing) {
                [self removeCacheConstraint:trailing];
                [self setTrailingGreaterConstraint:nil];
            }
            NSLayoutConstraint * right = [self rightConstraintRelation:related];
            if (right) {
                if (right.firstAttribute == attribute &&
                    right.secondAttribute == toAttribute &&
                    right.firstItem == item &&
                    right.secondItem == toItem &&
                    right.relation == related &&
                    right.multiplier == multiplier) {
                    right.constant = constant;
                    return self;
                }
                [self removeCacheConstraint:right];
                [self setRightConstraint:nil relation:related];
            }
        }
            break;
        case NSLayoutAttributeTop: {
            NSLayoutConstraint * firstBaseline = [self firstBaselineConstraint];
            if (firstBaseline) {
                [self removeCacheConstraint:firstBaseline];
                [self setFirstBaselineConstraint:nil];
            }
            firstBaseline = [self firstBaselineLessConstraint];
            if (firstBaseline) {
                [self removeCacheConstraint:firstBaseline];
                [self setFirstBaselineLessConstraint:nil];
            }
            firstBaseline = [self firstBaselineGreaterConstraint];
            if (firstBaseline) {
                [self removeCacheConstraint:firstBaseline];
                [self setFirstBaselineGreaterConstraint:nil];
            }
            NSLayoutConstraint * top = [self topConstraintRelation:related];
            if (top) {
                if (top.firstAttribute == attribute &&
                    top.secondAttribute == toAttribute &&
                    top.firstItem == item &&
                    top.secondItem == toItem &&
                    top.relation == related &&
                    top.multiplier == multiplier) {
                    top.constant = constant;
                    return self;
                }
                [self removeCacheConstraint:top];
                [self setTopConstraint:nil relation:related];
            }
        }
            break;
        case NSLayoutAttributeBottom: {
            NSLayoutConstraint * lastBaseline = [self lastBaselineConstraint];
            if (lastBaseline) {
                [self removeCacheConstraint:lastBaseline];
                [self setLastBaselineConstraint:nil];
            }
            lastBaseline = [self lastBaselineLessConstraint];
            if (lastBaseline) {
                [self removeCacheConstraint:lastBaseline];
                [self setLastBaselineLessConstraint:nil];
            }
            lastBaseline = [self lastBaselineGreaterConstraint];
            if (lastBaseline) {
                [self removeCacheConstraint:lastBaseline];
                [self setLastBaselineGreaterConstraint:nil];
            }
            NSLayoutConstraint * bottom = [self bottomConstraintRelation:related];
            if (bottom) {
                if (bottom.firstAttribute == attribute &&
                    bottom.secondAttribute == toAttribute &&
                    bottom.firstItem == item &&
                    bottom.secondItem == toItem &&
                    bottom.relation == related &&
                    bottom.multiplier == multiplier) {
                    bottom.constant = constant;
                    return self;
                }
                [self removeCacheConstraint:bottom];
                [self setBottomConstraint:nil relation:related];
            }
        }
            break;
        case NSLayoutAttributeLeading: {
            NSLayoutConstraint * left = [self leftConstraint];
            if (left) {
                [self removeCacheConstraint:left];
                [self setLeftConstraint:nil];
            }
            left = [self leftLessConstraint];
            if (left) {
                [self removeCacheConstraint:left];
                [self setLeftLessConstraint:nil];
            }
            left = [self leftGreaterConstraint];
            if (left) {
                [self removeCacheConstraint:left];
                [self setLeftGreaterConstraint:nil];
            }
            NSLayoutConstraint * leading = [self leadingConstraintRelation:related];
            if (leading) {
                if (leading.firstAttribute == attribute &&
                    leading.secondAttribute == toAttribute &&
                    leading.firstItem == item &&
                    leading.secondItem == toItem &&
                    leading.relation == related &&
                    leading.multiplier == multiplier) {
                    leading.constant = constant;
                    return self;
                }
                [self removeCacheConstraint:leading];
                [self setLeadingConstraint:nil relation:related];
            }
        }
            break;
        case NSLayoutAttributeTrailing: {
            NSLayoutConstraint * right = [self rightConstraint];
            if (right) {
                [self removeCacheConstraint:right];
                [self setRightConstraint:nil];
            }
            right = [self rightLessConstraint];
            if (right) {
                [self removeCacheConstraint:right];
                [self setRightLessConstraint:nil];
            }
            right = [self rightGreaterConstraint];
            if (right) {
                [self removeCacheConstraint:right];
                [self setRightGreaterConstraint:nil];
            }
            NSLayoutConstraint * trailing = [self trailingConstraintRelation:related];
            if (trailing) {
                if (trailing.firstAttribute == attribute &&
                    trailing.secondAttribute == toAttribute &&
                    trailing.firstItem == item &&
                    trailing.secondItem == toItem &&
                    trailing.relation == related &&
                    trailing.multiplier == multiplier) {
                    trailing.constant = constant;
                    return self;
                }
                [self removeCacheConstraint:trailing];
                [self setTrailingConstraint:nil relation:related];
            }
        }
            break;
        case NSLayoutAttributeWidth: {
            NSLayoutConstraint * width = [self widthConstraintRelation:related];
            if (width) {
                if (width.firstAttribute == attribute &&
                    width.secondAttribute == toAttribute &&
                    width.firstItem == item &&
                    width.secondItem == toItem &&
                    width.relation == related &&
                    width.multiplier == multiplier) {
                    width.constant = constant;
                    return self;
                }
                [self removeCacheConstraint:width];
                [self setWidthConstraint:nil relation:related];
            }
        }
            break;
        case NSLayoutAttributeHeight: {
            NSLayoutConstraint * height = [self heightConstraintRelation:related];
            if (height) {
                if (height.firstAttribute == attribute &&
                    height.secondAttribute == toAttribute &&
                    height.firstItem == item &&
                    height.secondItem == toItem &&
                    height.relation == related &&
                    height.multiplier == multiplier) {
                    height.constant = constant;
                    return self;
                }
                [self removeCacheConstraint:height];
                [self setHeightConstraint:nil relation:related];
            }
        }
            break;
        case NSLayoutAttributeCenterX: {
            NSLayoutConstraint * centerX = [self centerXConstraintRelation:related];
            if (centerX) {
                if (centerX.firstAttribute == attribute &&
                    centerX.secondAttribute == toAttribute &&
                    centerX.firstItem == item &&
                    centerX.secondItem == toItem &&
                    centerX.relation == related &&
                    centerX.multiplier == multiplier) {
                    centerX.constant = constant;
                    return self;
                }
                [self removeCacheConstraint:centerX];
                [self setCenterXConstraint:nil relation:related];
            }
        }
            break;
        case NSLayoutAttributeCenterY: {
            NSLayoutConstraint * centerY = [self centerYConstraintRelation:related];
            if (centerY) {
                if (centerY.firstAttribute == attribute &&
                    centerY.secondAttribute == toAttribute &&
                    centerY.firstItem == item &&
                    centerY.secondItem == toItem &&
                    centerY.relation == related &&
                    centerY.multiplier == multiplier) {
                    centerY.constant = constant;
                    return self;
                }
                [self removeCacheConstraint:centerY];
                [self setCenterYConstraint:nil relation:related];
            }
        }
            break;
        case NSLayoutAttributeLastBaseline: {
            NSLayoutConstraint * bottom = [self bottomConstraint];
            if (bottom) {
                [self removeCacheConstraint:bottom];
                [self setBottomConstraint:nil];
            }
            bottom = [self bottomLessConstraint];
            if (bottom) {
                [self removeCacheConstraint:bottom];
                [self setBottomLessConstraint:nil];
            }
            bottom = [self bottomGreaterConstraint];
            if (bottom) {
                [self removeCacheConstraint:bottom];
                [self setBottomGreaterConstraint:nil];
            }
            NSLayoutConstraint * lastBaseline = [self lastBaselineConstraintRelation:related];
            if (lastBaseline) {
                if (lastBaseline.firstAttribute == attribute &&
                    lastBaseline.secondAttribute == toAttribute &&
                    lastBaseline.firstItem == item &&
                    lastBaseline.secondItem == toItem &&
                    lastBaseline.relation == related &&
                    lastBaseline.multiplier == multiplier) {
                    lastBaseline.constant = constant;
                    return self;
                }
                [self removeCacheConstraint:lastBaseline];
                [self setLastBaselineConstraint:nil relation:related];
            }
        }
            break;
       #if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
        case NSLayoutAttributeFirstBaseline: {
            NSLayoutConstraint * top = [self topConstraint];
            if (top) {
                [self removeCacheConstraint:top];
                [self setTopConstraint:nil];
            }
            top = [self topLessConstraint];
            if (top) {
                [self removeCacheConstraint:top];
                [self setTopLessConstraint:nil];
            }
            top = [self topGreaterConstraint];
            if (top) {
                [self removeCacheConstraint:top];
                [self setTopGreaterConstraint:nil];
            }
            NSLayoutConstraint * firstBaseline = [self firstBaselineConstraintRelation:related];
            if (firstBaseline) {
                if (firstBaseline.firstAttribute == attribute &&
                    firstBaseline.secondAttribute == toAttribute &&
                    firstBaseline.firstItem == item &&
                    firstBaseline.secondItem == toItem &&
                    firstBaseline.relation == related &&
                    firstBaseline.multiplier == multiplier) {
                    firstBaseline.constant = constant;
                    return self;
                }
                [self removeCacheConstraint:firstBaseline];
                [self setFirstBaselineConstraint:nil relation:related];
            }
        }
            break;
        #endif
        default:
            break;
    }
    TFY_CLASS_VIEW * superView = [self mainSuperView:toItem view2:item];
    if (!superView) return self;
    NSLayoutConstraint * constraint = [NSLayoutConstraint constraintWithItem:item attribute:attribute relatedBy:related toItem:toItem attribute:toAttribute multiplier:multiplier constant:constant];
    [self setCacheConstraint:constraint attribute:attribute relation:related];
    [superView addConstraint:constraint];
    [self setCurrentConstraint:constraint];
    return self;
}



- (void)setCurrentConstraint:(NSLayoutConstraint *)currentConstraint {
    objc_setAssociatedObject(self, @selector(currentConstraint), currentConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)currentConstraint {
    return objc_getAssociatedObject(self, _cmd);
}


- (void)setLeftConstraint:(NSLayoutConstraint *)leftConstraint relation:(NSLayoutRelation)relation {
    switch (relation) {
        case NSLayoutRelationLessThanOrEqual:
            [self setLeftLessConstraint:leftConstraint];
            break;
        case NSLayoutRelationGreaterThanOrEqual:
            [self setLeftGreaterConstraint:leftConstraint];
        default:
            [self setLeftConstraint:leftConstraint];
            break;
    }
}

- (NSLayoutConstraint *)leftConstraintRelation:(NSLayoutRelation)relation {
    switch (relation) {
        case NSLayoutRelationGreaterThanOrEqual:
            return [self leftGreaterConstraint];
        case NSLayoutRelationLessThanOrEqual:
            return [self leftLessConstraint];
        default:
            return [self leftConstraint];
    }
}

- (void)setLeftConstraint:(NSLayoutConstraint *)leftConstraint {
    objc_setAssociatedObject(self, @selector(leftConstraint), leftConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)leftConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLeftLessConstraint:(NSLayoutConstraint *)leftConstraint {
    objc_setAssociatedObject(self, @selector(leftLessConstraint), leftConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)leftLessConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLeftGreaterConstraint:(NSLayoutConstraint *)leftConstraint {
    objc_setAssociatedObject(self, @selector(leftGreaterConstraint), leftConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)leftGreaterConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setRightConstraint:(NSLayoutConstraint *)rightConstraint relation:(NSLayoutRelation)relation {
    switch (relation) {
        case NSLayoutRelationLessThanOrEqual:
            [self setRightLessConstraint:rightConstraint];
            break;
        case NSLayoutRelationGreaterThanOrEqual:
            [self setRightGreaterConstraint:rightConstraint];
        default:
            [self setRightConstraint:rightConstraint];
            break;
    }
}

- (NSLayoutConstraint *)rightConstraintRelation:(NSLayoutRelation)relation {
    switch (relation) {
        case NSLayoutRelationGreaterThanOrEqual:
            return [self rightGreaterConstraint];
        case NSLayoutRelationLessThanOrEqual:
            return [self rightLessConstraint];
        default:
            return [self rightConstraint];
    }
}

- (void)setRightConstraint:(NSLayoutConstraint *)rightConstraint {
    objc_setAssociatedObject(self, @selector(rightConstraint), rightConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)rightConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setRightLessConstraint:(NSLayoutConstraint *)rightConstraint {
    objc_setAssociatedObject(self, @selector(rightLessConstraint), rightConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)rightLessConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setRightGreaterConstraint:(NSLayoutConstraint *)rightConstraint {
    objc_setAssociatedObject(self, @selector(rightGreaterConstraint), rightConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)rightGreaterConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTopConstraint:(NSLayoutConstraint *)topConstraint relation:(NSLayoutRelation)relation {
    switch (relation) {
        case NSLayoutRelationLessThanOrEqual:
            [self setTopLessConstraint:topConstraint];
            break;
        case NSLayoutRelationGreaterThanOrEqual:
            [self setTopGreaterConstraint:topConstraint];
        default:
            [self setTopConstraint:topConstraint];
            break;
    }
}

- (NSLayoutConstraint *)topConstraintRelation:(NSLayoutRelation)relation {
    switch (relation) {
        case NSLayoutRelationGreaterThanOrEqual:
            return [self topGreaterConstraint];
        case NSLayoutRelationLessThanOrEqual:
            return [self topLessConstraint];
        default:
            return [self topConstraint];
    }
}

- (void)setTopConstraint:(NSLayoutConstraint *)topConstraint {
    objc_setAssociatedObject(self, @selector(topConstraint), topConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)topConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTopLessConstraint:(NSLayoutConstraint *)topConstraint {
    objc_setAssociatedObject(self, @selector(topLessConstraint), topConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)topLessConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTopGreaterConstraint:(NSLayoutConstraint *)topConstraint {
    objc_setAssociatedObject(self, @selector(topGreaterConstraint), topConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)topGreaterConstraint {
    return objc_getAssociatedObject(self, _cmd);
}


- (void)setBottomConstraint:(NSLayoutConstraint *)bottomConstraint relation:(NSLayoutRelation)relation {
    switch (relation) {
        case NSLayoutRelationLessThanOrEqual:
            [self setBottomLessConstraint:bottomConstraint];
            break;
        case NSLayoutRelationGreaterThanOrEqual:
            [self setBottomGreaterConstraint:bottomConstraint];
        default:
            [self setBottomConstraint:bottomConstraint];
            break;
    }
}

- (NSLayoutConstraint *)bottomConstraintRelation:(NSLayoutRelation)relation {
    switch (relation) {
        case NSLayoutRelationGreaterThanOrEqual:
            return [self bottomGreaterConstraint];
        case NSLayoutRelationLessThanOrEqual:
            return [self bottomLessConstraint];
        default:
            return [self bottomConstraint];
    }
}


- (void)setBottomConstraint:(NSLayoutConstraint *)bottomConstraint {
    objc_setAssociatedObject(self, @selector(bottomConstraint), bottomConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)bottomConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setBottomLessConstraint:(NSLayoutConstraint *)bottomConstraint {
    objc_setAssociatedObject(self, @selector(bottomLessConstraint), bottomConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)bottomLessConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setBottomGreaterConstraint:(NSLayoutConstraint *)bottomConstraint {
    objc_setAssociatedObject(self, @selector(bottomGreaterConstraint), bottomConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)bottomGreaterConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLeadingConstraint:(NSLayoutConstraint *)leadingConstraint relation:(NSLayoutRelation)relation {
    switch (relation) {
        case NSLayoutRelationLessThanOrEqual:
            [self setLeadingLessConstraint:leadingConstraint];
            break;
        case NSLayoutRelationGreaterThanOrEqual:
            [self setLeadingGreaterConstraint:leadingConstraint];
        default:
            [self setLeadingConstraint:leadingConstraint];
            break;
    }
}

- (NSLayoutConstraint *)leadingConstraintRelation:(NSLayoutRelation)relation {
    switch (relation) {
        case NSLayoutRelationGreaterThanOrEqual:
            return [self leadingGreaterConstraint];
        case NSLayoutRelationLessThanOrEqual:
            return [self leadingLessConstraint];
        default:
            return [self leadingConstraint];
    }
}

- (void)setLeadingConstraint:(NSLayoutConstraint *)leadingConstraint {
    objc_setAssociatedObject(self, @selector(leadingConstraint), leadingConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)leadingConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLeadingLessConstraint:(NSLayoutConstraint *)leadingConstraint {
    objc_setAssociatedObject(self, @selector(leadingLessConstraint), leadingConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)leadingLessConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLeadingGreaterConstraint:(NSLayoutConstraint *)leadingConstraint {
    objc_setAssociatedObject(self, @selector(leadingGreaterConstraint), leadingConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)leadingGreaterConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTrailingConstraint:(NSLayoutConstraint *)trailingConstraint relation:(NSLayoutRelation)relation {
    switch (relation) {
        case NSLayoutRelationLessThanOrEqual:
            [self setTrailingLessConstraint:trailingConstraint];
            break;
        case NSLayoutRelationGreaterThanOrEqual:
            [self setTrailingGreaterConstraint:trailingConstraint];
        default:
            [self setTrailingConstraint:trailingConstraint];
            break;
    }
}

- (NSLayoutConstraint *)trailingConstraintRelation:(NSLayoutRelation)relation {
    switch (relation) {
        case NSLayoutRelationGreaterThanOrEqual:
            return [self trailingGreaterConstraint];
        case NSLayoutRelationLessThanOrEqual:
            return [self trailingLessConstraint];
        default:
            return [self trailingConstraint];
    }
}

- (void)setTrailingConstraint:(NSLayoutConstraint *)trailingConstraint {
    objc_setAssociatedObject(self, @selector(trailingConstraint), trailingConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)trailingConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTrailingLessConstraint:(NSLayoutConstraint *)trailingConstraint {
    objc_setAssociatedObject(self, @selector(trailingLessConstraint), trailingConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)trailingLessConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTrailingGreaterConstraint:(NSLayoutConstraint *)trailingConstraint {
    objc_setAssociatedObject(self, @selector(trailingGreaterConstraint), trailingConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)trailingGreaterConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setWidthConstraint:(NSLayoutConstraint *)widthConstraint relation:(NSLayoutRelation)relation {
    switch (relation) {
        case NSLayoutRelationLessThanOrEqual:
            [self setWidthLessConstraint:widthConstraint];
            break;
        case NSLayoutRelationGreaterThanOrEqual:
            [self setWidthGreaterConstraint:widthConstraint];
        default:
            [self setWidthConstraint:widthConstraint];
            break;
    }
}

- (NSLayoutConstraint *)widthConstraintRelation:(NSLayoutRelation)relation {
    switch (relation) {
        case NSLayoutRelationGreaterThanOrEqual:
            return [self widthGreaterConstraint];
        case NSLayoutRelationLessThanOrEqual:
            return [self widthLessConstraint];
        default:
            return [self widthConstraint];
    }
}


- (void)setWidthConstraint:(NSLayoutConstraint *)widthConstraint {
    objc_setAssociatedObject(self, @selector(widthConstraint), widthConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)widthConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setWidthLessConstraint:(NSLayoutConstraint *)widthConstraint {
    objc_setAssociatedObject(self, @selector(widthLessConstraint), widthConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)widthLessConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setWidthGreaterConstraint:(NSLayoutConstraint *)widthConstraint {
    objc_setAssociatedObject(self, @selector(widthGreaterConstraint), widthConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)widthGreaterConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHeightConstraint:(NSLayoutConstraint *)heightConstraint relation:(NSLayoutRelation)relation {
    switch (relation) {
        case NSLayoutRelationLessThanOrEqual:
            [self setHeightLessConstraint:heightConstraint];
            break;
        case NSLayoutRelationGreaterThanOrEqual:
            [self setHeightGreaterConstraint:heightConstraint];
        default:
            [self setHeightConstraint:heightConstraint];
            break;
    }
}

- (NSLayoutConstraint *)heightConstraintRelation:(NSLayoutRelation)relation {
    switch (relation) {
        case NSLayoutRelationGreaterThanOrEqual:
            return [self heightGreaterConstraint];
        case NSLayoutRelationLessThanOrEqual:
            return [self heightLessConstraint];
        default:
            return [self heightConstraint];
    }
}

- (void)setHeightConstraint:(NSLayoutConstraint *)heightConstraint {
    objc_setAssociatedObject(self, @selector(heightConstraint), heightConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)heightConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHeightLessConstraint:(NSLayoutConstraint *)heightConstraint {
    objc_setAssociatedObject(self, @selector(heightLessConstraint), heightConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)heightLessConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHeightGreaterConstraint:(NSLayoutConstraint *)heightConstraint {
    objc_setAssociatedObject(self, @selector(heightGreaterConstraint), heightConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)heightGreaterConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCenterXConstraint:(NSLayoutConstraint *)centerXConstraint relation:(NSLayoutRelation)relation {
    switch (relation) {
        case NSLayoutRelationLessThanOrEqual:
            [self setCenterXLessConstraint:centerXConstraint];
            break;
        case NSLayoutRelationGreaterThanOrEqual:
            [self setCenterXGreaterConstraint:centerXConstraint];
        default:
            [self setCenterXConstraint:centerXConstraint];
            break;
    }
}

- (NSLayoutConstraint *)centerXConstraintRelation:(NSLayoutRelation)relation {
    switch (relation) {
        case NSLayoutRelationGreaterThanOrEqual:
            return [self centerXGreaterConstraint];
        case NSLayoutRelationLessThanOrEqual:
            return [self centerXLessConstraint];
        default:
            return [self centerXConstraint];
    }
}


- (void)setCenterXConstraint:(NSLayoutConstraint *)centerXConstraint {
    objc_setAssociatedObject(self, @selector(centerXConstraint), centerXConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)centerXConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCenterXLessConstraint:(NSLayoutConstraint *)centerXConstraint {
    objc_setAssociatedObject(self, @selector(centerXLessConstraint), centerXConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)centerXLessConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCenterXGreaterConstraint:(NSLayoutConstraint *)centerXConstraint {
    objc_setAssociatedObject(self, @selector(centerXGreaterConstraint), centerXConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)centerXGreaterConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCenterYConstraint:(NSLayoutConstraint *)centerYConstraint relation:(NSLayoutRelation)relation {
    switch (relation) {
        case NSLayoutRelationLessThanOrEqual:
            [self setCenterYLessConstraint:centerYConstraint];
            break;
        case NSLayoutRelationGreaterThanOrEqual:
            [self setCenterYGreaterConstraint:centerYConstraint];
        default:
            [self setCenterYConstraint:centerYConstraint];
            break;
    }
}

- (NSLayoutConstraint *)centerYConstraintRelation:(NSLayoutRelation)relation {
    switch (relation) {
        case NSLayoutRelationGreaterThanOrEqual:
            return [self centerYGreaterConstraint];
        case NSLayoutRelationLessThanOrEqual:
            return [self centerYLessConstraint];
        default:
            return [self centerYConstraint];
    }
}

- (void)setCenterYConstraint:(NSLayoutConstraint *)centerYConstraint {
    objc_setAssociatedObject(self, @selector(centerYConstraint), centerYConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)centerYConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCenterYLessConstraint:(NSLayoutConstraint *)centerYConstraint {
    objc_setAssociatedObject(self, @selector(centerYLessConstraint), centerYConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)centerYLessConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCenterYGreaterConstraint:(NSLayoutConstraint *)centerYConstraint {
    objc_setAssociatedObject(self, @selector(centerYGreaterConstraint), centerYConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)centerYGreaterConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLastBaselineConstraint:(NSLayoutConstraint *)lastBaselineConstraint relation:(NSLayoutRelation)relation {
    switch (relation) {
        case NSLayoutRelationLessThanOrEqual:
            [self setLastBaselineLessConstraint:lastBaselineConstraint];
            break;
        case NSLayoutRelationGreaterThanOrEqual:
            [self setLastBaselineGreaterConstraint:lastBaselineConstraint];
        default:
            [self setLastBaselineConstraint:lastBaselineConstraint];
            break;
    }
}

- (NSLayoutConstraint *)lastBaselineConstraintRelation:(NSLayoutRelation)relation {
    switch (relation) {
        case NSLayoutRelationGreaterThanOrEqual:
            return [self lastBaselineGreaterConstraint];
        case NSLayoutRelationLessThanOrEqual:
            return [self lastBaselineLessConstraint];
        default:
            return [self lastBaselineConstraint];
    }
}


- (void)setLastBaselineConstraint:(NSLayoutConstraint *)lastBaselineConstraint {
    objc_setAssociatedObject(self, @selector(lastBaselineConstraint), lastBaselineConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)lastBaselineConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLastBaselineLessConstraint:(NSLayoutConstraint *)lastBaselineConstraint {
    objc_setAssociatedObject(self, @selector(lastBaselineLessConstraint), lastBaselineConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)lastBaselineLessConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLastBaselineGreaterConstraint:(NSLayoutConstraint *)lastBaselineConstraint {
    objc_setAssociatedObject(self, @selector(lastBaselineGreaterConstraint), lastBaselineConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)lastBaselineGreaterConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setFirstBaselineConstraint:(NSLayoutConstraint *)firstBaselineConstraint relation:(NSLayoutRelation)relation {
    switch (relation) {
        case NSLayoutRelationLessThanOrEqual:
            [self setFirstBaselineLessConstraint:firstBaselineConstraint];
            break;
        case NSLayoutRelationGreaterThanOrEqual:
            [self setFirstBaselineGreaterConstraint:firstBaselineConstraint];
        default:
            [self setFirstBaselineConstraint:firstBaselineConstraint];
            break;
    }
}

- (NSLayoutConstraint *)firstBaselineConstraintRelation:(NSLayoutRelation)relation {
    switch (relation) {
        case NSLayoutRelationGreaterThanOrEqual:
            return [self firstBaselineGreaterConstraint];
        case NSLayoutRelationLessThanOrEqual:
            return [self firstBaselineLessConstraint];
        default:
            return [self firstBaselineConstraint];
    }
}

- (void)setFirstBaselineConstraint:(NSLayoutConstraint *)firstBaselineConstraint {
    objc_setAssociatedObject(self, @selector(firstBaselineConstraint), firstBaselineConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)firstBaselineConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setFirstBaselineLessConstraint:(NSLayoutConstraint *)firstBaselineConstraint {
    objc_setAssociatedObject(self, @selector(firstBaselineLessConstraint), firstBaselineConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)firstBaselineLessConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setFirstBaselineGreaterConstraint:(NSLayoutConstraint *)firstBaselineConstraint {
    objc_setAssociatedObject(self, @selector(firstBaselineGreaterConstraint), firstBaselineConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)firstBaselineGreaterConstraint {
    return objc_getAssociatedObject(self, _cmd);
}

- (NSLayoutAttribute)tfy_GetMaxLayoutAttribute {
    NSLayoutAttribute maxAttr = NSLayoutAttributeNotAnAttribute;
    #if TARGET_OS_IPHONE || TARGET_OS_TV
    #if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)
    maxAttr = NSLayoutAttributeCenterYWithinMargins;
    #else
    maxAttr = NSLayoutAttributeLastBaseline;
    #endif
    
    #elif TARGET_OS_MAC
    #if (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
    maxAttr = NSLayoutAttributeFirstBaseline;
    #else
    maxAttr = NSLayoutAttributeLastBaseline;
    #endif
    
    #endif
    return maxAttr;
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_HandleConstraintsRelation:(NSLayoutRelation)relation {
    NSLayoutConstraint * constraints = [self currentConstraint];
    if (constraints && constraints.relation != relation) {
        NSLayoutConstraint * tmpConstraints = [NSLayoutConstraint constraintWithItem:constraints.firstItem attribute:constraints.firstAttribute relatedBy:relation toItem:constraints.secondItem attribute:constraints.secondAttribute multiplier:constraints.multiplier constant:constraints.constant];
        TFY_CLASS_VIEW * mainView = [self tfy_MainViewConstraint:constraints];
        if (mainView) {
            [mainView removeConstraint:constraints];
            [self setCacheConstraint:nil attribute:constraints.firstAttribute relation:constraints.relation];
            [mainView addConstraint:tmpConstraints];
            [self setCacheConstraint:tmpConstraints attribute:tmpConstraints.firstAttribute relation:tmpConstraints.relation];
            [self setCurrentConstraint:tmpConstraints];
        }
    }
    return self;
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_HandleConstraintsPriority:(TFY_LayoutPriority)priority {
    NSLayoutConstraint * constraints = [self currentConstraint];
    if (constraints && constraints.priority != priority) {
        #if TARGET_OS_IPHONE || TARGET_OS_TV
        if (constraints.priority == UILayoutPriorityRequired) {
            #elif TARGET_OS_MAC
            if (constraints.priority == NSLayoutPriorityRequired) {
                #endif
                TFY_CLASS_VIEW * mainView = [self tfy_MainViewConstraint:constraints];
                if (mainView) {
                    NSLayoutConstraint * tmpConstraints = [NSLayoutConstraint constraintWithItem:constraints.firstItem attribute:constraints.firstAttribute relatedBy:constraints.relation toItem:constraints.secondItem attribute:constraints.secondAttribute multiplier:constraints.multiplier constant:constraints.constant];
                    tmpConstraints.priority = priority;
                    [self setCacheConstraint:nil attribute:constraints.firstAttribute relation:constraints.relation];
                    [mainView removeConstraint:constraints];
                    [mainView addConstraint:tmpConstraints];
                    [self setCacheConstraint:tmpConstraints attribute:tmpConstraints.firstAttribute relation:tmpConstraints.relation];
                    [self setCurrentConstraint:tmpConstraints];
                }
            }else if (constraints) {
                constraints.priority = priority;
            }
        }
        return self;
    }
    
- (TFY_CLASS_LGUIDE * _Nonnull)tfy_priorityLow {
    #if TARGET_OS_IPHONE || TARGET_OS_TV
    return [self tfy_HandleConstraintsPriority:UILayoutPriorityDefaultLow];
    #elif TARGET_OS_MAC
    return [self tfy_HandleConstraintsPriority:NSLayoutPriorityDefaultLow];
    #endif
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_priorityHigh {
    #if TARGET_OS_IPHONE || TARGET_OS_TV
    return [self tfy_HandleConstraintsPriority:UILayoutPriorityDefaultHigh];
    #elif TARGET_OS_MAC
    return [self tfy_HandleConstraintsPriority:NSLayoutPriorityDefaultHigh];
    #endif
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_priorityRequired {
    #if TARGET_OS_IPHONE || TARGET_OS_TV
    return [self tfy_HandleConstraintsPriority:UILayoutPriorityRequired];
    #elif TARGET_OS_MAC
    return [self tfy_HandleConstraintsPriority:NSLayoutPriorityRequired];
    #endif
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_priorityFitting {
    #if TARGET_OS_IPHONE || TARGET_OS_TV
    return [self tfy_HandleConstraintsPriority:UILayoutPriorityFittingSizeLevel];
    #elif TARGET_OS_MAC
    return [self tfy_HandleConstraintsPriority:NSLayoutPriorityFittingSizeCompression];
    #endif
}

- (TFY_CLASS_LGUIDE * _Nonnull)tfy_priority:(CGFloat)value {
    return [self tfy_HandleConstraintsPriority:value];
}

- (TFY_CLASS_VIEW * _Nonnull)tfy_MainViewConstraint:(NSLayoutConstraint *)constraint {
    TFY_CLASS_VIEW * view = nil;
    if (constraint) {
        if (constraint.secondAttribute == NSLayoutAttributeNotAnAttribute ||
            constraint.secondItem == nil) {
            view = constraint.firstItem;
        }else if (constraint.firstAttribute == NSLayoutAttributeNotAnAttribute ||
                  constraint.firstItem == nil){
            view = constraint.firstItem;
        }else {
            id  firstItem = constraint.firstItem;
            id secondItem = constraint.secondItem;
            view = [self mainSuperView:secondItem view2:firstItem];
            if (!view) {
                view = [self mainSuperView:firstItem view2:secondItem];
            }
        }
    }
    return view;
}
    
- (void)tfy_CommonRemoveConstraint:(NSLayoutAttribute)attribute view:(TFY_CLASS_VIEW * _Nonnull)mainView to:(TFY_VIEW * _Nonnull)toView {
    NSLayoutConstraint * constraint = nil;
    TFY_CLASS_VIEW * view = nil;
    switch (attribute) {
    #if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
        case NSLayoutAttributeFirstBaseline:
            constraint = [self firstBaselineConstraint];
            if (constraint) {
                view = [self tfy_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setFirstBaselineConstraint:nil];
            }
            constraint = [self firstBaselineLessConstraint];
            if (constraint) {
                view = [self tfy_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setFirstBaselineLessConstraint:nil];
            }
            constraint = [self firstBaselineGreaterConstraint];
            if (constraint) {
                view = [self tfy_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setFirstBaselineGreaterConstraint:nil];
            }
            break;
        #endif
        case NSLayoutAttributeLastBaseline:
            constraint = [self lastBaselineConstraint];
            if (constraint) {
                view = [self tfy_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setLastBaselineConstraint:nil];
            }
            constraint = [self lastBaselineLessConstraint];
            if (constraint) {
                view = [self tfy_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setLastBaselineLessConstraint:nil];
            }
            constraint = [self lastBaselineGreaterConstraint];
            if (constraint) {
                view = [self tfy_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setLastBaselineGreaterConstraint:nil];
            }
            break;
        case NSLayoutAttributeCenterY:
            constraint = [self centerYConstraint];
            if (constraint) {
                view = [self tfy_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setCenterYConstraint:nil];
            }
            constraint = [self centerYLessConstraint];
            if (constraint) {
                view = [self tfy_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setCenterYLessConstraint:nil];
            }
            constraint = [self centerYGreaterConstraint];
            if (constraint) {
                view = [self tfy_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setCenterYGreaterConstraint:nil];
            }
            break;
        case NSLayoutAttributeCenterX:
            constraint = [self centerXConstraint];
            if (constraint) {
                view = [self tfy_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setCenterXConstraint:nil];
            }
            constraint = [self centerXLessConstraint];
            if (constraint) {
                view = [self tfy_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setCenterXLessConstraint:nil];
            }
            constraint = [self centerXGreaterConstraint];
            if (constraint) {
                view = [self tfy_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setCenterXGreaterConstraint:nil];
            }
            break;
        case NSLayoutAttributeTrailing:
            constraint = [self trailingConstraint];
            if (constraint) {
                view = [self tfy_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setTrailingConstraint:nil];
            }
            constraint = [self trailingLessConstraint];
            if (constraint) {
                view = [self tfy_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setTrailingLessConstraint:nil];
            }
            constraint = [self trailingGreaterConstraint];
            if (constraint) {
                view = [self tfy_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setTrailingGreaterConstraint:nil];
            }
            break;
        case NSLayoutAttributeLeading:
            constraint = [self leadingConstraint];
            if (constraint) {
                view = [self tfy_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setLeadingConstraint:nil];
            }
            constraint = [self leadingLessConstraint];
            if (constraint) {
                view = [self tfy_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setLeadingLessConstraint:nil];
            }
            constraint = [self leadingGreaterConstraint];
            if (constraint) {
                view = [self tfy_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setLeadingGreaterConstraint:nil];
            }
            break;
        case NSLayoutAttributeBottom:
            constraint = [self bottomConstraint];
            if (constraint) {
                view = [self tfy_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setBottomConstraint:nil];
            }
            constraint = [self bottomLessConstraint];
            if (constraint) {
                view = [self tfy_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setBottomLessConstraint:nil];
            }
            constraint = [self bottomGreaterConstraint];
            if (constraint) {
                view = [self tfy_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setBottomGreaterConstraint:nil];
            }
            break;
        case NSLayoutAttributeTop:
            constraint = [self topConstraint];
            if (constraint) {
                view = [self tfy_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setTopConstraint:nil];
            }
            constraint = [self topLessConstraint];
            if (constraint) {
                view = [self tfy_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setTopLessConstraint:nil];
            }
            constraint = [self topGreaterConstraint];
            if (constraint) {
                view = [self tfy_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setTopGreaterConstraint:nil];
            }
            break;
        case NSLayoutAttributeRight:
            constraint = [self rightConstraint];
            if (constraint) {
                view = [self tfy_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setRightConstraint:nil];
            }
            constraint = [self rightLessConstraint];
            if (constraint) {
                view = [self tfy_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setRightLessConstraint:nil];
            }
            constraint = [self rightGreaterConstraint];
            if (constraint) {
                view = [self tfy_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setRightGreaterConstraint:nil];
            }
            break;
        case NSLayoutAttributeLeft:
            constraint = [self leftConstraint];
            if (constraint) {
                view = [self tfy_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setLeftConstraint:nil];
            }
            constraint = [self leftLessConstraint];
            if (constraint) {
                view = [self tfy_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setLeftLessConstraint:nil];
            }
            constraint = [self leftGreaterConstraint];
            if (constraint) {
                view = [self tfy_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setLeftGreaterConstraint:nil];
            }
            break;
        case NSLayoutAttributeWidth:
            constraint = [self widthConstraint];
            if (constraint) {
                view = [self tfy_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setWidthConstraint:nil];
            }
            constraint = [self widthLessConstraint];
            if (constraint) {
                view = [self tfy_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setWidthLessConstraint:nil];
            }
            constraint = [self widthGreaterConstraint];
            if (constraint) {
                view = [self tfy_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setWidthGreaterConstraint:nil];
            }
            break;
        case NSLayoutAttributeHeight:
            constraint = [self heightConstraint];
            if (constraint) {
                view = [self tfy_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setHeightConstraint:nil];
            }
            constraint = [self heightLessConstraint];
            if (constraint) {
                view = [self tfy_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setHeightLessConstraint:nil];
            }
            constraint = [self heightGreaterConstraint];
            if (constraint) {
                view = [self tfy_MainViewConstraint:constraint];
                if (view) [view removeConstraint:constraint];
                [self setHeightGreaterConstraint:nil];
            }
            break;
        default:
            break;
    }
    if (mainView) {
        NSArray<NSLayoutConstraint *> * constraints = mainView.constraints;
        [constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            id linkView = (toView != nil ? toView : mainView);
            if ((obj.firstItem == self &&
                 obj.firstAttribute == attribute &&
                 (obj.secondItem == linkView || obj.secondItem == nil)) ||
                (obj.firstItem == linkView &&
                 obj.secondItem == self &&
                 obj.secondAttribute == attribute)) {
                    [mainView removeConstraint:obj];
                }
        }];
    }
}

- (void)tfy_SwitchRemoveAttr:(NSLayoutAttribute)attr view:(TFY_CLASS_VIEW *)view to:(TFY_VIEW *)toView removeSelf:(BOOL)removeSelf {
    switch (attr) {
        #if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
        case NSLayoutAttributeFirstBaseline:
        #endif
        #if ((TARGET_OS_IPHONE || TARGET_OS_TV) && (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000))
        case NSLayoutAttributeLeftMargin:
        case NSLayoutAttributeRightMargin:
        case NSLayoutAttributeTopMargin:
        case NSLayoutAttributeBottomMargin:
        case NSLayoutAttributeLeadingMargin:
        case NSLayoutAttributeTrailingMargin:
        case NSLayoutAttributeCenterXWithinMargins:
        case NSLayoutAttributeCenterYWithinMargins:
        #endif
        case NSLayoutAttributeLastBaseline:
        case NSLayoutAttributeCenterY:
        case NSLayoutAttributeCenterX:
        case NSLayoutAttributeTrailing:
        case NSLayoutAttributeLeading:
        case NSLayoutAttributeBottom:
        case NSLayoutAttributeTop:
        case NSLayoutAttributeRight:
        case NSLayoutAttributeLeft:
            [self tfy_CommonRemoveConstraint:attr view:view to:toView];
            break;
        case NSLayoutAttributeWidth:
        case NSLayoutAttributeHeight:
            if (removeSelf) {
                [self tfy_CommonRemoveConstraint:attr view:self.owningView to:toView];
            }
            [self tfy_CommonRemoveConstraint:attr view:view to:toView];
            break;
        default:
            break;
    }
}

- (TFY_VIEW *)tfy_ResetConstraints {
    
    NSLayoutConstraint * constraint = [self firstBaselineConstraint];
    if (constraint) {
        [self removeCacheConstraint:constraint];
        [self setFirstBaselineConstraint:nil];
    }
    constraint = [self firstBaselineLessConstraint];
    if (constraint) {
        [self removeCacheConstraint:constraint];
        [self setFirstBaselineLessConstraint:nil];
    }
    constraint = [self firstBaselineGreaterConstraint];
    if (constraint) {
        [self removeCacheConstraint:constraint];
        [self setFirstBaselineGreaterConstraint:nil];
    }
    
    constraint = [self lastBaselineConstraint];
    if (constraint) {
        [self removeCacheConstraint:constraint];
        [self setLastBaselineConstraint:nil];
    }
    constraint = [self lastBaselineLessConstraint];
    if (constraint) {
        [self removeCacheConstraint:constraint];
        [self setLastBaselineLessConstraint:nil];
    }
    constraint = [self lastBaselineGreaterConstraint];
    if (constraint) {
        [self removeCacheConstraint:constraint];
        [self setLastBaselineGreaterConstraint:nil];
    }
    
    constraint = [self centerYConstraint];
    if (constraint) {
        [self removeCacheConstraint:constraint];
        [self setCenterYConstraint:nil];
    }
    constraint = [self centerYLessConstraint];
    if (constraint) {
        [self removeCacheConstraint:constraint];
        [self setCenterYLessConstraint:nil];
    }
    constraint = [self centerYGreaterConstraint];
    if (constraint) {
        [self removeCacheConstraint:constraint];
        [self setCenterYGreaterConstraint:nil];
    }
    
    constraint = [self centerXConstraint];
    if (constraint) {
        [self removeCacheConstraint:constraint];
        [self setCenterXConstraint:nil];
    }
    constraint = [self centerXLessConstraint];
    if (constraint) {
        [self removeCacheConstraint:constraint];
        [self setCenterXLessConstraint:nil];
    }
    constraint = [self centerXGreaterConstraint];
    if (constraint) {
        [self removeCacheConstraint:constraint];
        [self setCenterXGreaterConstraint:nil];
    }
    
    constraint = [self trailingConstraint];
    if (constraint) {
        [self removeCacheConstraint:constraint];
        [self setTrailingConstraint:nil];
    }
    constraint = [self trailingLessConstraint];
    if (constraint) {
        [self removeCacheConstraint:constraint];
        [self setTrailingLessConstraint:nil];
    }
    constraint = [self trailingGreaterConstraint];
    if (constraint) {
        [self removeCacheConstraint:constraint];
        [self setTrailingGreaterConstraint:nil];
    }
    
    constraint = [self leadingConstraint];
    if (constraint) {
        [self removeCacheConstraint:constraint];
        [self setLeadingConstraint:nil];
    }
    constraint = [self leadingLessConstraint];
    if (constraint) {
        [self removeCacheConstraint:constraint];
        [self setLeadingLessConstraint:nil];
    }
    constraint = [self leadingGreaterConstraint];
    if (constraint) {
        [self removeCacheConstraint:constraint];
        [self setLeadingGreaterConstraint:nil];
    }
    
    constraint = [self bottomConstraint];
    if (constraint) {
        [self removeCacheConstraint:constraint];
        [self setBottomConstraint:nil];
    }
    constraint = [self bottomLessConstraint];
    if (constraint) {
        [self removeCacheConstraint:constraint];
        [self setBottomLessConstraint:nil];
    }
    constraint = [self bottomGreaterConstraint];
    if (constraint) {
        [self removeCacheConstraint:constraint];
        [self setBottomGreaterConstraint:nil];
    }
    
    constraint = [self topConstraint];
    if (constraint) {
        [self removeCacheConstraint:constraint];
        [self setTopConstraint:nil];
    }
    constraint = [self topLessConstraint];
    if (constraint) {
        [self removeCacheConstraint:constraint];
        [self setTopLessConstraint:nil];
    }
    constraint = [self topGreaterConstraint];
    if (constraint) {
        [self removeCacheConstraint:constraint];
        [self setTopGreaterConstraint:nil];
    }
    
    constraint = [self rightConstraint];
    if (constraint) {
        [self removeCacheConstraint:constraint];
        [self setRightConstraint:nil];
    }
    constraint = [self rightLessConstraint];
    if (constraint) {
        [self removeCacheConstraint:constraint];
        [self setRightLessConstraint:nil];
    }
    constraint = [self rightGreaterConstraint];
    if (constraint) {
        [self removeCacheConstraint:constraint];
        [self setRightGreaterConstraint:nil];
    }
    
    constraint = [self leftConstraint];
    if (constraint) {
        [self removeCacheConstraint:constraint];
        [self setLeftConstraint:nil];
    }
    constraint = [self leftLessConstraint];
    if (constraint) {
        [self removeCacheConstraint:constraint];
        [self setLeftLessConstraint:nil];
    }
    constraint = [self leftGreaterConstraint];
    if (constraint) {
        [self removeCacheConstraint:constraint];
        [self setLeftGreaterConstraint:nil];
    }
    
    constraint = [self widthConstraint];
    if (constraint) {
        [self removeCacheConstraint:constraint];
        [self setWidthConstraint:nil];
    }
    constraint = [self widthLessConstraint];
    if (constraint) {
        [self removeCacheConstraint:constraint];
        [self setWidthLessConstraint:nil];
    }
    constraint = [self widthGreaterConstraint];
    if (constraint) {
        [self removeCacheConstraint:constraint];
        [self setWidthGreaterConstraint:nil];
    }
    
    constraint = [self heightConstraint];
    if (constraint) {
        [self removeCacheConstraint:constraint];
        [self setHeightConstraint:nil];
    }
    constraint = [self heightLessConstraint];
    if (constraint) {
        [self removeCacheConstraint:constraint];
        [self setHeightLessConstraint:nil];
    }
    constraint = [self heightGreaterConstraint];
    if (constraint) {
        [self removeCacheConstraint:constraint];
        [self setHeightGreaterConstraint:nil];
    }
    return self;
}

- (void)removeCacheConstraint:(NSLayoutConstraint *)constraint {
    TFY_CLASS_VIEW * mainView = [self tfy_MainViewConstraint:constraint];
    if (mainView) {
        [mainView removeConstraint:constraint];
    }
}
    
    
- (TFY_CLASS_LGUIDE *)tfy_ClearLayoutAttrs {
    @autoreleasepool {
        NSArray<NSLayoutConstraint *> * constraints = self.owningView.constraints;
        if (constraints) {
            [constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.firstItem == self &&
                    obj.secondAttribute == NSLayoutAttributeNotAnAttribute) {
                    [self.owningView removeConstraint:obj];
                }
            }];
        }
        TFY_CLASS_VIEW * superView = self.owningView;
        if (superView) {
            constraints = superView.constraints;
            if (constraints) {
                [constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.firstItem == self || obj.secondItem == self) {
                        [superView removeConstraint:obj];
                    }
                }];
            }
        }
        [self tfy_ResetConstraints];
    }
    return self;
}
    
- (NSObject *)getSview {
    id sview = self.owningView;
    #if TARGET_OS_IPHONE
    if (@available(iOS 11.0, *)) {
        if (self.owningView &&
            (!self.owningView.superview ||
             (self.owningView.superview &&
              [NSStringFromClass(self.owningView.superview.class) isEqualToString:@"UIViewControllerWrapperView"]))) {
                 sview = self.owningView.safeAreaLayoutGuide;
             }
    }
    #endif
    return sview;
}

- (TFY_CLASS_VIEW *)mainSuperView:(TFY_VIEW *)view1 view2:(TFY_VIEW *)view2 {
    BOOL isView1 = !(view1 && [view1 isKindOfClass:TFY_CLASS_LGUIDE.self]);
    BOOL isView2 = !(view2 && [view2 isKindOfClass:TFY_CLASS_LGUIDE.self]);
    if (isView1 && isView2) {
        TFY_CLASS_VIEW * s_view1 = view(view1);
        TFY_CLASS_VIEW * s_view2 = view(view2);
        if (!s_view1 && s_view2) {
            return s_view2;
        }
        if (s_view1 && !s_view2) {
            return view(s_view1);
        }
        if (s_view1.superview && !s_view2.superview) {
            return s_view2;
        }
        if (!s_view1.superview && s_view2.superview) {
            return s_view1;
        }
        TFY_LGData * data = [self sameSuperviewWithView1:view1 view2:view2];
        if (data && data.superView) {
            return data.superView;
        }else if (data && data.isSameSuper && !data.superView) {
            return s_view1;
        }
        data = [self sameSuperviewWithView1:view2 view2:view1];
        if (data && data.superView) {
            return data.superView;
        }else if (data && data.isSameSuper && !data.superView) {
            return s_view2;
        }
    }else {
        if (isView1 && !isView2) {
            if (view1) {
                TFY_CLASS_VIEW * s_view = view(view1);
                TFY_CLASS_LGUIDE * guide1 = layout_guide(view2);
                if (s_view == guide1.owningView) {
                    return s_view;
                }else {
                    if (s_view.superview == guide1.owningView) {
                        return s_view.superview;
                    }
                    return [self mainSuperView:s_view.superview view2:guide1.owningView];
                }
            }else {
                return owningView(view2);
            }
        }else if (!isView1 && isView2) {
            if (view2) {
                TFY_CLASS_VIEW * s_view = view(view2);
                TFY_CLASS_LGUIDE * guide1 = layout_guide(view1);
                if (s_view == guide1.owningView) {
                    return s_view;
                }else {
                    if (s_view.superview == guide1.owningView) {
                        return s_view.superview;
                    }
                    return [self mainSuperView:s_view.superview view2:guide1.owningView];
                }
            }else {
                return owningView(view1);
            }
        }else {
            if (owningView(view1) == owningView(view2)) {
                return owningView(view1);
            }
            return [self mainSuperView:owningView(view1) view2:owningView(view2)];
        }
    }
    return nil;
}

- (TFY_CLASS_VIEW *)checkSubSuperView:(TFY_CLASS_VIEW *)superv subv:(TFY_CLASS_VIEW *)subv {
    TFY_CLASS_VIEW * superView;
    if (superv && subv && subv != superv) {
        TFY_CLASS_VIEW * sbvspv = subv.superview;
        if (sbvspv) {
            TFY_CLASS_VIEW * (^__block scanSubv)(NSArray<TFY_CLASS_VIEW *> *) = ^TFY_CLASS_VIEW * (NSArray<TFY_CLASS_VIEW *> * subvs) {
                __block TFY_CLASS_VIEW * superView;
                if (subvs && subvs.count > 0) {
                    if ([subvs containsObject:sbvspv]) {
                        superView = sbvspv;
                    }
                    if (!superView) {
                        NSMutableArray<TFY_CLASS_VIEW *> * sumSubv = [NSMutableArray array];
                        [subvs enumerateObjectsUsingBlock:^(TFY_CLASS_VIEW * _Nonnull sv, NSUInteger idx, BOOL * _Nonnull stop) {
                            [sumSubv addObjectsFromArray:sv.subviews];
                        }];
                        superView = scanSubv(sumSubv);
                    }
                }
                return superView;
            };
            if (scanSubv(@[superv])) {
                superView = superv;
            }
        }
    }
    return superView;
}

- (TFY_LGData *)sameSuperviewWithView1:(TFY_VIEW *)view1 view2:(TFY_VIEW *)view2 {
    TFY_LGData * data = [TFY_LGData new];
    data.isSameSuper = YES;
    BOOL isView1 = !(view1 && [view1 isKindOfClass:TFY_CLASS_LGUIDE.self]);
    BOOL isView2 = !(view2 && [view2 isKindOfClass:TFY_CLASS_LGUIDE.self]);
    if (isView1 && isView2) {
        TFY_CLASS_VIEW * tempToItem = view(view1);
        TFY_CLASS_VIEW * tempItem = view(view2);
        if (tempToItem && tempItem) {
            if ([self checkSubSuperView:tempToItem subv:tempItem]) {
                data.superView = tempToItem;
                data.isSameSuper = NO;
                return data;
            }
        }
        BOOL (^checkSameSuperview)(TFY_CLASS_VIEW *, TFY_CLASS_VIEW *) = ^(TFY_CLASS_VIEW * tmpSuperview, TFY_CLASS_VIEW * singleView) {
            TFY_CLASS_VIEW * tmpSingleView = singleView;
            if (tmpSingleView) {
                TFY_CLASS_VIEW * tempSingleSuperview = tmpSingleView.superview;
                while (tempSingleSuperview) {
                    if (tmpSuperview == tempSingleSuperview) {
                        return YES;
                    }else {
                        tempSingleSuperview = tempSingleSuperview.superview;
                    }
                }
            }
            return NO;
        };
        if (tempToItem && tempItem) {
            TFY_CLASS_VIEW * toItemSuperview = tempToItem.superview;
            TFY_CLASS_VIEW * itemSuperview = tempItem.superview;
            while (toItemSuperview && itemSuperview) {
                if (toItemSuperview == itemSuperview) {
                    data.superView = toItemSuperview;
                    return data;
                }else {
                    tempToItem = toItemSuperview;
                    tempItem = itemSuperview;
                    if (!tempToItem.superview && tempItem.superview) {
                        if (checkSameSuperview(tempToItem, tempItem)) {
                            data.superView = tempToItem;
                            return data;
                        }
                    }else if (tempToItem.superview && !tempItem.superview) {
                        if (checkSameSuperview(tempItem, tempToItem)) {
                            data.superView = tempItem;
                            return data;
                        }
                    }else {
                        toItemSuperview = toItemSuperview.superview;
                        itemSuperview = itemSuperview.superview;
                    }
                }
            }
            if ([self checkSubSuperView:view(view2) subv:view(view1)]) {
                data.superView = view(view2);
                data.isSameSuper = NO;
                return data;
            }
        }
    }else {
        if (isView1 && !isView2) {
            if (view1) {
                TFY_CLASS_VIEW * s_view = view(view1);
                TFY_CLASS_LGUIDE * guide1 = layout_guide(view2);
                if (s_view == guide1.owningView) {
                    data.superView = s_view;
                    data.isSameSuper = NO;
                }else {
                    if (s_view.superview == guide1.owningView) {
                        #if TARGET_OS_IPHONE || TARGET_OS_TV
                        if (@available(iOS 11.0, tvOS 11.0, *)) {
                            data.isSameSuper = s_view.superview.safeAreaLayoutGuide != guide1;
                        } else {
                            data.isSameSuper = YES;
                        }
                        #elif TARGET_OS_MAC
                        data.isSameSuper = YES;
                        #endif
                        data.superView = s_view.superview;
                        return data;
                    }
                    return [self sameSuperviewWithView1:s_view.superview view2:guide1.owningView];
                }
            }else {
                data.superView = owningView(view2);
                data.isSameSuper = NO;
            }
        }else if (!isView1 && isView2) {
            if (view2) {
                TFY_CLASS_VIEW * s_view = view(view2);
                TFY_CLASS_LGUIDE * guide1 = layout_guide(view1);
                if (s_view == guide1.owningView) {
                    data.superView = s_view;
                    data.isSameSuper = NO;
                }else {
                    if (s_view.superview == guide1.owningView) {
                        #if TARGET_OS_IPHONE || TARGET_OS_TV
                        if (@available(iOS 11.0, tvOS 11.0, *)) {
                            data.isSameSuper = s_view.superview.safeAreaLayoutGuide != guide1;
                        } else {
                            data.isSameSuper = YES;
                        }
                        #elif TARGET_OS_MAC
                        data.isSameSuper = YES;
                        #endif
                        data.superView = s_view.superview;
                        return data;
                    }
                    return [self sameSuperviewWithView1:guide1.owningView view2:s_view.superview];
                }
            }else {
                data.superView = owningView(view1);
                data.isSameSuper = NO;
            }
        }else {
            if (owningView(view1) == owningView(view2)) {
                data.superView = owningView(view1);
                #if TARGET_OS_IPHONE || TARGET_OS_TV
                if (@available(iOS 11.0, tvOS 11.0, *)) {
                    data.isSameSuper = !(owningView(view1).safeAreaLayoutGuide == layout_guide(view2) || owningView(view2).safeAreaLayoutGuide == layout_guide(view1));
                } else {
                    data.isSameSuper = YES;
                }
                #elif TARGET_OS_MAC
                data.isSameSuper = YES;
                #endif
            }else {
                return [self sameSuperviewWithView1:owningView(view1) view2:owningView(view2)];
            }
        }
    }
    return data;
}

- (void)setCacheConstraint:(NSLayoutConstraint *)constraint attribute:(NSLayoutAttribute) attribute relation:(NSLayoutRelation)relation {
    switch (attribute) {
        #if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
        case NSLayoutAttributeFirstBaseline:
            [self setFirstBaselineConstraint:constraint relation:relation];
            break;
        #endif
        case NSLayoutAttributeLastBaseline:
            [self setLastBaselineConstraint:constraint relation:relation];
            break;
        case NSLayoutAttributeCenterY:
            [self setCenterYConstraint:constraint relation:relation];
            break;
        case NSLayoutAttributeCenterX:
            [self setCenterXConstraint:constraint relation:relation];
            break;
        case NSLayoutAttributeTrailing:
            [self setTrailingConstraint:constraint relation:relation];
            break;
        case NSLayoutAttributeLeading:
            [self setLeadingConstraint:constraint relation:relation];
            break;
        case NSLayoutAttributeBottom:
            [self setBottomConstraint:constraint relation:relation];
            break;
        case NSLayoutAttributeTop:
            [self setTopConstraint:constraint relation:relation];
            break;
        case NSLayoutAttributeRight:
            [self setRightConstraint:constraint relation:relation];
            break;
        case NSLayoutAttributeLeft:
            [self setLeftConstraint:constraint relation:relation];
            break;
        case NSLayoutAttributeWidth:
            [self setWidthConstraint:constraint relation:relation];
            break;
        case NSLayoutAttributeHeight:
            [self setHeightConstraint:constraint relation:relation];
            break;
        default:
            break;
    }
}
@end
