//
//  TFY_fastView.h
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/7/3.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, fastState) {
    Progress_loading, //加载菊花
    Progress_fast,  //快进快退
    Progress_fail //加载失败
};

NS_ASSUME_NONNULL_BEGIN

@interface TFY_fastView : UIView
/**
 *  显示状态
 */
@property(nonatomic , assign)fastState fasttype;
/**
 *  快进视图是否显示动画，默认NO.
 */
@property(nonatomic, assign) BOOL fastViewAnimated;
/**
 *  滑动时间
 */
@property(nonatomic , assign)CGFloat value;
/**
 * 重复加载
 */
@property(nonatomic, copy, nullable) void(^failblack)(void);
/**
 *  错误显示文字
 */
@property(nonatomic , copy)NSString *faill_string;
/**
 *  开始菊花带网速监听
 */
- (void)startAnimating;
/**
 *  结束菊花带网速监听
 */
- (void)stopAnimating;
/**
 * 快递滑动时间  视频总时间  快递 YES 快退 NO
 */
-(void)draggedTime:(CGFloat)draggedTime totalTime:(CGFloat)totalTime IsForward:(BOOL)isForward;
@end

NS_ASSUME_NONNULL_END
