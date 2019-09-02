//
//  TFY_VolumeBrightnessView.m
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/7/1.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_VolumeBrightnessView.h"
#import <MediaPlayer/MediaPlayer.h>

@interface TFY_VolumeBrightnessView ()

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, assign) VolumeBrightnessType volumeBrightnessType;
@property (nonatomic, strong) MPVolumeView *volumeView;

@end

@implementation TFY_VolumeBrightnessView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.iconImageView];
        self.iconImageView.tfy_CenterY(0).tfy_size(20, 20).tfy_LeftSpace(10);
        
        [self addSubview:self.progressView];
        self.progressView.tfy_LeftSpaceToView(7, self.iconImageView).tfy_CenterY(0).tfy_RightSpace(10).tfy_Height(1);
        
        [self hideTipView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.layer.cornerRadius = self.bounds.size.height/2;
    self.layer.masksToBounds = YES;
}

/// 添加系统音量view
- (void)addSystemVolumeView {
    [self.volumeView removeFromSuperview];
}
/// 移除系统音量view
- (void)removeSystemVolumeView {
    [[UIApplication sharedApplication].keyWindow addSubview:self.volumeView];
}

- (void)updateProgress:(CGFloat)progress withVolumeBrightnessType:(VolumeBrightnessType)volumeBrightnessType {
    if (progress >= 1) {
        progress = 1;
    } else if (progress <= 0) {
        progress = 0;
    }
    self.progressView.progress = progress;
    self.volumeBrightnessType = volumeBrightnessType;
    UIImage *playerImage = nil;
    if (volumeBrightnessType == VolumeBrightnessTypeVolume) {
        if (progress == 0) {
            playerImage = [UIImage imageNamed:@"videoImages.bundle/muted"];
        } else if (progress > 0 && progress < 0.5) {
            playerImage = [UIImage imageNamed:@"videoImages.bundle/volume_low"];
        } else {
            playerImage = [UIImage imageNamed:@"videoImages.bundle/volume_high"];
        }
    } else if (volumeBrightnessType == VolumeBrightnessTypeumeBrightness) {
        if (progress >= 0 && progress < 0.5) {
            playerImage = [UIImage imageNamed:@"videoImages.bundle/brightness_low"];
        } else {
            playerImage = [UIImage imageNamed:@"videoImages.bundle/brightness_high"];
        }
    }
    self.iconImageView.image = playerImage;
    self.hidden = NO;
    self.alpha = 1;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideTipView) object:nil];
    [self performSelector:@selector(hideTipView) withObject:nil afterDelay:1.5];
}

- (void)hideTipView {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (void)setVolumeBrightnessType:(VolumeBrightnessType)volumeBrightnessType {
    _volumeBrightnessType = volumeBrightnessType;
    if (volumeBrightnessType == VolumeBrightnessTypeVolume) {
        self.iconImageView.image = [UIImage imageNamed:@"videoImages.bundle/volume"];
    } else {
        self.iconImageView.image = [UIImage imageNamed:@"videoImages.bundle/brightness"];
    }
}


- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.progressTintColor = [UIColor whiteColor];
        _progressView.trackTintColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];;
    }
    return _progressView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
    }
    return _iconImageView;
}

- (MPVolumeView *)volumeView {
    if (!_volumeView) {
        _volumeView = [[MPVolumeView alloc] init];
        _volumeView.frame = CGRectMake(-1000, -1000, 100, 100);
    }
    return _volumeView;
}
@end
