//
//  LinkUtil.m
//  Linkage
//
//  Created by Mac mini on 16/4/26.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "LinkUtil.h"
#import "LoginUser.h"
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/NSData+ImageContentType.h>
#import <SVProgressHUD/SVProgressHUD.h>

@implementation LinkUtil

+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy年MM月dd日";
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
                           @0:@"打单",
                           @1:@"提柜",
                           @2:@"送柜",
                           @3:@"待装货",
                           @4:@"还柜途中",
                           @5:@"进入码头",
                           @6:@"已卸柜"
                       };
    });
    return _taskStatus;
}

+ (NSArray *)userTypeOptions
{
    static NSArray * _options;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *_mutableOptions = [[NSMutableArray alloc]init];
        [self.userTypes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            XLFormOptionsObject *option = [XLFormOptionsObject formOptionsObjectWithValue:key displayText:obj];
            [_mutableOptions addObject:option];
        }];
        _options = [_mutableOptions copy];
    });
    return _options;
}

//上传到服务器
+(void)uploadWithUrl:(NSString *)url image:(NSData *)image name:(NSString *)fileName success:(void(^)(id responseObject))success
{
    NSDictionary *parameter = @{};
    parameter = [[LoginUser shareInstance].baseHttpParameter mtl_dictionaryByAddingEntriesFromDictionary:parameter];
    AFHTTPRequestOperationManager *manager = [[YGRestClient sharedInstance] getJSONRequestManager];
    manager.requestSerializer.timeoutInterval = 300.0f;
    AFHTTPRequestOperation *operation = [manager POST:url parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:image
                                    name:@"file"
                                fileName:fileName
                                mimeType:[NSData sd_contentTypeForImageData:image]];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
