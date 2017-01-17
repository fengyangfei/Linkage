//
//  VCCategoryModel.h
//  Linkage
//
//  Created by lihaijian on 2017/1/3.
//  Copyright © 2017年 LA. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface VCCategoryModel : NSManagedObject
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *code;
@property (nullable, nonatomic, copy) NSString *imageName;
@property (nullable, nonatomic, retain) NSNumber *sort;
@property (nonatomic) BOOL visible;
@property (nonatomic) BOOL favor;
@end
