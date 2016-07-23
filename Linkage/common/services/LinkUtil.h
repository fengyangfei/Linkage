//
//  LinkUtil.h
//  Linkage
//
//  Created by Mac mini on 16/4/26.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LinkUtil : NSObject

+ (NSDateFormatter *)dateFormatter;

+ (NSMutableDictionary *)cargoTypes;

+ (NSDictionary *)userTypes;

+ (NSDictionary *)taskStatus;

+ (NSDictionary *)orderStatus;

+ (NSDictionary *)ports;

+ (NSDictionary *)addressTypes;

+ (NSDictionary *)orderTitles;

+ (NSArray *)userTypeOptions;

+ (NSArray *)addressTypeOptions;

+ (NSArray *)portOptions;

//上传到服务器
+ (void)uploadWithUrl:(NSString *)url image:(NSData *)image name:(NSString *)fileName success:(void(^)(id responseObject))success;

@end
