//
//  TFY_ProgressHUD.m
//  TFY_AutoLayoutModelTools
//
//  Created by 田风有 on 2019/5/11.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import "TFY_ProgressHUD.h"
#import <AvailabilityMacros.h>
#import <QuartzCore/QuartzCore.h>

#define NotificationCenter [NSNotificationCenter defaultCenter]

typedef enum : NSUInteger{
    ProgressHUD_ERROR = 0,  // 错误信息
    ProgressHUD_SUCCESS,    // 成功信息
    ProgressHUD_PROMPT,     // 提示信息
}ProgressHUDType;

@interface TFY_ProgressHUD ()
@property (nonatomic,  assign) ProgressHUDMaskType maskType;
@property (nonatomic,  assign) ProgressHUDType type;
@property (nonatomic,  strong) NSTimer *fadeOutTimer;
@property (nonatomic,  strong) UIWindow *overlayWindow;
@property (nonatomic,  strong) UIView *hudView;
@property (nonatomic,  strong) UILabel *stringLabel;
@property (nonatomic,  strong) UIImageView *imageView;
@property (nonatomic,  strong) UIActivityIndicatorView *spinnerView;
@property (nonatomic,assign) CGFloat visibleKeyboardHeight;

- (void)showWithStatus:(NSString*)string maskType:(ProgressHUDMaskType)hudMaskType networkIndicator:(BOOL)show;
- (void)setStatus:(NSString*)string;
- (void)registerNotifications;
- (void)moveToPoint:(CGPoint)newCenter rotateAngle:(CGFloat)angle;
- (void)positionHUD:(NSNotification*)notification;

- (void)dismiss;
- (void)dismissWithStatus:(NSString*)string Status:(ProgressHUDType)status;
- (void)dismissWithStatus:(NSString*)string Status:(ProgressHUDType)status afterDelay:(NSTimeInterval)seconds;
@end

@implementation TFY_ProgressHUD

+ (TFY_ProgressHUD*)sharedView {
    static dispatch_once_t once;
    static TFY_ProgressHUD *sharedView;
    dispatch_once(&once, ^ { sharedView = [[TFY_ProgressHUD alloc] initWithFrame:[[UIScreen mainScreen] bounds]]; });
    return sharedView;
}

+ (void)setStatus:(NSString *)string {
    [[TFY_ProgressHUD sharedView] setStatus:string];
}

#pragma mark - Touch Events

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    if ([touch tapCount] == 2) {
        if ([TFY_ProgressHUD isVisible]) {
            [TFY_ProgressHUD dismiss];
            [[TFY_ProgressHUD sharedView] dismissWithNoAni];
        }
    }
}

#pragma mark - 显示方法

+ (void)show {
    [[TFY_ProgressHUD sharedView] showWithStatus:nil maskType:ProgressHUDMaskTypeNone networkIndicator:NO];
}

+ (void)showWithStatus:(NSString *)status {
    [[TFY_ProgressHUD sharedView] showWithStatus:status maskType:ProgressHUDMaskTypeNone networkIndicator:NO];
}

+ (void)showWithMaskType:(ProgressHUDMaskType)maskType {
    [[TFY_ProgressHUD sharedView] showWithStatus:nil maskType:maskType networkIndicator:NO];
}

+ (void)showWithStatus:(NSString*)status maskType:(ProgressHUDMaskType)maskType {
    [[TFY_ProgressHUD sharedView] showWithStatus:status maskType:maskType networkIndicator:NO];
}

+ (void)showSuccessWithStatus:(NSString *)string {
    [TFY_ProgressHUD showSuccessWithStatus:string duration:1];
}

+ (void)showSuccessWithStatus:(NSString *)string duration:(NSTimeInterval)duration {
    [TFY_ProgressHUD show];
    [TFY_ProgressHUD dismissWithSuccess:string afterDelay:duration];
    
}

+ (void)showErrorWithStatus:(NSString *)string {
    [TFY_ProgressHUD showErrorWithStatus:string duration:1];
}

+ (void)showErrorWithStatus:(NSString *)string duration:(NSTimeInterval)duration {
    [TFY_ProgressHUD show];
    
    [TFY_ProgressHUD dismissWithError:string afterDelay:duration];
}

+ (void)showPromptWithStatus:(NSString *)string {
    
    [TFY_ProgressHUD showPromptWithStatus:string duration:1];
    
}
+ (void)showPromptWithStatus:(NSString *)string duration:(NSTimeInterval)duration {
    
    [TFY_ProgressHUD show];
    [TFY_ProgressHUD dismissWithPrompt:string afterDelay:duration];
}




#pragma mark - Dismiss Methods

+ (void)dismiss {
    [[TFY_ProgressHUD sharedView] dismiss];
}

+ (void)dismissWithSuccess:(NSString *)successString {
    [[TFY_ProgressHUD sharedView] dismissWithStatus:successString Status:ProgressHUD_SUCCESS];
}

+ (void)dismissWithSuccess:(NSString *)successString afterDelay:(NSTimeInterval)seconds {
    [[TFY_ProgressHUD sharedView] dismissWithStatus:successString Status:ProgressHUD_SUCCESS afterDelay:seconds];
}

+ (void)dismissWithError:(NSString*)errorString {
    [[TFY_ProgressHUD sharedView] dismissWithStatus:errorString Status:ProgressHUD_ERROR];
}

+ (void)dismissWithError:(NSString *)errorString afterDelay:(NSTimeInterval)seconds {
    [[TFY_ProgressHUD sharedView] dismissWithStatus:errorString Status:ProgressHUD_ERROR afterDelay:seconds];
}
+ (void)dismissWithPrompt:(NSString*)promptString {
    [[TFY_ProgressHUD sharedView] dismissWithStatus:promptString Status:ProgressHUD_PROMPT];
}
+ (void)dismissWithPrompt:(NSString *)promptString afterDelay:(NSTimeInterval)seconds {
    [[TFY_ProgressHUD sharedView] dismissWithStatus:promptString Status:ProgressHUD_PROMPT afterDelay:seconds];
}

#pragma mark - Instance Methods

- (id)initWithFrame:(CGRect)frame {
    
    if ((self = [super initWithFrame:frame])) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    self.userInteractionEnabled = YES;
    return self;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleDefault;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    switch (self.maskType) {
        case ProgressHUDMaskTypeNone:
        case ProgressHUDMaskTypeClear:
        case ProgressHUDMaskTypeBlack: {
            [[UIColor colorWithWhite:0 alpha:0.5] set];
            CGContextFillRect(context, self.bounds);
            [self preferredStatusBarStyle];
            break;
        }
        case ProgressHUDMaskTypeGradient: {
            
            size_t locationsCount = 2;
            CGFloat locations[2] = {0.0f, 1.0f};
            CGFloat colors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.75f};
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
            CGColorSpaceRelease(colorSpace);
            
            CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
            float radius = MIN(self.bounds.size.width , self.bounds.size.height) ;
            CGContextDrawRadialGradient (context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
            CGGradientRelease(gradient);
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
            break;
        }
    }
}

//计算文字的大小
- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize fontSize:(UIFont *)font {
    CGSize nameSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return nameSize;
}
- (void)setStatus:(NSString *)string {
    
    CGFloat hudWidth = 100;
    CGFloat hudHeight = 100;
    CGFloat stringWidth = 0;
    CGFloat stringHeight = 0;
    CGRect labelRect = CGRectZero;
    
    if(string) {
        CGSize stringSize = [self sizeWithText:string maxSize:CGSizeMake(200, 300) fontSize:self.stringLabel.font];
        stringWidth = stringSize.width;
        stringHeight = stringSize.height;
        hudHeight = 80 + stringHeight;
        
        if (stringWidth > hudWidth)
            hudWidth = ceil(stringWidth / 2) * 2;
        
        if (hudHeight > 100) {
            labelRect = CGRectMake(12, 66, hudWidth, stringHeight);
            hudWidth += 24;
        } else {
            hudWidth += 24;
            labelRect = CGRectMake(0, 66, hudWidth, stringHeight);
        }
    }
    
    self.hudView.bounds = CGRectMake(0, 0, hudWidth, hudHeight);
    
    if(string)
        self.imageView.center = CGPointMake(CGRectGetWidth(self.hudView.bounds)/2, 36);
    else
        self.imageView.center = CGPointMake(CGRectGetWidth(self.hudView.bounds)/2, CGRectGetHeight(self.hudView.bounds)/2);
    
    self.stringLabel.hidden = NO;
    self.stringLabel.text = string;
    self.stringLabel.frame = labelRect;
    
    if(string)
        self.spinnerView.center = CGPointMake(ceil(CGRectGetWidth(self.hudView.bounds)/2)+0.5, 40.5);
    else
        self.spinnerView.center = CGPointMake(ceil(CGRectGetWidth(self.hudView.bounds)/2)+0.5, ceil(self.hudView.bounds.size.height/2)+0.5);
}

- (void)registerNotifications {
    [NotificationCenter addObserver:self
                           selector:@selector(positionHUD:)
                               name:UIApplicationDidChangeStatusBarOrientationNotification
                             object:nil];
    
    [NotificationCenter addObserver:self
                           selector:@selector(positionHUD:)
                               name:UIKeyboardWillHideNotification
                             object:nil];
    
    [NotificationCenter addObserver:self
                           selector:@selector(positionHUD:)
                               name:UIKeyboardDidHideNotification
                             object:nil];
    
    [NotificationCenter addObserver:self
                           selector:@selector(positionHUD:)
                               name:UIKeyboardWillShowNotification
                             object:nil];
    
    [NotificationCenter addObserver:self
                           selector:@selector(positionHUD:)
                               name:UIKeyboardDidShowNotification
                             object:nil];
}


- (void)positionHUD:(NSNotification*)notification {
    
    CGFloat keyboardHeight;
    double animationDuration = 0.0;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if(notification) {
        NSDictionary* keyboardInfo = [notification userInfo];
        CGRect keyboardFrame = [[keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        animationDuration = [[keyboardInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        if(notification.name == UIKeyboardWillShowNotification || notification.name == UIKeyboardDidShowNotification) {
            if(UIInterfaceOrientationIsPortrait(orientation))
                keyboardHeight = keyboardFrame.size.height;
            else
                keyboardHeight = keyboardFrame.size.width;
        } else
            keyboardHeight = 0;
    } else {
        keyboardHeight = self.visibleKeyboardHeight;
    }
    
    CGRect orientationFrame = [UIScreen mainScreen].bounds;
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    
    if(UIInterfaceOrientationIsLandscape(orientation)) {
        float temp = orientationFrame.size.width;
        orientationFrame.size.width = orientationFrame.size.height;
        orientationFrame.size.height = temp;
        
        temp = statusBarFrame.size.width;
        statusBarFrame.size.width = statusBarFrame.size.height;
        statusBarFrame.size.height = temp;
    }
    
    CGFloat activeHeight = orientationFrame.size.height;
    
    if(keyboardHeight > 0)
        activeHeight += statusBarFrame.size.height*2;
    
    activeHeight -= keyboardHeight;
    CGFloat posY = floor(activeHeight*0.45);
    CGFloat posX = orientationFrame.size.width/2;
    
    CGPoint newCenter;
    CGFloat rotateAngle;
    
    switch (orientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
            rotateAngle = M_PI;
            newCenter = CGPointMake(posX, orientationFrame.size.height-posY);
            break;
        case UIInterfaceOrientationLandscapeLeft:
            rotateAngle = -M_PI/2.0f;
            newCenter = CGPointMake(posY, posX);
            break;
        case UIInterfaceOrientationLandscapeRight:
            rotateAngle = M_PI/2.0f;
            newCenter = CGPointMake(orientationFrame.size.height-posY, posX);
            break;
        default:
            //UI界面定向图
            rotateAngle = 0.0;
            newCenter = CGPointMake(posX, posY);
            break;
    }
    
    if(notification) {
        [UIView animateWithDuration:animationDuration
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             [self moveToPoint:newCenter rotateAngle:rotateAngle];
                         } completion:NULL];
    } else {
        [self moveToPoint:newCenter rotateAngle:rotateAngle];
    }
    
}

- (void)moveToPoint:(CGPoint)newCenter rotateAngle:(CGFloat)angle {
    self.hudView.transform = CGAffineTransformMakeRotation(angle);
    self.hudView.center = newCenter;
}

#pragma mark - Master show/dismiss methods

- (void)showWithStatus:(NSString*)string maskType:(ProgressHUDMaskType)hudMaskType networkIndicator:(BOOL)show {
    dispatch_async(dispatch_get_main_queue(), ^{
        if(!self.superview)
            [self.overlayWindow addSubview:self];
        
        self.fadeOutTimer = nil;
        self.imageView.hidden = YES;
        self.maskType = hudMaskType;
        
        [self setStatus:string];
        [self.spinnerView startAnimating];
        
        if(self.maskType != ProgressHUDMaskTypeNone) {
            self.overlayWindow.userInteractionEnabled = NO;
        } else {
            self.overlayWindow.userInteractionEnabled = YES;
        }
        
        [self.overlayWindow makeKeyAndVisible];
        [self positionHUD:nil];
        
        if(self.alpha != 1) {
            [self registerNotifications];
            self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 1.3, 1.3);
            
            [UIView animateWithDuration:0.15
                                  delay:0
                                options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 1/1.3, 1/1.3);
                                 self.alpha = 1;
                             }
                             completion:NULL];
        }
        
        [self setNeedsDisplay];
    });
}


- (void)dismissWithStatus:(NSString*)string Status:(ProgressHUDType)status {
    [self dismissWithStatus:string Status:status afterDelay:0.9];
    
}


- (void)dismissWithStatus:(NSString *)string Status:(ProgressHUDType)status afterDelay:(NSTimeInterval)seconds {
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.alpha != 1)
            return;
        
        if(status == ProgressHUD_ERROR){
            self.imageView.image = [UIImage imageNamed:@"TFY_ProgressHUD.bundle/my_error"];
        }else if(status == ProgressHUD_SUCCESS) {
            self.imageView.image = [UIImage imageNamed:@"TFY_ProgressHUD.bundle/my_success"];
        }else if(status == ProgressHUD_PROMPT) {
            self.imageView.image = [UIImage imageNamed:@"TFY_ProgressHUD.bundle/my_prompt"];
        }
        self.imageView.hidden = NO;
        [self setStatus:string];
        [self.spinnerView stopAnimating];
        
        self.fadeOutTimer = [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
    });
}

- (void)dismissWithNoAni{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [NotificationCenter removeObserver:self];
    //    OMGLog(@"*****************");
    [self.hudView removeFromSuperview];
    self.hudView = nil;
    
    // 确保从窗口列表中删除覆盖窗口
    // 在尝试在同一列表中找到键窗口之前
    NSMutableArray *windows = [[NSMutableArray alloc] initWithArray:[UIApplication sharedApplication].windows];
    [self.overlayWindow setUserInteractionEnabled:YES];
    
    [windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *window, NSUInteger idx, BOOL *stop) {
        if([window isKindOfClass:[UIWindow class]] && window.windowLevel == UIWindowLevelNormal) {
            [window makeKeyWindow];
            *stop = YES;
        }
    }];
    windows = nil;
    [self.fadeOutTimer invalidate];
    self.fadeOutTimer = nil;
    
    [self.stringLabel removeFromSuperview];
    self.stringLabel = nil;
    
    [self.imageView removeFromSuperview];
    self.imageView = nil;
    [self.spinnerView removeFromSuperview];
    self.spinnerView = nil;
    [self removeFromSuperview];
    [self.window removeFromSuperview];
}

- (void)dismiss {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction animations:^{
            self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 0.8, 0.8);
            self.alpha = 0;
            
        }completion:^(BOOL finished){
            
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
            if(self.alpha == 0) {
                [NotificationCenter removeObserver:self];
                [self.hudView removeFromSuperview];
                self.hudView = nil;
                
                // 确保从窗口列表中删除覆盖窗口
                // 在尝试在同一列表中找到键窗口之前
                NSMutableArray *windows = [[NSMutableArray alloc] initWithArray:[UIApplication sharedApplication].windows];
                [self.overlayWindow setUserInteractionEnabled:YES];
                
                [windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *window, NSUInteger idx, BOOL *stop) {
                    if([window isKindOfClass:[UIWindow class]] && window.windowLevel == UIWindowLevelNormal) {
                        [window makeKeyWindow];
                        *stop = YES;
                    }
                }];
                
                windows = nil;
                [self.fadeOutTimer invalidate];
                self.fadeOutTimer = nil;
                
                [self.stringLabel removeFromSuperview];
                self.stringLabel = nil;
                [self.imageView removeFromSuperview];
                self.imageView = nil;
                [self.spinnerView removeFromSuperview];
                self.spinnerView = nil;
                [self removeFromSuperview];
                [self.window removeFromSuperview];
            }
        }];
    });
}

#pragma mark - Utilities

+ (BOOL)isVisible {
    return ([TFY_ProgressHUD sharedView].alpha == 1);
}


#pragma mark - Getters

- (UIWindow *)overlayWindow {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    _overlayWindow = window;
    return _overlayWindow;
}

- (UIView *)hudView {
    
    if(!_hudView) {
        
        self.hudView = [[UIView alloc] initWithFrame:CGRectZero];
        self.hudView.layer.cornerRadius = 10;
        self.hudView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        self.hudView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin     | UIViewAutoresizingFlexibleRightMargin   | UIViewAutoresizingFlexibleLeftMargin);
        
        [self addSubview:self.hudView];
    }
    return _hudView;
}

- (UILabel *)stringLabel {
    if (_stringLabel == nil) {
        
        self.stringLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.stringLabel.textColor = [UIColor whiteColor];
        self.stringLabel.backgroundColor = [UIColor clearColor];
        self.stringLabel.adjustsFontSizeToFitWidth = YES;
        self.stringLabel.textAlignment = NSTextAlignmentCenter;
        self.stringLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        self.stringLabel.font = [UIFont boldSystemFontOfSize:16];
        self.stringLabel.shadowColor = [UIColor blackColor];
        self.stringLabel.shadowOffset = CGSizeMake(0, -1);
        self.stringLabel.numberOfLines = 0;
    }
    
    if(!_stringLabel.superview)
        [self.hudView addSubview:_stringLabel];
    
    return _stringLabel;
}

- (UIImageView *)imageView {
    if (_imageView == nil)
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
    
    if(!_imageView.superview)
        [self.hudView addSubview:_imageView];
    
    return _imageView;
}

- (UIActivityIndicatorView *)spinnerView {
    if (_spinnerView == nil) {
        self.spinnerView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.spinnerView.hidesWhenStopped = YES;
        self.spinnerView.bounds = CGRectMake(0, 0, 37, 37);
    }
    
    if(!_spinnerView.superview)
        [self.hudView addSubview:_spinnerView];
    
    return _spinnerView;
}

- (CGFloat)visibleKeyboardHeight {
    
    UIWindow *keyboardWindow = nil;
    for (UIWindow *testWindow in [[UIApplication sharedApplication] windows]) {
        if(![[testWindow class] isEqual:[UIWindow class]]) {
            keyboardWindow = testWindow;
            break;
        }
    }
    
    // Locate UIKeyboard.
    UIView *foundKeyboard = nil;
    for (__strong UIView *possibleKeyboard in [keyboardWindow subviews]) {
        
        // iOS 4 sticks the UIKeyboard inside a UIPeripheralHostView.
        if ([[possibleKeyboard description] hasPrefix:@"<UIPeripheralHostView"]) {
            possibleKeyboard = [[possibleKeyboard subviews] objectAtIndex:0];
        }
        
        if ([[possibleKeyboard description] hasPrefix:@"<UIKeyboard"]) {
            foundKeyboard = possibleKeyboard;
            break;
        }
    }
    
    if(foundKeyboard && foundKeyboard.bounds.size.height > 100)
        return foundKeyboard.bounds.size.height;
    
    return 0;
}

- (void)dealloc {
    self.fadeOutTimer = nil;
    
    [NotificationCenter removeObserver:self];
}

@end
