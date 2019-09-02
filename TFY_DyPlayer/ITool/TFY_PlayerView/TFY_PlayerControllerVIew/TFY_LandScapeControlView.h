//
//  TFY_LandScapeControlView.h
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/7/2.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFY_PlayerController.h"
#import "TFY_SliderView.h"
#import "TFY_PlayerTopBar.h"
#import "TFY_bottomToolView.h"
#import "TFY_PhotocroppingView.h"
NS_ASSUME_NONNULL_BEGIN

@interface TFY_LandScapeControlView : UIView
/**
 *  头部工具
 */
@property (nonatomic, strong, readonly) TFY_PlayerTopBar *toptoolView;
/**
 * 底部工具栏 |
 */
@property (nonatomic, strong, readonly) TFY_bottomToolView *bottomToolView;
/**
 *  拍照裁剪工具
 */
@property (nonatomic, strong, readonly) TFY_PhotocroppingView *photocroppiingView;
/**
 * 播放或暂停按钮 | 锁定屏幕按钮
 */
@property (nonatomic, strong, readonly) UIButton *lockBtn;
/**
 * 播放器
 */
@property (nonatomic, weak) TFY_PlayerController *player;
/**
 * slider滑动中
 */
@property (nonatomic, copy, nullable) void(^sliderValueChanging)(CGFloat value,BOOL forward);
/**
 *  slider滑动结束
 */
@property (nonatomic, copy, nullable) void(^sliderValueChanged)(CGFloat value);
/**
 *  小窗户选集点击
 */
@property (nonatomic, copy, nullable) void(^didSelectItemblock)(NSInteger index);
/**
 *  下一集
 */
@property (nonatomic, copy, nullable) void(^nextpalyerblock)(void);
/**
 * 如果是暂停状态，seek完是否播放，默认YES
 */
@property (nonatomic, assign) BOOL seekToPlay;
/**
 *  告诉按钮状态
 */
@property(nonatomic , assign)BOOL rightbool;
/**
 * 重置控制层
 */
- (void)resetControlView;
/**
 * 显示控制层
 */
- (void)showControlView;
/**
 *  隐藏控制层
 */
- (void)hideControlView;
/**
 *  设置播放时间
 */
- (void)videoPlayer:(TFY_PlayerController *)videoPlayer currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime;
/**
 * 设置缓冲时间
 */
- (void)videoPlayer:(TFY_PlayerController *)videoPlayer bufferTime:(NSTimeInterval)bufferTime;
/**
 * 是否响应该手势
 */
- (BOOL)shouldResponseGestureWithPoint:(CGPoint)point withGestureType:(PlayerGestureType)type touch:(nonnull UITouch *)touch;
/**
 * 视频尺寸改变
 */
- (void)videoPlayer:(TFY_PlayerController *)videoPlayer presentationSizeChanged:(CGSize)size;
/**
 *  标题和全屏模式
 */
- (void)showTitle:(NSString *_Nullable)title fullScreenMode:(FullScreenMode)fullScreenMode;
/**
 * 播放按钮状态
 */
- (void)playBtnSelectedState:(BOOL)selected;
/**
 *  调节播放进度slider和当前时间更新
 */
- (void)sliderValueChanged:(CGFloat)value currentTimeString:(NSTimeInterval)timeString;
/**
 *  滑杆结束滑动
 */
- (void)sliderChangeEnded;
/**
 *  播放暂停返回
 */
-(void)controlBarSetPlayerPlay:(BOOL)play;
/**
 *  多视频播放总个数
 */
@property (nonatomic, assign) NSInteger videoCount;
/**
 *  当前播放的索引，仅限于一维数组。
 */
@property (nonatomic) NSInteger currentPlayIndex;
/**
 *  判断是不是全屏
 */
-(void)fullScreenMode:(BOOL)fullScreenMode VideoCount:(NSInteger)count;

@end

NS_ASSUME_NONNULL_END
