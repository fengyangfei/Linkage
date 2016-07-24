//
//  Comment.m
//  Linkage
//
//  Created by lihaijian on 16/7/24.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "Comment.h"
#import "OrderModel.h"

@implementation Comment

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyMap = @{
                             @"commentId":@"comment_id"
                             };
    NSDictionary *keys = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    keys = [keys mtl_dictionaryByAddingEntriesFromDictionary:keyMap];
    return keys;
}

+(NSValueTransformer *)scoreJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError **error) {
        if ([value isKindOfClass:[NSString class]]) {
            return @([value intValue]);
        }else if ([value isKindOfClass:[NSNumber class]]){
            return value;
        }else{
            return @(0);
        }
    } reverseBlock:^id(id value, BOOL *success, NSError **error) {
        return value;
    }];
}

#pragma mark - MTLManagedObjectSerializing
+ (NSString *)managedObjectEntityName
{
    return NSStringFromClass([CommentModel class]);
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

@end
