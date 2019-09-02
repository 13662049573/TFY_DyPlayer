//
//  TFY_TabBarItem.h
//  TFY_AutoLayoutModelTools
//
//  Created by 田风有 on 2019/5/14.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFY_TabBarItem : UIControl
/**
 * itemheight是一个可选的属性。当设置是用来代替tabbar的高度。
 */
@property (nonatomic, assign)CGFloat itemHeight;

#pragma mark - Title configuration
/**
 * 选项卡栏项显示的标题。
 */
@property (nonatomic, copy)NSString *title;

/**
 * 标签栏项目标题周围矩形的偏移量。
 */
@property (nonatomic, assign)UIOffset titlePositionAdjustment;
/**
 * 标题属性用于标签栏的选中状态字典。
 */
@property (nonatomic, copy)NSDictionary *unselectedTitleAttributes;

/**
 * 标题属性字典用于标签栏项目的选择状态。
 */
@property (nonatomic, copy)NSDictionary *selectedTitleAttributes;

#pragma mark - Image configuration

/**
 * 选项卡栏项图像周围矩形的偏移量。
 */
@property (nonatomic, assign)UIOffset imagePositionAdjustment;
/**
 * 用于选项卡栏项选择状态的图像。
 */
- (UIImage *)finishedSelectedImage;
/**
 * 用于标签栏的选中状态的图像。
 */
- (UIImage *)finishedUnselectedImage;
/**
 * 设置标签栏的选中和未选中的图片。
 */
- (void)setFinishedSelectedImage:(NSString *)selectedImage_Str withFinishedUnselectedImage:(NSString *)unselectedImage_Str;

#pragma mark - Background configuration
/**
 * 用于选项卡栏项选择状态的背景图像。
 */
- (UIImage *)backgroundSelectedImage;

/**
 * 用于标签栏的选中状态的背景图像。
 */
- (UIImage *)backgroundUnselectedImage;
/**
 * 设置标签栏的选中和未选中的背景图片。
 */
- (void)setBackgroundSelectedImage:(NSString *)selectedImage_Str withUnselectedImage:(NSString*)unselectedImage_Str;
- (void)setBackgroundImage:(UIImage *)selectedImage withUnImage:(UIImage*)unselectedImage;
/**
 *   字体
 */
-(void)tabarTitle:(NSString *)selectedtitle FontOfSize:(CGFloat)ofszie ColorTitle:(UIColor *)color Unselectedtitle:(NSString *)unselectedtitle UnTitleFontOfSize:(CGFloat)unofszie UnColorTitle:(UIColor *)untitlecolor;
#pragma mark - Badge configuration

/**
 * 文本的右上角显示的项目与周围的背景。
 */
@property (nonatomic, copy)NSString *badgeValue;

/**
 * 用于徽章背景的图像。
 */
@property (nonatomic, strong)UIImage *badgeBackgroundImage;

/**
 * 用于徽章背景的颜色。
 */
@property (nonatomic, strong)UIColor *badgeBackgroundColor;

/**
 * 用于徽章文本的颜色。
 */
@property (nonatomic, strong)UIColor *badgeTextColor;

/**
 * 标签栏项目徽章周围矩形的偏移量。
 */
@property (nonatomic, assign)UIOffset badgePositionAdjustment;

/**
 * 用于徽章文本的字体。
 */
@property (nonatomic, assign)UIFont *badgeTextFont;
@end

NS_ASSUME_NONNULL_END
