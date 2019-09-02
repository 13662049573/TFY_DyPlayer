//
//  TFY_AVPlayerManager.m
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/6/30.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_AVPlayerManager.h"
#import <UIKit/UIKit.h>

#import "TFY_PlayerToolsHeader.h"
#import "TFY_ReachabilityManager.h"
#import "TFY_PlayerBaseView.h"
#import "TFY_KVOController.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

/*!
 *  刷新AVPlayer定时观察的间隔
 */
static NSString *const kStatus                   = @"status";
static NSString *const kLoadedTimeRanges         = @"loadedTimeRanges";
static NSString *const kPlaybackBufferEmpty      = @"playbackBufferEmpty";
static NSString *const kPlaybackLikelyToKeepUp   = @"playbackLikelyToKeepUp";
static NSString *const kPresentationSize         = @"presentationSize";

@interface TFY_PlayerPresentView : TFY_PlayerBaseView

@property (nonatomic, strong) AVPlayer *player;
/// 默认为AVLayerVideoGravityResizeAspect。
@property (nonatomic, strong) AVLayerVideoGravity videoGravity;

@end

@implementation TFY_PlayerPresentView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayerLayer *)avLayer {
    return (AVPlayerLayer *)self.layer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)setPlayer:(AVPlayer *)player {
    if (player == _player) return;
    self.avLayer.player = player;
}

- (void)setVideoGravity:(AVLayerVideoGravity)videoGravity {
    if (videoGravity == self.videoGravity) return;
    [self avLayer].videoGravity = videoGravity;
}

- (AVLayerVideoGravity)videoGravity {
    return [self avLayer].videoGravity;
}

@end


@interface TFY_AVPlayerManager ()
{
    id _timeObserver;
    id _itemEndObserver;
    TFY_KVOController *_playerItemKVO;
}
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayerItemVideoOutput * playerOutput;
@property (nonatomic, assign) BOOL isBuffering;
@property (nonatomic, assign) BOOL isReadyToPlay;
//视频截图
@property(nonatomic , strong)NSMutableArray *thumbImages;
@end

@implementation TFY_AVPlayerManager
@synthesize view                           = _view;
@synthesize currentTime                    = _currentTime;
@synthesize totalTime                      = _totalTime;
@synthesize playerPlayTimeChanged          = _playerPlayTimeChanged;
@synthesize playerBufferTimeChanged        = _playerBufferTimeChanged;
@synthesize playerDidToEnd                 = _playerDidToEnd;
@synthesize bufferTime                     = _bufferTime;
@synthesize playState                      = _playState;
@synthesize loadState                      = _loadState;
@synthesize assetURL                       = _assetURL;
@synthesize playerPrepareToPlay            = _playerPrepareToPlay;
@synthesize playerReadyToPlay              = _playerReadyToPlay;
@synthesize playerPlayStateChanged         = _playerPlayStateChanged;
@synthesize playerLoadStateChanged         = _playerLoadStateChanged;
@synthesize seekTime                       = _seekTime;
@synthesize muted                          = _muted;
@synthesize volume                         = _volume;
@synthesize presentationSize               = _presentationSize;
@synthesize isPlaying                      = _isPlaying;
@synthesize rate                           = _rate;
@synthesize isPreparedToPlay               = _isPreparedToPlay;
@synthesize shouldAutoPlay                 = _shouldAutoPlay;
@synthesize scalingMode                    = _scalingMode;
@synthesize playerPlayFailed               = _playerPlayFailed;
@synthesize presentationSizeChanged        = _presentationSizeChanged;


- (instancetype)init {
    self = [super init];
    if (self) {
        _scalingMode = PlayerScalingModeAspectFit;
        _shouldAutoPlay = YES;
    }
    return self;
}

- (void)prepareToPlay {
    if (!_assetURL) return;
    _isPreparedToPlay = YES;
    [self initializePlayer];
    if (self.shouldAutoPlay) {
        [self play];
    }
    self.loadState = PlayerLoadStatePrepare;
    if (self.playerPrepareToPlay) self.playerPrepareToPlay(self, self.assetURL);
}

- (void)reloadPlayer {
    self.seekTime = self.currentTime;
    [self prepareToPlay];
}

- (void)play {
    if (!_isPreparedToPlay) {
        [self prepareToPlay];
    } else {
        [self.player play];
        self.player.rate = self.rate;
        self->_isPlaying = YES;
        self.playState = PlayerPlayStatePlaying;
    }
}

- (void)pause {
    [self.player pause];
    self->_isPlaying = NO;
    self.playState = PlayerPlayStatePaused;
    [_playerItem cancelPendingSeeks];
    [_asset cancelLoading];
}

- (void)stop {
    [_playerItemKVO safelyRemoveAllObservers];
    self.loadState = PlayerLoadStateUnknown;
    if (self.player.rate != 0) [self.player pause];
    [self.player removeTimeObserver:_timeObserver];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    _timeObserver = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:_itemEndObserver name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    _itemEndObserver = nil;
    _isPlaying = NO;
    _player = nil;
    _assetURL = nil;
    _playerItem = nil;
    _isPreparedToPlay = NO;
    self->_currentTime = 0;
    self->_totalTime = 0;
    self->_bufferTime = 0;
    self.isReadyToPlay = NO;
    self.playState = PlayerPlayStatePlayStopped;
}

- (void)replay {
    @weakify(self)
    [self seekToTime:0 completionHandler:^(BOOL finished) {
        @strongify(self)
        [self play];
    }];
}

- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^ __nullable)(BOOL finished))completionHandler {
    if (self.totalTime > 0) {
        CMTime seekTime = CMTimeMake(time, 1);
        [_player seekToTime:seekTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:completionHandler];
    } else {
        self.seekTime = time;
    }
}

// 视频分解
- (void)splitVideofps:(float)fps progressImageBlock:(void (NS_NOESCAPE ^)(CGFloat progress))progressImageBlock splitCompleteBlock:(void (NS_NOESCAPE ^)(BOOL success, NSMutableArray *splitimgs))splitCompleteBlock {
    if (!self.assetURL) {
        return;
    }
    NSMutableArray *splitImages = [NSMutableArray array];
    CMTime cmtime = self.asset.duration; //视频时间信息结构体
    Float64 durationSeconds = CMTimeGetSeconds(cmtime); //视频总秒数
    
    NSMutableArray *times = [NSMutableArray array];
    Float64 totalFrames = durationSeconds / fps; //获得视频总帧数
    CMTime timeFrame;
    for (int i = 1; i <= totalFrames; i++) {
        timeFrame = CMTimeMake(totalFrames, fps); //第i帧  帧率
        if ([self.assetURL hasSuffix:@"m3u8"]) {
            NSValue *timeValue = [NSValue valueWithCMTime:timeFrame];
            [times addObject:timeValue];
            UIImage *frameImg = [self screenshotsm3u8WithCurrentTime:timeFrame playerItemVideoOutput:_playerOutput];
            
            if ([frameImg isKindOfClass:[UIImage class]]) {
                [splitImages addObject:frameImg];
            }
        }
        else{
            NSValue *timeValue = [NSValue valueWithCMTime:timeFrame];
            [times addObject:timeValue];
        }
    }
    
    AVAssetImageGenerator *imgGenerator = [[AVAssetImageGenerator alloc] initWithAsset:_asset];
    //防止时间出现偏差
    imgGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    imgGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    
    NSInteger timesCount = [times count];
    [imgGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
       
        if (progressImageBlock) {
            CGFloat progress = requestedTime.value * 1.0 / timesCount;
            progressImageBlock(progress);
        }
        
        BOOL isSuccess = NO;
        switch (result) {
            case AVAssetImageGeneratorCancelled:
                NSLog(@"Cancelled");
                break;
            case AVAssetImageGeneratorFailed:
                NSLog(@"Failed");
                break;
            case AVAssetImageGeneratorSucceeded: {
                UIImage *frameImg = [UIImage imageWithCGImage:image];
                [splitImages addObject:frameImg];
                
                if (requestedTime.value == timesCount) {
                    isSuccess = YES;
                }
            }
                break;
        }
        if (splitCompleteBlock) {
            splitCompleteBlock(isSuccess,splitImages);
        }
    }];
}

- (UIImage *)thumbnailImageAtCurrentTime {
    UIImage *image;
    if ([self.assetURL hasSuffix:@"m3u8"]) {
        image = [self screenshotsm3u8WithCurrentTime:_playerItem.currentTime playerItemVideoOutput:_playerOutput];
    }
    else{
       image = [self screenshotsMP4WithCurrentTime:_playerItem.currentTime videoUrl:self.assetURL];
    }
    return image;
}

-(UIImage *)screenshotsMP4WithCurrentTime:(CMTime)currentTime videoUrl:(NSString *)url{
    
    AVURLAsset * asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:url] options:nil];
    AVAssetImageGenerator * gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    gen.requestedTimeToleranceAfter = kCMTimeZero;
    gen.requestedTimeToleranceBefore = kCMTimeZero;
    CMTime time = CMTimeMakeWithSeconds(CMTimeGetSeconds(currentTime), 600);
    NSError * error = nil;
    CMTime actualTime;
    CGImageRef imageRef = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage * image = [[UIImage alloc] initWithCGImage:imageRef];
    return image;
}

-(UIImage *)screenshotsm3u8WithCurrentTime:(CMTime)currentTime playerItemVideoOutput:(AVPlayerItemVideoOutput *)output{
    
    CVPixelBufferRef pixelBuffer = [output copyPixelBufferForItemTime:currentTime itemTimeForDisplay:nil];
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext createCGImage:ciImage
                                                   fromRect:CGRectMake(0, 0,
                                                                       CVPixelBufferGetWidth(pixelBuffer),
                                                                       CVPixelBufferGetHeight(pixelBuffer))];
    UIImage *frameImg = [UIImage imageWithCGImage:videoImage];
    CGImageRelease(videoImage);
    CVBufferRelease(pixelBuffer);
    return frameImg;
}

#pragma mark - private method

///计算缓冲区进度
- (NSTimeInterval)availableDuration {
    NSArray *timeRangeArray = _playerItem.loadedTimeRanges;
    CMTime currentTime = [_player currentTime];
    BOOL foundRange = NO;
    CMTimeRange aTimeRange = {0};
    if (timeRangeArray.count) {
        aTimeRange = [[timeRangeArray objectAtIndex:0] CMTimeRangeValue];
        if (CMTimeRangeContainsTime(aTimeRange, currentTime)) {
            foundRange = YES;
        }
    }
    
    if (foundRange) {
        CMTime maxTime = CMTimeRangeGetEnd(aTimeRange);
        NSTimeInterval playableDuration = CMTimeGetSeconds(maxTime);
        if (playableDuration > 0) {
            return playableDuration;
        }
    }
    return 0;
}

- (void)initializePlayer {
    _asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:self.assetURL] options:self.requestHeader];
    _playerItem = [AVPlayerItem playerItemWithAsset:_asset];
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    self.playerOutput = [[AVPlayerItemVideoOutput alloc] init];
    [self.playerItem addOutput:self.playerOutput];
    [self enableAudioTracks:YES inPlayerItem:_playerItem];
    
    TFY_PlayerPresentView *presentView = (TFY_PlayerPresentView *)self.view;
    presentView.player = _player;
    self.scalingMode = _scalingMode;
    if (@available(iOS 9.0, *)) {
        _playerItem.canUseNetworkResourcesForLiveStreamingWhilePaused = NO;
    }
    if (@available(iOS 10.0, *)) {
        _playerItem.preferredForwardBufferDuration = 5;
        _player.automaticallyWaitsToMinimizeStalling = NO;
    }
    [self itemObserving];
}

/// 播放速度切换方法
- (void)enableAudioTracks:(BOOL)enable inPlayerItem:(AVPlayerItem*)playerItem {
    for (AVPlayerItemTrack *track in playerItem.tracks){
        if ([track.assetTrack.mediaType isEqual:AVMediaTypeVideo]) {
            track.enabled = enable;
        }
    }
}

/**
 *  缓冲较差时候回调这里
 */
- (void)bufferingSomeSecond {
    // playbackBufferEmpty会反复进入，因此在bufferingOneSecond延时播放执行完之前再调用bufferingSomeSecond都忽略
    if (self.isBuffering || self.playState == PlayerPlayStatePlayStopped) return;
    /// 没有网络
    if ([TFY_ReachabilityManager sharedManager].networkReachabilityStatus == ReachabilityStatusNotReachable) return;
    self.isBuffering = YES;
    
    // 需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
    [self.player pause];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 如果此时用户已经暂停了，则不再需要开启播放了
        if (!self.isPlaying) {
            self.isBuffering = NO;
            return;
        }
        [self play];
        // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
        self.isBuffering = NO;
        if (!self.playerItem.isPlaybackLikelyToKeepUp) [self bufferingSomeSecond];
    });
}

- (void)itemObserving {
    [_playerItemKVO safelyRemoveAllObservers];
    _playerItemKVO = [[TFY_KVOController alloc] initWithTarget:_playerItem];
    
    [_playerItemKVO safelyAddObserver:self forKeyPath:kStatus options:NSKeyValueObservingOptionNew context:@""];
    
    [_playerItemKVO safelyAddObserver:self forKeyPath:kPlaybackBufferEmpty options:NSKeyValueObservingOptionNew context:@""];
    
    [_playerItemKVO safelyAddObserver:self forKeyPath:kPlaybackLikelyToKeepUp options:NSKeyValueObservingOptionNew context:@""];
    
    [_playerItemKVO safelyAddObserver:self forKeyPath:kLoadedTimeRanges options:NSKeyValueObservingOptionNew context:@""];
    
    [_playerItemKVO safelyAddObserver:self forKeyPath:kPresentationSize options:NSKeyValueObservingOptionNew context:@""];
    
    CMTime interval = CMTimeMakeWithSeconds(self.timeRefreshInterval > 0 ? self.timeRefreshInterval : 0.1, NSEC_PER_SEC);
    TFY_PLAYER_WS(myself);
    _timeObserver = [self.player addPeriodicTimeObserverForInterval:interval queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        if (!myself) return;
        NSArray *loadedRanges = myself.playerItem.seekableTimeRanges;
        /// 大于0才把状态改为可以播放，解决黑屏问题
        if (CMTimeGetSeconds(time) > 0 && !myself.isReadyToPlay) {
            myself.isReadyToPlay = YES;
            myself.loadState = PlayerLoadStatePlaythroughOK;
        }
        if (loadedRanges.count > 0) {
            if (myself.playerPlayTimeChanged) myself.playerPlayTimeChanged(myself, myself.currentTime, myself.totalTime);
        }
    }];
    
    _itemEndObserver = [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        if (!myself) return;
        myself.playState = PlayerPlayStatePlayStopped;
        if (myself.playerDidToEnd) myself.playerDidToEnd(myself);
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([keyPath isEqualToString:kStatus]) {
            if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
                /// 第一次初始化
                if (self.loadState == PlayerLoadStatePrepare) {
                    if (self.playerReadyToPlay) self.playerReadyToPlay(self, self.assetURL);
                }
                if (self.seekTime) {
                    [self seekToTime:self.seekTime completionHandler:nil];
                    self.seekTime = 0;
                }
                if (self.isPlaying) [self play];
                self.player.muted = self.muted;
                NSArray *loadedRanges = self.playerItem.seekableTimeRanges;
                if (loadedRanges.count > 0) {
                    
                    if (self.playerPlayTimeChanged) self.playerPlayTimeChanged(self, self.currentTime, self.totalTime);
                }
            } else if (self.player.currentItem.status == AVPlayerItemStatusFailed) {
                self.playState = PlayerPlayStatePlayFailed;
                NSError *error = self.player.currentItem.error;
                if (self.playerPlayFailed) self.playerPlayFailed(self, error);
            }
        } else if ([keyPath isEqualToString:kPlaybackBufferEmpty]) {
            //当缓冲区为空时
            if (self.playerItem.playbackBufferEmpty) {
                self.loadState = PlayerLoadStateStalled;
                [self bufferingSomeSecond];
            }
        } else if ([keyPath isEqualToString:kPlaybackLikelyToKeepUp]) {
            // 当缓冲区好的时候
            if (self.playerItem.playbackLikelyToKeepUp) {
                self.loadState = PlayerLoadStatePlayable;
                if (self.isPlaying) [self.player play];
            }
        } else if ([keyPath isEqualToString:kLoadedTimeRanges]) {
            NSTimeInterval bufferTime = [self availableDuration];
            self->_bufferTime = bufferTime;
            if (self.playerBufferTimeChanged) self.playerBufferTimeChanged(self, bufferTime);
        } else if ([keyPath isEqualToString:kPresentationSize]) {
            self->_presentationSize = self.playerItem.presentationSize;
            if (self.presentationSizeChanged) {
                self.presentationSizeChanged(self, self->_presentationSize);
            }
        }
        else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    });
}

#pragma mark - getter

- (UIView *)view {
    if (!_view) {
        _view = [[TFY_PlayerPresentView alloc] init];
    }
    return _view;
}

- (float)rate {
    return _rate == 0 ?1:_rate;
}

- (NSTimeInterval)totalTime {
    NSTimeInterval sec = CMTimeGetSeconds(self.player.currentItem.duration);
    if (isnan(sec)) {
        return 0;
    }
    return sec;
}

- (NSTimeInterval)currentTime {
    NSTimeInterval sec = CMTimeGetSeconds(self.playerItem.currentTime);
    if (isnan(sec) || sec < 0) {
        return 0;
    }
    return sec;
}
- (NSMutableArray *)thumbImages{
    
    if (_thumbImages == nil) {
        _thumbImages = [NSMutableArray array];
    }
    return _thumbImages;
}

#pragma mark - setter

- (void)setPlayState:(PlayerPlaybackState)playState {
    _playState = playState;
    if (self.playerPlayStateChanged) self.playerPlayStateChanged(self, playState);
}

- (void)setLoadState:(PlayerLoadState)loadState {
    _loadState = loadState;
    if (self.playerLoadStateChanged) self.playerLoadStateChanged(self, loadState);
}

- (void)setAssetURL:(NSString *)assetURL {
    if (self.player) [self stop];
    _assetURL = assetURL;
    [self prepareToPlay];
}

- (void)setRate:(float)rate {
    _rate = rate;
    if (self.player && fabsf(_player.rate) > 0.00001f) {
        self.player.rate = rate;
    }
}

- (void)setMuted:(BOOL)muted {
    _muted = muted;
    self.player.muted = muted;
}

- (void)setScalingMode:(PlayerScalingMode)scalingMode {
    _scalingMode = scalingMode;
    TFY_PlayerPresentView *presentView = (TFY_PlayerPresentView *)self.view;
    switch (scalingMode) {
        case PlayerScalingModeNone:
            presentView.videoGravity = AVLayerVideoGravityResizeAspect;
            break;
        case PlayerScalingModeAspectFit:
            presentView.videoGravity = AVLayerVideoGravityResizeAspect;
            break;
        case PlayerScalingModeAspectFill:
            presentView.videoGravity = AVLayerVideoGravityResizeAspectFill;
            break;
        case PlayerScalingModeFill:
            presentView.videoGravity = AVLayerVideoGravityResize;
            break;
        default:
            break;
    }
}

- (void)setVolume:(float)volume {
    _volume = MIN(MAX(0, volume), 1);
    self.player.volume = volume;
}

@end

#pragma clang diagnostic pop
