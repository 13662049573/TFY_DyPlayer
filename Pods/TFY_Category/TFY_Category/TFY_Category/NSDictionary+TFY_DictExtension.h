//
//  NSDictionary+TFY_DictExtension.h
//  TFY_AutoLayoutModelTools
//
//  Created by 田风有 on 2019/5/2.
//  Copyright © 2019 恋机科技. All rights reserved.
//  https://github.com/13662049573/TFY_AutoLayoutModelTools

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (TFY_DictExtension)
/**
 *   返回字典所获取的数据
 */
+(nullable NSDictionary *)tfy_NSDictionpathForResource:(nullable NSString *)name ofType:(nullable NSString *)ext;
/**
 *  模型转为字典
 */
+(NSDictionary *)tfy_entityToDictionary:(id)entity;
/**
 *  将json格式的字典转化成字典
 */
+(NSDictionary *)tfy_dictionaryWithJsonString:(NSString *)jsonString;
/**
 * 将属性列表数据转换为 NSDictionary 返回。
 */
+ (nullable NSDictionary *)tfy_dictionaryWithPlistData:(NSData *)plist;

/**
 * 将xml格式的属性列表字符串转换为 NSDictionary 返回。
 */
+ (nullable NSDictionary *)tfy_dictionaryWithPlistString:(NSString *)plist;
/**
 * 返回一个新的字典，该字典包含原字典所有 keys 及它们对应的值。
 */
- (NSDictionary *)tfy_entriesForKeys:(NSArray *)keys;
/**
 *  合并两个NSDictionary
 */
+(NSDictionary *)tfy_dictionaryByMerging:(NSDictionary *)dict1 with:(NSDictionary *)dict2;

@end

NS_ASSUME_NONNULL_END
