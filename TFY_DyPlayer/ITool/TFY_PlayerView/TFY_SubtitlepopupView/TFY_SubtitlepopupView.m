//
//  TFY_SubtitlepopupView.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/23.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_SubtitlepopupView.h"

@interface TFY_SubtitlepopupView ()
//维护图片的数组
@property (nonatomic, strong) NSMutableArray *danmuArray;
//移除图片数据
@property (nonatomic, strong) NSMutableArray *deleteArray;

//定时器
@property (nonatomic, strong) CADisplayLink  *link;
@end

@implementation TFY_SubtitlepopupView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self dataSouce];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self dataSouce];
    }
    return self;
}

-(void)dataSouce{
    self.danmuArray  = [NSMutableArray array];
    self.deleteArray = [NSMutableArray array];
    
    //定时器
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeX)];
    //加入RunLoop循环,开启定时器
    [self.link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

/**
 * 根据模型构建一个弹幕
 */
- (TFY_DanMuImage *)imageWithDanMuModel:(TFY_SubtitlepopupModel *)danMuModel{
    //绘制文字得大小
    UIFont *fontSize = [UIFont systemFontOfSize:13 weight:10];
    
    //内容画布的大小
    CGFloat contentH = 30;
    CGFloat contentW = 200;
    
    //设置间距
    CGFloat margin   = 20;
    
    //头像的大小
    CGFloat iconH_W = contentH;
    
    //计算用户名实际的长度
    CGSize nameSize = [self boundingRectWithString:danMuModel.username];
    
    //计算文本内容的实际宽度
    CGSize textSize = [self boundingRectWithString:danMuModel.text];
    
    //重置画布的实际宽度(间隙 + 头像的宽度 + 内容的宽度 + 表情的个数✖️宽度)
    contentW = margin * 4 + iconH_W + nameSize.width + textSize.width + danMuModel.enmotios.count * iconH_W;
    
    //获取位图的上下尺寸
    CGSize contentSize = CGSizeMake(contentW, contentH);
    
    //开启一个画布
    UIGraphicsBeginImageContextWithOptions(contentSize, NO, 0.0);
    
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //将上下文保存到栈中
    CGContextSaveGState(context);
    
    //头像的区域
    CGRect iconFrame = CGRectMake(0, 0, iconH_W, iconH_W);
    
    //绘制头像的画布
    CGContextAddEllipseInRect(context, iconFrame);
    
    //超出范围才减掉
    CGContextClip(context);
    
    //绘制头像
    UIImage *img = danMuModel.type ? danMuModel.userimage : danMuModel.otherimage;
    
    [img drawInRect:iconFrame];
    
    //将上下文出栈替换当前的上下文
    CGContextRestoreGState(context);
    
    //绘制背景图片
    CGFloat bgY = 0;
    CGFloat bgX = iconH_W * 0.5 + margin;
    
    CGFloat bgH = contentH;
    CGFloat bgW = contentW - bgX;
    
    //填充颜色
    danMuModel.type == YES ? [danMuModel.usercolor set] : [danMuModel.othercolor set];
    
    //绘制
    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(bgX, bgY, bgW, bgH) cornerRadius:20] fill];
    
    //绘制昵称
    CGFloat nameX = bgX + margin;
    CGFloat nameY = (contentH - nameSize.height) * 0.5;
    
    [danMuModel.username drawAtPoint:CGPointMake(nameX, nameY)
                      withAttributes:@{NSFontAttributeName:fontSize}];
    
    //绘制内容
    CGFloat textX = nameX + margin + nameSize.width;
    CGFloat textY = nameY;
    
    [danMuModel.text drawAtPoint:CGPointMake(textX, textY)
                  withAttributes:@{NSFontAttributeName:fontSize}];
    
    //绘制表情
    __block CGFloat emotionX = textX + textSize.width;
    CGFloat emotionY = (contentH - iconH_W) * 0.5;
    
    [danMuModel.enmotios enumerateObjectsUsingBlock:^(NSString *  _Nonnull emotionsName, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //加载图片
        UIImage *emotion = [UIImage imageNamed:emotionsName];
        //绘制表情
        [emotion drawInRect:CGRectMake(emotionX, emotionY, iconH_W, iconH_W)];
        //修改表情的x值
        emotionX += iconH_W;
    }];
    
    //从位图上获取绘制好的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    //返回计算好的图片
    return [[TFY_DanMuImage alloc] initWithCGImage:image.CGImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
}
/**
 *  添加弹幕
 */
- (void)addDanMuImage:(TFY_DanMuImage *)image{
    
    [self.danmuArray addObject:image];
    
    [self setNeedsDisplay];
}

#pragma mark - 改变坐标
- (void)changeX {
    [self setNeedsDisplay];
}

//MARK:重绘进行位置偏移
- (void)drawRect:(CGRect)rect {
    
    for (TFY_DanMuImage *image in _danmuArray) {
        
        image.image_x -= 3;
        
        [image drawAtPoint:CGPointMake(image.image_x, image.image_y)];
        
        //将移除屏幕的图片进行删除
        if (image.image_x + image.size.width < 0) {
            
            [self.deleteArray addObject:image];
        }
    }
    //移除
    for (TFY_DanMuImage *img in _deleteArray) {
        
        [self.danmuArray removeObject:img];
    }
    
    [self.deleteArray removeAllObjects];
}

#pragma mark - Private Method

- (CGSize)boundingRectWithString:(NSString *)str {
    
    return [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                             options:NSStringDrawingUsesLineFragmentOrigin
                          attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13
                                                                             weight:10]}
                             context:nil].size;
    
}

@end
