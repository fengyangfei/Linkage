//
//  PhotoModel+CoreDataProperties.h
//  Linkage
//
//  Created by Mac mini on 16/3/25.
//  Copyright © 2016年 LA. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PhotoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhotoModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *createTime;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *url;

@end

NS_ASSUME_NONNULL_END
