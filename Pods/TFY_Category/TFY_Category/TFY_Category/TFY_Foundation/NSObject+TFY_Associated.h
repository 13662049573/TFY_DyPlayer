//
//  NSObject+TFY_Associated.h
//  TFY_AutoLayoutModelTools
//
//  Created by 田风有 on 2019/5/15.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (TFY_Associated)
/**
 *  关联key
 */
- (id)tfy_getAssociatedValueForKey:(void *)key;
/**
 *  关联 - OBJC_ASSOCIATION_RETAIN_NONATOMIC
 */
- (void)tfy_setAssociatedValue:(id)value withKey:(void *)key;
/**
 *  关联- OBJC_ASSOCIATION_ASSIGN
 */
- (void)tfy_setAssignValue:(id)value withKey:(SEL)key;
/**
 *  关联 - OBJC_ASSOCIATION_COPY_NONATOMIC
 */
- (void)tfy_setCopyValue:(id)value withKey:(SEL)key;
/**
 *  删除关联
 */
- (void)tfy_removeAssociatedObjects;
/**
 *  类名
 */
- (NSString *)tfy_className;
+ (NSString *)tfy_className;
/**
 *  父类名称
 */
- (NSString *)tfy_superClassName;
+ (NSString *)tfy_superClassName;
/**
 *  实例属性字典
 */
-(NSDictionary *)tfy_propertyDictionary;
/**
 *  属性名称列表
 */
- (NSArray*)tfy_propertyKeys;
+ (NSArray *)tfy_propertyKeys;
/**
 * 属性详细信息列表
 */
- (NSArray *)tfy_propertiesInfo;
+ (NSArray *)tfy_propertiesInfo;
/**
 *  格式化后的属性列表
 */
+ (NSArray *)tfy_propertiesWithCodeFormat;
/**
 *  方法列表
 */
-(NSArray*)tfy_methodList;
+(NSArray*)tfy_methodList;

-(NSArray*)tfy_methodListInfo;
/**
 *  创建并返回一个指向所有已注册类的指针列表
 */
+ (NSArray *)tfy_registedClassList;
/**
 * 实例变量
 */
+ (NSArray *)tfy_instanceVariable;
/**
 *  协议列表
 */
-(NSDictionary *)tfy_protocolList;
+ (NSDictionary *)tfy_protocolList;


- (BOOL)tfy_hasPropertyForKey:(NSString*)key;
- (BOOL)tfy_hasIvarForKey:(NSString*)key;

#pragma mark - Swap method (Swizzling)

/**
 * 交换两个实例方法的实现. originalSel   Selector 1.  newSel        Selector 2.
 */
+ (BOOL)tfy_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel;

/**
 * 交换类方法的实现  originalSel   Selector 1. newSel        Selector 2.
 */
+ (BOOL)tfy_swizzleClassMethod:(SEL)originalSel with:(SEL)newSel;
/**
 *  将字典中乱码转成中文显示
 */
-(NSString *)tfy_jsonString;


@end

NS_ASSUME_NONNULL_END
