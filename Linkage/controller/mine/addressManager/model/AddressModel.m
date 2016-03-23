//
//  AddressModel.m
//  Linkage
//
//  Created by lihaijian on 16/3/23.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel

+(NSArray *)findAll
{
    return [AddressModel MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
}

+(AddressModel *)createEntity
{
    return [AddressModel MR_createEntityInContext:[NSManagedObjectContext MR_defaultContext]];
}

-(BOOL)remove
{
    return [self MR_deleteEntityInContext:[NSManagedObjectContext MR_defaultContext]];
}

@end
