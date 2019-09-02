//
//  TFY_NetWorking.h
//  daerOA
//
//  Created by 田风有 on 2017/3/30.
//  Copyright © 2017年 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/*!
 *
 *  下载进度
 *
 *   bytesRead                 已下载的大小
 *   totalBytesRead            文件总大小
 *   totalBytesExpectedToRead  还有多少需要下载
 */
typedef void (^TFY_DownloadProgress)(int64_t bytesRead,int64_t totalBytesRead);

typedef TFY_DownloadProgress GetProgress;
typedef TFY_DownloadProgress PostProgress;

/*!
 *
 *  上传进度
 *
 *   bytesWritten              已上传的大小
 *   totalBytesWritten         总上传大小
 */
typedef void (^TFY_UploadProgress)(int64_t bytesWritten,int64_t totalBytesWritten);

typedef NS_ENUM(NSUInteger, TFY_ResponseType) {
    TFY_ResponseTypeJSON = 1, // 默认
    TFY_ResponseTypeXML  = 2, // XML
    TFY_ResponseTypeData = 3  //
};

typedef NS_ENUM(NSUInteger, TFY_RequestType) {
    TFY_RequestTypeJSON = 1,       // 默认
    TFY_RequestTypePlainText  = 2  // 普通text/html
};

/**
 *  所有的接口返回值均为NSURLSessionTask
 */
typedef NSURLSessionTask TFY_URLSessionTask;

/*!
 *
 *  请求成功的回调
 *
 *   response 服务端返回的数据类型
 */
typedef void(^TFY_ResponseSuccess)(id response);

/*!
 *
 *  网络响应失败时的回调
 *
 *   error 错误信息
 */
typedef void(^TFY_ResponseFail)(NSError *error);

/************* class **************/
/************* class **************/

@interface TFY_NetWorking : NSObject

/*!
 *
 *  用于指定网络请求接口的基础url
 *   baseUrl 网络接口的基础url
 */
+ (void)updateBaseUrl:(NSString *)baseUrl;
+ (NSString *)baseUrl;

/**
 *	设置请求超时时间，默认为30秒
 *
 *	 timeout 超时时间
 */
+ (void)setTimeout:(NSTimeInterval)timeout;

/**
 *	当检查到网络异常时，是否从从本地提取数据。默认为NO。一旦设置为YES,当设置刷新缓存时，
 *  若网络异常也会从缓存中读取数据。同样，如果设置超时不回调，同样也会在网络异常时回调，除非
 *  本地没有数据！
 *
 *	 shouldObtain	YES/NO
 */
+ (void)obtainDataFromLocalWhenNetworkUnconnected:(BOOL)shouldObtain;

/**
 *
 *	默认请求是不缓存的。如果要缓存获取的数据，需要手动调用设置
 *
 *
 *	 isCacheGet			默认为NO
 *	 shouldCachePost      默认为NO
 */
+ (void)cacheGetRequest:(BOOL)isCacheGet shoulCachePost:(BOOL)shouldCachePost;

/**
 *
 *	获取缓存总大小/bytes
 *
 *	 缓存大小
 */
+ (unsigned long long)totalCacheSize;

/**
 *
 *	清除缓存
 */
+ (void)clearCaches;

/*!
 *
 *
 *  开启或关闭接口打印信息
 *
 *  @param isDebug 开发期，最好打开，默认是NO
 */
+ (void)enableInterfaceDebug:(BOOL)isDebug;

/*!
 *
 *  配置请求格式，默认为JSON。
 *
 *   requestType                      请求格式，默认为JSON
 *   responseType                     响应格式，默认为JSO，
 *   shouldAutoEncode                 YES or NO,默认为NO，是否自动encode url
 *   shouldCallbackOnCancelRequest    当取消请求时，是否要回调，默认为YES
 */
+ (void)configRequestType:(TFY_RequestType)requestType responseType:(TFY_ResponseType)responseType shouldAutoEncodeUrl:(BOOL)shouldAutoEncode callbackOnCancelRequest:(BOOL)shouldCallbackOnCancelRequest;

/*!
 *
 *  配置公共的请求头，只调用一次即可
 *
 *   httpHeaders 只需要将与服务器商定的固定参数设置即可
 */
+ (void)configCommonHttpHeaders:(NSDictionary *)httpHeaders;

/**
 *
 *	取消所有请求
 */
+ (void)cancelAllRequest;
/**
 *
 *	取消某个请求
 *
 *	 url				URL，可以是绝对URL，也可以是path（也就是不包括baseurl）
 */
+ (void)cancelRequestWithURL:(NSString *)url;

/*!
 *
 *  GET请求接口，若不指定baseurl，可传完整的url
 *
 *   url          接口路径
 *   refreshCache 是否刷新缓存
 *   statusText   提示框文字
 *   params       接口中所需要的拼接参数
 *   success      接口成功请求到数据的回调
 *   fail         接口请求数据失败的回调
 *
 *               返回的对象中有可取消请求的API
 */
+ (TFY_URLSessionTask *)getWithUrl:(NSString *)url refreshCache:(BOOL)refreshCache success:(TFY_ResponseSuccess)success fail:(TFY_ResponseFail)fail;

// （有提示框）
+ (TFY_URLSessionTask *)getWithUrl:(NSString *)url refreshCache:(BOOL)refreshCache showHUD:(NSString *)statusText success:(TFY_ResponseSuccess)success fail:(TFY_ResponseFail)fail;


// 多一个params参数（无提示框）
+ (TFY_URLSessionTask *)getWithUrl:(NSString *)url refreshCache:(BOOL)refreshCache params:(NSDictionary *)params success:(TFY_ResponseSuccess)success fail:(TFY_ResponseFail)fail;


// 多一个params参数（有提示框）
+ (TFY_URLSessionTask *)getWithUrl:(NSString *)url refreshCache:(BOOL)refreshCache showHUD:(NSString *)statusText params:(NSDictionary *)params success:(TFY_ResponseSuccess)success fail:(TFY_ResponseFail)fail;


// 多一个带进度回调（无提示框）
+ (TFY_URLSessionTask *)getWithUrl:(NSString *)url refreshCache:(BOOL)refreshCache params:(NSDictionary *)params progress:(GetProgress)progress success:(TFY_ResponseSuccess)success fail:(TFY_ResponseFail)fail;

// 多一个带进度回调（有提示框）
+ (TFY_URLSessionTask *)getWithUrl:(NSString *)url refreshCache:(BOOL)refreshCache showHUD:(NSString *)statusText params:(NSDictionary *)params progress:(GetProgress)progress success:(TFY_ResponseSuccess)success fail:(TFY_ResponseFail)fail;

/*!
 *
 *  POST请求接口，若不指定baseurl，可传完整的url
 *
 *   url     接口路径
 *   params  接口中所需的参数
 *   success 接口成功请求到数据的回调
 *   fail    接口请求数据失败的回调
 *
 *          返回的对象中有可取消请求的API
 */
+ (TFY_URLSessionTask *)postWithUrl:(NSString *)url refreshCache:(BOOL)refreshCache params:(NSDictionary *)params success:(TFY_ResponseSuccess)success fail:(TFY_ResponseFail)fail;

// (有提示框)
+ (TFY_URLSessionTask *)postWithUrl:(NSString *)url refreshCache:(BOOL)refreshCache showHUD:(NSString *)statusText params:(NSDictionary *)params success:(TFY_ResponseSuccess)success fail:(TFY_ResponseFail)fail;


// 多一个带进度回调（无提示框）
+ (TFY_URLSessionTask *)postWithUrl:(NSString *)url refreshCache:(BOOL)refreshCache params:(NSDictionary *)params progress:(PostProgress)progress success:(TFY_ResponseSuccess)success fail:(TFY_ResponseFail)fail;


// 多一个带进度回调（有提示框）
+ (TFY_URLSessionTask *)postWithUrl:(NSString *)url refreshCache:(BOOL)refreshCache showHUD:(NSString *)statusText params:(NSDictionary *)params progress:(PostProgress)progress success:(TFY_ResponseSuccess)success fail:(TFY_ResponseFail)fail;
/**
 *
 *	图片上传接口，若不指定baseurl，可传完整的url
 *
 *	 image		图片对象
 *	 url			上传图片的接口路径，如/path/images/
 *	 filename		给图片起一个名字，默认为当前日期时间,格式为"yyyyMMddHHmmss"，后缀为`jpg`
 *	 name			与指定的图片相关联的名称，这是由后端写接口的人指定的，如imagefiles
 *	 mimeType		默认为image/jpeg
 *	 parameters	参数
 *	 progress		上传进度
 *	 success		上传成功回调
 *	 fail			上传失败回调
 *
 */
+ (TFY_URLSessionTask *)uploadWithImage:(UIImage *)image url:(NSString *)url filename:(NSString *)filename name:(NSString *)name mimeType:(NSString *)mimeType parameters:(NSDictionary *)parameters progress:(TFY_UploadProgress)progress success:(TFY_ResponseSuccess)success fail:(TFY_ResponseFail)fail;

/**
 *
 *	上传文件操作
 *
 *	 url				上传路径
 *	 uploadingFile	待上传文件的路径
 *	 progress			上传进度
 *	 success			上传成功回调
 *	 fail				上传失败回调
 *
 */
+ (TFY_URLSessionTask *)uploadFileWithUrl:(NSString *)url uploadingFile:(NSString *)uploadingFile progress:(TFY_UploadProgress)progress success:(TFY_ResponseSuccess)success fail:(TFY_ResponseFail)fail;


/*!
 *
 *  下载文件
 *
 *   url           下载URL
 *   saveToPath    下载到哪个路径下
 *   progressBlock 下载进度
 *   success       下载成功后的回调
 *   failure       下载失败后的回调
 */
+ (TFY_URLSessionTask *)downloadWithUrl:(NSString *)url saveToPath:(NSString *)saveToPath progress:(TFY_DownloadProgress)progressBlock success:(TFY_ResponseSuccess)success failure:(TFY_ResponseFail)failure;


@end
