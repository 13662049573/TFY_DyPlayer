//
//  TfyCU_TabBarView.m
//  TFY_TabBarController
//
//  Created by tiandengyou on 2019/11/28.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TfyCU_TabBarView.h"
#import <objc/runtime.h>

/**
 *  自定义UIScrollView，在需要时可以拦截其滑动手势
 */

@class _TabContentScrollView;

@protocol _TabContentScrollViewDelegate <NSObject>

@optional

- (BOOL)scrollView:(_TabContentScrollView *)scrollView shouldScrollToPageIndex:(NSUInteger)index;

@end

@interface _TabContentScrollView : UIScrollView

@property (nonatomic, weak) id <_TabContentScrollViewDelegate> tfy_delegate;

@property (nonatomic, assign) BOOL interceptLeftSlideGuetureInLastPage;
@property (nonatomic, assign) BOOL interceptRightSlideGuetureInFirstPage;

@end

typedef void (^_ViewControllerWillAppearInjectBlock)(UIViewController *viewController, BOOL animated);

@interface UIViewController (Private)

@property (nonatomic, assign) BOOL tfy_hasBeenDisplayed;

@property (nonatomic, copy) _ViewControllerWillAppearInjectBlock tfy_willAppearInjectBlock;

@end


@implementation TfyCU_TabBarTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end


@implementation UIViewController (Private)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(tfy_viewWillAppear:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)tfy_viewWillAppear:(BOOL)animated {
    [self tfy_viewWillAppear:animated];
    
    if (self.tfy_willAppearInjectBlock) {
        self.tfy_willAppearInjectBlock(self, animated);
    }
}

- (void)setTfy_hasBeenDisplayed:(BOOL)tfy_hasBeenDisplayed {
    objc_setAssociatedObject(self, @selector(tfy_hasBeenDisplayed), @(tfy_hasBeenDisplayed), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)tfy_hasBeenDisplayed {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setTfy_willAppearInjectBlock:(_ViewControllerWillAppearInjectBlock)block {
    objc_setAssociatedObject(self, @selector(tfy_willAppearInjectBlock), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (_ViewControllerWillAppearInjectBlock)tfy_willAppearInjectBlock {
    return objc_getAssociatedObject(self, _cmd);
}

@end


@interface TfyCU_TabBarView ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, _TabContentScrollViewDelegate> {
    
    CGFloat _lastContentScrollViewOffsetX;
    CGFloat _currentScrollViewOffsetY;
}
@property (nonatomic, strong) _TabContentScrollView *contentScrollView;
@property (nonatomic, assign) BOOL isDefaultSelectedTabIndexSetuped;

@property (nonatomic, assign) CGFloat headerViewDefaultHeight;
@property (nonatomic, assign) CGFloat tabBarStopOnTopHeight;

@property (nonatomic, assign) BOOL contentScrollEnabled;
@property (nonatomic, assign) BOOL contentSwitchAnimated;

@property (nonatomic, strong, readwrite) UIView *headerView;
@property (nonatomic, strong) UITableViewCell *containerTableViewCell;
@property (nonatomic, assign) BOOL canChildScroll;
@property (nonatomic, assign) BOOL canContentScroll;
@property (nonatomic, assign) TabHeaderStyle headerStyle;
@property (nonatomic, strong) UIView *tabBarContainerView;
@end

@implementation TfyCU_TabBarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self _setup];
    }
    return self;
}

- (void)_setup {
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    
    _tabBar = [[TfyCU_TabBar alloc] init];
    _tabBar.delegate = self;
    
    _contentScrollView = [[_TabContentScrollView alloc] initWithFrame:self.frame];
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.scrollEnabled = NO;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.showsVerticalScrollIndicator = NO;
    _contentScrollView.scrollsToTop = NO;
    _contentScrollView.delegate = self;
    _contentScrollView.tfy_delegate = self;
    _contentScrollView.interceptRightSlideGuetureInFirstPage = self.interceptRightSlideGuetureInFirstPage;
    _contentScrollView.interceptLeftSlideGuetureInLastPage = self.interceptLeftSlideGuetureInLastPage;
    [self addSubview:_contentScrollView];

    _loadViewOfChildContollerWhileAppear = NO;
    _removeViewOfChildContollerWhileDeselected = YES;
    _selectedTabIndex = NSNotFound;
    _defaultSelectedTabIndex = 0;
    _isDefaultSelectedTabIndexSetuped = NO;
}

- (void)setTabBar:(TfyCU_TabBar *)tabBar {
    _tabBar = tabBar;
    _tabBar.delegate = self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    if (CGRectEqualToRect(frame, CGRectZero)) {
        return;
    }
    if (!self.headerView) {
        self.contentScrollView.frame = self.bounds;
    }
    [self updateContentViewsFrame];
}


- (void)setViewControllers:(NSArray *)viewControllers {
    for (UIViewController *vc in _viewControllers) {
        [vc removeFromParentViewController];
        if (vc.isViewLoaded) {
            [vc.view removeFromSuperview];
        }
    }

    _viewControllers = [viewControllers copy];
    
    UIViewController *containerVC = [self containerViewController];

    NSMutableArray *items = [NSMutableArray array];
    for (UIViewController *vc in _viewControllers) {
        if (containerVC) {
            [containerVC addChildViewController:vc];
        }
        
        TfyCU_TabBarItem *item = [TfyCU_TabBarItem buttonWithType:UIButtonTypeCustom];
        item.image = vc.tfy_tabItemImage;
        item.selectedImage = vc.tfy_tabItemSelectedImage;
        item.title = vc.tfy_tabItemTitle;
        [items addObject:item];
    }
    self.tabBar.items = items;

    // 更新scrollView的content size
    if (self.contentScrollEnabled) {
        self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.bounds.size.width * _viewControllers.count,
                self.contentScrollView.bounds.size.height);
    }
    
    if (self.isDefaultSelectedTabIndexSetuped) {
        _selectedTabIndex = NSNotFound;
        self.tabBar.selectedItemIndex = 0;
    }
}

- (void)setContentScrollEnabledAndTapSwitchAnimated:(BOOL)switchAnimated {
    self.contentScrollView.scrollEnabled = YES;
    self.contentScrollEnabled = YES;
    [self updateContentViewsFrame];
    self.contentSwitchAnimated = switchAnimated;
}

- (void)setContentScrollEnabled:(BOOL)enabled tapSwitchAnimated:(BOOL)animated {
    if (!self.contentScrollEnabled && enabled) {
        self.contentScrollEnabled = enabled;
        [self updateContentViewsFrame];
    }
    self.contentScrollView.scrollEnabled = enabled;
    self.contentSwitchAnimated = animated;
}

- (void)updateContentViewsFrame {
    if (self.contentScrollEnabled) {
        self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.bounds.size.width * self.viewControllers.count, self.contentScrollView.bounds.size.height);
        [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *_Nonnull controller,
                NSUInteger idx, BOOL *_Nonnull stop) {
            if (controller.isViewLoaded) {
                controller.view.frame = [self frameForControllerAtIndex:idx];
            }
        }];
        [self.contentScrollView scrollRectToVisible:self.selectedController.view.frame animated:NO];
    } else {
        self.contentScrollView.contentSize = self.contentScrollView.bounds.size;
        self.selectedController.view.frame = self.contentScrollView.bounds;
    }
}

- (CGRect)frameForControllerAtIndex:(NSUInteger)index {
    return CGRectMake(index * self.contentScrollView.bounds.size.width,
                      0,
                      self.contentScrollView.bounds.size.width,
                      self.contentScrollView.bounds.size.height);
}

- (void)setInterceptRightSlideGuetureInFirstPage:(BOOL)interceptRightSlideGuetureInFirstPage {
    _interceptRightSlideGuetureInFirstPage = interceptRightSlideGuetureInFirstPage;
    self.contentScrollView.interceptRightSlideGuetureInFirstPage = interceptRightSlideGuetureInFirstPage;
}

- (void)setInterceptLeftSlideGuetureInLastPage:(BOOL)interceptLeftSlideGuetureInLastPage {
    _interceptLeftSlideGuetureInLastPage = interceptLeftSlideGuetureInLastPage;
    self.contentScrollView.interceptLeftSlideGuetureInLastPage = interceptLeftSlideGuetureInLastPage;
}

- (void)setSelectedTabIndex:(NSUInteger)selectedTabIndex {
    self.tabBar.selectedItemIndex = selectedTabIndex;
}

- (UIViewController *)selectedController {
    if (self.selectedTabIndex != NSNotFound) {
        return self.viewControllers[self.selectedTabIndex];
    }
    return nil;
}

- (UIScrollView *)containerScrollView {
    return self.contentScrollView;
}

- (UIViewController *)containerViewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark - Super

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    if (self.isDefaultSelectedTabIndexSetuped) {
        return;
    }
    
    UIViewController *vc = [self containerViewController];
    __weak UIViewController *weakVC = vc;
    __weak TfyCU_TabBarView *weakSelf = self;
    vc.tfy_willAppearInjectBlock = ^(UIViewController *viewController, BOOL animated) {
        __strong UIViewController *strongVC = weakVC;
        __strong TfyCU_TabBarView *strongSelf = weakSelf;
        strongSelf.selectedTabIndex = self.defaultSelectedTabIndex;
        strongSelf.isDefaultSelectedTabIndexSetuped = YES;
        strongVC.tfy_willAppearInjectBlock = nil;
    };
}

#pragma mark - HeaderView

- (void)setHeaderView:(UIView *)headerView
                style:(TabHeaderStyle)style
         headerHeight:(CGFloat)headerHeight
         tabBarHeight:(CGFloat)tabBarHeight
tabBarStopOnTopHeight:(CGFloat)tabBarStopOnTopHeight
                frame:(CGRect)frame {
    if (!headerView) {
        return;
    }
    self.frame = frame;
    self.headerView = headerView;
    
    self.headerView.frame = CGRectMake(0, 0, self.bounds.size.width, headerHeight);

    self.headerStyle = style;
    self.headerViewDefaultHeight = headerHeight;
    self.tabBarStopOnTopHeight = tabBarStopOnTopHeight;
    
    [self.contentScrollView removeFromSuperview];
    
    self.containerTableView = [[TfyCU_TabBarTableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    self.containerTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.containerTableView.delegate = self;
    self.containerTableView.dataSource = self;
    
    if (style == TabHeaderStyleStretch) {
        UIView *view = [[UIView alloc] initWithFrame:self.headerView.bounds];
        self.containerTableView.tableHeaderView = view;
        [self.containerTableView addSubview:self.headerView];
    } else {
        self.containerTableView.tableHeaderView = self.headerView;
    }
    
    if (@available(iOS 11.0, *)) {
        self.containerTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self addSubview:self.containerTableView];
    
    self.contentScrollView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - tabBarHeight - self.tabBarStopOnTopHeight);
    self.containerTableViewCell = [[UITableViewCell alloc] init];
    [self.containerTableViewCell.contentView addSubview:self.contentScrollView];
    
    self.tabBarContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, tabBarHeight)];
    self.tabBar.frame = self.tabBarContainerView.bounds;
    [self.tabBar removeFromSuperview];
    [self.tabBarContainerView addSubview:self.tabBar];
    
    self.canContentScroll = YES;
    self.canChildScroll = NO;
}

- (void)containerTableViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != self.containerTableView) {
        return;
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat stopY = self.headerViewDefaultHeight - self.tabBarStopOnTopHeight;
    if (!self.canContentScroll) {
        // 这里通过固定contentOffset的值，来实现不滚动
        self.containerTableView.contentOffset = CGPointMake(0, stopY);
    } else if (self.containerTableView.contentOffset.y >= stopY) {
        self.containerTableView.contentOffset = CGPointMake(0, stopY);
        self.canContentScroll = NO;
        self.canChildScroll = YES;
    }
    
    scrollView.showsVerticalScrollIndicator = !_canChildScroll;
    
    if (self.headerStyle == TabHeaderStyleStretch) {
        if (offsetY <= 0) {
            self.headerView.frame = CGRectMake(0,
                                               offsetY,
                                               self.headerView.frame.size.width,
                                               self.headerViewDefaultHeight - offsetY);
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabContentView:didChangedContentOffsetY:)]) {
        [self.delegate tabContentView:self didChangedContentOffsetY:scrollView.contentOffset.y];
    }
}

- (void)childScrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.canChildScroll) {
        self.selectedController.tfy_scrollView.contentOffset = CGPointZero;
    } else if (self.selectedController.tfy_scrollView.contentOffset.y <= 0) {
        self.selectedController.tfy_scrollView.contentOffset = CGPointZero;
        self.canChildScroll = NO;
        self.canContentScroll = YES;
        for (UIViewController *vc in self.viewControllers) {
            if (vc.isViewLoaded) {
                vc.tfy_scrollView.contentOffset = CGPointZero;
            }
        }
    }
    scrollView.showsVerticalScrollIndicator = _canChildScroll;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.containerTableViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.contentScrollView.frame.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.tabBarContainerView.frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.tabBarContainerView;
}

#pragma mark - TabBarDelegate

- (BOOL)tfy_tabBar:(TfyCU_TabBar *)tabBar shouldSelectItemAtIndex:(NSUInteger)index {
    return [self shouldSelectItemAtIndex:index];
}

- (void)tfy_tabBar:(TfyCU_TabBar *)tabBar willSelectItemAtIndex:(NSUInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabContentView:willSelectTabAtIndex:)]) {
        [self.delegate tabContentView:self willSelectTabAtIndex:index];
    }
}

- (void)tfy_tabBar:(TfyCU_TabBar *)tabBar didSelectedItemAtIndex:(NSUInteger)index {
    if (index == self.selectedTabIndex) {
        return;
    }
    UIViewController *oldController = nil;
    if (self.selectedTabIndex != NSNotFound) {
        oldController = self.viewControllers[self.selectedTabIndex];
        [oldController tfy_tabItemDidDeselected];
        if (!self.contentScrollEnabled ||
                (self.contentScrollEnabled && self.removeViewOfChildContollerWhileDeselected)) {
            [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *_Nonnull controller, NSUInteger idx, BOOL *_Nonnull stop) {
                if (idx != index && controller.isViewLoaded && controller.view.superview) {
                    [controller.view removeFromSuperview];
                }
            }];
        }
    }
    UIViewController *curController = self.viewControllers[index];
    if (self.contentScrollEnabled) {
        // contentView支持滚动
        curController.view.frame = [self frameForControllerAtIndex:index];

        [self.contentScrollView addSubview:curController.view];
        // 切换到curController
        [self.contentScrollView scrollRectToVisible:curController.view.frame animated:self.contentSwitchAnimated];

    } else {
        // contentView不支持滚动
        // 设置curController.view的frame
        curController.view.frame = self.contentScrollView.bounds;
        [self.contentScrollView addSubview:curController.view];
    }
    
    if (self.headerView && !curController.tfy_scrollView.tfy_didScrollHandler) {
        __weak TfyCU_TabBarView *weakSelf = self;
        curController.tfy_scrollView.tfy_didScrollHandler = ^(UIScrollView *scrollView) {
            __strong TfyCU_TabBarView *strongSelf = weakSelf;
            [strongSelf childScrollViewDidScroll:scrollView];
        };
    }

    // 获取是否是第一次被选中的标识
    
    if (curController.tfy_hasBeenDisplayed) {
        [curController tfy_tabItemDidSelected:NO];
    } else {
        [curController tfy_tabItemDidSelected:YES];
        curController.tfy_hasBeenDisplayed = YES;
    }

    // 当contentView为scrollView及其子类时，设置它支持点击状态栏回到顶部
    if (oldController && [oldController.view isKindOfClass:[UIScrollView class]]) {
        [(UIScrollView *) oldController.view setScrollsToTop:NO];
    }
    if ([curController.view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *curScrollView = (UIScrollView *) curController.view;
        [curScrollView setScrollsToTop:YES];
    }

    _selectedTabIndex = index;

    if (self.delegate && [self.delegate respondsToSelector:@selector(tabContentView:didSelectedTabAtIndex:)]) {
        [self.delegate tabContentView:self didSelectedTabAtIndex:index];
    }
}

#pragma mark - _TabContentScrollViewDelegate

- (BOOL)scrollView:(_TabContentScrollView *)scrollView shouldScrollToPageIndex:(NSUInteger)index {
    return [self shouldSelectItemAtIndex:index];
}

- (BOOL)shouldSelectItemAtIndex:(NSUInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabContentView:shouldSelectTabAtIndex:)]) {
        return [self.delegate tabContentView:self shouldSelectTabAtIndex:index];
    }
    return YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.contentScrollView) {
        NSUInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
        self.tabBar.selectedItemIndex = page;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.containerTableView) {
        [self containerTableViewDidScroll:scrollView];
        return;
    }
    // 如果不是手势拖动导致的此方法被调用，不处理
    if (!(scrollView.isDragging || scrollView.isDecelerating)) {
        if (scrollView.contentOffset.x == 0) {
            // 解决有时候滑动冲突后scrollView跳动导致的item颜色显示错乱的问题
            [self.tabBar updateSubViewsWhenParentScrollViewScroll:self.contentScrollView];
        }
        return;
    }

    // 滑动越界不处理
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat scrollViewWidth = scrollView.frame.size.width;

    if (offsetX < 0) {
        return;
    }
    if (offsetX > scrollView.contentSize.width - scrollViewWidth) {
        return;
    }

    NSUInteger leftIndex = offsetX / scrollViewWidth;
    NSUInteger rightIndex = leftIndex + 1;

    // 这里处理shouldSelectItemAtIndex方法
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabContentView:shouldSelectTabAtIndex:)] && !scrollView.isDecelerating) {
        NSUInteger targetIndex;
        if (_lastContentScrollViewOffsetX < (CGFloat)offsetX) {
            // 向左
            targetIndex = rightIndex;
        } else {
            // 向右
            targetIndex = leftIndex;
        }
        if (targetIndex != self.selectedTabIndex) {
            if (![self shouldSelectItemAtIndex:targetIndex]) {
                [scrollView setContentOffset:CGPointMake(self.selectedTabIndex * scrollViewWidth, 0) animated:NO];
            }
        }
    }
    _lastContentScrollViewOffsetX = offsetX;

    // 刚好处于能完整显示一个child view的位置
    if (leftIndex == offsetX / scrollViewWidth) {
        rightIndex = leftIndex;
    }
    // 将需要显示的child view放到scrollView上
    for (NSUInteger index = leftIndex; index <= rightIndex; index++) {
        UIViewController *controller = self.viewControllers[index];

        if (!controller.isViewLoaded && self.loadViewOfChildContollerWhileAppear) {
            CGRect frame = [self frameForControllerAtIndex:index];
            controller.view.frame = frame;
        }
        if (controller.isViewLoaded && !controller.view.superview) {
            [self.contentScrollView addSubview:controller.view];
        }
    }

    // 同步修改tarBar的子视图状态
    [self.tabBar updateSubViewsWhenParentScrollViewScroll:self.contentScrollView];
}

@end

@implementation _TabContentScrollView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isKindOfClass:[UISlider class]]) {
        self.scrollEnabled = NO;
    } else {
        self.scrollEnabled = YES;
    }
    return view;
}

/**
 *  重写此方法，在需要的时候，拦截UIPanGestureRecognizer
 */
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    if (![gestureRecognizer respondsToSelector:@selector(translationInView:)]) {
        return YES;
    }
    // 计算可能切换到的index
    NSInteger currentIndex = self.contentOffset.x / self.frame.size.width;
    NSInteger targetIndex = currentIndex;
    
    CGPoint translation = [gestureRecognizer translationInView:self];
    if (translation.x > 0) {
        targetIndex = currentIndex - 1;
    } else {
        targetIndex = currentIndex + 1;
    }
    
    // 第一页往右滑动
    if (self.interceptRightSlideGuetureInFirstPage && targetIndex < 0) {
        return NO;
    }
    
    // 最后一页往左滑动
    if (self.interceptLeftSlideGuetureInLastPage) {
        NSUInteger numberOfPage = self.contentSize.width / self.frame.size.width;
        if (targetIndex >= numberOfPage) {
            return NO;
        }
    }
    
    // 其他情况
    if (self.tfy_delegate && [self.tfy_delegate respondsToSelector:@selector(scrollView:shouldScrollToPageIndex:)]) {
        return [self.tfy_delegate scrollView:self shouldScrollToPageIndex:targetIndex];
    }
    
    return YES;
}

@end


@implementation UIScrollView (TfyCU_TabBar)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString *methodName = [NSString stringWithFormat:@"%@%@%@%@", @"_", @"notify", @"Did", @"Scroll"];
        SEL originalSel = NSSelectorFromString(methodName);
        SEL swizzledSel = @selector(tfy_didScroll);
        
        Method originalMethod = class_getInstanceMethod(self, originalSel);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSel);
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

- (void)tfy_didScroll {
    if (self.tfy_didScrollHandler) {
        self.tfy_didScrollHandler(self);
    }
    [self tfy_didScroll];
}

- (void)setTfy_didScrollHandler:(void (^)(UIScrollView *))tfy_didScrollHandler {
    objc_setAssociatedObject(self, @selector(tfy_didScrollHandler), tfy_didScrollHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIScrollView *))tfy_didScrollHandler {
    return objc_getAssociatedObject(self, _cmd);
}


@end
