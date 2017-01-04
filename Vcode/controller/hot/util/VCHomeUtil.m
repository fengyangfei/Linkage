//
//  VCHomeUtil.m
//  Linkage
//
//  Created by lihaijian on 2017/1/4.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCHomeUtil.h"
#import "YGRestClient.h"
#import "VcodeUtil.h"
#import "VCIndex.h"

@implementation VCHomeUtil

+(void)queryModelFromServer:(void(^)(id<MTLJSONSerializing> model))completion
{
    [self queryHomePage:completion];
}

//首页请求
+(void)queryHomePage:(void(^)(id model))completion
{
    NSDictionary *parameter = @{@"deviceCode":[VcodeUtil UUID]};
    [[YGRestClient sharedInstance] postForObjectWithUrl:HomePageUrl form:parameter success:^(id responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSError *error;
            id model = [MTLJSONAdapter modelOfClass:[VCIndex class] fromJSONDictionary:responseObject error:&error];
            if (error) {
                NSLog(@"%@",error);
            }
            if (completion) {
                completion(model);
            }
        }else{
            completion(nil);
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end
