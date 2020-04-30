//
//  TFY_SpeedLoadingView.m
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/7/2.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_SpeedLoadingView.h"
#import "TFY_NetworkSpeedMonitor.h"
#import "TFY_LoadingView.h"

@interface TFY_SpeedLoadingView ()
/**
 *  获取网络网速
 */
@property(nonatomic , strong)TFY_NetworkSpeedMonitor *speedmonitor;
/**
 *  动画加载圆圈
 */
@property(nonatomic , strong)TFY_LoadingView *loadingview;
/**
 *  网速显示
 */
@property(nonatomic , strong)UILabel *speed_label;

@end

@implementation TFY_SpeedLoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}

- (void)initialize {
    self.userInteractionEnabled = NO;
    [self addSubview:self.loadingview];
    [self addSubview:self.speed_label];
    [self.speedmonitor startNetworkSpeedMonitor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkSpeedChanged:) name:DownloadNetworkSpeedNotificationKey object:nil];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.loadingview.tfy_Center(0, -10).tfy_size(40, 40);
    
    self.speed_label.tfy_LeftSpace(10).tfy_TopSpaceToView(0, self.loadingview).tfy_RightSpace(10).tfy_Height(25);
}

- (void)networkSpeedChanged:(NSNotification *)sender {
    NSString *downloadSpped = [sender.userInfo objectForKey:NetworkSpeedNotificationKey];
    self.speed_label.text = downloadSpped;
}

- (void)startAnimating {
    [self.loadingview startAnimating];
    self.hidden = NO;
}

- (void)stopAnimating {
    [self.loadingview stopAnimating];
    self.hidden = YES;
}

#pragma 懒加载

-(TFY_NetworkSpeedMonitor *)speedmonitor{
    if (!_speedmonitor) {
        _speedmonitor = [TFY_NetworkSpeedMonitor new];
    }
    return _speedmonitor;
}

-(TFY_LoadingView *)loadingview{
    if (!_loadingview) {
        _loadingview = [TFY_LoadingView new];
        _loadingview.lineWidth = 1;
        _loadingview.duration = 2;
        _loadingview.hidesWhenStopped = YES;
    }
    return _loadingview;
}

-(UILabel *)speed_label{
    if (!_speed_label) {
        _speed_label = tfy_label();
        _speed_label.tfy_textcolor(@"ffffff", 1).tfy_fontSize([UIFont systemFontOfSize:13]).tfy_alignment(1);
    }
    return _speed_label;
}

- (void)dealloc {
    [self.speedmonitor stopNetworkSpeedMonitor];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DownloadNetworkSpeedNotificationKey object:nil];
}

@end
