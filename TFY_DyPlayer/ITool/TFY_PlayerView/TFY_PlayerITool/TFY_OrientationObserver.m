//
//  TFY_OrientationObserver.m
//  TFY_PlayerView
//
//  Created by 田风有 on 2019/6/30.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_OrientationObserver.h"
#import "TFY_PlayerToolsHeader.h"

#define SysVersion [[UIDevice currentDevice] systemVersion].floatValue

@interface UIWindow (CurrentViewController)

/*!
 @method currentViewController
  @return返回topMostController堆栈中的topViewController。
 */
+ (UIViewController*)tfy_currentViewController;

@end

@implementation UIWindow (CurrentViewController)

+ (UIViewController*)tfy_currentViewController; {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *topViewController = [window rootViewController];
    while (true) {
        if (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topViewController topViewController]) {
            topViewController = [(UINavigationController *)topViewController topViewController];
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
        } else {
            break;
        }
    }
    return topViewController;
}

@end

@interface TFY_OrientationObserver ()
@property (nonatomic, weak) UIView *view;

@property (nonatomic, assign, getter=isFullScreen) BOOL fullScreen;

@property (nonatomic, strong) UIView *cell;

@property (nonatomic, assign) NSInteger playerViewTag;

@property (nonatomic, assign) RotateType roateType;

@property (nonatomic, strong) UIView *blackView;
@end

@implementation TFY_OrientationObserver

- (instancetype)init {
    self = [super init];
    if (self) {
        _duration = 0.30;
        _fullScreenMode = FullScreenModeLandscape;
        _supportInterfaceOrientation = InterfaceOrientationMaskAllButUpsideDown;
        _allowOrentitaionRotation = YES;
        _systemrotationbool = NO;
        _roateType = RotateTypeNormal;
    }
    return self;
}

- (void)updateRotateView:(UIView *)rotateView containerView:(UIView *)containerView {
    self.view = rotateView;
    self.containerView = containerView;
}

- (void)cellModelRotateView:(UIView *)rotateView rotateViewAtCell:(UIView *)cell playerViewTag:(NSInteger)playerViewTag {
    self.roateType = RotateTypeCell;
    self.view = rotateView;
    self.cell = cell;
    self.playerViewTag = playerViewTag;
}

- (void)cellOtherModelRotateView:(UIView *)rotateView containerView:(UIView *)containerView {
    self.roateType = RotateTypeCellOther;
    self.view = rotateView;
    self.containerView = containerView;
}

- (void)dealloc {
    [self removeDeviceOrientationObserver];
    [self.blackView removeFromSuperview];
}

- (void)addDeviceOrientationObserver {
    if (![UIDevice currentDevice].generatesDeviceOrientationNotifications) {
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)removeDeviceOrientationObserver {
    if (![UIDevice currentDevice].generatesDeviceOrientationNotifications) {
        [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)handleDeviceOrientationChange {
    if (self.fullScreenMode == FullScreenModePortrait || !self.allowOrentitaionRotation) return;
    if (UIDeviceOrientationIsValidInterfaceOrientation([UIDevice currentDevice].orientation)) {
        _currentOrientation = (UIInterfaceOrientation)[UIDevice currentDevice].orientation;
    } else {
        _currentOrientation = UIInterfaceOrientationUnknown;
        return;
    }
    if (self.systemrotationbool==NO) {
        UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
        // 确定如果当前方向与您想要旋转的方向相同，则不执行任何操作
        if (_currentOrientation == currentOrientation && ![self isNeedAdaptiveiOS8Rotation] && !self.forceDeviceOrientation) return;
    }
    
    switch (_currentOrientation) {
        case UIInterfaceOrientationPortrait: {
            if ([self isSupportedPortrait]) {
                [self enterLandscapeFullScreen:UIInterfaceOrientationPortrait animated:YES];
            }
        }
            break;
        case UIInterfaceOrientationLandscapeLeft: {
            if ([self isSupportedLandscapeLeft]) {
                [self enterLandscapeFullScreen:UIInterfaceOrientationLandscapeLeft animated:YES];
            }
        }
            break;
        case UIInterfaceOrientationLandscapeRight: {
            if ([self isSupportedLandscapeRight]) {
                [self enterLandscapeFullScreen:UIInterfaceOrientationLandscapeRight animated:YES];
            }
        }
            break;
        default: break;
    }
}

- (void)enterLandscapeFullScreen:(UIInterfaceOrientation)orientation animated:(BOOL)animated {
    if (self.fullScreenMode == FullScreenModePortrait) return;
    _currentOrientation = orientation;
    UIView *superview = nil;
    CGRect frame;
    if ([self isNeedAdaptiveiOS8Rotation] || self.forceDeviceOrientation) {
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            if (self.fullScreen) return;
            superview = self.fullScreenContainerView;
            self.fullScreen = YES;
        } else {
            if (!self.fullScreen) return;
            if (self.roateType == RotateTypeCell) superview = [self.cell viewWithTag:self.playerViewTag];
            else superview = self.containerView;
            self.fullScreen = NO;
            if (self.blackView.superview != nil) [self.blackView removeFromSuperview];
        }
        if (self.orientationWillChange) self.orientationWillChange(self, self.isFullScreen);
        
        [superview addSubview:self.view];
        if (animated) {
            [UIView animateWithDuration:self.duration animations:^{
                self.view.frame = superview.bounds;
                [self.view layoutIfNeeded];
                [self interfaceOrientation:orientation];
            } completion:^(BOOL finished) {
                if (self.fullScreen) {
                    [superview insertSubview:self.blackView belowSubview:self.view];
                    self.blackView.frame = superview.bounds;
                }
                if (self.orientationDidChanged) self.orientationDidChanged(self, self.isFullScreen);
            }];
        } else {
            self.view.frame = superview.bounds;
            [self.view layoutIfNeeded];
            [UIView animateWithDuration:0 animations:^{
                [self interfaceOrientation:orientation];
            }];
            if (self.fullScreen) {
                [superview insertSubview:self.blackView belowSubview:self.view];
                self.blackView.frame = superview.bounds;
            }
            if (self.orientationDidChanged) self.orientationDidChanged(self, self.isFullScreen);
        }
        return;
    }
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        superview = self.fullScreenContainerView;
        if (!self.isFullScreen) { /// 它不是从屏幕的另一侧设置到这一侧
            self.view.frame = [self.view convertRect:self.view.frame toView:superview];
        }
        self.fullScreen = YES;
        /// 先加到window上，效果更好一些
        [superview addSubview:self.view];
    } else {
        if (self.roateType == RotateTypeCell) superview = [self.cell viewWithTag:self.playerViewTag];
        else superview = self.containerView;
        self.fullScreen = NO;
        if (self.blackView.superview != nil) [self.blackView removeFromSuperview];
    }
    frame = [superview convertRect:superview.bounds toView:self.fullScreenContainerView];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [UIApplication sharedApplication].statusBarOrientation = orientation;
#pragma clang diagnostic pop
    
    if (self.orientationWillChange) self.orientationWillChange(self, self.isFullScreen);
    if (animated) {
        [UIView animateWithDuration:self.duration animations:^{
            self.view.transform = [self getTransformRotationAngle:orientation];
            [UIView animateWithDuration:self.duration animations:^{
                self.view.frame = frame;
                [self.view layoutIfNeeded];
            }];
        } completion:^(BOOL finished) {
            [superview addSubview:self.view];
            self.view.frame = superview.bounds;
            if (self.fullScreen) {
                [superview insertSubview:self.blackView belowSubview:self.view];
                self.blackView.frame = superview.bounds;
            }
            if (self.orientationDidChanged) self.orientationDidChanged(self, self.isFullScreen);
        }];
    } else {
        self.view.transform = [self getTransformRotationAngle:orientation];
        [superview addSubview:self.view];
        self.view.frame = superview.bounds;
        [self.view layoutIfNeeded];
        if (self.fullScreen) {
            [superview insertSubview:self.blackView belowSubview:self.view];
            self.blackView.frame = superview.bounds;
        }
        if (self.orientationDidChanged) self.orientationDidChanged(self, self.isFullScreen);
    }
}

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (BOOL)isNeedAdaptiveiOS8Rotation {
    NSArray<NSString *> *versionStrArr = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    int firstVer = [[versionStrArr objectAtIndex:0] intValue];
    int secondVer = [[versionStrArr objectAtIndex:1] intValue];
    if (firstVer == 8) {
        if (secondVer >= 1 && secondVer <= 3) {
            return YES;
        }
    }
    return NO;
}

/// 获取转换的旋转角度。
- (CGAffineTransform)getTransformRotationAngle:(UIInterfaceOrientation)orientation {
    if (orientation == UIInterfaceOrientationPortrait) {
        return CGAffineTransformIdentity;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft){
        return CGAffineTransformMakeRotation(-M_PI_2);
    } else if(orientation == UIInterfaceOrientationLandscapeRight){
        return CGAffineTransformMakeRotation(M_PI_2);
    }
    return CGAffineTransformIdentity;
}

- (void)enterPortraitFullScreen:(BOOL)fullScreen animated:(BOOL)animated {
    if (self.fullScreenMode == FullScreenModeLandscape) return;
    UIView *superview = nil;
    if (fullScreen) {
        superview = self.fullScreenContainerView;
        self.view.frame = [self.view convertRect:self.view.frame toView:superview];
        [superview addSubview:self.view];
        self.fullScreen = YES;
    } else {
        if (self.roateType == RotateTypeCell) {
            superview = [self.cell viewWithTag:self.playerViewTag];
        } else {
            superview = self.containerView;
        }
        self.fullScreen = NO;
    }
    if (self.orientationWillChange) self.orientationWillChange(self, self.isFullScreen);
    CGRect frame = [superview convertRect:superview.bounds toView:self.fullScreenContainerView];
    if (animated) {
        [UIView animateWithDuration:self.duration animations:^{
            self.view.frame = frame;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [superview addSubview:self.view];
            self.view.frame = superview.bounds;
            if (self.orientationDidChanged) self.orientationDidChanged(self, self.isFullScreen);
        }];
    } else {
        [superview addSubview:self.view];
        self.view.frame = superview.bounds;
        [self.view layoutIfNeeded];
        if (self.orientationDidChanged) self.orientationDidChanged(self, self.isFullScreen);
    }
}

- (void)exitFullScreenWithAnimated:(BOOL)animated {
    if (self.fullScreenMode == FullScreenModeLandscape) {
        [self enterLandscapeFullScreen:UIInterfaceOrientationPortrait animated:animated];
    } else if (self.fullScreenMode == FullScreenModePortrait) {
        [self enterPortraitFullScreen:NO animated:animated];
    }
}

/// 是否支持 Portrait
- (BOOL)isSupportedPortrait {
    return self.supportInterfaceOrientation & InterfaceOrientationMaskPortrait;
}

/// 是否支持 LandscapeLeft
- (BOOL)isSupportedLandscapeLeft {
    return self.supportInterfaceOrientation & InterfaceOrientationMaskLandscapeLeft;
}

/// 是否支持 LandscapeRight
- (BOOL)isSupportedLandscapeRight {
    return self.supportInterfaceOrientation & InterfaceOrientationMaskLandscapeRight;
}

- (UIView *)blackView {
    if (!_blackView) {
        _blackView = [UIView new];
        _blackView.backgroundColor = [UIColor blackColor];
    }
    return _blackView;
}

#pragma mark - setter

- (void)setLockedScreen:(BOOL)lockedScreen {
    _lockedScreen = lockedScreen;
    if (lockedScreen) {
        [self removeDeviceOrientationObserver];
    } else {
        [self addDeviceOrientationObserver];
    }
}

- (UIView *)fullScreenContainerView {
    if (!_fullScreenContainerView) {
        _fullScreenContainerView = [UIApplication sharedApplication].keyWindow;
    }
    return _fullScreenContainerView;
}

- (void)setFullScreen:(BOOL)fullScreen {
    _fullScreen = fullScreen;
    [[UIWindow tfy_currentViewController] setNeedsStatusBarAppearanceUpdate];
}

- (void)setStatusBarHidden:(BOOL)statusBarHidden {
    _statusBarHidden = statusBarHidden;
    [[UIWindow tfy_currentViewController] setNeedsStatusBarAppearanceUpdate];
}


@end
