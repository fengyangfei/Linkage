//
//  AddressModel+CoreDataProperties.h
//  Linkage
//
//  Created by lihaijian on 16/3/23.
//  Copyright © 2016年 LA. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "AddressModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddressModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *phoneNum;
@property (nullable, nonatomic, retain) NSString *address;

@end

NS_ASSUME_NONNULL_END
