//
//  VCRankModel.h
//  Linkage
//
//  Created by Mac mini on 2017/1/3.
//  Copyright © 2017年 LA. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface VCRankModel : NSManagedObject
@property (nullable, nonatomic, retain) NSString *gid;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *introduction;
@property (nullable, nonatomic, retain) NSString *country;
@property (nullable, nonatomic, retain) NSString *countryCode;
@property (nullable, nonatomic, retain) NSString *category;
@property (nullable, nonatomic, retain) NSString *categoryCode;
@property (nullable, nonatomic, retain) NSString *subCategory;
@property (nullable, nonatomic, retain) NSString *subCategoryCode;
@property (nullable, nonatomic, retain) NSString *rank;
@property (nullable, nonatomic, retain) NSDate   *createdDate;
@property (nullable, nonatomic, retain) NSString *userId;
@property (nullable, nonatomic, retain) NSNumber *visiteCount;
@property (nullable, nonatomic, retain) NSNumber *favorCount;
@property (nullable, nonatomic, retain) NSNumber *likeCount;
@end
