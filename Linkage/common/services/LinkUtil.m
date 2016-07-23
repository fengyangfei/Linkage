//
//  LinkUtil.m
//  Linkage
//
//  Created by Mac mini on 16/4/26.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "LinkUtil.h"
#import "LoginUser.h"
#import "Order.h"
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/NSData+ImageContentType.h>
#import <SVProgressHUD/SVProgressHUD.h>

@implementation LinkUtil

+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    });
    return dateFormatter;
}

+ (NSMutableDictionary *)cargoTypes
{
    static NSMutableDictionary * _cargoTypes;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _cargoTypes = [@{@0:@"GP(20尺)",
                         @1:@"GP(40尺)",
                         @2:@"HQ(40尺)",
                         @3:@"HQ(45尺)",
                         @4:@"OT(20尺)",
                         @5:@"OT(40尺)",
                         @6:@"FR(20尺)",
                         @7:@"FR(40尺)",
                         @8:@"FR(45尺)",
                         @9:@"R(20尺)",
                         @10:@"R(40尺)"} mutableCopy];
    });
    return _cargoTypes;
}

+ (NSDictionary *)userTypes
{
    static NSDictionary * _userTypes;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _userTypes = @{
                         @0:@"厂商管理员",
                         @1:@"承厂商普通员工",
                         @2:@"承运商管理员",
                         @3:@"承运商普通员工",
                         @4:@"承运商司机"
                        };
    });
    return _userTypes;
}

+ (NSDictionary *)taskStatus
{
    static NSDictionary * _taskStatus;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _taskStatus = @{
                           @0:@"接单",
                           @1:@"打单",
                           @2:@"提柜",
                           @3:@"送柜",
                           @4:@"装货",
                           @5:@"还柜",
                           @6:@"进入码头",
                           @7:@"卸货",
                           @8:@"任务完成"
                       };
    });
    return _taskStatus;
}

+ (NSDictionary *)orderStatus
{
    static NSDictionary * _orderStatus;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _orderStatus = @{
                        @(OrderStatusPending):@"待处理",
                        @(OrderStatusExecuting):@"处理中",
                        @(OrderStatusDenied):@"被拒绝",
                        @(OrderStatusCompletion):@"确认完成",
                        @(OrderStatusCancelled):@"已取消"
                        };
    });
    return _orderStatus;
}

+ (NSDictionary *)ports
{
    static NSDictionary * _ports;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _ports = @{
                          @1:@"洪湾",
                          @2:@"西域",
                          @3:@"湾仔",
                          @4:@"高栏",
                          @5:@"斗门",
                          @6:@"其他"
                };
    });
    return _ports;
}

+ (NSDictionary *)addressTypes
{
    static NSDictionary * _addressTypes;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _addressTypes = @{
                         @(AddressTypeTake):@"装货地址",
                         @(AddressTypeDelivery):@"送货地址"
                         };
    });
    return _addressTypes;
}

+ (NSArray *)userTypeOptions
{
    static NSArray * _userTypeOptions;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        XLFormOptionsObject *op1 = [XLFormOptionsObject formOptionsObjectWithValue:@0 displayText:[self.userTypes objectForKey:@0]];
        XLFormOptionsObject *op2 = [XLFormOptionsObject formOptionsObjectWithValue:@2 displayText:[self.userTypes objectForKey:@2]];
        _userTypeOptions = @[op1, op2];
    });
    return _userTypeOptions;
}

+ (NSArray *)addressTypeOptions
{
    static NSArray * _addressTypeOptions;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *array = [NSMutableArray array];
        for (NSNumber *key in [self.addressTypes allKeys]) {
            [array addObject:[XLFormOptionsObject formOptionsObjectWithValue:key displayText:[self.addressTypes objectForKey:key]]];
        }
        _addressTypeOptions = [array copy];
    });
    return _addressTypeOptions;
}

+ (NSArray *)portOptions
{
    static NSArray * _portOptions;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *array = [NSMutableArray array];
        NSArray *sortKeys = [[self.ports allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
        {
            return [obj1 compare:obj2];
        }];
        for (NSNumber *key in sortKeys) {
            NSString *value = [self.ports objectForKey:key];
            [array addObject:[XLFormOptionsObject formOptionsObjectWithValue:value displayText:value]];
        }
        _portOptions = [array copy];
    });
    return _portOptions;
}

//上传到服务器
+(void)uploadWithUrl:(NSString *)url image:(NSData *)image name:(NSString *)fileName success:(void(^)(id responseObject))success
{
    NSDictionary *parameter = @{};
    parameter = [[LoginUser shareInstance].baseHttpParameter mtl_dictionaryByAddingEntriesFromDictionary:parameter];
    AFHTTPRequestOperationManager *manager = [[YGRestClient sharedInstance] getJSONRequestManager];
    manager.requestSerializer.timeoutInterval = 300.0f;
    dLog(@"请求服务：%@\n 参数：%@", url, parameter);
    AFHTTPRequestOperation *operation = [manager POST:url parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:image
                                    name:@"file"
                                fileName:fileName
                                mimeType:[NSData sd_contentTypeForImageData:image]];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        iLog(@"URL：%@\r\n服务成功返回结果：%@", operation.request.URL, responseObject);
        [SVProgressHUD showSuccessWithStatus:@"上传成功"];
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"上传失败"];
    }];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        float p = (totalBytesWritten + 0.0f) / totalBytesExpectedToWrite;
        [SVProgressHUD showProgress:p status:@"上传中"];
    }];
}


@end
