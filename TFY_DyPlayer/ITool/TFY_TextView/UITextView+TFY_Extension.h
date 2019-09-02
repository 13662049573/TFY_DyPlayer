//
//  UITextView+TFY_Extension.h
//  TFY_AutoLMTools
//
//  Created by 田风有 on 2019/6/4.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (TFY_Extension)
/**
 *   placeholdLabel
 */
@property(nonatomic,readonly)  UILabel * _Nonnull placeholdLabel;
/**
 * placeholder
 */
@property(nonatomic,copy) NSString * _Nonnull placeholder;
/**
 * placeholder颜色
 */
@property(nonatomic,copy) UIColor * _Nonnull placeholderColor;
/**
 * 富文本
 */
@property(nonnull,strong) NSAttributedString *attributePlaceholder;
/**
 * 位置
 */
@property(nonatomic,assign) CGPoint location;
/**
 * 默认颜色
 */
+ (UIColor *_Nonnull)defaultColor;
@end

NS_ASSUME_NONNULL_END
