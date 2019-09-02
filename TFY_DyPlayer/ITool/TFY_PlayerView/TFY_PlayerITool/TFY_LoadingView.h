//
//  TFY_LoadingView.h
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/6/30.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LoadingType) {
    LoadingTypeKeep,
    LoadingTypeFadeOut,
};


NS_ASSUME_NONNULL_BEGIN

@interface TFY_LoadingView : UIView
/**
 *  状态
 */
@property(nonatomic , assign)LoadingType animType;
/**
 *  圈的颜色
 */
@property (nonatomic, strong, null_resettable) UIColor *lineColor;
/**
 *  圈的线条宽度
 */
@property (nonatomic) CGFloat lineWidth;
/**
 *  是否隐藏
 */
@property (nonatomic) BOOL hidesWhenStopped;
/**
 * 转动时间
 */
@property (nonatomic, readwrite) NSTimeInterval duration;
/**
 *  是否需要动画
 */
@property (nonatomic, assign, readonly, getter=isAnimating) BOOL animating;
/**
 *  开始加载
 */
- (void)startAnimating;
/**
 *  结束加载
 */
- (void)stopAnimating;

@end

NS_ASSUME_NONNULL_END
