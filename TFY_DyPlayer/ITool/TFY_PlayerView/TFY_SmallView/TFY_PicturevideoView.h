//
//  TFY_PicturevideoView.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/22.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PicturevideoStatus) {
    TFY_PictureStatus,
    TFY_VideoStatus,
};

NS_ASSUME_NONNULL_BEGIN

@interface TFY_PicturevideoView : UIView
/**
 *  截取图片
 */
@property(nonatomic , strong)UIImage *thumeimage;
/**
 *  类型状态
 */
@property(nonatomic , assign)PicturevideoStatus status;
/**
 *  视频图片组
 */
@property(nonatomic , strong)NSArray *thumeiImages;
/**
 *  关闭视图
 */
@property (nonatomic, copy) void(^picturevideoback)(void);
/**
 *  分享回调 index 1 微信 2 QQ 3 新浪 4 空间 5朋友圈  6 保存相册
 */
@property (nonatomic , copy) void(^Sharblock)(NSInteger index);
@end

NS_ASSUME_NONNULL_END
