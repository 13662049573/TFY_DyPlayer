//
//  TfyCU_TabBar.m
//  TFY_TabBarController
//
//  Created by tiandengyou on 2019/11/28.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TfyCU_TabBar.h"

#define BADGE_BG_COLOR_DEFAULT [UIColor colorWithRed:252 / 255.0f green:15 / 255.0f blue:29 / 255.0f alpha:1.0f]

typedef NS_ENUM(NSInteger, TabBarIndicatorStyle) {
    TabBarIndicatorStyleFitItem,
    TabBarIndicatorStyleFitTitle,
    TabBarIndicatorStyleFixedWidth,
};

@interface TfyCU_TabBar (){
    CGFloat _scrollViewLastOffsetX;
}
// 当TabBar支持滚动时，使用此scrollView
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) TfyCU_TabBarItem *specialItem;
@property (nonatomic, copy) void (^specialItemHandler)(TfyCU_TabBarItem *item);

// 选中背景
@property (nonatomic, strong) UIImageView *indicatorImageView;

// 选中背景相对于TFY_TabItem的insets
@property (nonatomic, assign) UIEdgeInsets indicatorInsets;
@property (nonatomic, assign) TabBarIndicatorStyle indicatorStyle;
@property (nonatomic, assign) CGFloat indicatorWidthFixTitleAdditional;
@property (nonatomic, assign) CGFloat indicatorWidth;

// Item是否匹配title的文字宽度
@property (nonatomic, assign) BOOL itemFitTextWidth;

// 当Item匹配title的文字宽度时，左右留出的空隙，item的宽度 = 文字宽度 + spacing
@property (nonatomic, assign) CGFloat itemFitTextWidthSpacing;

// item的宽度
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, assign) CGFloat itemMinWidth;

// 数字样式的badge相关属性
@property (nonatomic, assign) CGFloat numberBadgeMarginTop;
@property (nonatomic, assign) CGFloat numberBadgeCenterMarginRight;
@property (nonatomic, assign) CGFloat numberBadgeTitleHorizonalSpace;
@property (nonatomic, assign) CGFloat numberBadgeTitleVerticalSpace;

// 小圆点样式的badge相关属性
@property (nonatomic, assign) CGFloat dotBadgeMarginTop;
@property (nonatomic, assign) CGFloat dotBadgeCenterMarginRight;
@property (nonatomic, assign) CGFloat dotBadgeSideLength;

// 分割线相关属性
@property (nonatomic, strong) NSMutableArray *separatorLayers;
@property (nonatomic, strong) UIColor *itemSeparatorColor;
@property (nonatomic, assign) CGFloat itemSeparatorThickness;
@property (nonatomic, assign) CGFloat itemSeparatorLeading;
@property (nonatomic, assign) CGFloat itemSeparatorTrailing;

@property (nonatomic, assign) BOOL isVertical;

@end

@implementation TfyCU_TabBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self _setup];
}

- (void)_setup {
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    
    _selectedItemIndex = NSNotFound;
    _itemTitleColor = [UIColor whiteColor];
    _itemTitleSelectedColor = [UIColor blackColor];
    _itemTitleFont = [UIFont systemFontOfSize:10];
    
    _itemContentHorizontalCenter = YES;
    _itemFontChangeFollowContentScroll = NO;
    _itemColorChangeFollowContentScroll = YES;
    _indicatorScrollFollowContent = NO;
    
    _badgeTitleColor = [UIColor whiteColor];
    _badgeTitleFont = [UIFont systemFontOfSize:13];
    _badgeBackgroundColor = BADGE_BG_COLOR_DEFAULT;
    
    _numberBadgeMarginTop = 2;
    _numberBadgeCenterMarginRight = 30;
    _numberBadgeTitleHorizonalSpace = 8;
    _numberBadgeTitleVerticalSpace = 2;
    
    _dotBadgeMarginTop = 5;
    _dotBadgeCenterMarginRight = 25;
    _dotBadgeSideLength = 10;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollEnabled = NO;
    [self addSubview:_scrollView];
    
    _indicatorImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_scrollView addSubview:_indicatorImageView];
}

- (void)setClipsToBounds:(BOOL)clipsToBounds {
    [super setClipsToBounds:clipsToBounds];
    self.scrollView.clipsToBounds = clipsToBounds;
}

- (void)setFrame:(CGRect)frame {
    BOOL resize = !CGSizeEqualToSize(frame.size, self.frame.size);
    [super setFrame:frame];
    if (resize) {
        self.scrollView.frame = self.bounds;
        [self updateAllUI];
    }
}

- (void)setItems:(NSArray *)items {
    _selectedItemIndex = NSNotFound;
    
    // 将老的item从superview上删除
    [_items makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _items = [items copy];
    
    // 初始化每一个item
    for (TfyCU_TabBarItem *item in self.items) {
        item.titleColor = self.itemTitleColor;
        item.titleSelectedColor = self.itemTitleSelectedColor;
        item.titleFont = self.itemTitleFont;
        
        if ([item imageForState:UIControlStateNormal]) {
            [item setContentHorizontalCenterAndMarginTop:5 spacing:5];
        }
        
        item.badgeTitleFont = self.badgeTitleFont;
        item.badgeTitleColor = self.badgeTitleColor;
        item.badgeBackgroundColor = self.badgeBackgroundColor;
        item.badgeBackgroundImage = self.badgeBackgroundImage;
        
        [item setNumberBadgeMarginTop:self.numberBadgeMarginTop
                    centerMarginRight:self.numberBadgeCenterMarginRight
                  titleHorizonalSpace:self.numberBadgeTitleHorizonalSpace
                   titleVerticalSpace:self.numberBadgeTitleVerticalSpace];
        [item setDotBadgeMarginTop:self.dotBadgeMarginTop
                 centerMarginRight:self.dotBadgeCenterMarginRight
                        sideLength:self.dotBadgeSideLength];
        
        [item addTarget:self action:@selector(tabItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:item];
    }
    
    // 更新item的大小缩放
    [self updateItemsScaleIfNeeded];
    [self updateAllUI];
}

- (void)setTitles:(NSArray *)titles {
    NSMutableArray *items = [NSMutableArray array];
    for (NSString *title in titles) {
        TfyCU_TabBarItem *item = [[TfyCU_TabBarItem alloc] init];
        item.title = title;
        [items addObject:item];
    }
    self.items = items;
}

- (void)setLeadingSpace:(CGFloat)leadingSpace {
    _leadingSpace = leadingSpace;
    [self updateAllUI];
}

- (void)setTrailingSpace:(CGFloat)trailingSpace {
    _trailingSpace = trailingSpace;
    [self updateAllUI];
}

- (void)updateAllUI {
    [self updateItemsFrame];
    [self updateItemIndicatorInsets];
    [self updateIndicatorFrameWithIndex:self.selectedItemIndex];
    [self updateSeperators];
}

- (void)updateItemsFrame {
    if (self.items.count == 0) {
        return;
    }
    
    if (self.isVertical) {
        // 支持滚动
        CGFloat y = self.leadingSpace;
        if (!self.scrollView.scrollEnabled) {
            self.itemHeight = ceilf((self.frame.size.height - self.leadingSpace - self.trailingSpace) / self.items.count);
        }
        for (NSUInteger index = 0; index < self.items.count; index++) {
            TfyCU_TabBarItem *item = self.items[index];
            item.frame = CGRectMake(0, y, self.frame.size.width, self.itemHeight);
            item.index = index;
            y += self.itemHeight;
        }
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, MAX(y + self.trailingSpace, self.scrollView.frame.size.height));
    } else {
        if (self.scrollView.scrollEnabled) {
            // 支持滚动
            CGFloat x = self.leadingSpace;
            for (NSUInteger index = 0; index < self.items.count; index++) {
                TfyCU_TabBarItem *item = self.items[index];
                CGFloat width = 0;
                // item的宽度为一个固定值
                if (self.itemWidth > 0) {
                    width = self.itemWidth;
                }
                // item的宽度为根据字体大小和spacing进行适配
                if (self.itemFitTextWidth) {
                    width = MAX(item.titleWidth + self.itemFitTextWidthSpacing, self.itemMinWidth);
                }
                item.frame = CGRectMake(x, 0, width, self.frame.size.height);
                item.index = index;
                x += width;
            }
            self.scrollView.contentSize = CGSizeMake(MAX(x + self.trailingSpace, self.scrollView.frame.size.width),
                                                     self.scrollView.frame.size.height);
        } else {
            // 不支持滚动
            
            CGFloat x = self.leadingSpace;
            CGFloat allItemsWidth = self.frame.size.width - self.leadingSpace - self.trailingSpace;
            if (self.specialItem && self.specialItem.frame.size.width != 0) {
                self.itemWidth = (allItemsWidth - self.specialItem.frame.size.width) / self.items.count;
            } else {
                self.itemWidth = allItemsWidth / self.items.count;
            }
            
            // 四舍五入，取整，防止字体模糊
            self.itemWidth = floorf(self.itemWidth + 0.5f);
            
            for (NSUInteger index = 0; index < self.items.count; index++) {
                TfyCU_TabBarItem *item = self.items[index];
                item.frame = CGRectMake(x, 0, self.itemWidth, self.frame.size.height);
                item.index = index;
                
                x += self.itemWidth;
                
                // 如果有特殊的单独item，设置其位置
                if (self.specialItem && self.specialItem.index == index) {
                    CGFloat width = self.specialItem.frame.size.width;
                    // 如果宽度为0，将其宽度设置为itemWidth
                    if (width == 0) {
                        width = self.itemWidth;
                    }
                    CGFloat height = self.specialItem.frame.size.height;
                    // 如果高度为0，将其宽度设置为tabBar的高度
                    if (height == 0) {
                        height = self.frame.size.height;
                    }
                    self.specialItem.frame = CGRectMake(x, self.frame.size.height - height, width, height);
                    x += width;
                }
            }
            self.scrollView.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
        }
    }
}

/**
 *  更新选中背景的frame
 */
- (void)updateIndicatorFrameWithIndex:(NSUInteger)index {
    if (self.items.count == 0 || index == NSNotFound) {
        self.indicatorImageView.frame = CGRectZero;
        return;
    }
    TfyCU_TabBarItem *item = self.items[index];
    self.indicatorImageView.frame = item.indicatorFrame;
}

- (void)setSelectedItemIndex:(NSUInteger)selectedItemIndex {
    [self setSelectedItemIndex:selectedItemIndex animated:self.indicatorSwitchAnimated callDelegate:YES];
}

- (void)setSelectedItemIndex:(NSUInteger)selectedItemIndex animated:(BOOL)animated {
    [self setSelectedItemIndex:selectedItemIndex animated:animated callDelegate:YES];
}

- (void)setSelectedItemIndex:(NSUInteger)selectedItemIndex animated:(BOOL)animated callDelegate:(BOOL)callDelegate {
    if (selectedItemIndex == _selectedItemIndex ||
        selectedItemIndex >= self.items.count ||
        self.items.count == 0) {
        return;
    }
    
    if (callDelegate && self.delegate && [self.delegate respondsToSelector:@selector(tfy_tabBar:shouldSelectItemAtIndex:)]) {
        BOOL should = [self.delegate tfy_tabBar:self shouldSelectItemAtIndex:selectedItemIndex];
        if (!should) {
            return;
        }
    }
    if (callDelegate && self.delegate && [self.delegate respondsToSelector:@selector(tfy_tabBar:willSelectItemAtIndex:)]) {
        [self.delegate tfy_tabBar:self willSelectItemAtIndex:selectedItemIndex];
    }
    
    if (_selectedItemIndex != NSNotFound) {
        TfyCU_TabBarItem *oldSelectedItem = self.items[_selectedItemIndex];
        oldSelectedItem.selected = NO;
        if (self.itemTitleSelectedFont) {
            if (self.itemFontChangeFollowContentScroll) {
                // 如果支持字体平滑渐变切换，则设置item的scale
                oldSelectedItem.transform = CGAffineTransformMakeScale(self.itemTitleUnselectedFontScale,
                                                                       self.itemTitleUnselectedFontScale);
                oldSelectedItem.titleFont = [self.itemTitleFont fontWithSize:self.itemTitleSelectedFont.pointSize];
            } else {
                oldSelectedItem.titleFont = self.itemTitleFont;
            }
        }
    }
    
    TfyCU_TabBarItem *newSelectedItem = self.items[selectedItemIndex];
    newSelectedItem.selected = YES;
    
    if (self.itemTitleSelectedFont) {
        if (self.itemFontChangeFollowContentScroll) {
            // 如果支持字体平滑渐变切换，则设置item的scale
            newSelectedItem.transform = CGAffineTransformMakeScale(1, 1);
        }
        newSelectedItem.titleFont = self.itemTitleSelectedFont;
    }
    
    if (animated && _selectedItemIndex != NSNotFound) {
        [UIView animateWithDuration:0.25f animations:^{
            [self updateIndicatorFrameWithIndex:selectedItemIndex];
        }];
    } else {
        [self updateIndicatorFrameWithIndex:selectedItemIndex];
    }
    
    _selectedItemIndex = selectedItemIndex;
    
    // 如果tabbar支持滚动，将选中的item放到tabbar的中央
    [self setSelectedItemCenter];
    
    if (callDelegate && self.delegate && [self.delegate respondsToSelector:@selector(tfy_tabBar:didSelectedItemAtIndex:)]) {
        [self.delegate tfy_tabBar:self didSelectedItemAtIndex:selectedItemIndex];
    }
}

- (void)setScrollEnabledAndItemWidth:(CGFloat)width {
    self.scrollView.scrollEnabled = YES;
    self.itemWidth = width;
    self.itemFitTextWidth = NO;
    self.itemFitTextWidthSpacing = 0;
    self.itemMinWidth = 0;
    [self updateItemsFrame];
}

- (void)setScrollEnabledAndItemFitTextWidthWithSpacing:(CGFloat)spacing {
    [self setScrollEnabledAndItemFitTextWidthWithSpacing:spacing minWidth:0];
}

- (void)setScrollEnabledAndItemFitTextWidthWithSpacing:(CGFloat)spacing minWidth:(CGFloat)minWidth {
    self.scrollView.scrollEnabled = YES;
    self.itemFitTextWidth = YES;
    self.itemFitTextWidthSpacing = spacing;
    self.itemWidth = 0;
    self.itemMinWidth = minWidth;
    [self updateItemsFrame];
}

- (void)layoutTabItemsVertical {
    self.isVertical = YES;
    if (self.items.count == 0) {
        return;
    }
    [self updateAllUI];
}

- (void)layoutTabItemsVerticalWithItemHeight:(CGFloat)height {
    self.isVertical = YES;
    if (self.items.count == 0) {
        return;
    }
    self.scrollView.scrollEnabled = YES;
    self.itemHeight = height;
    [self updateAllUI];
}

- (void)setSelectedItemCenter {
    if (!self.scrollView.scrollEnabled || self.isVertical) {
        return;
    }
    // 修改偏移量
    CGFloat offsetX = self.selectedItem.center.x - self.scrollView.frame.size.width * 0.5f;
    // 处理最小滚动偏移量
    if (offsetX < 0) {
        offsetX = 0;
    }
    // 处理最大滚动偏移量
    CGFloat maxOffsetX = self.scrollView.contentSize.width - self.scrollView.frame.size.width;
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}


/**
 *  获取未选中字体与选中字体大小的比例
 */
- (CGFloat)itemTitleUnselectedFontScale {
    if (_itemTitleSelectedFont) {
        return self.itemTitleFont.pointSize / _itemTitleSelectedFont.pointSize;
    }
    return 1.0f;
}

- (void)tabItemClicked:(TfyCU_TabBarItem *)item {
    self.selectedItemIndex = item.index;
}

- (void)specialItemClicked:(TfyCU_TabBarItem *)item {
    if (self.specialItemHandler) {
        self.specialItemHandler(item);
    }
}

- (TfyCU_TabBarItem *)selectedItem {
    if (self.selectedItemIndex == NSNotFound) {
        return nil;
    }
    return self.items[self.selectedItemIndex];
}

- (void)setSpecialItem:(TfyCU_TabBarItem *)item afterItemWithIndex:(NSUInteger)index tapHandler:(void (^)(TfyCU_TabBarItem *item))handler {
    self.specialItem = item;
    self.specialItem.index = index;
    [self.specialItem addTarget:self action:@selector(specialItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:item];
    [self updateItemsFrame];
    
    self.specialItemHandler = handler;
}

#pragma mark - indicator

- (void)setIndicatorColor:(UIColor *)indicatorColor {
    _indicatorColor = indicatorColor;
    self.indicatorImageView.backgroundColor = indicatorColor;
}

- (void)setIndicatorImage:(UIImage *)indicatorImage {
    _indicatorImage = indicatorImage;
    self.indicatorImageView.image = indicatorImage;
}

- (void)setIndicatorCornerRadius:(CGFloat)indicatorCornerRadius {
    _indicatorCornerRadius = indicatorCornerRadius;
    self.indicatorImageView.clipsToBounds = YES;
    self.indicatorImageView.layer.cornerRadius = indicatorCornerRadius;
}

- (void)setIndicatorInsets:(UIEdgeInsets)insets
         tapSwitchAnimated:(BOOL)animated {
    self.indicatorStyle = TabBarIndicatorStyleFitItem;
    self.indicatorSwitchAnimated = animated;
    self.indicatorInsets = insets;
    
    [self updateItemIndicatorInsets];
    [self updateIndicatorFrameWithIndex:self.selectedItemIndex];
}

- (void)setIndicatorWidthFitTextAndMarginTop:(CGFloat)top marginBottom:(CGFloat)bottom widthAdditional:(CGFloat)additional tapSwitchAnimated:(BOOL)animated {
    self.indicatorStyle = TabBarIndicatorStyleFitTitle;
    self.indicatorSwitchAnimated = animated;
    self.indicatorInsets = UIEdgeInsetsMake(top, 0, bottom, 0);
    self.indicatorWidthFixTitleAdditional = additional;
    
    [self updateItemIndicatorInsets];
    [self updateIndicatorFrameWithIndex:self.selectedItemIndex];
}

- (void)setIndicatorWidth:(CGFloat)width marginTop:(CGFloat)top marginBottom:(CGFloat)bottom tapSwitchAnimated:(BOOL)animated {
    self.indicatorStyle = TabBarIndicatorStyleFixedWidth;
    self.indicatorSwitchAnimated = animated;
    self.indicatorInsets = UIEdgeInsetsMake(top, 0, bottom, 0);
    self.indicatorWidth = width;
    
    [self updateItemIndicatorInsets];
    [self updateIndicatorFrameWithIndex:self.selectedItemIndex];
}

- (void)updateItemIndicatorInsets {
    for (TfyCU_TabBarItem *item in self.items) {
        if (self.indicatorStyle == TabBarIndicatorStyleFitTitle) {
            CGRect frame = item.frameWithOutTransform;
            CGFloat space = (frame.size.width - item.titleWidth - self.indicatorWidthFixTitleAdditional) / 2;
            item.indicatorInsets = UIEdgeInsetsMake(self.indicatorInsets.top, space, self.indicatorInsets.bottom, space);
        } else if (self.indicatorStyle == TabBarIndicatorStyleFixedWidth) {
            for (TfyCU_TabBarItem *item in self.items) {
                CGRect frame = item.frameWithOutTransform;
                CGFloat space = (frame.size.width - self.indicatorWidth) / 2;
                item.indicatorInsets = UIEdgeInsetsMake(self.indicatorInsets.top, space, self.indicatorInsets.bottom, space);
            }
        } else if (self.indicatorStyle == TabBarIndicatorStyleFitItem) {
            for (TfyCU_TabBarItem *item in self.items) {
                item.indicatorInsets = self.indicatorInsets;
            }
        }
    }
}

#pragma mark - ItemTitle

- (void)setItemTitleColor:(UIColor *)itemTitleColor {
    _itemTitleColor = itemTitleColor;
    [self.items makeObjectsPerformSelector:@selector(setTitleColor:) withObject:itemTitleColor];
}

- (void)setItemTitleSelectedColor:(UIColor *)itemTitleSelectedColor {
    _itemTitleSelectedColor = itemTitleSelectedColor;
    [self.items makeObjectsPerformSelector:@selector(setTitleSelectedColor:) withObject:itemTitleSelectedColor];
}

- (void)setItemTitleFont:(UIFont *)itemTitleFont {
    _itemTitleFont = itemTitleFont;
    if (self.itemFontChangeFollowContentScroll) {
        // item字体支持平滑切换，更新每个item的scale
        [self updateItemsScaleIfNeeded];
    } else {
        // item字体不支持平滑切换，更新item的字体
        if (self.itemTitleSelectedFont) {
            // 设置了选中字体，则只更新未选中的item
            for (TfyCU_TabBarItem *item in self.items) {
                if (!item.selected) {
                    item.titleFont = itemTitleFont;
                }
            }
        } else {
            // 未设置选中字体，更新所有item
            [self.items makeObjectsPerformSelector:@selector(setTitleFont:) withObject:itemTitleFont];
        }
    }
    if (self.itemFitTextWidth) {
        // 如果item的宽度是匹配文字的，更新item的位置
        [self updateItemsFrame];
    }
    [self updateIndicatorFrameWithIndex:self.selectedItemIndex];
}

- (void)setItemTitleSelectedFont:(UIFont *)itemTitleSelectedFont {
    _itemTitleSelectedFont = itemTitleSelectedFont;
    self.selectedItem.titleFont = itemTitleSelectedFont;
    [self updateItemsScaleIfNeeded];
}

- (void)setItemFontChangeFollowContentScroll:(BOOL)itemFontChangeFollowContentScroll {
    _itemFontChangeFollowContentScroll = itemFontChangeFollowContentScroll;
    [self updateItemsScaleIfNeeded];
}

- (void)updateItemsScaleIfNeeded {
    if (self.itemTitleSelectedFont && self.itemFontChangeFollowContentScroll && self.itemTitleSelectedFont.pointSize != self.itemTitleFont.pointSize) {
        UIFont *normalFont = [self.itemTitleFont fontWithSize:self.itemTitleSelectedFont.pointSize];
        
        for (TfyCU_TabBarItem *item in self.items) {
            if (item.selected) {
                item.titleFont = self.itemTitleSelectedFont;
            } else {
                item.titleFont = normalFont;
                item.transform = CGAffineTransformMakeScale(self.itemTitleUnselectedFontScale, self.itemTitleUnselectedFontScale);
            }
        }
    }
}

#pragma mark - Item Content

- (void)setItemContentHorizontalCenter:(BOOL)itemContentHorizontalCenter {
    _itemContentHorizontalCenter = itemContentHorizontalCenter;
    if (itemContentHorizontalCenter) {
        [self setItemContentHorizontalCenterAndMarginTop:5 spacing:5];
    } else {
        [self.items makeObjectsPerformSelector:@selector(setContentHorizontalCenter:) withObject:@(NO)];
    }
}

- (void)setItemContentHorizontalCenterAndMarginTop:(CGFloat)marginTop spacing:(CGFloat)spacing {
    _itemContentHorizontalCenter = YES;
    for (TfyCU_TabBarItem *item in self.items) {
        [item setContentHorizontalCenterAndMarginTop:marginTop spacing:spacing];
    }
}

#pragma mark - Badge

- (void)setBadgeBackgroundColor:(UIColor *)badgeBackgroundColor {
    _badgeBackgroundColor = badgeBackgroundColor;
    [self.items makeObjectsPerformSelector:@selector(setBadgeBackgroundColor:) withObject:badgeBackgroundColor];
}

- (void)setBadgeBackgroundImage:(UIImage *)badgeBackgroundImage {
    _badgeBackgroundImage = badgeBackgroundImage;
    [self.items makeObjectsPerformSelector:@selector(setBadgeBackgroundImage:) withObject:badgeBackgroundImage];
}

- (void)setBadgeTitleColor:(UIColor *)badgeTitleColor {
    _badgeTitleColor = badgeTitleColor;
    [self.items makeObjectsPerformSelector:@selector(setBadgeTitleColor:) withObject:badgeTitleColor];
}

- (void)setBadgeTitleFont:(UIFont *)badgeTitleFont {
    _badgeTitleFont = badgeTitleFont;
    [self.items makeObjectsPerformSelector:@selector(setBadgeTitleFont:) withObject:badgeTitleFont];
}

- (void)setNumberBadgeMarginTop:(CGFloat)marginTop centerMarginRight:(CGFloat)centerMarginRight titleHorizonalSpace:(CGFloat)titleHorizonalSpace titleVerticalSpace:(CGFloat)titleVerticalSpace {
    self.numberBadgeMarginTop = marginTop;
    self.numberBadgeCenterMarginRight = centerMarginRight;
    self.numberBadgeTitleHorizonalSpace = titleHorizonalSpace;
    self.numberBadgeTitleVerticalSpace = titleVerticalSpace;
    
    for (TfyCU_TabBarItem *item in self.items) {
        [item setNumberBadgeMarginTop:marginTop centerMarginRight:centerMarginRight titleHorizonalSpace:titleHorizonalSpace titleVerticalSpace:titleVerticalSpace];
    }
}

- (void)setDotBadgeMarginTop:(CGFloat)marginTop centerMarginRight:(CGFloat)centerMarginRight sideLength:(CGFloat)sideLength {
    self.dotBadgeMarginTop = marginTop;
    self.dotBadgeCenterMarginRight = centerMarginRight;
    self.dotBadgeSideLength = sideLength;
    
    for (TfyCU_TabBarItem *item in self.items) {
        [item setDotBadgeMarginTop:marginTop centerMarginRight:centerMarginRight sideLength:sideLength];
    }
}

#pragma mark - Separator

- (void)setItemSeparatorColor:(UIColor *)itemSeparatorColor thickness:(CGFloat)thickness leading:(CGFloat)leading trailing:(CGFloat)trailing {
    self.itemSeparatorColor = itemSeparatorColor;
    self.itemSeparatorThickness = thickness;
    self.itemSeparatorLeading = leading;
    self.itemSeparatorTrailing = trailing;
    [self updateSeperators];
}

- (void)setItemSeparatorColor:(UIColor *)itemSeparatorColor leading:(CGFloat)leading trailing:(CGFloat)trailing {
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGFloat onePixel;
    if ([mainScreen respondsToSelector:@selector(nativeScale)]) {
        onePixel = 1.0f / mainScreen.nativeScale;
    } else {
        onePixel = 1.0f / mainScreen.scale;
    }
    [self setItemSeparatorColor:itemSeparatorColor thickness:onePixel leading:leading trailing:trailing];
}

- (void)updateSeperators {
    if (self.itemSeparatorColor) {
        if (!self.separatorLayers) {
            self.separatorLayers = [[NSMutableArray alloc] init];
        }
        [self.separatorLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        [self.separatorLayers removeAllObjects];
        
        [self.items enumerateObjectsUsingBlock:^(TfyCU_TabBarItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx > 0) {
                CALayer *layer = [[CALayer alloc] init];
                layer.backgroundColor = self.itemSeparatorColor.CGColor;
                if (self.isVertical) {
                    layer.frame = CGRectMake(self.itemSeparatorLeading,
                                             item.frame.origin.y - self.itemSeparatorThickness / 2,
                                             self.bounds.size.width - self.itemSeparatorLeading - self.itemSeparatorTrailing,
                                             self.itemSeparatorThickness);
                } else {
                    layer.frame = CGRectMake(item.frame.origin.x - self.itemSeparatorThickness / 2,
                                             self.itemSeparatorLeading,
                                             self.itemSeparatorThickness,
                                             self.bounds.size.height - self.itemSeparatorLeading - self.itemSeparatorTrailing);
                }
                [self.scrollView.layer addSublayer:layer];
                [self.separatorLayers addObject:layer];
            }
        }];
    } else {
        [self.separatorLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        [self.separatorLayers removeAllObjects];
        self.separatorLayers = nil;
    }
}

#pragma mark - Others

- (void)updateSubViewsWhenParentScrollViewScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat scrollViewWidth = scrollView.frame.size.width;
    
    NSUInteger leftIndex = offsetX / scrollViewWidth;
    NSUInteger rightIndex = leftIndex + 1;
    
    TfyCU_TabBarItem *leftItem = self.items[leftIndex];
    TfyCU_TabBarItem *rightItem = nil;
    if (rightIndex < self.items.count) {
        rightItem = self.items[rightIndex];
    }
    
    // 计算右边按钮偏移量
    CGFloat rightScale = offsetX / scrollViewWidth;
    // 只想要 0~1
    rightScale = rightScale - leftIndex;
    CGFloat leftScale = 1 - rightScale;
    
    if (self.itemFontChangeFollowContentScroll && self.itemTitleUnselectedFontScale != 1.0f) {
        // 如果支持title大小跟随content的拖动进行变化，并且未选中字体和已选中字体的大小不一致
        
        // 计算字体大小的差值
        CGFloat diff = self.itemTitleUnselectedFontScale - 1;
        // 根据偏移量和差值，计算缩放值
        leftItem.transform = CGAffineTransformMakeScale(rightScale * diff + 1, rightScale * diff + 1);
        rightItem.transform = CGAffineTransformMakeScale(leftScale * diff + 1, leftScale * diff + 1);
    }
    
    if (self.itemColorChangeFollowContentScroll) {
        CGFloat normalRed, normalGreen, normalBlue, normalAlpha;
        CGFloat selectedRed, selectedGreen, selectedBlue, selectedAlpha;
        
        [self.itemTitleColor getRed:&normalRed green:&normalGreen blue:&normalBlue alpha:&normalAlpha];
        [self.itemTitleSelectedColor getRed:&selectedRed green:&selectedGreen blue:&selectedBlue alpha:&selectedAlpha];
        // 获取选中和未选中状态的颜色差值
        CGFloat redDiff = selectedRed - normalRed;
        CGFloat greenDiff = selectedGreen - normalGreen;
        CGFloat blueDiff = selectedBlue - normalBlue;
        CGFloat alphaDiff = selectedAlpha - normalAlpha;
        // 根据颜色值的差值和偏移量，设置tabItem的标题颜色
        leftItem.titleLabel.textColor = [UIColor colorWithRed:leftScale * redDiff + normalRed
                                                        green:leftScale * greenDiff + normalGreen
                                                         blue:leftScale * blueDiff + normalBlue
                                                        alpha:leftScale * alphaDiff + normalAlpha];
        rightItem.titleLabel.textColor = [UIColor colorWithRed:rightScale * redDiff + normalRed
                                                         green:rightScale * greenDiff + normalGreen
                                                          blue:rightScale * blueDiff + normalBlue
                                                         alpha:rightScale * alphaDiff + normalAlpha];
    }
    
    // 计算背景的frame
    if (self.indicatorScrollFollowContent) {
        
        if (self.indicatorAnimationStyle == TabBarIndicatorAnimationStyleDefault) {
            CGRect frame = self.indicatorImageView.frame;
            CGFloat xDiff = rightItem.indicatorFrame.origin.x - leftItem.indicatorFrame.origin.x;
            
            frame.origin.x = rightScale * xDiff + leftItem.indicatorFrame.origin.x;
            
            CGFloat widthDiff = rightItem.indicatorFrame.size.width - leftItem.indicatorFrame.size.width;
            frame.size.width = rightScale * widthDiff + leftItem.indicatorFrame.size.width;
            
            self.indicatorImageView.frame = frame;
        } else if (self.indicatorAnimationStyle == TabBarIndicatorAnimationStyle1) {
            NSUInteger page = offsetX / scrollViewWidth;
            
            NSUInteger currentIndex;
            NSUInteger targetIndex;
            
            CGFloat scale = offsetX / scrollViewWidth - page;
            if (_scrollViewLastOffsetX < offsetX) {
                currentIndex = page;
                targetIndex = page + 1;
                scale = scale * 2;
            } else if (_scrollViewLastOffsetX > offsetX) {
                currentIndex = page + 1;
                targetIndex = page;
                scale = (1 - scale) * 2;
            } else {
                return;
            }
            if (targetIndex >= self.items.count) {
                return;
            }
            
            TfyCU_TabBarItem *currentItem = self.items[currentIndex];
            TfyCU_TabBarItem *targetItem = self.items[targetIndex];
            
            CGFloat currentItemWidth = currentItem.frameWithOutTransform.size.width;
            CGFloat targetItemWidth = targetItem.frameWithOutTransform.size.width;
            
            // 设置滑动过程中，指示器的位置
            if (targetIndex > currentIndex) {
                if (scale < 1) {
                    CGFloat addition = scale * (CGRectGetMaxX(targetItem.indicatorFrame) - CGRectGetMaxX(currentItem.indicatorFrame));
                    // 小于半个屏幕距离
                    [self setIndicatorX:currentItem.indicatorFrame.origin.x
                                  width:addition + currentItem.indicatorFrame.size.width];
                } else if (scale > 1) {
                    // 大于等于半个屏幕距离
                    scale = scale - 1;
                    CGFloat addition = scale * (targetItem.indicatorFrame.origin.x - currentItem.indicatorFrame.origin.x);
                    [self setIndicatorX:currentItem.indicatorFrame.origin.x + addition
                                  width:targetItemWidth + currentItemWidth - addition - currentItem.indicatorInsets.left - targetItem.indicatorInsets.right];
                }
            } else {
                if (scale < 1) {
                    CGFloat addition = scale * (currentItem.indicatorFrame.origin.x - targetItem.indicatorFrame.origin.x);
                    [self setIndicatorX:currentItem.indicatorFrame.origin.x - addition
                                  width:addition + currentItem.indicatorFrame.size.width];
                } else if (scale > 1) {
                    scale = scale - 1;
                    CGFloat addition = (1 - scale) * (CGRectGetMaxX(currentItem.indicatorFrame) - CGRectGetMaxX(targetItem.indicatorFrame));
                    [self setIndicatorX:targetItem.indicatorFrame.origin.x
                                  width:targetItem.indicatorFrame.size.width + addition];
                }
            }
        }
    }
    _scrollViewLastOffsetX = offsetX;
}

// 设置指示器的frame
- (void)setIndicatorX:(CGFloat)x width:(CGFloat)width {
    CGRect frame = self.indicatorImageView.frame;
    frame.origin.x = x;
    frame.size.width = width;
    self.indicatorImageView.frame = frame;
}

#pragma mark - hitTest

// 让specialItem超出父视图的部分能响应事件
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (self.specialItem && !view) {
        CGPoint tp = [self.specialItem convertPoint:point fromView:self];
        if (CGRectContainsPoint(self.specialItem.bounds, tp)) {
            view = self.specialItem;
        }
    }
    return view;
}

@end
