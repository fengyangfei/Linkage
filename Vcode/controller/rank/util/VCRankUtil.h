//
//  VCRankUtil.h
//  Linkage
//
//  Created by Mac mini on 2017/1/3.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "ModelUtil.h"

@interface VCRankUtil : ModelUtil
+(void)queryHotRank:(NSDictionary *)parameter completion:(void(^)(NSArray *models))completion failure:(void(^)(NSError *error))failure;
+(void)queryRecommendRank:(NSDictionary *)parameter completion:(void(^)(NSArray *models))completion failure:(void(^)(NSError *error))failure;
+(void)queryGlobalRank:(NSDictionary *)parameter completion:(void(^)(NSArray *models))completion failure:(void(^)(NSError *error))failure;
+(void)queryLocalRank:(NSDictionary *)parameter completion:(void(^)(NSArray *models))completion failure:(void(^)(NSError *error))failure;
+(void)queryCategoryRank:(NSDictionary *)parameter completion:(void(^)(NSArray *models))completion failure:(void(^)(NSError *error))failure;
@end
