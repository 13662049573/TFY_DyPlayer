//
//  TFY_ClipViewController.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/18.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TFY_ClipViewController;

typedef enum{
    CIRCULARCLIP   = 0,   //圆形裁剪
    SQUARECLIP            //方形裁剪
    
}ClipType;


@protocol ClipViewControllerDelegate <NSObject>
//数据传输代理
-(void)ClipViewController:(TFY_ClipViewController *)clipViewController FinishClipImage:(UIImage *)editImage WithName:(NSString *)imageName;
//拍照时取消代理
-(void)RetirementController:(TFY_ClipViewController *)clipViewController;
@end

@interface TFY_ClipViewController : UIViewController<UIGestureRecognizerDelegate>
@property (nonatomic, assign)CGFloat scaleRation;//图片缩放的最大倍数
@property (nonatomic, assign)CGFloat radius; //圆形裁剪框的半径
@property (nonatomic, assign)ClipType clipType;  //裁剪的形状
@property (nonatomic, strong)id<ClipViewControllerDelegate>delegate;

-(instancetype)initWithImage:(UIImage *)image WithName:(NSString *)imageName;
@end

NS_ASSUME_NONNULL_END
