//
//  TfySY_TabBarItem.h
//  TFY_TabarController
//
//  Created by tiandengyou on 2019/11/25.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TfySY_TabBarBadge.h"

/**凸出后的形状*/
typedef NS_ENUM(NSInteger, TfySY_TabBarConfigBulgeStyle) {
    TfySY_TabBarConfigBulgeStyleNormal = 0,         /** 无 默认*/
    TfySY_TabBarConfigBulgeStyleCircular,           /**圆形*/
    TfySY_TabBarConfigBulgeStyleSquare              /**方形*/
};

/**item相对在tabbar的独立单元格布局*/
typedef NS_ENUM(NSInteger, TfySY_TabBarConfigAlignmentStyle) {
    TfySY_TabBarConfigAlignmentStyleCenter = 0,           /**居中 默认*/
    TfySY_TabBarConfigAlignmentStyleCenterTop,            /**顶部对齐*/
    TfySY_TabBarConfigAlignmentStyleCenterLeft,           /**靠左对齐*/
    TfySY_TabBarConfigAlignmentStyleCenterRight,          /**靠右对齐*/
    TfySY_TabBarConfigAlignmentStyleCenterBottom,         /**靠下对齐*/
    
    TfySY_TabBarConfigAlignmentStyleTopLeft,        /**上左对齐*/
    TfySY_TabBarConfigAlignmentStyleTopRight,       /**上右对齐*/
    
    TfySY_TabBarConfigAlignmentStyleBottomLeft,     /**下左对齐*/
    TfySY_TabBarConfigAlignmentStyleBottomRight,    /**下右对齐*/
};

/**item内部组件布局模式*/
typedef NS_ENUM(NSInteger, TfySY_TabBarItemLayoutStyle) {
    TfySY_TabBarItemLayoutStyleTopPictureBottomTitle = 0,   /**上图片下文字 默认*/
    TfySY_TabBarItemLayoutStyleBottomPictureTopTitle,       /**下图片上文字*/
    TfySY_TabBarItemLayoutStyleLeftPictureRightTitle,       /**左图片右文字*/
    TfySY_TabBarItemLayoutStyleRightPictureLeftTitle,       /**右图片左文字*/
    TfySY_TabBarItemLayoutStylePicture,                     /**单图片占满全部*/
    TfySY_TabBarItemLayoutStyleTitle,                       /**单标题占满全部*/
};

/**item的Badge脚标方位*/
typedef NS_ENUM(NSInteger, TfySY_TabBarItemBadgeStyle) {
    TfySY_TabBarItemBadgeStyleTopRight = 0,   /**右上方 默认*/
    TfySY_TabBarItemBadgeStyleTopCenter,      /**上中间*/
    TfySY_TabBarItemBadgeStyleTopLeft         /**左上方*/
};

/**点击触发时候的交互效果*/
typedef NS_ENUM(NSInteger, TfySY_TabBarInteractionEffectStyle) {
    TfySY_TabBarInteractionEffectStyleNone,     /**无 默认*/
    TfySY_TabBarInteractionEffectStyleSpring,   /**放大放小弹簧效果*/
    TfySY_TabBarInteractionEffectStyleShake,    /**摇动动画效果*/
    TfySY_TabBarInteractionEffectStyleAlpha,    /**透明动画效果*/
    TfySY_TabBarInteractionEffectStyleCustom,   /**自定义动画效果*/
};

@class TfySY_TabBarItem;
/**当交互效果选选择自定义时，会回调以下Block*/
typedef void(^CustomInteractionEffectBlock) (TfySY_TabBarItem * _Nonnull item);


@interface TfySY_TabBarConfigModel : NSObject

#pragma mark - 标题控制类
/**item的标题*/
@property(nonatomic, copy)NSString * _Nonnull itemTitle;
/**默认标题颜色 默认灰色*/
@property (nonatomic, strong) UIColor * _Nonnull normalColor;
/**选中标题颜色 默认TfySY_TabBarItemSlectBlue*/
@property (nonatomic, strong) UIColor * _Nonnull selectColor;

#pragma mark - 图片控制类
/**选中后的图片名称*/
@property(nonatomic, copy)NSString * _Nonnull selectImageName;
/**正常的图片名称*/
@property(nonatomic, copy)NSString * _Nonnull normalImageName;
/**默认的 图片tintColor*/
@property(nonatomic, strong)UIColor * _Nonnull normalTintColor;
/**选中的 图片tintColor*/
@property(nonatomic, strong)UIColor * _Nonnull selectTintColor;

#pragma mark - item背景控制类
/**默认的 按钮背景Color 默认无*/
@property(nonatomic, strong)UIColor * _Nonnull normalBackgroundColor;
/**选中的 按钮背景Color 默认无*/
@property(nonatomic, strong)UIColor * _Nonnull selectBackgroundColor;
/**单个item的背景图*/
@property(nonatomic, strong)UIImageView * _Nonnull backgroundImageView;

#pragma mark - item附加控制类
/**凸出形变类型*/
@property(nonatomic, assign)TfySY_TabBarConfigBulgeStyle bulgeStyle;
/**凸出高于TabBar多高 默认20*/
@property(nonatomic, assign)CGFloat bulgeHeight;
/**突出后圆角 默认0  如果是圆形的圆角，则会根据设置的ItemSize最大宽度自动裁切，设置后将按照此参数进行裁切*/
@property(nonatomic, assign)CGFloat bulgeRoundedCorners;
/**item相对TabBar对齐模式*/
@property(nonatomic, assign)TfySY_TabBarConfigAlignmentStyle alignmentStyle;
/**item大小*/
@property(nonatomic, assign)CGSize itemSize;
/**角标内容*/
@property(nonatomic, strong)NSString * _Nonnull badge;
/**角标方位*/
@property(nonatomic, assign)TfySY_TabBarItemBadgeStyle itemBadgeStyle;
/**为零是否自动隐藏 默认不隐藏*/
@property(nonatomic, assign)BOOL automaticHidden;

#pragma mark - item内部组件控制类
/**TitleLabel指针*/
@property (nonatomic, strong) UILabel * _Nonnull titleLabel;
/**imageView*/
@property (nonatomic, strong) UIImageView * _Nonnull icomImgView;
/**item内部组件布局模式*/
@property(nonatomic, assign)TfySY_TabBarItemLayoutStyle itemLayoutStyle;
/**titleLabel大小 有默认值*/
@property(nonatomic, assign)CGSize titleLabelSize;
/**icomImgView大小 有默认值*/
@property(nonatomic, assign)CGSize icomImgViewSize;
/**所有组件距离item边距 默认 UIEdgeInsetsMake(5, 5, 10, 5)*/
@property(nonatomic, assign)UIEdgeInsets componentMargin;
/**图片文字的间距 默认 2*/
@property(nonatomic, assign)CGFloat pictureWordsMargin;

#pragma mark - item交互控制类
/**点击触发后的交互效果*/
@property(nonatomic, assign)TfySY_TabBarInteractionEffectStyle interactionEffectStyle;
/**是否允许重复点击触发动画 默认NO*/
@property(nonatomic, assign)BOOL isRepeatClick;
/**当交互效果选选择自定义时，会回调以下Block*/
@property(nonatomic, copy)CustomInteractionEffectBlock _Nonnull customInteractionEffectBlock;
/**多个自定义时候使用区分的Tag*/
@property(nonatomic, assign)NSInteger tag;

@end

NS_ASSUME_NONNULL_BEGIN

@interface TfySY_TabBarItem : UIControl
/**构造*/
- (instancetype)initWithModel:(TfySY_TabBarConfigModel *)itemModel;

/**标题*/
@property (nonatomic, copy) NSString *title;
/**默认标题颜色*/
@property (nonatomic, strong) UIColor *normalColor;
/**选中标题颜色*/ 
@property (nonatomic, strong) UIColor *selectColor;
/**默认的 Image*/
@property (nonatomic, strong) UIImage *normalImage;
/**选中的 Image*/
@property (nonatomic, strong) UIImage *selectImage;
/**默认的 图片tintColor*/
@property(nonatomic, strong)UIColor *normalTintColor;
/**选中的 图片tintColor*/
@property(nonatomic, strong)UIColor *selectTintColor;
/**默认的 按钮背景Color 默认无*/
@property(nonatomic, strong)UIColor *normalBackgroundColor;
/**选中的 按钮背景Color 默认无*/
@property(nonatomic, strong)UIColor *selectBackgroundColor;
/**单个item的背景图*/
@property(nonatomic, strong)UIImageView *backgroundImageView;
/**角标内容*/
@property(nonatomic, strong)NSString *badge;
/**item的所在索引*/
@property(nonatomic, assign)NSInteger itemIndex;

/**选中状态*/
@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, strong) UIImageView *icomImgView;
/**标题Label*/
@property (nonatomic, strong) UILabel *titleLabel;
/**角标Label*/
@property(nonatomic, strong)TfySY_TabBarBadge *badgeLabel;

/**模型构造器*/
@property(nonatomic, strong)TfySY_TabBarConfigModel *itemModel;
/**重新开始布局*/
- (void)itemDidLayoutControl;
/**开始执行设置的动画*/
- (void)startStrringConfigAnimation;
@end

NS_ASSUME_NONNULL_END
