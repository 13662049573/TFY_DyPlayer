//
//  UIImage+Image.h
//  PanGesture
//
//  Created by 田风有 on 2017/7/1.
//  Copyright © 2017年 田风有. All rights reserved.
//  https://github.com/13662049573/TFY_AutoLayoutModelTools

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TFY_GradientType) {
    
    TFY_GradientTypeTopToBottom      = 0,//从上到小
    TFY_GradientTypeLeftToRight      = 1,//从左到右
    TFY_GradientTypeUpleftToLowright = 2,//左上到右下
    TFY_GradientTypeUprightToLowleft = 3,//右上到左下
};

@interface UIImage (Image)

/**
 *  获取图片宽
 */
- (CGFloat)tfy_width;

/**
 *  获取图片高
 */
- (CGFloat)tfy_height;

/**
 *  获取启动页图片 启动页图片
 */
+ (UIImage *)tfy_launchImage;

/**
 *  加载非.Bound文件下图片，单张、或2x、3x均适用(若加载非png图片需要拼接后缀名) image 图片名
 */
+ (UIImage *)tfy_loadImage:(NSString *)image;

/**
 *  加载.Bound文件下图片(无子文件夹，若加载非png图片需要拼接后缀名) image 图片名
 */
+ (UIImage *)tfy_bundleImage:(NSString *)image;

/**
 *  加载.Bound文件下子文件夹图片(若加载非png图片需要拼接后缀名) fileName 图片文件夹名  fileImage 图片名
 */
+ (UIImage *)tfy_fileImage:(NSString *)fileImage fileName:(NSString *)fileName;

/**
 *  字符串转图片
 */
+ (UIImage *)tfy_base64StrToUIImage:(NSString *)encodedImageStr;

/**
 * 图片转字符串
 */
+ (NSString *)tfy_imageToBase64Str:(UIImage *)image;

/**
 * 图片上绘制文字
 */
- (UIImage *)tfy_imageAddTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color;

/**
 *  图片切割  image  要切割的图片 imageSize 要切割的图片的大小 切割好的图片
 */
+ (UIImage *)tfy_cutImage:(UIImage*)image andSize:(CGSize)imageSize;

/**
 *  根据url返回一个圆形的头像 iconUrl 头像的URL border  边框的宽度 color   边框的颜色  切割好的头像
 */
+ (UIImage *)tfy_captureCircleImageWithURL:(NSString *)iconUrl andBorderWith:(CGFloat)border andBorderColor:(UIColor *)color;

/**
 *  根据iamge返回一个圆形的头像 iconImage 要切割的头像 border    边框的宽度 color     边框的颜色  切割好的头像
 */
+ (UIImage *)tfy_captureCircleImageWithImage:(UIImage *)iconImage andBorderWith:(CGFloat)border andBorderColor:(UIColor *)color;

/**
 *  生成毛玻璃效果的图片 image      要模糊化的图片  blurAmount 模糊化指数 返回模糊化之后的图片
 */
+ (UIImage *)tfy_blurredImageWithImage:(UIImage *)image andBlurAmount:(CGFloat)blurAmount;

/**
 *  生成一个毛玻璃效果的图片  返回模糊化好的图片
 */
- (UIImage *)tfy_blurredImage:(CGFloat)blurAmount;

/**
 *  生成一个毛玻璃效果的图片 blurLevel 毛玻璃的模糊程度 毛玻璃好的图片
 */
- (UIImage *)tfy_blearImageWithBlurLevel:(CGFloat)blurLevel;

/**
 *  截取相应的view生成一张图片 view 要截的view  生成的图片
 */
+ (UIImage *)tfy_viewShotWithView:(UIView *)view;

/**
 *  截屏 返回截屏的图片
 */
+ (UIImage *)tfy_screenShot;

/**
 *  图片进行压缩 image   要压缩的图片  percent 要压缩的比例(建议在0.3以上)  压缩之后的图片 压缩之后为image/jpeg 格式
 */
+ (UIImage *)tfy_reduceImage:(UIImage *)image percent:(float)percent;

/**
 *  对图片进行压缩  image   要压缩的图片 newSize 压缩后的图片的像素尺寸  压缩好的图片
 */
+ (UIImage *)tfy_imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

/**
 *  对图片进行压缩 image   要压缩的图片 kb 压缩后的图片的内存大小  压缩好的图片
 */
+ (UIImage *)tfy_imageWithImageSimple:(UIImage*)image scaledToKB:(NSInteger)kb;

/**
 *  对图片进行压缩 image   要压缩的图片 maxLength 压缩后的图片的内存大小  压缩好的图片
 */
+ (UIImage *)tfy_compressImage:(UIImage *)image toByte:(NSInteger)maxLength;

/**
 *  根据给定的url计算网络图片的大小
 */
+ (CGSize)tfy_downloadImageSizeWithURL:(id)imageURL;

/**
 *  根据视频url获取第一帧图片
 */
+ (UIImage *)tfy_videoPreViewImage:(NSURL *)path;

/**
 * 根据给定的颜色生成图片
 */
+ (UIImage *)tfy_createImage:(UIColor *)imageColor;

/**
 * 通过渐变色生成图片 colors 渐变颜色数组  gradientType 渐变类型 imageSize 需要的图片尺寸
 */
+ (UIImage *)tfy_imageFromGradientColors:(NSArray *)colors gradientType:(TFY_GradientType)gradientType imageSize:(CGSize)imageSize;

/**
 * 对比两张图片是否相同 image 原图  anotherImage 需要比较的图片
 */
+ (BOOL)tfy_imageEqualToImage:(UIImage*)image anotherImage:(UIImage *)anotherImage;

/**
 *  图片透明度 alpha 透明度 image 原图
 */
+ (UIImage *)tfy_imageByApplyingAlpha:(CGFloat)alpha image:(UIImage*)image;

/**
 * 镶嵌图片 firstImage 图片1 secondImage 图片2  拼接后的图片
 */
+ (UIImage *)tfy_spliceFirstImage:(UIImage *)firstImage secondImage:(UIImage *)secondImage;

/**
 * 生成二维码图片  一个二维码图片，水印在二维码中央 waterImage 水印图片 size 二维码Size  dataDic 二维码中的信息
 */
+ (UIImage *)tfy_qrCodeImageForDataDic:(NSDictionary *)dataDic size:(CGSize)size waterImage:(UIImage *)waterImage;

/**
 *  修改二维码颜色  修改颜色后的二维码图片
 */
+ (UIImage *)tfy_changeColorWithQRCodeImage:(UIImage *)image red:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue;
/**
 * 改变图片颜色
 */
- (UIImage *)tfy_imageWithColor:(UIColor *)color;
/**
 *  图片的拉伸显示
 */
+(UIImage *)tfy_stretchImageWith:(NSString *)imageString;
 /**
  *  编码生产图片
  */
+(UIImage *)tfy_stringToUIImage:(NSString *)string;
/**
 *  将数组图片加入 随机生成一个图片
 */
+(UIImage *)tfy_RandomButtonImage:(NSArray *)changeArray Integer:(NSInteger )index;
/**
 *  更改图片显示大小
 */
+(UIImage *)tfy_imageByScalingToSize:(CGSize)targetSize andSourceImage:(UIImage *)sourceImage;
/**
 * slaveheaderImage  上边视图的图片，生成的图片的宽度为headerImageView的宽度
 * mastermidImage  中间视图的图片，生成的图片的宽度为midView的宽度，拼接在headerImageView的下面
 * masterfootImage  下边视图的图片，生成的图片的宽度为footerImageView的宽度，拼接在midView的下面
 */
+ (UIImage *)tfy_addSlaveHeaderImage:(UIImage *)slaveheaderImage toMasterMidImage:(UIImage *)mastermidImage toMasterFootImage:(UIImage *)masterfootImage;
/**
 *  leftImage:左侧图片 rightImage:右侧图片 margin:两者间隔
 */
+ (UIImage *)tfy_combineWithLeftImg:(UIImage*)leftImage rightImg:(UIImage*)rightImage withMargin:(NSInteger)margin;
/**
 * *masterImage  主图片，生成的图片的宽度为masterImage的宽度
 * slaveImage   从图片，拼接在masterImage的下面
 */
+ (UIImage *)tfy_addSlaveImage:(UIImage *)slaveImage toMasterImage:(UIImage *)masterImage;
@end
