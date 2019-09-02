//
//  TFY_bottomToolView.h
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/7/2.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFY_SliderView.h"
#import "TFY_OrientationObserver.h"

NS_ASSUME_NONNULL_BEGIN

@protocol bottomToolDelegate <NSObject>

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
 *  滑块滑动结束
 */
- (void)sliderTouchEnded:(float)value;
/**
 *  滑杆点击
 */
- (void)sliderTapped:(float)value;
/**
 *  播放暂停返回
 */
-(void)controlBarSetPlayerPlay:(BOOL)play;
/**
 *  屏幕全屏
 */
-(void)controlBarSetPlayerFullScreen:(BOOL)fullScreen;
/**
 * 选集
 */
-(void)selectionplayer:(BOOL)selection;
/**
 * 下一集
 */
-(void)nextbtnplayer;
/**
 *  倍速点击回调
 */
-(void)doublespeed_btnClick:(BOOL)speed;
/**
 *  弹幕输入点击输回调
 */
-(void)barrage_inputboxClick;

@end


@interface TFY_bottomToolView : UIView
@property (nonatomic, weak) id<bottomToolDelegate> delegate;
/**
 *  播放或暂停按钮
 */
@property (nonatomic, assign) BOOL selected;
/**
 *  告诉按钮状态
 */
@property(nonatomic , assign)BOOL rightbool;
@property (nonatomic, strong) UIButton *speed_btn;
/**
 *  播放的当前时间
 */
@property (nonatomic, assign) NSTimeInterval currentTime;
/**
 *  滑杆
 */
@property (nonatomic, strong, readonly) TFY_SliderView *slider;
/**
 *  视频总时间
 */
@property (nonatomic, assign) NSTimeInterval totalTime;
/**
 *  slider滑动中
 */
@property (nonatomic, copy, nullable) void(^sliderValueChanging)(CGFloat value,BOOL forward);
/**
 *  slider滑动结束
 */
@property (nonatomic, copy, nullable) void(^sliderValueChanged)(CGFloat value);
/**
 *  判断是不是全屏
 */
-(void)fullScreenMode:(BOOL)fullScreenMode VideoCount:(NSInteger)count;
/**
 *  字符开始是否  默认YES
 */
-(BOOL)barragebool;
@end

NS_ASSUME_NONNULL_END
