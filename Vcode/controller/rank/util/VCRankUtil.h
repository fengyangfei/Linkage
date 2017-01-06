//
//  VCRankUtil.h
//  Linkage
//
//  Created by Mac mini on 2017/1/3.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "ModelUtil.h"

@interface VCRankUtil : ModelUtil
+(void)queryRecommendRank:(NSDictionary *)parameter completion:(void(^)(NSArray *models))completion;
+(void)queryHotRank:(NSDictionary *)parameter completion:(void(^)(NSArray *models))completion;
+(void)queryGlobalRank:(NSDictionary *)parameter completion:(void(^)(NSArray *models))completion;
+(void)queryLocalRank:(NSDictionary *)parameter completion:(void(^)(NSArray *models))completion;
+(void)queryCategoryRank:(NSDictionary *)parameter completion:(void(^)(NSArray *models))completion;
@end
