//
//  TFY_NavigationController.m
//
//  Created by 田风有 on 2019/03/27.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import "TFY_NavigationController.h"
#import <objc/runtime.h>

#pragma mark - 容器控制器
@interface TFYContainerViewController : UIViewController

@property (nonatomic, weak) UIViewController *contentViewController;
+ (instancetype)containerViewControllerWithViewController:(UIViewController *)viewController;

@end

@implementation TFYContainerViewController

+ (instancetype)containerViewControllerWithViewController:(UIViewController *)viewController {
    if (viewController.parentViewController) {
        [viewController willMoveToParentViewController:nil];
        [viewController removeFromParentViewController];
    }
    
    Class cls = [viewController tfy_navigationControllerClass];
    NSAssert(![cls isKindOfClass:UINavigationController.class], @"`-tfy_navigationControllerClass` must return UINavigationController or its subclasses.");
    UINavigationController *nav = [[cls alloc] initWithRootViewController:viewController];
    nav.interactivePopGestureRecognizer.enabled = NO;
    TFYContainerViewController *containerViewController = [[TFYContainerViewController alloc] init];
    containerViewController.contentViewController = viewController;
    containerViewController.hidesBottomBarWhenPushed = viewController.hidesBottomBarWhenPushed;
    [containerViewController addChildViewController:nav];
    [containerViewController.view addSubview:nav.view];
    [nav didMoveToParentViewController:containerViewController];
    
    return containerViewController;
}

@end


#pragma mark - 全局函数

/// 装包
UIKIT_STATIC_INLINE UIViewController* TFYWrapViewController(UIViewController *vc)
{
    if ([vc isKindOfClass:TFYContainerViewController.class]) {
        return vc;
    }
    return [TFYContainerViewController containerViewControllerWithViewController:vc];
}

/// 解包
UIKIT_STATIC_INLINE UIViewController* TFYUnwrapViewController(UIViewController *vc)
{
    if ([vc isKindOfClass:TFYContainerViewController.class]) {
        return ((TFYContainerViewController*)vc).contentViewController;
    }
    return vc;
}


#pragma mark - 导航栏控制器

@interface TFY_NavigationController ()<UIGestureRecognizerDelegate>
@end

@implementation TFY_NavigationController

#pragma mark Lifecycle

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self commonInit];
        [self setupNavigationBarTheme];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(void)setBarBackgroundColor:(UIColor *)barBackgroundColor{
    _barBackgroundColor  = barBackgroundColor;
    
   [self setupNavigationBarTheme];
}
-(void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    
    [self setupNavigationBarTheme];
}

- (void)setupNavigationBarTheme
{
    UINavigationBar *navBar = [UINavigationBar appearance];
    UIColor *color = self.barBackgroundColor ?: [UIColor whiteColor];
    [navBar setBackgroundImage:[self tfy_createImage:color] forBarMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[[UIImage alloc] init]];
    // 设置标题文字颜色
    UIColor *titlecolor = self.titleColor ?: [UIColor blackColor];
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15.0];
    textAttrs[NSForegroundColorAttributeName] = titlecolor;
    [navBar setTitleTextAttributes:textAttrs];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        // 返回按钮目前仅支持图片
        UIImage *backImage = [self.backIconImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] ?: [[self navigationBarBackIconImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStylePlain target:viewController action:@selector(tfy_popViewController)];
#pragma clang diagnostic pop
        viewController.navigationItem.leftBarButtonItem = backItem;
    }
    [super pushViewController:TFYWrapViewController(viewController) animated:animated];
    
    // pop手势
    self.interactivePopGestureRecognizer.delaysTouchesBegan = YES;
    self.interactivePopGestureRecognizer.delegate = self;
}

- (UIImage *)tfy_createImage:(UIColor *)imageColor {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [imageColor CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
#pragma mark <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return self.viewControllers.count > 1;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

/// 在pop手势生效后能够确保滚动视图静止
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return (gestureRecognizer == self.interactivePopGestureRecognizer);
}

#pragma mark Private

- (void)commonInit {
    UIViewController *topViewController = self.topViewController;
    if (topViewController) {
        UIViewController *wrapViewController = TFYWrapViewController(topViewController);
        [super setViewControllers:@[wrapViewController] animated:NO];
    }
    [self setNavigationBarHidden:YES animated:NO];
}

- (UIImage *)navigationBarBackIconImage {
    CGSize const size = CGSizeMake(15.0, 21.0);
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
    
    UIColor *color = [UIColor blackColor];
    [color setFill];
    [color setStroke];
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(10.9, 0)];
    [bezierPath addLineToPoint: CGPointMake(12, 1.1)];
    [bezierPath addLineToPoint: CGPointMake(1.1, 11.75)];
    [bezierPath addLineToPoint: CGPointMake(0, 10.7)];
    [bezierPath addLineToPoint: CGPointMake(10.9, 0)];
    [bezierPath closePath];
    [bezierPath moveToPoint: CGPointMake(11.98, 19.9)];
    [bezierPath addLineToPoint: CGPointMake(10.88, 21)];
    [bezierPath addLineToPoint: CGPointMake(0.54, 11.21)];
    [bezierPath addLineToPoint: CGPointMake(1.64, 10.11)];
    [bezierPath addLineToPoint: CGPointMake(11.98, 19.9)];
    [bezierPath closePath];
    [bezierPath setLineWidth:1.0];
    [bezierPath fill];
    [bezierPath stroke];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark setter & getter

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden {
    [super setNavigationBarHidden:YES];
}

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated {
    [super setNavigationBarHidden:YES animated:NO];
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
    NSMutableArray<UIViewController *> *aViewControllers = [NSMutableArray array];
    for (UIViewController *vc in viewControllers) {
        [aViewControllers addObject:TFYWrapViewController(vc)];
    }
    [super setViewControllers:aViewControllers animated:animated];
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
    NSMutableArray<UIViewController *> *aViewControllers = [NSMutableArray array];
    for (UIViewController *vc in viewControllers) {
        [aViewControllers addObject:TFYWrapViewController(vc)];
    }
    [super setViewControllers:[NSArray arrayWithArray:aViewControllers]];
}

- (NSArray<UIViewController *> *)viewControllers {
    // 返回真正的控制器给外界
    NSMutableArray<UIViewController *> *vcs = [NSMutableArray array];
    NSArray<UIViewController *> *viewControllers = [super viewControllers];
    for (UIViewController *vc in viewControllers) {
        [vcs addObject:TFYUnwrapViewController(vc)];
    }
    return [NSArray arrayWithArray:vcs];
}

@end


#pragma mark -

@implementation UIViewController (TFYNavigationContainer)

/// 通过返回不同的导航栏控制器可以给每个控制器定制不同的导航栏样式
- (Class)tfy_navigationControllerClass {
#ifdef kTFYNavigationControllerClassName
    return NSClassFromString(kTFYNavigationControllerClassName);
#else
    return [TFYContainerNavigationController class];
#endif
}

- (TFY_NavigationController *)tfy_rootNavigationController {
    UIViewController *parentViewController = self.navigationController.parentViewController;
    if (parentViewController && [parentViewController isKindOfClass:TFYContainerViewController.class]) {
        TFYContainerViewController *container = (TFYContainerViewController*)parentViewController;
        return (TFY_NavigationController*)container.navigationController;
    }
    return nil;
}

- (void)tfy_popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

@end


#pragma mark -

@interface UINavigationController (TFYNavigationContainer)
@end

@implementation UINavigationController (TFYNavigationContainer)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *actions = @[
                             NSStringFromSelector(@selector(pushViewController:animated:)),
                             NSStringFromSelector(@selector(popViewControllerAnimated:)),
                             NSStringFromSelector(@selector(popToViewController:animated:)),
                             NSStringFromSelector(@selector(popToRootViewControllerAnimated:)),
                             NSStringFromSelector(@selector(viewControllers))
                             ];
        
        for (NSString *str in actions) {
            Method original = class_getInstanceMethod(self, NSSelectorFromString(str));
            Method swizzled = class_getInstanceMethod(self, NSSelectorFromString([@"tfy_" stringByAppendingString:str]));
            method_exchangeImplementations(original, swizzled);
        }
    });
}

#pragma mark Private

- (TFY_NavigationController *)rootNavigationController {
    if (self.parentViewController && [self.parentViewController isKindOfClass:TFYContainerViewController.class]) {
        TFYContainerViewController *containerViewController = (TFYContainerViewController *)self.parentViewController;
        TFY_NavigationController *rootNavigationController = (TFY_NavigationController *)containerViewController.navigationController;
        return rootNavigationController;
    }
    return nil;
}

#pragma mark Override

- (void)tfy_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    TFY_NavigationController *rootNavigationController = [self rootNavigationController];
    if (rootNavigationController) {
        return [rootNavigationController pushViewController:viewController animated:animated];
    }
    [self tfy_pushViewController:viewController animated:animated];
}

- (UIViewController *)tfy_popViewControllerAnimated:(BOOL)animated {
    TFY_NavigationController *rootNavigationController = [self rootNavigationController];
    if (rootNavigationController) {
        TFYContainerViewController *containerViewController = (TFYContainerViewController*)[rootNavigationController popViewControllerAnimated:animated];
        return containerViewController.contentViewController;
    }
    return [self tfy_popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)tfy_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    TFY_NavigationController *rootNavigationController = [self rootNavigationController];
    if (rootNavigationController) {
        NSArray<UIViewController*> *array = [rootNavigationController popToViewController:viewController animated:animated];
        NSMutableArray *viewControllers = [NSMutableArray array];
        for (UIViewController *vc in array) {
            [viewControllers addObject:TFYUnwrapViewController(vc)];
        }
        return viewControllers;
    }
    return [self tfy_popToViewController:viewController animated:animated];
}

- (NSArray<UIViewController *> *)tfy_popToRootViewControllerAnimated:(BOOL)animated {
    TFY_NavigationController *rootNavigationController = [self rootNavigationController];
    if (rootNavigationController) {
        NSArray<UIViewController*> *array = [rootNavigationController popToRootViewControllerAnimated:animated];
        NSMutableArray *viewControllers = [NSMutableArray array];
        for (UIViewController *vc in array) {
            [viewControllers addObject:TFYUnwrapViewController(vc)];
        }
        return viewControllers;
    }
    return [self tfy_popToRootViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)tfy_viewControllers {
    TFY_NavigationController *rootNavigationController = [self rootNavigationController];
    if (rootNavigationController) {
        return [rootNavigationController viewControllers];
    }
    return [self tfy_viewControllers];
}

@end


#pragma mark - 状态栏样式 & 屏幕旋转

@implementation TFYContainerNavigationController

- (UIViewController *)childViewControllerForStatusBarStyle {
    if (self.topViewController) {
        return TFYUnwrapViewController(self.topViewController);
    }
    return [super childViewControllerForStatusBarStyle];
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    if (self.topViewController) {
        return TFYUnwrapViewController(self.topViewController);
    }
    return [super childViewControllerForStatusBarHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.topViewController) {
        return [TFYUnwrapViewController(self.topViewController) preferredStatusBarStyle];
    }
    return [super preferredStatusBarStyle];
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    if (self.topViewController) {
        return [TFYUnwrapViewController(self.topViewController) preferredStatusBarUpdateAnimation];
    }
    return [super preferredStatusBarUpdateAnimation];
}

- (BOOL)prefersStatusBarHidden {
    if (self.topViewController) {
        return [TFYUnwrapViewController(self.topViewController) prefersStatusBarHidden];
    }
    return [super prefersStatusBarHidden];
}

- (BOOL)shouldAutorotate {
    if (self.topViewController) {
        return [TFYUnwrapViewController(self.topViewController) shouldAutorotate];
    }
    return [super shouldAutorotate];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    if (self.topViewController) {
        return [TFYUnwrapViewController(self.topViewController) preferredInterfaceOrientationForPresentation];
    }
    return [super preferredInterfaceOrientationForPresentation];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.topViewController) {
        return [TFYUnwrapViewController(self.topViewController) supportedInterfaceOrientations];
    }
    return [super supportedInterfaceOrientations];
}

#if __IPHONE_11_0 && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0
- (nullable UIViewController *)childViewControllerForScreenEdgesDeferringSystemGestures
{
    if (self.topViewController) {
        return TFYUnwrapViewController(self.topViewController);
    }
    return [super childViewControllerForScreenEdgesDeferringSystemGestures];
}

- (UIRectEdge)preferredScreenEdgesDeferringSystemGestures
{
    if (self.topViewController) {
        return [TFYUnwrapViewController(self.topViewController) preferredScreenEdgesDeferringSystemGestures];
    }
    return [super preferredScreenEdgesDeferringSystemGestures];
}

- (BOOL)prefersHomeIndicatorAutoHidden
{
    if (self.topViewController) {
        return [TFYUnwrapViewController(self.topViewController) prefersHomeIndicatorAutoHidden];
    }
    return [super prefersHomeIndicatorAutoHidden];
}

- (UIViewController *)childViewControllerForHomeIndicatorAutoHidden
{
    if (self.topViewController) {
        return TFYUnwrapViewController(self.topViewController);
    }
    return [super childViewControllerForHomeIndicatorAutoHidden];
}
#endif

@end
