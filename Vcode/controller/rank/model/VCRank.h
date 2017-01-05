//
//  VCRank.h
//  Linkage
//
//  Created by Mac mini on 2017/1/3.
//  Copyright © 2017年 LA. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "MTLManagedObjectAdapter.h"
#import "ModelOperation.h"

@interface VCRank : MTLModel<MTLJSONSerializing,MTLManagedObjectSerializing>
@property (nonatomic,copy  ) NSString *gid;
@property (nonatomic,copy  ) NSString *url;
@property (nonatomic,copy  ) NSString *name;
@property (nonatomic,copy  ) NSString *introduction;
@property (nonatomic,copy  ) NSString *country;
@property (nonatomic,copy  ) NSString *countryCode;
@property (nonatomic,copy  ) NSString *categoryCode;
@property (nonatomic,copy  ) NSString *category;
@property (nonatomic,copy  ) NSString *subCategory;
@property (nonatomic,copy  ) NSString *subCategoryCode;
@property (nonatomic,copy  ) NSString *rank;
@property (nonatomic,strong) NSDate   *createdDate;
@property (nonatomic,copy  ) NSString *userId;
@property (nonatomic,strong) NSNumber *visiteCount;
@property (nonatomic,strong) NSNumber *favorCount;
@property (nonatomic,strong) NSNumber *likeCount;
@end
