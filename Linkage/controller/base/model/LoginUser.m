//
//  LoginUser.m
//  Linkage
//
//  Created by lihaijian on 16/3/12.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "LoginUser.h"
#import "Company.h"
#define kUserDefalutLoginUserKey @"kUserDefalutLoginUserKey"
static LoginUser *user;
@implementation LoginUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyDic = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    keyDic = [keyDic mtl_dictionaryByRemovingValuesForKeys:@[@"createTime", @"updateTime",@"birthday"]];
    return keyDic;
}

+ (NSValueTransformer *)genderJSONTransformer
{
    NSDictionary *transDic = @{
                               @"F": @(Female),
                               @"M": @(Male)
                               };
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:transDic defaultValue:@(Male) reverseDefaultValue:@"M"];
}

+ (NSValueTransformer *)ctypeJSONTransformer
{
    NSDictionary *transDic = @{
                               @(0): @(UserTypeCompanyAdmin),
                               @(1): @(UserTypeCompanyUser),
                               @(2): @(UserTypeSubCompanyAdmin),
                               @(3): @(UserTypeSubCompanyUser),
                               @(4): @(UserTypeSubCompanyDriver)
                               };
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:transDic defaultValue:@(UserTypeCompanyAdmin) reverseDefaultValue:@(0)];
}

+ (NSValueTransformer *)companiesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[Company class]];
}

- (NSSet *)propertyMergeKeys
{
    return [NSSet setWithArray:@[@"userName",@"gender",@"email",@"avatar"]];
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

-(NSDictionary *)baseHttpParameter
{
    return @{
             @"cid":self.cid,
             @"token":self.token
             };
}
@end

@implementation LoginUser(Extensions)
UserDefault_AttrImpl(currentLocation, NSString *)

+(Company *)findCompanyById:(NSString *)companyId
{
    __block Company *company;
    [[LoginUser shareInstance].companies enumerateObjectsUsingBlock:^(Company *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.companyId isEqualToString:companyId]) {
            company = obj;
            *stop = YES;
        }
    }];
    return company;
}
@end

