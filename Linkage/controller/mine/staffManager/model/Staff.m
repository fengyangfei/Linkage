//
//  Staff.m
//  Linkage
//
//  Created by lihaijian on 16/4/30.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "Staff.h"
#import "StaffModel.h"
#import "LoginUser.h"

@implementation Staff
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyMap = @{
                             @"staffId":@"staff_id",
                             @"staffIcon":@"staff_icon",
                             @"userName":@"username"
                             };
    NSDictionary *keyDic = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    keyDic = [keyDic mtl_dictionaryByAddingEntriesFromDictionary:keyMap];
    return keyDic;
}

#pragma mark - MTLManagedObjectSerializing
+ (NSString *)managedObjectEntityName
{
    return NSStringFromClass([StaffModel class]);
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    NSDictionary *keyDic = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    return keyDic;
}

#pragma mark - ModelHttpParameter
-(NSDictionary *)httpParameterForDetail
{
    if (!self.staffId) {
        return nil;
    }
    NSDictionary *baseParameter = [LoginUser shareInstance].baseHttpParameter;
    NSDictionary *paramter = [baseParameter mtl_dictionaryByAddingEntriesFromDictionary:@{@"staff_id": self.staffId}];
    return paramter;
}


#pragma mark - XLFormTitleOptionObject
-(NSString *)formTitleText
{
    return self.userName;
}

-(NSString *)formDisplayText
{
    return self.mobile;
}

-(id)formValue{
    return self.staffId;
}
@end
