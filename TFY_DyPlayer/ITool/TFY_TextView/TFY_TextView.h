//
//  TFY_TextView.h
//  TFY_AutoLMTools
//
//  Created by 田风有 on 2019/6/4.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 文字最多字符数量显示类型 **/
typedef enum {
    MaxNumStateNormal = 0,  // 默认模式（0/200）
    MaxNumStateDiminishing = 1,  // 递减模式（200）
}MaxNumState;

/** 返回输入监听内容 */
typedef void(^BackText)(NSString * _Nonnull textViewStr);

NS_ASSUME_NONNULL_BEGIN

@interface TFY_TextView : UIView
/**
 * 是否设置边框 （默认 Yes）
 */
@property (nonatomic, assign) BOOL isSetBorder;
/**
 * 上边距 (默认8)
 */
@property (nonatomic, assign) CGFloat topSpace;
/**
 * 左 右 边距 (默认8)
 */
@property (nonatomic, assign) CGFloat leftAndRightSpace;
/**
 * 边框线颜色
 */
@property (nonatomic, strong) UIColor *borderLineColor;
/**
 * 边宽线宽度
 */
@property (nonatomic, assign) CGFloat borderLineWidth;
/**
 * textView的内容
 */
@property (nonatomic, copy) NSString *text;
/**
 * textView 文字颜色 (默认黑色)
 */
@property (nonatomic, strong) UIColor *textColor;
/**
 * textView 字体大小 (默认14)
 */
@property (nonatomic, strong) UIFont *textFont;
/**
 * 占位文字 (默认：请输入内容)
 */
@property (nonatomic, copy) NSString *placeholder;
/**
 * placeholder 文字颜色 (默认[UIColor grayColor])
 */
@property (nonatomic, strong) UIColor *placeholderColor;
/**
 * 文字最多数量 (默认200个字符)
 */
@property (nonatomic, assign) int textMaxNum;
/**
 * Num 文字颜色 (默认黑色)
 */
@property (nonatomic, strong) UIColor *maxNumColor;
/**
 * Num 字体大小 (默认12)
 */
@property (nonatomic, strong) UIFont *maxNumFont;
/**
 * Num 样式 （默认 0/200）
 */
@property (nonatomic, assign) MaxNumState maxNumState;
/**
 * 返回输入监听内容
 */
@property (nonatomic, copy) BackText textViewListening;


@end

NS_ASSUME_NONNULL_END
