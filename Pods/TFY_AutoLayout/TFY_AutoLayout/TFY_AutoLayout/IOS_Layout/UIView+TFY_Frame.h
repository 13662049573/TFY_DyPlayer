//
//  UIView+TFY_Frame.h
//  TFY_AutoLayoutModelTools
//
//  Created by 田风有 on 2019/4/30.
//  Copyright © 2019 恋机科技. All rights reserved.
//  https://github.com/13662049573/TFY_AutoLayoutModelTools

#import "TFY_AutoLayoutHerder.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFY_CLASS_VIEW (TFY_Frame)
/**
 *  获取屏幕宽度
 */
@property(nonatomic, assign, readonly)CGFloat tfy_swidth;
/**
 *  获取屏幕高度
 */
@property(nonatomic, assign, readonly)CGFloat tfy_sheight;
/**
 *  获取视图层宽度
 */
@property(nonatomic, assign)CGFloat tfy_width;
/**
 *  获取视图层高度
 */
@property(nonatomic, assign)CGFloat tfy_height;
/**
 *  获取视图层x
 */
@property(nonatomic, assign)CGFloat tfy_x;
/**
 *  获取视图层y
 */
@property(nonatomic, assign)CGFloat tfy_y;
/**
 *  获取视图层最大x
 */
@property(nonatomic, assign)CGFloat tfy_maxX;
/**
 *  获取视图层最大y
 */
@property(nonatomic, assign)CGFloat tfy_maxY;
/**
 *  获取视图层中间x
 */
@property(nonatomic, assign)CGFloat tfy_midX;
/**
 *  获取视图层中间y
 */
@property(nonatomic, assign)CGFloat tfy_midY;

#if TARGET_OS_IPHONE || TARGET_OS_TV
/**
 *  获取视图层中心锚点x
 */
@property(nonatomic, assign)CGFloat tfy_cx;
/**
 *  获取视图层中心锚点y
 */
@property(nonatomic, assign)CGFloat tfy_cy;

#endif
/**
 *  获取视图层xy
 */
@property(nonatomic, assign)CGPoint tfy_xy;
/**
 *  获取视图层size
 */
@property(nonatomic, assign)CGSize tfy_se;

@end

NS_ASSUME_NONNULL_END
