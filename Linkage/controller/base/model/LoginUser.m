//
//  LoginUser.m
//  Linkage
//
//  Created by lihaijian on 16/3/12.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "LoginUser.h"
#define kUserDefalutLoginUserKey @"kUserDefalutLoginUserKey"
static LoginUser *user;
@implementation LoginUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyDic = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    [keyDic mtl_dictionaryByRemovingValuesForKeys:@[@"gender", @"createTime", @"updateTime"]];
    return keyDic;
}

+ (NSValueTransformer *)genderJSONTransformer
{
    NSDictionary *transDic = @{
                               @(0): @(Female),
                               @(1): @(Male)
                               };
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:transDic];
}

-(instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error
{
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self) {
        _createTime = [NSDate date];
        _updateTime = [NSDate date];
    }
    return self;
}

//保存登录用户信息
-(BOOL)save
{
    user = self;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kUserDefalutLoginUserKey];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

//获取用户信息
+(LoginUser *)shareInstance
{
    if (!user) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefalutLoginUserKey];
        if(data){
            user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }
    return user;
}

//清除用户信息
+(BOOL)clearUserInfo
{
    user = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefalutLoginUserKey];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

@implementation LoginUser(Extensions)
UserDefault_AttrImpl(currentLocation, NSString *)
@end

