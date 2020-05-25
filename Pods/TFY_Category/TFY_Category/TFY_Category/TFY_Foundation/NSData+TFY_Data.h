//
//  NSData+TFY_Data.h
//  TFY_AutoLMTools
//
//  Created by 田风有 on 2019/5/20.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (TFY_Data)
/**
 * md2 hash, 返回小写字符串。
 */
- (NSString *)md2String;

/**
 * md2 hash, 返回NSData。
 */
- (NSData *)md2Data;

/**
 * md4 hash, 返回小写字符串。
 */
- (NSString *)md4String;

/**
 * md4 hash, 返回NSData。
 */
- (NSData *)md4Data;

/**
 * md5 hash, 返回小写字符串。
 */
- (NSString *)md5String;

/**
 * md5 hash, 返回NSData。
 */
- (NSData *)md5Data;

/**
 * sha1 hash, 返回小写字符串。
 */
- (NSString *)sha1String;

/**
 * sha1 hash, 返回NSData。
 */
- (NSData *)sha1Data;

/**
 * sha224 hash, 返回小写字符串。
 */
- (NSString *)sha224String;

/**
 * sha224 hash, 返回NSData。
 */
- (NSData *)sha224Data;

/**
 * sha256 hash, 返回小写字符串。
 */
- (NSString *)sha256String;

/**
 * sha256 hash, 返回NSData。
 */
- (NSData *)sha256Data;

/**
 * sha384 hash, 返回小写字符串。
 */
- (NSString *)sha384String;

/**
 * sha384 hash, 返回NSData。
 */
- (NSData *)sha384Data;

/**
 * sha512 hash, 返回小写字符串。
 */
- (NSString *)sha512String;

/**
 * sha512 hash, 返回NSData。
 */
- (NSData *)sha512Data;

/**
 * HMAC MD5 hash, 返回一个小写字符串。此 HMAC 进程将密钥与消息数据混合，使用哈希函数对混合结果进行哈希计算，将所得哈希值与该密钥混合，然后再次应用哈希函数。
 */
- (NSString *)hmacMD5StringWithKey:(NSString *)key;

/**
 * HMAC MD5 hash, 返回一个NSData。此 HMAC 进程将密钥与消息数据混合，使用哈希函数对混合结果进行哈希计算，将所得哈希值与该密钥混合，然后再次应用哈希函数。
 */
- (NSData *)hmacMD5DataWithKey:(NSData *)key;

/**
 * HMAC sha1 hash, 返回一个小写字符串。此 HMAC 进程将密钥与消息数据混合，使用哈希函数对混合结果进行哈希计算，将所得哈希值与该密钥混合，然后再次应用哈希函数。
 */
- (NSString *)hmacSHA1StringWithKey:(NSString *)key;

/**
 * HMAC sha1 hash, 返回一个NSData。此 HMAC 进程将密钥与消息数据混合，使用哈希函数对混合结果进行哈希计算，将所得哈希值与该密钥混合，然后再次应用哈希函数。
 */
- (NSData *)hmacSHA1DataWithKey:(NSData *)key;

/**
 * HMAC sha224 hash, 返回一个小写字符串。此 HMAC 进程将密钥与消息数据混合，使用哈希函数对混合结果进行哈希计算，将所得哈希值与该密钥混合，然后再次应用哈希函数。
 */
- (NSString *)hmacSHA224StringWithKey:(NSString *)key;

/**
 * HMAC sha224 hash, 返回一个NSData。此 HMAC 进程将密钥与消息数据混合，使用哈希函数对混合结果进行哈希计算，将所得哈希值与该密钥混合，然后再次应用哈希函数。
 */
- (NSData *)hmacSHA224DataWithKey:(NSData *)key;

/**
 * HMAC sha256 hash, 返回一个小写字符串。此 HMAC 进程将密钥与消息数据混合，使用哈希函数对混合结果进行哈希计算，将所得哈希值与该密钥混合，然后再次应用哈希函数。
 */
- (NSString *)hmacSHA256StringWithKey:(NSString *)key;

/**
 * HMAC sha256 hash, 返回一个NSData。此 HMAC 进程将密钥与消息数据混合，使用哈希函数对混合结果进行哈希计算，将所得哈希值与该密钥混合，然后再次应用哈希函数。
 */
- (NSData *)hmacSHA256DataWithKey:(NSData *)key;

/**
 * HMAC sha384 hash, 返回一个小写字符串。此 HMAC 进程将密钥与消息数据混合，使用哈希函数对混合结果进行哈希计算，将所得哈希值与该密钥混合，然后再次应用哈希函数。
 */
- (NSString *)hmacSHA384StringWithKey:(NSString *)key;

/**
 * HMAC sha384 hash, 返回一个NSData。此 HMAC 进程将密钥与消息数据混合，使用哈希函数对混合结果进行哈希计算，将所得哈希值与该密钥混合，然后再次应用哈希函数。
 */
- (NSData *)hmacSHA384DataWithKey:(NSData *)key;

/**
 * HMAC sha512 hash, 返回一个小写字符串。此 HMAC 进程将密钥与消息数据混合，使用哈希函数对混合结果进行哈希计算，将所得哈希值与该密钥混合，然后再次应用哈希函数。
 */
- (NSString *)hmacSHA512StringWithKey:(NSString *)key;

/**
 * HMAC sha512 hash, 返回一个NSData。此 HMAC 进程将密钥与消息数据混合，使用哈希函数对混合结果进行哈希计算，将所得哈希值与该密钥混合，然后再次应用哈希函数。
 */
- (NSData *)hmacSHA512DataWithKey:(NSData *)key;

/**
 * 返回 ASE 加密的 NSData。.
 */
- (nullable NSData *)aes256EncryptWithKey:(NSData *)key iv:(nullable NSData *)iv;

/**
 * 返回 ASE 解密的 NSData.
 */
- (nullable NSData *)aes256DecryptWithkey:(NSData *)key iv:(nullable NSData *)iv;
/**
 * 返回 UTF8 解码后的字符串
 */
- (nullable NSString *)utf8String;

/**
 * 返回十六进制字符串
 */
- (nullable NSString *)hexString;

/**
 * 将十六进制字符串转换为 NSData
 */
+ (nullable NSData *)dataWithHexString:(NSString *)hexString;

/**
 * 返回 base64 解码的字符串
 */
- (nullable NSString *)base64EncodedString;

/**
 * 返回字符串经 base64 编码后的NSData
 */
+ (nullable NSData *)dataWithBase64EncodedString:(NSString *)base64EncodedString;

/**
 * 将 NSData 进行解码，返回一个字典或者字符串。例如 NSString: @"{"name":"a","count":2}"  => NSDictionary: @[@"name":@"a",@"count”:@2]。
 */
- (nullable id)jsonValueDecoded;
/**
 * 对使用 gzip 压缩后的数据进行解压
 */
- (nullable NSData *)gzipInflate;
/**
 * 使用 gzip 默认 compresssion 级别对 NSData 进行压缩。
 */
- (nullable NSData *)gzipDeflate;
/**
 * 对使用 zlib 压缩后的数据进行解压。
 */
- (nullable NSData *)zlibInflate;
/**
 * 使用 zlib 默认 compresssion 级别对 NSData 进行压缩。
 */
- (nullable NSData *)zlibDeflate;
/**
 *  将URL作为key保存到磁盘里缓存起来
 */
- (void)saveDataCacheWithIdentifier:(NSString *)identifier;
/**
 *  取出缓存data
 */
+ (NSData *)getDataCacheWithIdentifier:(NSString *)identifier;
/**
 * 获取 name 文件里的内容，返回 NSData。类似[UIImage imageNamed:]。
 */
+ (nullable NSData *)dataNamed:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
