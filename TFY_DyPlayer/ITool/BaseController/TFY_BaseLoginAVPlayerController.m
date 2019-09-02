//
//  TFY_BaseLoginAVPlayerController.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/24.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_BaseLoginAVPlayerController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
@interface TFY_BaseLoginAVPlayerController ()

@property (strong,nonatomic) AVPlayerViewController *moviePlayer;
@property (strong,nonatomic) AVPlayer *player;
@property (strong,nonatomic) AVPlayerItem *item;
@end

@implementation TFY_BaseLoginAVPlayerController

-(void)setVideoUrl:(NSString *)videoUrl{
    _videoUrl  = videoUrl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([TFY_CommonUtils judgeIsEmptyWithString:self.videoUrl]) {
        self.videoUrl = [[NSBundle mainBundle]pathForResource:@"qidong"ofType:@"mp4"];
    }
    
    AVAsset *asset = [AVAsset assetWithURL:[self.videoUrl hasPrefix:@"http"] ? [NSURL URLWithString:self.videoUrl]:[NSURL fileURLWithPath:self.videoUrl]];
    
    self.item=[AVPlayerItem playerItemWithAsset:asset];
    
    //设置AVPlayer中的AVPlayerItem
    self.player=[AVPlayer playerWithPlayerItem:self.item];
    
    //初始化AVPlayerViewController
    self.moviePlayer=[[AVPlayerViewController alloc]init];
    self.moviePlayer.showsPlaybackControls = NO;
    self.moviePlayer.accessibilityElementsHidden = YES;
    if (@available(iOS 11.0, *)) {
        self.moviePlayer.entersFullScreenWhenPlaybackBegins = NO;
    }
    self.moviePlayer.player=self.player;
    
    [self.view addSubview:self.moviePlayer.view];
    
    //设置AVPlayerViewController的frame
    self.moviePlayer.view.frame=self.view.frame;
    
    [self.player play];
    
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:self.item] subscribeNext:^(NSNotification * _Nullable x) {
        
        [self rerunPlayVideo];
        
    } error:^(NSError * _Nullable error) {}];
}

-(void)rerunPlayVideo{
    if (!self.player) {
        return;
    }
    CGFloat a = 0;
    NSInteger dragedSeconds = floorf(a);
    CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
    [self.player seekToTime:dragedCMTime];
    [self.player play];
}

@end
