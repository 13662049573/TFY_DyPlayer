//
//  TFY_SliderView.h
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/7/2.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (SliderFrame)

@property (nonatomic) CGFloat tfy_x;
@property (nonatomic) CGFloat tfy_y;
@property (nonatomic) CGFloat tfy_width;
@property (nonatomic) CGFloat tfy_height;

@property (nonatomic) CGFloat tfy_top;
@property (nonatomic) CGFloat tfy_bottom;
@property (nonatomic) CGFloat tfy_left;
@property (nonatomic) CGFloat tfy_right;

@property (nonatomic) CGFloat tfy_centerX;
@property (nonatomic) CGFloat tfy_centerY;

@property (nonatomic) CGPoint tfy_origin;
@property (nonatomic) CGSize  tfy_size_size;

@end

@protocol SliderViewDelegate <NSObject>

@optional
/**
 *  滑块滑动开始
 */
- (void)sliderTouchBegan:(float)value;
/**
 *  滑块滑动中
 */
- (void)sliderValueChanged:(float)value;
/**
 * 滑块滑动结束
 */
- (void)sliderTouchEnded:(float)value;
/**
 *  滑杆点击
 */
- (void)sliderTapped:(float)value;

@end

@interface SliderButton : UIButton

@end

@interface TFY_SliderView : UIView
/**
 * 滑块
 */
@property (nonatomic, strong, readonly) SliderButton *sliderBtn;
/**
 *  滑块代理
 */
@property(nonatomic , weak) id<SliderViewDelegate> delegate;
/**
 *  默认滑杆的颜色 | 滑杆进度颜色 | 缓存进度颜色 | loading进度颜色
 */
@property(nonatomic , strong)UIColor *maximumTrackTintColor,*minimumTrackTintColor,*bufferTrackTintColor,*loadingTintColor;
/**
 *  默认滑杆的图片 | 滑杆进度的图片 | 缓存进度的图片
 */
@property(nonatomic , strong)UIImage *maximumTrackImage,*minimumTrackImage,*bufferTrackImage;
/**
 *  滑杆进度 | 缓存进度
 */
@property(nonatomic , assign)float value,bufferValue;
/**
 *  是否允许点击，默认是YES |  是否允许点击，默认是YES | 是否隐藏滑块（默认为NO）| 是否正在拖动 | 向前还是向后拖动
 */
@property(nonatomic , assign)BOOL allowTapped,animate,isHideSliderBlock,isdragging,isForward;
/**
 *  设置滑杆的高度
 */
@property(nonatomic , assign)CGFloat sliderHeight;
/**
 * 大小
 */
@property(nonatomic , assign)CGSize thumbSize;
/**
 *  启动微调器的动画。
 */
- (void)startAnimating;
/**
 *  停止微调器的动画。
 */
- (void)stopAnimating;
/**
 * 设置滑块背景色
 */
- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state;
/**
 *  设置滑块图片
 */
- (void)setThumbImage:(UIImage *)image forState:(UIControlState)state;

@end

NS_ASSUME_NONNULL_END
