//
//  MTLModel+Merge.m
//  Linkage
//
//  Created by lihaijian on 16/4/20.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "MTLModel+Merge.h"

@implementation MTLModel (Merge)

- (void)mergeValuesForMergeKeysFromModel:(id<MTLJSONSerializingExt>)model
{
    if ([model conformsToProtocol:@protocol(MTLJSONSerializingExt)]) {
        NSSet *propertyKeys = [model propertyMergeKeys];
        
        for (NSString *key in propertyKeys) {
            if (![propertyKeys containsObject:key]) continue;
            
            [self mergeValueForKey:key fromModel:model];
        }
    }
}

@end
