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
    NSDictionary *keys = @{
                          @"userName":@"username",
                          @"realName":@"realname",
                          @"companyId":@"company_id"
                          };
    NSDictionary *keyDic = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    keyDic = [keyDic mtl_dictionaryByAddingEntriesFromDictionary:keys];
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
                               @(3): @(UserTypeSubCompanyUser)
                               };
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:transDic defaultValue:@(UserTypeCompanyAdmin) reverseDefaultValue:@(0)];
}

+ (NSValueTransformer *)companiesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[Company class]];
}

+ (NSValueTransformer *)advertesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[Advert class]];
}

- (NSSet *)propertyMergeKeys
{
    return [NSSet setWithArray:@[@"userName",@"gender",@"email",@"avatar",@"realName"]];
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kUserDefalutLoginUserKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    });
    return YES;
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefalutLoginUserKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    });
    return YES;
}

-(NSDictionary *)baseHttpParameter
{
    return @{
             @"cid":self.cid,
             @"token":self.token
             };
}

-(NSDictionary *)basePageHttpParameter
{
    NSDictionary *extensMap = @{
                                @"pagination":@0,
                                @"offset":@0,
                                @"size":@1000
                                };
    return [self.baseHttpParameter mtl_dictionaryByAddingEntriesFromDictionary:extensMap];
}
@end

@implementation LoginUser(Extensions)
UserDefault_AttrBoolImpl(receiveSms, BOOL)//接收平台短信
UserDefault_AttrBoolImpl(receiveEmail, BOOL)//接收平台邮件
UserDefault_AttrImpl(searchKeys, NSArray *)//搜索历史
UserDefault_AttrImpl(searchCompanyKeys, NSArray *)//搜索历史

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

-(void)setupTheme
{
    //主题变更
    if (self.ctype == UserTypeCompanyAdmin) {
        [TRThemeManager shareInstance].themeType = TRThemeTypeCompany;
    }else if (self.ctype == UserTypeSubCompanyAdmin){
        [TRThemeManager shareInstance].themeType = TRThemeTypeSubCompany;
    }else if (self.ctype == UserTypeCompanyUser){
        [TRThemeManager shareInstance].themeType = TRThemeTypeContact;
    }else if (self.ctype == UserTypeSubCompanyUser){
        [TRThemeManager shareInstance].themeType = TRThemeTypeSubContact;
    }else{
        [TRThemeManager shareInstance].themeType = TRThemeTypeCompany;
    }
}


@end

@implementation Advert

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keyDic = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    return keyDic;
}
@end

