//
//  MTLModel+Merge.h
//  Linkage
//
//  Created by lihaijian on 16/4/20.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Mantle/Mantle.h>

@protocol MTLJSONSerializingExt <MTLJSONSerializing>
@optional
- (NSSet *)propertyMergeKeys;
@end

@interface MTLModel (Merge)

- (void)mergeValuesForMergeKeysFromModel:(id<MTLJSONSerializingExt>)model;

@end
