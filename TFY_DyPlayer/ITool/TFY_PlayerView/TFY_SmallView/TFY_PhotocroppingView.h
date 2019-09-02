//
//  TFY_PhotocroppingView.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/19.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFY_PhotocroppingView : UIView
@property(nonatomic , strong)UIView *back_View;
/**
 *  裁剪一段视频
 */
@property (nonatomic, copy) void(^croppingBlock)(void);
/**
 *  截取视频图片到相册
 */
@property (nonatomic, copy) void(^PhotoBlock)(void);
@end

NS_ASSUME_NONNULL_END
