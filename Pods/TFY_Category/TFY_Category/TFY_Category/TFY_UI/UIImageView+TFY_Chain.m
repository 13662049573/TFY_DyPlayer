//
//  UIImageView+TFY_Chain.m
//  TFY_Category
//
//  Created by 田风有 on 2019/6/6.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import "UIImageView+TFY_Chain.h"
#import <objc/runtime.h>
#import <CommonCrypto/CommonDigest.h>

#define WSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@implementation ImageDownloader

- (void)tfy_startDownloadImageWithUrl:(NSString *)url progress:(DownloadProgressBlock)progress finished:(DownLoadDataCallBack)finished {
    self.progressBlock = progress;
    self.callbackOnFinished = finished;
    
    if ([NSURL URLWithString:url] == nil) {
        NSData *data; NSError *error;
        if (finished) {
            finished(data, error);
        }
        return;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                       timeoutInterval:60];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    self.session = [NSURLSession sessionWithConfiguration:config
                                                 delegate:self
                                            delegateQueue:queue];
    NSURLSessionDownloadTask *task = [self.session downloadTaskWithRequest:request];
    [task resume];
    self.task = task;
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSData *data = [NSData dataWithContentsOfURL:location];
    
    if (self.progressBlock) {
        self.progressBlock(self.totalLength, self.currentLength);
    }
    
    if (self.callbackOnFinished) {
        NSError *error;
        self.callbackOnFinished(data, error);
        
        // 防止重复调用
        self.callbackOnFinished =nil;
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    self.currentLength = totalBytesWritten;
    self.totalLength = totalBytesExpectedToWrite;
    
    if (self.progressBlock) {
        self.progressBlock(self.totalLength, self.currentLength);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if ([error code] != NSURLErrorCancelled) {
        if (self.callbackOnFinished) {
            NSData *data;
            self.callbackOnFinished(data, error);
        }
        self.callbackOnFinished = nil;
    }
}

@end


@interface NSString (md5)

+ (NSString *)tfy_cachedFileNameForKey:(NSString *)key;
+ (NSString *)tfy_cachePath;
+ (NSString *)tfy_keyForRequest:(NSURLRequest *)request;

@end

@implementation NSString (md5)

+ (NSString *)tfy_keyForRequest:(NSURLRequest *)request{
    return request.URL.absoluteString;
}

+ (NSString *)tfy_cachePath {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *directoryPath = [NSString stringWithFormat:@"%@/%@/%@",cachePath,@"default",@"com.hackemist.SDWebImageCache.default"];
    return directoryPath;
}

+ (NSString *)tfy_cachedFileNameForKey:(NSString *)key {
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%@",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10],
                          r[11], r[12], r[13], r[14], r[15], [[key pathExtension] isEqualToString:@""] ? @"" : [NSString stringWithFormat:@".%@", [key pathExtension]]];
    
    return filename;
}

@end

@interface UIApplication (CacheImage)

@property (nonatomic, strong, readonly) NSMutableDictionary *tfy_cacheFaileTimes;

- (UIImage *)tfy_cacheImageForRequest:(NSURLRequest *)request;
- (void)tfy_cacheImage:(UIImage *)image forRequest:(NSURLRequest *)request;
- (void)tfy_cacheFailRequest:(NSURLRequest *)request;
- (NSUInteger)tfy_failTimesForRequest:(NSURLRequest *)request;

@end

@implementation UIApplication (CacheImage)

- (NSMutableDictionary *)tfy_cacheFaileTimes {
    NSMutableDictionary *dict = objc_getAssociatedObject(self, _cmd);
    if (!dict) {
        dict = [[NSMutableDictionary alloc] init];
    }
    return dict;
}

- (void)setTfy_cacheFaileTimes:(NSMutableDictionary *)tfy_cacheFaileTimes {
    objc_setAssociatedObject(self, @selector(tfy_cacheFaileTimes), tfy_cacheFaileTimes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)tfy_clearCache {
    [self.tfy_cacheFaileTimes removeAllObjects];
    self.tfy_cacheFaileTimes = nil;
}

- (void)tfy_clearDiskCaches {
    NSString *directoryPath = [NSString tfy_cachePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
        dispatch_queue_t ioQueue = dispatch_queue_create("com.hackemist.SDWebImageCache", DISPATCH_QUEUE_SERIAL);
        dispatch_async(ioQueue, ^{
            NSError *error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:directoryPath error:&error];
            [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:nil];
        });
    }
    [self tfy_clearCache];
}

- (UIImage *)tfy_cacheImageForRequest:(NSURLRequest *)request {
    if (request) {
        NSString *directoryPath = [NSString tfy_cachePath];
        NSString *path = [NSString stringWithFormat:@"%@/%@", directoryPath, [NSString tfy_cachedFileNameForKey:[NSString tfy_keyForRequest:request]]];
        return [UIImage imageWithContentsOfFile:path];
    }
    return nil;
}

- (NSUInteger)tfy_failTimesForRequest:(NSURLRequest *)request {
    NSNumber *faileTimes = [self.tfy_cacheFaileTimes objectForKey:[NSString tfy_cachedFileNameForKey:[NSString tfy_keyForRequest:request]]];
    if (faileTimes && [faileTimes respondsToSelector:@selector(integerValue)]) {
        return faileTimes.integerValue;
    }
    return 0;
}

- (void)tfy_cacheFailRequest:(NSURLRequest *)request {
    NSNumber *faileTimes = [self.tfy_cacheFaileTimes objectForKey:[NSString tfy_cachedFileNameForKey:[NSString tfy_keyForRequest:request]]];
    NSUInteger times = 0;
    if (faileTimes && [faileTimes respondsToSelector:@selector(integerValue)]) {
        times = [faileTimes integerValue];
    }
    
    times++;
    
    [self.tfy_cacheFaileTimes setObject:@(times) forKey:[NSString tfy_cachedFileNameForKey:[NSString tfy_keyForRequest:request]]];
}

- (void)tfy_cacheImage:(UIImage *)image forRequest:(NSURLRequest *)request {
    if (!image || !request) { return; }
    
    NSString *directoryPath = [NSString tfy_cachePath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
        if (error) { return; }
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", directoryPath, [NSString tfy_cachedFileNameForKey:[NSString tfy_keyForRequest:request]]];
    NSData *data = UIImagePNGRepresentation(image);
    if (data) {
        [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
    }
}

@end

@implementation UIImageView (TFY_Chain)


-(UIImageView *(^)(NSString *))tfy_imge{
    WSelf(myself);
    return ^(NSString *str){
        myself.image = [[UIImage imageNamed:str] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [myself setUserInteractionEnabled:YES];
        return myself;
    };
}

-(UIImageView *(^)(CGFloat))tfy_cornerRadius{
    WSelf(myself);
    return ^(CGFloat cornerRadius){
        myself.layer.cornerRadius = cornerRadius;
        myself.layer.masksToBounds = YES;
        return myself;
    };
}

-(UIImageView *(^)(CGFloat, NSString *))tfy_borders{
    WSelf(myself);
    return ^(CGFloat borderWidth, NSString *color){
        myself.layer.borderWidth = borderWidth;
        myself.layer.borderColor = [myself btncolorWithHexString:color alpha:1].CGColor;
        return myself;
    };
}
/**
 *  添加四边 color_str阴影颜色  shadowRadius阴影半径
 */
-(UIImageView *(^)(NSString *, CGFloat))tfy_bordersShadow{
    WSelf(myself);
    return ^(NSString *color_str, CGFloat shadowRadius){
        // 阴影颜色
        myself.layer.shadowColor = [myself btncolorWithHexString:color_str alpha:1].CGColor;
        // 阴影偏移，默认(0, -3)
        myself.layer.shadowOffset = CGSizeMake(0,0);
        // 阴影透明度，默认0
        myself.layer.shadowOpacity = 0.5;
        // 阴影半径，默认3
        myself.layer.shadowRadius = shadowRadius;
        
        return myself;
    };
}

-(UIImageView *(^)(NSString *,CGFloat))tfy_backgroundColor{
    WSelf(myself);
    return ^(NSString *HexString,CGFloat alpha){
        [myself setBackgroundColor:[myself btncolorWithHexString:HexString alpha:alpha]];
        [myself setUserInteractionEnabled:YES];
        return myself;
    };
}

/**
 *  透明度
 */
-(UIImageView *(^)(CGFloat))tfy_alpha{
    WSelf(myself);
    return ^(CGFloat alpha){
        myself.alpha = alpha;
        return myself;
    };
}
/**
 *  交互
 */
-(UIImageView *(^)(BOOL))tfy_userInteractionEnabled{
    WSelf(myself);
    return ^(BOOL userInteractionEnabled){
        myself.userInteractionEnabled = userInteractionEnabled;
        return myself;
    };
}

-(UIImageView *(^)(id, SEL))tfy_action{
    WSelf(myself);
    return ^(id object, SEL action){
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:object action:action];
        [myself addGestureRecognizer:tap];
        [myself setUserInteractionEnabled:YES];
        return myself;
    };
}


-(UIColor *)btncolorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r                       截取的range = (0,2)
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;//     截取的range = (2,2)
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;//     截取的range = (4,2)
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;//将字符串十六进制两位数字转为十进制整数
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

#pragma mark - getter

- (ImageBlock)tfy_completion
{
    return objc_getAssociatedObject(self, _cmd);
}

- (ImageDownloader *)tfy_imageDownloader
{
    return objc_getAssociatedObject(self, _cmd);
}

- (NSUInteger)tfy_attemptToReloadTimesForFailedURL
{
    NSUInteger count = [objc_getAssociatedObject(self, _cmd) integerValue];
    if (count == 0) {  count = 2; }
    return count;
}

- (BOOL)tfy_shouldAutoClipImageToViewSize
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

#pragma mark - setter

-(void)setTfy_completion:(ImageBlock)tfy_completion{
    objc_setAssociatedObject(self, @selector(tfy_completion), tfy_completion, OBJC_ASSOCIATION_COPY_NONATOMIC);
}



- (void)setTfy_imageDownloader:(ImageDownloader *)tfy_imageDownloader
{
    objc_setAssociatedObject(self, @selector(tfy_imageDownloader), tfy_imageDownloader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTfy_attemptToReloadTimesForFailedURL:(NSUInteger)tfy_attemptToReloadTimesForFailedURL
{
    objc_setAssociatedObject(self, @selector(tfy_attemptToReloadTimesForFailedURL), @(tfy_attemptToReloadTimesForFailedURL), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTfy_shouldAutoClipImageToViewSize:(BOOL)tfy_shouldAutoClipImageToViewSize
{
    objc_setAssociatedObject(self, @selector(tfy_shouldAutoClipImageToViewSize), @(tfy_shouldAutoClipImageToViewSize), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - public method

- (void)tfy_setImageWithURLString:(NSString *)url placeholderImageName:(NSString *)placeholderImageName {
    return [self tfy_setImageWithURLString:url placeholderImageName:placeholderImageName completion:^(UIImage * _Nonnull image) {}];
}

- (void)tfy_setImageWithURLString:(NSString *)url placeholder:(UIImage *)placeholderImage {
    return [self tfy_setImageWithURLString:url placeholder:placeholderImage completion:^(UIImage * _Nonnull image) {}];
}

- (void)tfy_setImageWithURLString:(NSString *)url placeholderImageName:(NSString *)placeholderImage completion:(void (^)(UIImage *image))completion {
    NSString *path = [[NSBundle mainBundle] pathForResource:placeholderImage ofType:nil];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    if (image == nil) { image = [UIImage imageNamed:placeholderImage]; }
    
    [self tfy_setImageWithURLString:url placeholder:image completion:completion];
}

//解析gif文件数据的方法 block中会将解析的数据传递出来
-(void)getGifImageWithUrk:(NSURL *)url returnData:(void(^)(NSArray<UIImage *> * imageArray, NSArray<NSNumber *>*timeArray,CGFloat totalTime, NSArray<NSNumber *>* widths,NSArray<NSNumber *>* heights))dataBlock{
    //通过文件的url来将gif文件读取为图片数据引用
    CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    //获取gif文件里图片的个数
    size_t count = CGImageSourceGetCount(source);
    //定义一个变量记录gif播放一轮的时间
    float allTime=0;
    //存放全部图片
    NSMutableArray * imageArray = [[NSMutableArray alloc]init];
    //存放每一帧播放的时间
    NSMutableArray * timeArray = [[NSMutableArray alloc]init];
    //存放每张图片的宽度 （一般在一个gif文件里，全部图片尺寸都会一样）
    NSMutableArray * widthArray = [[NSMutableArray alloc]init];
    //存放每张图片的高度
    NSMutableArray * heightArray = [[NSMutableArray alloc]init];
    //遍历
    for (size_t i=0; i<count; i++) {
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
        [imageArray addObject:(__bridge UIImage *)(image)];
        CGImageRelease(image);
        //获取图片信息
        NSDictionary * info = (__bridge NSDictionary*)CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
        CGFloat width = [[info objectForKey:(__bridge NSString *)kCGImagePropertyPixelWidth] floatValue];
        CGFloat height = [[info objectForKey:(__bridge NSString *)kCGImagePropertyPixelHeight] floatValue];
        [widthArray addObject:[NSNumber numberWithFloat:width]];
        [heightArray addObject:[NSNumber numberWithFloat:height]];
        NSDictionary * timeDic = [info objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
        CGFloat time = [[timeDic objectForKey:(__bridge NSString *)kCGImagePropertyGIFDelayTime]floatValue];
        allTime+=time;
        [timeArray addObject:[NSNumber numberWithFloat:time]];
    }
    dataBlock(imageArray,timeArray,allTime,widthArray,heightArray);
}

//为UIImageView加入一个设置gif图内容的方法：
-(void)tfy_setImage:(NSURL *)imageUrl{
    __weak id __self = self;
    [self getGifImageWithUrk:imageUrl returnData:^(NSArray<UIImage *> *imageArray, NSArray<NSNumber *> *timeArray, CGFloat totalTime, NSArray<NSNumber *> *widths, NSArray<NSNumber *> *heights) {
        //加入帧动画
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
        NSMutableArray * times = [[NSMutableArray alloc]init];
        float currentTime = 0;
        //设置每一帧的时间占比
        for (int i=0; i<imageArray.count; i++) {
            [times addObject:[NSNumber numberWithFloat:currentTime/totalTime]];
            currentTime+=[timeArray[i] floatValue];
        }
        [animation setKeyTimes:times];
        [animation setValues:imageArray];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        //设置循环
        animation.repeatCount= MAXFLOAT;
        //设置播放总时长
        animation.duration = totalTime;
        //Layer层加入
        [[(UIImageView *)__self layer]addAnimation:animation forKey:@"gifAnimation"];
    }];
}

- (void)tfy_setImageWithURLString:(NSString *)url placeholder:(UIImage *)placeholderImageName completion:(void (^)(UIImage *image))completion {
    [self.layer removeAllAnimations];
    self.tfy_completion = completion;
    
    if (url == nil || [url isKindOfClass:[NSNull class]] || (![url hasPrefix:@"http://"] && ![url hasPrefix:@"https://"])) {
        [self setImage:placeholderImageName isFromCache:YES];
        
        if (completion) {
            self.tfy_completion(self.image);
        }
        return;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self downloadWithReqeust:request holder:placeholderImageName];
}

#pragma mark - private method

- (void)downloadWithReqeust:(NSURLRequest *)theRequest holder:(UIImage *)holder {
    UIImage *cachedImage = [[UIApplication sharedApplication] tfy_cacheImageForRequest:theRequest];
    
    if (cachedImage) {
        [self setImage:cachedImage isFromCache:YES];
        if (self.tfy_completion) {
            self.tfy_completion(cachedImage);
        }
        return;
    }
    
    [self setImage:holder isFromCache:YES];
    
    if ([[UIApplication sharedApplication] tfy_failTimesForRequest:theRequest] >= self.tfy_attemptToReloadTimesForFailedURL) {
        return;
    }
    
    [self cancelRequest];
    self.tfy_imageDownloader = [ImageDownloader new];
    
    WSelf(myslef);
    
    self.tfy_imageDownloader = [[ImageDownloader alloc] init];
    [self.tfy_imageDownloader tfy_startDownloadImageWithUrl:theRequest.URL.absoluteString progress:nil finished:^(NSData *data, NSError *error) {
        // success
        if (data != nil && error == nil) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                UIImage *image = [UIImage imageWithData:data];
                UIImage *finalImage = image;
                
                if (image) {
                    if (myslef.tfy_shouldAutoClipImageToViewSize) {
                        // cutting
                        if (fabs(myslef.frame.size.width - image.size.width) != 0
                            && fabs(myslef.frame.size.height - image.size.height) != 0) {
                            finalImage = [self clipImage:image toSize:myslef.frame.size isScaleToMax:YES];
                        }
                    }
                    
                    [[UIApplication sharedApplication] tfy_cacheImage:finalImage forRequest:theRequest];
                } else {
                    [[UIApplication sharedApplication] tfy_cacheFailRequest:theRequest];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (finalImage) {
                        [myslef setImage:finalImage isFromCache:NO];
                        
                        if (myslef.tfy_completion) {
                            myslef.tfy_completion(myslef.image);
                        }
                    } else {// error data
                        if (myslef.tfy_completion) {
                            myslef.tfy_completion(myslef.image);
                        }
                    }
                });
            });
        } else { // error
            [[UIApplication sharedApplication] tfy_cacheFailRequest:theRequest];
            
            if (myslef.tfy_completion) {
                myslef.tfy_completion(myslef.image);
            }
        }
    }];
}

- (void)setImage:(UIImage *)image isFromCache:(BOOL)isFromCache {
    self.image = image;
    if (!isFromCache) {
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.6f];
        [animation setType:kCATransitionFade];
        animation.removedOnCompletion = YES;
        [self.layer addAnimation:animation forKey:@"transition"];
    }
}

- (void)cancelRequest {
    [self.tfy_imageDownloader.task cancel];
}

- (UIImage *)clipImage:(UIImage *)image toSize:(CGSize)size isScaleToMax:(BOOL)isScaleToMax {
    CGFloat scale =  [UIScreen mainScreen].scale;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    
    CGSize aspectFitSize = CGSizeZero;
    if (image.size.width != 0 && image.size.height != 0) {
        CGFloat rateWidth = size.width / image.size.width;
        CGFloat rateHeight = size.height / image.size.height;
        
        CGFloat rate = isScaleToMax ? MAX(rateHeight, rateWidth) : MIN(rateHeight, rateWidth);
        aspectFitSize = CGSizeMake(image.size.width * rate, image.size.height * rate);
    }
    
    [image drawInRect:CGRectMake(0, 0, aspectFitSize.width, aspectFitSize.height)];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finalImage;
}

@end
