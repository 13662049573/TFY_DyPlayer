//
//  NSDictionary+TFY_DictExtension.m
//  TFY_AutoLayoutModelTools
//
//  Created by 田风有 on 2019/5/2.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import "NSDictionary+TFY_DictExtension.h"
#import <objc/runtime.h>

@implementation NSDictionary (TFY_DictExtension)
/**
 *   返回字典所获取的数据
 */
+(nullable NSDictionary *)tfy_NSDictionpathForResource:(nullable NSString *)name ofType:(nullable NSString *)ext{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:ext];
    
    NSString *shoppingStr = [NSString stringWithContentsOfFile:path usedEncoding:nil error:nil];
    
    NSDictionary *shoppingDic = [self tfy_dictionaryWithJsonString:shoppingStr];
    
    return shoppingDic;
}

+(NSDictionary *)tfy_dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err)
    {
        return nil;
    }
    return dic;
}

//模型转为字典
+(NSDictionary *)tfy_entityToDictionary:(id)entity{
    
    Class clazz = [entity class];
    u_int count;
    
    objc_property_t* properties = class_copyPropertyList(clazz, &count);
    NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray* valueArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count ; i++)
    {
        objc_property_t prop=properties[i];
        const char* propertyName = property_getName(prop);
        
        [propertyArray addObject:[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
        
        id value =  [entity performSelector:NSSelectorFromString([NSString stringWithUTF8String:propertyName])];
        if(value ==nil)
            [valueArray addObject:[NSNull null]];
        else {
            [valueArray addObject:value];
        }
    }
    
    free(properties);
    
    NSDictionary* returnDic = [NSDictionary dictionaryWithObjects:valueArray forKeys:propertyArray];
    return returnDic;
}
+ (NSDictionary *)tfy_dictionaryWithPlistData:(NSData *)plist {
    if (!plist) return nil;
    NSDictionary *dictionary = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListImmutable format:NULL error:NULL];
    if ([dictionary isKindOfClass:[NSDictionary class]]) return dictionary;
    return nil;
}

+ (NSDictionary *)tfy_dictionaryWithPlistString:(NSString *)plist {
    if (!plist) return nil;
    NSData *data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self tfy_dictionaryWithPlistData:data];
}
- (NSDictionary *)tfy_entriesForKeys:(NSArray *)keys {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    for (id key in keys) {
        id value = self[key];
        if (value) dic[key] = value;
    }
    return [dic copy];
}

+(NSDictionary *)tfy_dictionaryByMerging:(NSDictionary *)dict1 with:(NSDictionary *)dict2 {
    NSMutableDictionary * result = [NSMutableDictionary dictionaryWithDictionary:dict1];
    NSMutableDictionary * resultTemp = [NSMutableDictionary dictionaryWithDictionary:dict1];
    [resultTemp addEntriesFromDictionary:dict2];
    [resultTemp enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
        if ([dict1 objectForKey:key]) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary * newVal = [[dict1 objectForKey: key] dictionaryByMergingWith:(NSDictionary *) obj];
                [result setObject: newVal forKey: key];
            } else {
                [result setObject: obj forKey: key];
            }
        }
        else if([dict2 objectForKey:key])
        {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary * newVal = [[dict2 objectForKey: key] dictionaryByMergingWith:(NSDictionary *) obj];
                [result setObject: newVal forKey: key];
            } else {
                [result setObject: obj forKey: key];
            }
        }
    }];
    return (NSDictionary *) [result mutableCopy];
}
- (NSDictionary *)dictionaryByMergingWith:(NSDictionary *)dict {
    return [[self class] tfy_dictionaryByMerging:self with: dict];
}


@end
