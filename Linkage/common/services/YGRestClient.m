//
//  YGRestClient.m
//  TechnologyTemplate
//
//  Created by leitaiyuan on 15/5/26.
//  Copyright (c) 2015年 leitaiyuan. All rights reserved.
//

#import "YGRestClient.h"
#import <AFNetworking.h>
#import <AFNetworkActivityIndicatorManager.h>
#import <SVProgressHUD.h>

/**
 http 错误代码表
 所有 HTTP 状态代码及其定义。
 　代码  指示
 2xx  成功
 200  正常；请求已完成。
 201  正常；紧接 POST 命令。
 202  正常；已接受用于处理，但处理尚未完成。
 203  正常；部分信息 — 返回的信息只是一部分。
 204  正常；无响应 — 已接收请求，但不存在要回送的信息。
 3xx  重定向
 301  已移动 — 请求的数据具有新的位置且更改是永久的。
 302  已找到 — 请求的数据临时具有不同 URI。
 303  请参阅其它 — 可在另一 URI 下找到对请求的响应，且应使用 GET 方法检索此响应。
 304  未修改 — 未按预期修改文档。
 305  使用代理 — 必须通过位置字段中提供的代理来访问请求的资源。
 306  未使用 — 不再使用；保留此代码以便将来使用。
 4xx  客户机中出现的错误
 400  错误请求 — 请求中有语法问题，或不能满足请求。
 401  未授权 — 未授权客户机访问数据。
 402  需要付款 — 表示计费系统已有效。
 403  禁止 — 即使有授权也不需要访问。
 404  找不到 — 服务器找不到给定的资源；文档不存在。
 407  代理认证请求 — 客户机首先必须使用代理认证自身。
 415  介质类型不受支持 — 服务器拒绝服务请求，因为不支持请求实体的格式。
 5xx  服务器中出现的错误
 500  内部错误 — 因为意外情况，服务器不能完成请求。
 501  未执行 — 服务器不支持请求的工具。
 502  错误网关 — 服务器接收到来自上游服务器的无效响应。
 503  无法获得服务 — 由于临时过载或维护，服务器无法处理请求。
 -----------------------------------------------------------------------------------------------------------------------
 HTTP 400 - 请求无效
 HTTP 401.1 - 未授权：登录失败
 HTTP 401.2 - 未授权：服务器配置问题导致登录失败
 HTTP 401.3 - ACL 禁止访问资源
 HTTP 401.4 - 未授权：授权被筛选器拒绝
 HTTP 401.5 - 未授权：ISAPI 或 CGI 授权失败
 HTTP 403 - 禁止访问
 HTTP 403 - 对 Internet 服务管理器 (HTML) 的访问仅限于 Localhost
 HTTP 403.1 禁止访问：禁止可执行访问
 HTTP 403.2 - 禁止访问：禁止读访问
 HTTP 403.3 - 禁止访问：禁止写访问
 HTTP 403.4 - 禁止访问：要求 SSL
 HTTP 403.5 - 禁止访问：要求 SSL 128
 HTTP 403.6 - 禁止访问：IP 地址被拒绝
 HTTP 403.7 - 禁止访问：要求客户证书
 HTTP 403.8 - 禁止访问：禁止站点访问
 HTTP 403.9 - 禁止访问：连接的用户过多
 HTTP 403.10 - 禁止访问：配置无效
 HTTP 403.11 - 禁止访问：密码更改
 HTTP 403.12 - 禁止访问：映射器拒绝访问
 HTTP 403.13 - 禁止访问：客户证书已被吊销
 HTTP 403.15 - 禁止访问：客户访问许可过多
 HTTP 403.16 - 禁止访问：客户证书不可信或者无效
 HTTP 403.17 - 禁止访问：客户证书已经到期或者尚未生效
 HTTP 404.1 - 无法找到 Web 站点
 HTTP 404 - 无法找到文件
 HTTP 405 - 资源被禁止
 HTTP 406 - 无法接受
 HTTP 407 - 要求代理身份验证
 HTTP 410 - 永远不可用
 HTTP 412 - 先决条件失败
 HTTP 414 - 请求 - URI 太长
 HTTP 500 - 内部服务器错误
 HTTP 500.100 - 内部服务器错误 - ASP 错误
 HTTP 500-11 服务器关闭
 HTTP 500-12 应用程序重新启动
 HTTP 500-13 - 服务器太忙
 HTTP 500-14 - 应用程序无效
 HTTP 500-15 - 不允许请求 global.asa 
 Error 501 - 未实现 
 HTTP 502 - 网关错误
 */
/**
 要使用常规的AFN网络访问
 
 1. AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
 
 所有的网络请求,均有manager发起
 
 2. 需要注意的是,默认提交请求的数据是二进制的,返回格式是JSON
 
 1> 如果提交数据是JSON的,需要将请求格式设置为AFJSONRequestSerializer
 2> 如果返回格式不是JSON的,
 
 3. 请求格式
 
 AFHTTPRequestSerializer            二进制格式
 AFJSONRequestSerializer            JSON
 AFPropertyListRequestSerializer    PList(是一种特殊的XML,解析起来相对容易)
 
 4. 返回格式
 
 AFHTTPResponseSerializer           二进制格式
 AFJSONResponseSerializer           JSON
 AFXMLParserResponseSerializer      XML,只能返回XMLParser,还需要自己通过代理方法解析
 AFXMLDocumentResponseSerializer (Mac OS X)
 AFPropertyListResponseSerializer   PList
 AFImageResponseSerializer          Image
 AFCompoundResponseSerializer       组合
 */

static NSString *kCookieKey = @"Cookie";

@implementation YGRestClient

+ (void)load {
    //设置加载提示
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [SVProgressHUD setBackgroundColor:UIColorFromRGBAndAlpha(0x000000, 0.8)];
    [SVProgressHUD setForegroundColor:UIColorFromRGB(0xFFFFFF)];
    
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 未连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 移动网络 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域网络,不花钱
     */
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                iLog(@"网络状态：未知。");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                iLog(@"网络状态：未连接。");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                iLog(@"网络状态：移动网络。");
            case AFNetworkReachabilityStatusReachableViaWiFi:
                iLog(@"网络状态：WiFi网络。");
                break;
                
            default:
                break;
        }
    }];
}

- (instancetype)init {
    if (self = [super init]) {
        self.showProgressHUD = YES;
    }
    return self;
}

//检查当前网络连接是否正常
-(BOOL)connectedToNetWork {
    if ([AFNetworkReachabilityManager sharedManager].isReachable) {
        return YES;
    }
    return [AFNetworkReachabilityManager sharedManager].isReachable;
}

- (void)dealloc {
    //停止监听网络状态
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

+ (instancetype)sharedInstance {
    static id server;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        server = [[self alloc] init];
    });
    return server;
}

typedef void (^SuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^FailureBlock)(AFHTTPRequestOperation *operation, NSError *error);

NSString* __GetMethodName(HTTPRequestMethod method) {
    if(method==HTTPRequestMethodPOST)return @"POST";
    else if(method==HTTPRequestMethodPUT)return @"PUT";
    else if(method==HTTPRequestMethodDELETE)return @"DELETE";
    else if(method==HTTPRequestMethodHEAD)return @"HEAD";
    else if(method==HTTPRequestMethodPATCH)return @"PATCH";
    else if(method==HTTPRequestMethodMultipartData)return @"MultipartData";
    else return @"GET";
}

- (AFHTTPRequestOperation*) executeRequest:(AFHTTPRequestOperationManager *)manager
                                    method:(HTTPRequestMethod)method
                                       url:(NSString *) url
                                parameters:(id) parameters
                                   success:(SuccessBlock) success
                                   failure:(FailureBlock) failure {
    iLog(@"请求服务：%@\n method:%@ 参数：%@", url, __GetMethodName(method), parameters);
    if (!url) {
        [SVProgressHUD showErrorWithStatus:@"请求URL 为空"];
        return nil;
    }
    __block AFHTTPRequestOperation *operation;
    if ([self connectedToNetWork]){
        // 设置超时时间
        //[manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        //manager.requestSerializer.timeoutInterval = 10.f;
        //[manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        //[SVProgressHUD show];
        
        if (manager.requestSerializer.class == [AFHTTPRequestSerializer class]) {//如果是form表单请求，设置编码格式为UTF-8
            [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        }
        [manager.requestSerializer setValue:@"iphone" forHTTPHeaderField:@"MOBILE"];
        manager.securityPolicy.allowInvalidCertificates = YES;
        //设置使用cookie
        manager.requestSerializer.HTTPShouldHandleCookies = YES;
        
        //设置Cookie，使用系统自动存储的cookie
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:url]];//id: NSHTTPCookie
        NSDictionary *sheaders = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
        for (NSString *key in sheaders.allKeys) {
            [manager.requestSerializer setValue:sheaders[key] forHTTPHeaderField:key];
        }

        //请求成功Block
        SuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseData){
            //NSDictionary *allHeaderFields = operation.response.allHeaderFields;
            //id cookie = allHeaderFields[kCookieKey];
            //[manager.requestSerializer setValue:cookie forHTTPHeaderField:kCookieKey];
            if (success) {
                success(operation, responseData);
            }
        };
        //请求失败Block
        WeakSelf
        FailureBlock failureBlock = ^(AFHTTPRequestOperation *operation, NSError *error) {
            NSError *e = error;
            NSString *localizedDescription = nil;
            StrongSelf
            if (error.code == 401 || operation.response.statusCode == 401) {//未登录或登录超时
                eLog(@"未登录或登录超时：%@", error);
                [SVProgressHUD dismiss];
                return;
            }else if (error.code == -1001){
                eLog(@"请求超时：%@", error);
                localizedDescription = @"请求超时，不能连接服务器。";//error.localizedDescription;
            }else if (error.code == -1005){
                eLog(@"网络连接已中断:%@", error);
                localizedDescription = error.localizedDescription;
            }else if (error.code == -1022){
                //The resource could not be loaded because the App Transport Security policy requires the use of a secure connection.
                NSString *msg = @"iOS9不允许使用HTTP协议，请在在Info.plist中添加属性NSAppTransportSecurity，类型Dictionary，再添加子属性NSAllowsArbitraryLoads，类型Boolean，值设为YES。";
                if (IOS9) {
                    localizedDescription = msg;
                }else{
                    localizedDescription = error.localizedDescription;
                }
                eLog(@"%@错误信息:%@", msg, error);
            }else if (error.code == 3840){
                eLog(@"JSON数据解析失败:%@", error);
                localizedDescription = @"JSON数据解析失败。";
            }else{
                NSInteger statusCode = operation.response.statusCode;
                if (statusCode == 403){
                    eLog(@"服务器拒绝访问，403错误：%@", error);
                    localizedDescription = @"服务器拒绝访问。";
                }else if (statusCode == 404){
                    eLog(@"你请求的地址错误或服务地址已改变，404错误：%@", error);
                    NSData *data = operation.responseData;
                    if ([data isKindOfClass:NSData.class]) {
                        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        eLog(@"网络异常，返回结果：%@", str);
                    }
                    localizedDescription = @"你请求的地址错误或服务地址已改变。";
                    if (failure) {failure(operation, e);}
                }else if (statusCode == 500) {
                    eLog(@"网络异常：%@", error);
                    NSData *data = operation.responseData;
                    if ([data isKindOfClass:NSData.class]) {
                        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        eLog(@"网络异常，返回结果：%@", str);
                    }
                    localizedDescription = @"服务器500异常。";
                }else if (statusCode == 502) {
                    eLog(@"网络异常：%@", error);
                    localizedDescription = @"服务器正在启动，请稍后再试。";
                }else if (statusCode == 504) {
                    eLog(@"网络异常：%@", error);
                    localizedDescription = @"服务器请求超时，请稍后再试。";
                }else{
                    eLog(@"网络异常：%@", error);
                }
                if (localizedDescription) {
                    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:error.userInfo];
                    userInfo[NSLocalizedDescriptionKey] = localizedDescription;
                    e = [NSError errorWithDomain:error.domain code:statusCode userInfo:userInfo];
                }else{
                    localizedDescription = @"网络异常";
                }
            }
            if (self.showProgressHUD) {
                [SVProgressHUD show];
                [SVProgressHUD showInfoWithStatus:localizedDescription];
            }
            if (failure) {failure(operation, e);}
        };
        
        //开始执行请求
        operation = [self executeRequestBlock:manager method:method url:url parameters:parameters success:successBlock failure:failureBlock];
    }else{
        iLog(@"网络状态：未连接。");
        if (failure) {
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey : @"当前网络不可用，请检查你的网络设置。",//详细描述
                                       NSLocalizedFailureReasonErrorKey : @"网络状态：未连接。",//失败原因
                                       NSLocalizedRecoverySuggestionErrorKey : @"网络未连接，请检查手机网络。"//恢复建议
                                       };
            NSError *error = [NSError errorWithDomain:@"NSHTTPRequestFailureError" code:-1000 userInfo:userInfo];
            if (self.showProgressHUD) {
                [SVProgressHUD show];
                [SVProgressHUD showInfoWithStatus:error.localizedDescription];
            }
            failure(nil, error);
        }
    }
    return operation;
}

- (AFHTTPRequestOperation *) executeRequestBlock:(AFHTTPRequestOperationManager *)manager
                                          method:(HTTPRequestMethod)method
                                             url:(NSString *) url
                                      parameters:(id) parameters
                                         success:(SuccessBlock) successBlock
                                         failure:(FailureBlock) failureBlock{
    NSDictionary *headers = self.HTTPRequestHeaders;
    if (headers) {
        for (NSString *key in headers) {
            [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    __block AFHTTPRequestOperation *operation;
    switch (method) {
        case HTTPRequestMethodGET:{
            operation = [manager GET:url parameters:parameters success:successBlock failure:failureBlock];
            break;
        }
        case HTTPRequestMethodPOST:{
            operation = [manager POST:url parameters:parameters success:successBlock failure:failureBlock];
            break;
        }
        case HTTPRequestMethodPUT:{
            operation = [manager PUT:url parameters:parameters success:successBlock failure:failureBlock];
            break;
        }
        case HTTPRequestMethodDELETE:{
            operation = [manager DELETE:url parameters:parameters success:successBlock failure:failureBlock];
            break;
        }
        case HTTPRequestMethodHEAD:{
            operation = [manager HEAD:url parameters:parameters success:^(AFHTTPRequestOperation *operation) {
                successBlock(operation, nil);
            } failure:failureBlock];
            break;
        }
        case HTTPRequestMethodPATCH:{
            operation = [manager PATCH:url parameters:parameters success:successBlock failure:failureBlock];
            break;
        }
        case HTTPRequestMethodMultipartData:{
            operation = [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                if (parameters && [parameters isKindOfClass:[NSDictionary class]]) {
                    for (NSString *field in parameters) {
                        id value = parameters[field];
                        if ([value isKindOfClass:[NSString class]]){
                            NSString *filePath = value;
                            if (filePath && [[NSFileManager defaultManager] fileExistsAtPath:filePath]){
                                NSURL *url = [NSURL fileURLWithPath:filePath];
                                value = url;
                            }
                        }
                        if ([value isKindOfClass:[NSData class]]) {
                            
                            //上传图片要加上mimeType，否则上传不成功，修改:dlc 20151012
                            if ([field isEqualToString:@"image"]) {
                                [formData appendPartWithFileData:value
                                                            name:field
                                                        fileName:[NSString stringWithFormat:@"%d.jpg",[(NSData *)value length]]
                                                        mimeType:@"application/octet-stream"];
                            }else{
                                [formData appendPartWithFormData:value name:field];
                                
                            }
                        }else if ([value isKindOfClass:[NSURL class]]){
                            NSError *error;
                            [formData appendPartWithFileURL:value name:field error:&error];
                            if (error) {
                                iLog(@"上传文件失败：%@", error);
                            }
                        }
                    }
                }
            } success:successBlock failure:failureBlock];
            break;
        }
        default:
            break;
    }
    return operation;
}

- (AFHTTPRequestOperation*) getForObjectWithUrl:(NSString *) url parameters:(id) parameters success:(HTTPJSONSuccessHandler) success  failure:(HTTPJSONFailureHandler) failure {
    AFHTTPRequestOperationManager *manager = [self getJSONRequestManager];
    return [self executeRequestForJSON:manager method:HTTPRequestMethodGET url:url parameters:parameters success:success failure:failure];
}

- (AFHTTPRequestOperation*) headForObjectWithUrl:(NSString *) url json:(id) parameters success:(HTTPJSONSuccessHandler) success  failure:(HTTPJSONFailureHandler) failure {
    AFHTTPRequestOperationManager *manager = [self getJSONRequestManager];
    return [self executeRequestForJSON:manager method:HTTPRequestMethodHEAD url:url parameters:parameters success:success failure:failure];
}

- (AFHTTPRequestOperation*) postForObjectWithUrl:(NSString *) url form:(NSDictionary *) parameters success:(HTTPJSONSuccessHandler) success  failure:(HTTPJSONFailureHandler) failure {
    AFHTTPRequestOperationManager *manager = [self getJSONRequestManager];
    manager.requestSerializer = [self getAFHTTPRequestSerializer];
    return [self executeRequestForJSON:manager method:HTTPRequestMethodPOST url:url parameters:parameters success:success failure:failure];
}

- (AFHTTPRequestOperation*) postForObjectWithUrl:(NSString *) url json:(id) parameters success:(HTTPJSONSuccessHandler) success  failure:(HTTPJSONFailureHandler) failure {
    AFHTTPRequestOperationManager *manager = [self getJSONRequestManager];
    return [self executeRequestForJSON:manager method:HTTPRequestMethodPOST url:url parameters:parameters success:success failure:failure];
}

- (AFHTTPRequestOperation*) putForObjectWithUrl:(NSString *) url json:(id) parameters success:(HTTPJSONSuccessHandler) success  failure:(HTTPJSONFailureHandler) failure {
    AFHTTPRequestOperationManager *manager = [self getJSONRequestManager];
    return [self executeRequestForJSON:manager method:HTTPRequestMethodPUT url:url parameters:parameters success:success failure:failure];
}

- (AFHTTPRequestOperation*) deleteForObjectWithUrl:(NSString *) url json:(id) parameters success:(HTTPJSONSuccessHandler) success  failure:(HTTPJSONFailureHandler) failure {
    AFHTTPRequestOperationManager *manager = [self getJSONRequestManager];
    return [self executeRequestForJSON:manager method:HTTPRequestMethodDELETE url:url parameters:parameters success:success failure:failure];
}

#pragma Get
- (AFHTTPRequestOperation*)getWithUrl:(NSString *)url
                         parameters:(NSDictionary *)parameters
                      success:(HTTPSuccessHandler)success
                      failure:(HTTPFailureHandler)failure{
    AFHTTPRequestOperationManager *manager = [self getHttpRequestManager];
    return [self executeRequestForForm:manager method:HTTPRequestMethodGET url:url form:parameters success:success failure:failure];
}

#pragma Post
- (AFHTTPRequestOperation*)postWithUrl:(NSString *)url
                         form:(NSDictionary *)parameters
                      success:(HTTPSuccessHandler)success
                      failure:(HTTPFailureHandler)failure{
    AFHTTPRequestOperationManager *manager = [self getHttpRequestManager];
    return [self executeRequestForForm:manager method:HTTPRequestMethodPOST url:url form:parameters success:success failure:failure];
}

- (AFHTTPRequestOperation*)postWithUrl:(NSString *)url
                                  json:(id)parameters
                               success:(HTTPSuccessHandler)success
                               failure:(HTTPFailureHandler)failure{
    AFHTTPRequestOperationManager *manager = [self getHttpRequestManager];
    manager.requestSerializer = [self getAFJSONRequestSerializer];
    return [self executeRequest:manager method:HTTPRequestMethodPOST url:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseData) {
        if (success) {
            success(responseData);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (AFHTTPRequestOperation*) executeRequestForJSON:(AFHTTPRequestOperationManager *)manager method:(HTTPRequestMethod)method url:(NSString *) url parameters:(id) parameters success:(HTTPJSONSuccessHandler) success  failure:(HTTPJSONFailureHandler) failure {
    __block int requestCount = 0;
    FailureBlock failureBlock = ^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    };
    SuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger statusCode = 0;
        NSString *message = @"";
        id stackTrace;
        id result;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)responseObject;
            if ([dict.allKeys containsObject:@"errorCode"]) {
                statusCode = [dict[@"errorCode"] integerValue];
                message = dict[@"errorMessage"];
                stackTrace = dict[@"stackTrace"];
                result = dict;
                if (statusCode == 9) {
                    iLog(@"%@", message);
                    return;
                }
            }else if ([dict.allKeys containsObject:@"code"]){
                statusCode = [dict[@"code"] integerValue];
                message = dict[@"message"];
                stackTrace = dict[@"stackTrace"];
                result = dict[@"result"];
            }else{
                result = dict;
            }
        }else{
            result = responseObject;
        }
        
        //[SVProgressHUD dismiss];
        if (statusCode == 0) {
            iLog(@"URL：%@\r\n服务成功返回结果：%@", operation.request.URL, responseObject);
            if (success) {success(result);}
        } else if (statusCode == 10){//未登录或登录超时
            if (requestCount == 0) {
                requestCount++;
            }
        } else {
            if ([message isKindOfClass:NSData.class]) {
                NSString *msg = [[NSString alloc] initWithData:(NSData*)message encoding:NSUTF8StringEncoding];
                if (msg) {
                    message = msg;
                }
            }
            //[SVProgressHUD showErrorWithStatus:message];
            if (failure) {
                NSDictionary *userInfo = @{
                                           NSLocalizedDescriptionKey : message,//详细描述
                                           NSLocalizedFailureReasonErrorKey : NilWrapper(stackTrace),//失败原因
                                           NSLocalizedRecoverySuggestionErrorKey : @"请求发送成功，但服务器返回错误的结果，可能是请求数据不能通过服务器验证或服务器处理异常。"//恢复建议
                                           };
                NSError *error = [NSError errorWithDomain:@"NSHTTPRequestFailureError" code:statusCode userInfo:userInfo];
                iLog(@"URL：%@\r\n服务端异常：%@\n Stack:%@", operation.request.URL, message, NilWrapper(stackTrace));
                failure(error);
            }
        }
    };
    return [self executeRequest:manager method:method url:url parameters:parameters success:successBlock failure:failureBlock];
}

- (AFHTTPRequestOperation*)executeRequestForForm:(AFHTTPRequestOperationManager *)manager
                                          method:(HTTPRequestMethod)method
                                             url:(NSString *)url
                                            form:(NSDictionary *)parameters
                                         success:(HTTPSuccessHandler)success
                                         failure:(HTTPFailureHandler)failure{
    manager.requestSerializer = [self getAFHTTPRequestSerializer];
    return [self executeRequest:manager method:method url:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseData) {
        if (success) {
            success(responseData);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  「同步」调用服务端服务，包装AFHTTPRequestOperationManager使用，处理服务端返回的异常，输出请求日志
 *
 *  @param url        服务地址
 *  @param parameters 请求参数
 */
- (AFHTTPRequestOperation *)postForObject:(NSString *)url
           parameters:(NSDictionary *)parameters {
    AFHTTPRequestOperationManager *manager = [self getJSONRequestManager];
    manager.requestSerializer = [self getAFHTTPRequestSerializer];
    AFHTTPRequestOperation *requestOperation = [self executeRequestForJSON:manager method:HTTPRequestMethodPOST url:url parameters:parameters success:nil failure:nil];
    [requestOperation waitUntilFinished];
    return requestOperation;
}

- (AFHTTPRequestOperation *)uploadFileForObject:(NSString *)url parameters:(NSDictionary *)parameters success:(HTTPSuccessHandler)success failure:(HTTPFailureHandler)failure {
    AFHTTPRequestOperationManager *manager = [self getJSONRequestManager];
    manager.requestSerializer = [self getAFHTTPRequestSerializer];
    return [self executeUploadFile:manager url:url parameters:parameters success:success failure:failure];
}

- (AFHTTPRequestOperation *)uploadFile:(NSString *)url parameters:(NSDictionary *)parameters success:(HTTPSuccessHandler)success failure:(HTTPFailureHandler)failure {
    AFHTTPRequestOperationManager *manager = [self getHttpRequestManager];
    return [self executeUploadFile:manager url:url parameters:parameters success:success failure:failure];
}

- (AFHTTPRequestOperation *)uploadFile:(NSString *)url parameters:(NSDictionary *)parameters success:(HTTPSuccessHandler)success failure:(HTTPFailureHandler)failure progress:(HTTPUploadProgressHandler)progress {
    AFHTTPRequestOperationManager *manager = [self getHttpRequestManager];
    return [self executeUploadFile:manager url:url parameters:parameters success:success failure:failure progress:progress];
}

- (AFHTTPRequestOperation *)executeUploadFile:(AFHTTPRequestOperationManager *)manager url:(NSString *)url parameters:(NSDictionary *)parameters success:(HTTPSuccessHandler)success failure:(HTTPFailureHandler)failure {
    return [self executeUploadFile:manager url:url parameters:parameters success:success failure:failure progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        //上传进度
        float progress = ((float)totalBytesWritten) / (totalBytesExpectedToWrite);
        NSLog(@"上传进度：%f",progress);
        [SVProgressHUD showProgress:progress];
    }];
}

- (AFHTTPRequestOperation *)executeUploadFile:(AFHTTPRequestOperationManager *)manager url:(NSString *)url parameters:(NSDictionary *)parameters success:(HTTPSuccessHandler)success failure:(HTTPFailureHandler)failure progress:(HTTPUploadProgressHandler)progress {
    NSTimeInterval timeoutInterval = manager.requestSerializer.timeoutInterval;
    manager.requestSerializer.timeoutInterval = 0;
    
    AFHTTPRequestOperation *operation = [self executeRequest:manager method:HTTPRequestMethodMultipartData url:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id response) {
        dLog(@"文件上传成功：%@", response);
        manager.requestSerializer.timeoutInterval = timeoutInterval;
        [SVProgressHUD dismiss];
        if (success) {
            success(response);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        eLog(@"网络异常：%@", error);
        manager.requestSerializer.timeoutInterval = timeoutInterval;
        [SVProgressHUD dismiss];
        if (failure) {
            failure(error);
        }
    }];
    if (progress) {
        [operation setUploadProgressBlock:progress];
    }
    return operation;
}

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
             failure:(HTTPFailureHandler)failure {
    return [self downloadFile:url parameters:nil fileName:fileName success:success failure:failure];
}

- (AFHTTPRequestOperation *)downloadFile:(NSString *)url
                                fileName:(NSString *)fileName
                                 success:(void (^)(NSString *filePath))success
                                 failure:(HTTPFailureHandler)failure
                                progress:(HTTPDownloadProgressHandler)progress {
    return [self downloadFile:url parameters:nil fileName:fileName success:success failure:failure progress:progress];
}

- (AFHTTPRequestOperation *)downloadFile:(NSString *)url
                              parameters:(NSDictionary *)parameters
                                fileName:(NSString *)fileName
                                 success:(void (^)(NSString *filePath))success
                                 failure:(HTTPFailureHandler)failure{
    return [self downloadFile:url parameters:parameters fileName:fileName success:success failure:failure progress:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        //下载进度
        float progress = ((float)totalBytesRead) / (totalBytesExpectedToRead);
        NSLog(@"下载进度：%f。总字节数：%lld，已下载字节数：%lld",progress,totalBytesExpectedToRead,totalBytesRead);
        [SVProgressHUD showProgress:progress];
    }];
}
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
            progress:(HTTPDownloadProgressHandler)progress{
    dLog(@"请求服务：%@\n 参数：%@", url, parameters);
    NSString *saveFilePath = fileName;
    if (!fileName || ![fileName hasPrefix:@"/"]) {
        if (fileName == nil || fileName.length == 0) {
            fileName = [NSString stringWithFormat:@"%@.tmp", [NSUUID UUID].UUIDString];
        }
        //saveFilePath = GetTmpPathDownloadFileName(fileName);
    }
    AFHTTPRequestOperationManager *manager = [self getHttpRequestManager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"*/*"]];
    AFHTTPRequestOperation* operation = [self executeRequest:manager method:HTTPRequestMethodGET url:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id response) {
        dLog(@"下载文件成功：%@", saveFilePath);
        if(![[NSFileManager defaultManager] fileExistsAtPath:saveFilePath]) {
            if ([response isKindOfClass:NSData.class]) {
                NSData *data = (NSData*)response;
                NSError *error;
                [data writeToFile:saveFilePath options:NSDataWritingAtomic error:&error];
                if (error) {
                    eLog(@"下载文件[%@]保存失败：%@", saveFilePath, error);
                }
            }
        }
        [SVProgressHUD dismiss];
        if (success) {
            success(saveFilePath);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        eLog(@"网络异常：%@", error);
        [SVProgressHUD dismiss];
        if (failure) {
            failure(error);
        }
    }];
    if (progress) {
        //下载进度回调
        [operation setDownloadProgressBlock:progress];
    }
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:saveFilePath append:NO];

    [operation start];
    return operation;
}
@end

@implementation YGRestClient (Basic)


- (AFHTTPRequestSerializer *)getAFHTTPRequestSerializer{
    static AFHTTPRequestSerializer *requestSerializer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        requestSerializer = [AFHTTPRequestSerializer serializer];
    });
    return requestSerializer;
}

- (AFJSONRequestSerializer *)getAFJSONRequestSerializer{
    static AFJSONRequestSerializer *requestSerializer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        requestSerializer = [AFJSONRequestSerializer serializer];
    });
    return requestSerializer;
}

- (AFHTTPResponseSerializer *)getAFHTTPResponseSerializer{
    static AFHTTPResponseSerializer *responseSerializer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        responseSerializer = [AFHTTPResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/plain", @"application/x-www-form-urlencoded"]];
    });
    return responseSerializer;
}

- (AFJSONResponseSerializer *)getAFJSONResponseSerializer{
    static AFJSONResponseSerializer *responseSerializer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        responseSerializer = [AFJSONResponseSerializer serializer];
        responseSerializer.removesKeysWithNullValues = YES;//剔除json中的空属性
        
        responseSerializer.acceptableContentTypes = [responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/plain", @"application/x-www-form-urlencoded"]];
    });
    return responseSerializer;
}

/**
 *  获取单例的RequestManager
 */
- (AFHTTPRequestOperationManager *)getHttpRequestManager {
    static AFHTTPRequestOperationManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPRequestOperationManager manager];
    });
    manager.responseSerializer = [self getAFHTTPResponseSerializer];
    manager.requestSerializer = [self getAFHTTPRequestSerializer];
    return manager;
}

/**
 *  获取JSON格式提交的RequestManager
 */
- (AFHTTPRequestOperationManager *)getJSONRequestManager {
    static AFHTTPRequestOperationManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPRequestOperationManager manager];
    });
    manager.responseSerializer = [self getAFJSONResponseSerializer];
    manager.requestSerializer = [self getAFJSONRequestSerializer];
    
    return manager;
}
/**
 *  用于图片文件下载的RequestManager
 */
- (AFHTTPRequestOperationManager *)getImageRequestManager {
    static AFHTTPRequestOperationManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFImageResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/plain", @"application/x-www-form-urlencoded"]];
    });
    manager.requestSerializer = [self getAFJSONRequestSerializer];
    return manager;
}

@end

@interface NSURL (YGRestClient)
- (NSString *)baseUrl;
@end

@implementation NSURL (YGRestClient)
- (NSString *)baseUrl {
    NSString *baseUrl = [NSString stringWithFormat:@"%@//%@", self.scheme, self.host];
    if (self.port && self.port.intValue > 0) {
        baseUrl = [baseUrl stringByAppendingFormat:@":%@", self.port];
    }
    return baseUrl;
}
@end
