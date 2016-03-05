//
//  YGRestClient.h
//  TechnologyTemplate
//
//  Created by leitaiyuan on 15/5/26.
//  Copyright (c) 2015年 leitaiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

//HTTP响应成功或失败的回调Block
typedef void (^HTTPFailureHandler)(NSError *error);
typedef void (^HTTPSuccessHandler)(id responseData);
typedef void (^HTTPJSONFailureHandler)(NSError *error);
typedef void (^HTTPJSONSuccessHandler)(id responseObject);

//HTTP上传文件的回调Block
typedef void (^HTTPUploadProgressHandler)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite);
//HTTP下载文件的回调Block
typedef void (^HTTPDownloadProgressHandler)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead);

/**
 HTTP methods for requests
 */
typedef NS_OPTIONS(NSInteger, HTTPRequestMethod) {
    HTTPRequestMethodGET          = 1 << 0,
    HTTPRequestMethodPOST         = 1 << 1,
    HTTPRequestMethodPUT          = 1 << 2,
    HTTPRequestMethodDELETE       = 1 << 3,
    HTTPRequestMethodHEAD         = 1 << 4,
    HTTPRequestMethodPATCH        = 1 << 5,
    HTTPRequestMethodMultipartData= 1 << 6,
    //HTTPRequestMethodOPTIONS      = 1 << 7
};

@class AFHTTPRequestOperation;
@class AFHTTPRequestOperationManager;


@interface YGRestClient : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, copy) NSDictionary *HTTPRequestHeaders;

// 是否显示提示信息，默认YES
@property (nonatomic, assign, getter=isShowProgressHUD) BOOL showProgressHUD;

/**
 *  调用服务端服务，返回数据格式由manager.responseSerializer指定，请求参数格式由manager.requestSerializer指定
 *
 *  @param manager    请求操作管理对象
 *  @param method     请求类型，如GET、POSR
 *  @param url        服务地址
 *  @param parameters 请求参数
 *  @param success    请求成功回调Block
 *  @param failure    请求失败回调Block
 */
- (AFHTTPRequestOperation*) executeRequest:(AFHTTPRequestOperationManager *)manager
                                    method:(HTTPRequestMethod)method
                                       url:(NSString *) url
                                parameters:(id) parameters
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseData)) success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure;

/**
 *  调用服务端服务(GET请求)，返回JSON格式数据，请求参数为FORM表单数据
 *
 *  @param url        服务地址
 *  @param parameters 请求参数
 *  @param success    请求成功回调Block
 *  @param failure    请求失败回调Block
 */
- (AFHTTPRequestOperation*) getForObjectWithUrl:(NSString *) url
                                     parameters:(NSDictionary *) parameters
                                        success:(HTTPJSONSuccessHandler) success
                                        failure:(HTTPJSONFailureHandler) failure;

- (AFHTTPRequestOperation*) headForObjectWithUrl:(NSString *) url
                                            json:(id) parameters
                                         success:(HTTPJSONSuccessHandler) success
                                         failure:(HTTPJSONFailureHandler) failure;
/**
 *  调用服务端服务(POST请求)，返回JSON格式数据，请求参数为FORM表单格式数据
 *
 *  @param url        服务地址
 *  @param parameters 请求参数
 *  @param success    请求成功回调Block
 *  @param failure    请求失败回调Block
 */
- (AFHTTPRequestOperation*) postForObjectWithUrl:(NSString *) url
                                            form:(NSDictionary *) parameters
                                         success:(HTTPJSONSuccessHandler) success
                                         failure:(HTTPJSONFailureHandler) failure;
/**
 *  调用服务端服务(POST请求)，返回JSON格式数据，请求参数为JSON格式数据
 *
 *  @param url        服务地址
 *  @param parameters 请求参数
 *  @param success    请求成功回调Block
 *  @param failure    请求失败回调Block
 */
- (AFHTTPRequestOperation*) postForObjectWithUrl:(NSString *) url
                                            json:(id) parameters
                                         success:(HTTPJSONSuccessHandler) success
                                         failure:(HTTPJSONFailureHandler) failure;
/**
 *  调用服务端服务(PUT请求)，返回JSON格式数据，请求参数为JSON格式数据
 *
 *  @param url        服务地址
 *  @param parameters 请求参数
 *  @param success    请求成功回调Block
 *  @param failure    请求失败回调Block
 */
- (AFHTTPRequestOperation*) putForObjectWithUrl:(NSString *) url
                                           json:(id) parameters
                                        success:(HTTPJSONSuccessHandler) success
                                        failure:(HTTPJSONFailureHandler) failure;
/**
 *  调用服务端服务(DELETE请求)，返回JSON格式数据，请求参数为JSON格式数据
 *
 *  @param url        服务地址
 *  @param parameters 请求参数
 *  @param success    请求成功回调Block
 *  @param failure    请求失败回调Block
 */
- (AFHTTPRequestOperation*) deleteForObjectWithUrl:(NSString *) url
                                              json:(id) parameters
                                           success:(HTTPJSONSuccessHandler) success
                                           failure:(HTTPJSONFailureHandler) failure;
/**
 *  调用服务端服务(GET请求)，返回HTTP格式数据，请求参数为FORM表单格式数据
 *
 *  @param url        服务地址
 *  @param parameters 请求参数
 *  @param success    请求成功回调Block
 *  @param failure    请求失败回调Block
 */
- (AFHTTPRequestOperation*)getWithUrl:(NSString *)url
                           parameters:(NSDictionary *)parameters
                              success:(HTTPSuccessHandler)success
                              failure:(HTTPFailureHandler)failure;
/**
 *  调用服务端服务(POST请求)，返回HTTP格式数据，请求参数为FORM表单格式数据
 *
 *  @param url        服务地址
 *  @param parameters 请求参数
 *  @param success    请求成功回调Block
 *  @param failure    请求失败回调Block
 */
- (AFHTTPRequestOperation*)postWithUrl:(NSString *)url
                                  form:(NSDictionary *)parameters
                               success:(HTTPSuccessHandler)success
                               failure:(HTTPFailureHandler)failure;
/**
 *  调用服务端服务(POST请求)，返回HTTP格式数据，请求参数为JSON格式数据
 *
 *  @param url        服务地址
 *  @param parameters 请求参数
 *  @param success    请求成功回调Block
 *  @param failure    请求失败回调Block
 */
- (AFHTTPRequestOperation*)postWithUrl:(NSString *)url
                                  json:(id)parameters
                               success:(HTTPSuccessHandler)success
                               failure:(HTTPFailureHandler)failure;
/**
 *  上传文件，返回JSON数据
 *
 *  @param url        服务地址
 *  @param parameters 文件信息
 *  @param success    请求成功回调Block
 *  @param failure    请求失败回调Block
 */
- (AFHTTPRequestOperation *)uploadFileForObject:(NSString *)url
                                     parameters:(NSDictionary *)parameters
                                        success:(HTTPSuccessHandler)success
                                        failure:(HTTPFailureHandler)failure;
/**
 *  上传文件，返回HTTP数据
 *
 *  @param url        服务地址
 *  @param parameters 文件信息
 *  @param success    请求成功回调Block
 *  @param failure    请求失败回调Block
 */
- (AFHTTPRequestOperation *)uploadFile:(NSString *)url
                            parameters:(NSDictionary *)parameters
                               success:(HTTPSuccessHandler)success
                               failure:(HTTPFailureHandler)failure;
/**
 *  上传文件
 *
 *  @param url        服务地址
 *  @param parameters 文件信息
 *  @param success    请求成功回调Block
 *  @param failure    请求失败回调Block
 *  @param progress   上传进度回调Block
 */
- (AFHTTPRequestOperation *)uploadFile:(NSString *)url
                            parameters:(NSDictionary *)parameters
                               success:(HTTPSuccessHandler)success
                               failure:(HTTPFailureHandler)failure
                              progress:(HTTPUploadProgressHandler)progress;
/**
 *  下载文件（一般用于处理二进制文件），输出请求日志
 *
 *  @param url        服务地址
 *  @param fileName   保存的文件名
 *  @param success    请求成功回调Block
 *  @param failure    请求失败回调Block
 */
- (AFHTTPRequestOperation *)downloadFile:(NSString *)url
            fileName:(NSString *)fileName
             success:(void (^)(NSString *filePath))success
             failure:(HTTPFailureHandler)failure;
/**
 *  下载文件（一般用于处理二进制文件），输出请求日志
 *
 *  @param url        服务地址
 *  @param parameters 请求参数
 *  @param fileName   保存的文件名
 *  @param success    请求成功回调Block
 *  @param failure    请求失败回调Block
 */
- (AFHTTPRequestOperation *)downloadFile:(NSString *)url
          parameters:(NSDictionary *)parameters
            fileName:(NSString *)fileName
             success:(void (^)(NSString *filePath))success
                                 failure:(HTTPFailureHandler)failure;
/**
 *  下载文件（一般用于处理二进制文件），输出请求日志
 *
 *  @param url        服务地址
 *  @param fileName   保存的文件名
 *  @param success    请求成功回调Block
 *  @param failure    请求失败回调Block
 */
- (AFHTTPRequestOperation *)downloadFile:(NSString *)url
                                fileName:(NSString *)fileName
                                 success:(void (^)(NSString *filePath))success
                                 failure:(HTTPFailureHandler)failure
                                progress:(HTTPDownloadProgressHandler)progress;
/**
 *  下载文件（一般用于处理二进制文件），输出请求日志
 *
 *  @param url        服务地址
 *  @param parameters 请求参数
 *  @param fileName   保存的文件名
 *  @param success    请求成功回调Block
 *  @param failure    请求失败回调Block
 */
- (AFHTTPRequestOperation *)downloadFile:(NSString *)url
                              parameters:(NSDictionary *)parameters
                                fileName:(NSString *)fileName
                                 success:(void (^)(NSString *filePath))success
                                 failure:(HTTPFailureHandler)failure
                                progress:(HTTPDownloadProgressHandler)progress;

@end

@class AFHTTPRequestSerializer;
@class AFJSONRequestSerializer;
@class AFHTTPResponseSerializer;
@class AFJSONResponseSerializer;

@interface YGRestClient (Basic)

- (AFHTTPRequestSerializer *)getAFHTTPRequestSerializer;
- (AFJSONRequestSerializer *)getAFJSONRequestSerializer;
- (AFHTTPResponseSerializer *)getAFHTTPResponseSerializer;
- (AFJSONResponseSerializer *)getAFJSONResponseSerializer;

/**
 *  获取返回HTTP格式的RequestManager
 */
- (AFHTTPRequestOperationManager *)getHttpRequestManager;

/**
 *  获取返回JSON格式的RequestManager
 */
- (AFHTTPRequestOperationManager *)getJSONRequestManager;

/**
 *  用于图片文件下载的RequestManager
 */
- (AFHTTPRequestOperationManager *)getImageRequestManager;

@end
