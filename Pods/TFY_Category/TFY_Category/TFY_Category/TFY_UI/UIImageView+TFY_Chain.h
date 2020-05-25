//
//  UIImageView+TFY_Chain.h
//  TFY_Category
//
//  Created by 田风有 on 2019/6/6.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^DownLoadDataCallBack)(NSData * __nullable data, NSError * __nullable error);
typedef void (^DownloadProgressBlock)(unsigned long long total, unsigned long long current);

@interface ImageDownloader : NSObject<NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURLSession * __nullable session;
@property (nonatomic, strong) NSURLSessionDownloadTask * __nullable task;

@property (nonatomic, assign) unsigned long long totalLength;
@property (nonatomic, assign) unsigned long long currentLength;

@property (nonatomic, copy) DownloadProgressBlock __nullable progressBlock;
@property (nonatomic, copy) DownLoadDataCallBack __nullable callbackOnFinished;

- (void)tfy_startDownloadImageWithUrl:(NSString *__nullable)url progress:(DownloadProgressBlock __nullable)progress finished:(DownLoadDataCallBack __nullable)finished;

@end

static inline UIImageView * _Nonnull tfy_imageView(void){
    return [[UIImageView alloc] init];
}
static inline UIImageView * _Nonnull tfy_imageframe(CGRect rect){
    return [[UIImageView alloc] initWithFrame:rect];
}

typedef void (^ImageBlock)(UIImage *__nullable image);

@interface UIImageView (TFY_Chain)
/**
 *  图片赋值字符串
 */
@property(nonatomic,copy,readonly)UIImageView *_Nonnull(^_Nonnull tfy_imge)(NSString *_Nonnull);
/**
 *  图片添加圆角
 */
@property(nonatomic,copy,readonly)UIImageView *_Nonnull(^_Nonnull tfy_cornerRadius)(CGFloat);
/**
 *  添加四边框和color 颜色  borderWidth 宽度
 */
@property(nonatomic,copy,readonly)UIImageView *_Nonnull(^_Nonnull tfy_borders)(CGFloat,NSString *);
/**
 *  添加四边 color_str阴影颜色  shadowRadius阴影半径
 */
@property(nonatomic,copy,readonly)UIImageView *_Nonnull(^_Nonnull tfy_bordersShadow)(NSString *_Nonnull, CGFloat);
/**
 *  图片HexString 背景颜色 alpha 背景透明度
 */
@property(nonatomic,copy,readonly)UIImageView *_Nonnull(^_Nonnull tfy_backgroundColor)(NSString *_Nonnull,CGFloat);
/**
 *  透明度
 */
@property(nonatomic,copy,readonly)UIImageView *_Nonnull(^_Nonnull tfy_alpha)(CGFloat);
/**
 *  交互
 */
@property(nonatomic,copy,readonly)UIImageView *_Nonnull(^_Nonnull tfy_userInteractionEnabled)(BOOL);

/**
 *  图片 点击方法
 */
@property(nonatomic,copy,readonly)UIImageView *_Nonnull(^_Nonnull tfy_action)(id, SEL);
/**
 *  下载完图像后获取/设置回调块。来自网络或磁盘的图像对象。
 */
@property(nonatomic,copy)ImageBlock tfy_completion;
/**
 *  图片下载器
 */
@property(nonatomic,strong)ImageDownloader *tfy_imageDownloader;
/**
 *  指定下载图像的URL失败，重试次数，默认为2
 */
@property(nonatomic,assign)NSUInteger tfy_attemptToReloadTimesForFailedURL;
/**
 * 将自动下载到UIImageView图像大小的剪切。默认值为NO。如果设置为YES，则仅在切割图像后成功存储后才下载
 */
@property(nonatomic,assign)BOOL tfy_shouldAutoClipImageToViewSize;
/**
 *  使用`url`和占位符设置imageView`image`。下载是异步和缓存的。
 */
- (void)tfy_setImageWithURLString:(NSString *__nullable)url placeholderImageName:(NSString *__nullable)placeholderImageName;
/**
 *  使用`url`和占位符设置imageView`image`。下载是异步和缓存的。
 */
- (void)tfy_setImageWithURLString:(NSString *__nullable)url placeholder:(UIImage *__nullable)placeholderImage;
/**
 * placeholderImage最初要设置的图像，直到图像请求完成。
 * completion操作完成时调用的块。该块没有返回值
 * UIImage作为第一个参数。如果出现错误，图像参数
 * 为nil，第二个参数可能包含NSError。第三个参数是布尔值
 * 指示图像是从本地缓存还是从网络检索的。
 * 第四个参数是原始图像网址。
 */
- (void)tfy_setImageWithURLString:(NSString *__nullable)url placeholder:(UIImage *__nullable)placeholderImage completion:(void (^)(UIImage *image))completion;
/**
 * placeholderImageName最初要设置的图像名称，直到图像请求完成。
 * completion操作完成时调用的块。该块没有返回值
 * 并将请求的UIImage作为第一个参数。如果出现错误，图像参数
 * 为nil，第二个参数可能包含NSError。第三个参数是布尔值
 * 指示图像是从本地缓存还是从网络检索的。
 * 第四个参数是原始图像网址。
 */
- (void)tfy_setImageWithURLString:(NSString *_Nonnull)url placeholderImageName:(NSString *_Nonnull)placeholderImageName completion:(void (^)(UIImage *_Nonnull image))completion;
/**
 *  为UIImageView加入一个设置gif图内容的方法：
 */
-(void)tfy_setImage:(NSURL *_Nonnull)imageUrl;
@end

NS_ASSUME_NONNULL_END
