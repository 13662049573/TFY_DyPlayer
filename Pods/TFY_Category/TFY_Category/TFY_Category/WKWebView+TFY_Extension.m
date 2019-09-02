//
//  WKWebView+TFY_Extension.m
//  TFY_CHESHI
//
//  Created by 田风有 on 2019/3/29.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "WKWebView+TFY_Extension.h"
#include <objc/runtime.h>

@interface WKWebView ()<WKNavigationDelegate>

@property (nonatomic, strong) UIProgressView *tfy_progressView;

@end

@implementation WKWebView (TFY_Extension)
- (void)tfy_showProgressWithColor:(UIColor *)color {
    
    //进度条初始化
    self.tfy_progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    //设置进度条上进度的颜色
    self.tfy_progressView.progressTintColor = (color != nil) ? color : [self tfy_hexColor:@"11BF76"];
    //设置进度条背景色
    self.tfy_progressView.trackTintColor = [UIColor lightGrayColor];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.tfy_progressView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    [self addSubview:self.tfy_progressView];
    
    [self addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    self.navigationDelegate = self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if(self.tfy_progressView != nil) {
        
        if (object == self && [keyPath isEqualToString:@"estimatedProgress"])
        {
            CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
            if (newprogress == 1)
            {
                self.tfy_progressView.hidden = YES;
                [self.tfy_progressView setProgress:0 animated:NO];
            }
            else
            {
                self.tfy_progressView.hidden = NO;
                [self.tfy_progressView setProgress:newprogress animated:YES];
            }
        }
    }
}

//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    //开始加载网页时展示出progressView
    if(self.tfy_progressView != nil) {
        
        self.tfy_progressView.hidden = NO;
        //开始加载网页的时候将progressView的Height恢复为1.5倍
        self.tfy_progressView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        //防止progressView被网页挡住
        [self bringSubviewToFront:self.tfy_progressView];
    }
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    //加载完成后隐藏progressView
    if(self.tfy_progressView != nil) {
        
        self.tfy_progressView.hidden = YES;
    }
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    //加载失败同样需要隐藏progressView
    if(self.tfy_progressView != nil) {
        
        self.tfy_progressView.hidden = YES;
    }
}

- (void)setTfy_progressView:(UIProgressView *)tfy_progressView {
    
    objc_setAssociatedObject(self, &@selector(tfy_progressView), tfy_progressView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIProgressView *)tfy_progressView {
    
    UIProgressView *obj = objc_getAssociatedObject(self, &@selector(tfy_progressView));
    return obj;
}

- (void)dealloc {
    
    if(self.tfy_progressView != nil) {
        
        [self removeObserver:self forKeyPath:@"estimatedProgress"];
    }
}

-(UIColor *)tfy_hexColor:(NSString *)hexColor {
    
    unsigned int red, green, blue;
    
    NSRange range;
    
    range.length = 2;
    
    range.location = 0;
    
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    
    range.location = 2;
    
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    
    range.location = 4;
    
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/ 255.0f) green:(float)(green/ 255.0f) blue:(float)(blue/ 255.0f) alpha: 1.0f];
}

@end
