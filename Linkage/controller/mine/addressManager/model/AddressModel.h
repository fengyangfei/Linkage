//
//  AddressModel.h
//  Linkage
//
//  Created by lihaijian on 16/3/23.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddressModel : NSManagedObject

+(NSArray *)findAll;

+(AddressModel *)createEntity;

-(BOOL)remove;

@end

NS_ASSUME_NONNULL_END

#import "AddressModel+CoreDataProperties.h"
