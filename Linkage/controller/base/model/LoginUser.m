//
//  LoginUser.m
//  Linkage
//
//  Created by lihaijian on 16/3/12.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "LoginUser.h"

NSString * const email = @"email";
NSString * const phoneNumber = @"phoneNumber";
NSString * const tokenId = @"tokenId";
NSString * const userName = @"userName";
NSString * const userId = @"userId";
NSString * const photoId = @"photoId";

#define kUserDefalutLoginUserKey    @"kUserDefalutLoginUserKey"
#define UserDefaultkey(attr)      [NSString stringWithFormat:@"UserDefaultKey_%s", #attr]

#define LoginUser_AttrImpl(attr,attrType) \
+ (attrType)attr \
{ \
return [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultkey(attr)]; \
}\
+ (void)set##attr:(attrType)attr \
{\
[[NSUserDefaults standardUserDefaults] setObject:attr forKey:UserDefaultkey(attr)];\
[[NSUserDefaults standardUserDefaults] synchronize];\
}

#define LoginUser_AttrBoolImpl(attr,attrType) \
+ (attrType)attr \
{ \
return [[NSUserDefaults standardUserDefaults] boolForKey:UserDefaultkey(attr)]; \
}\
+ (void)set##attr:(attrType)attr \
{\
[[NSUserDefaults standardUserDefaults] setBool:attr forKey:UserDefaultkey(attr)];\
[[NSUserDefaults standardUserDefaults] synchronize];\
}

#define LoginUser_AttrIntegerImpl(attr,attrType) \
+ (attrType)attr \
{ \
return [[NSUserDefaults standardUserDefaults] integerForKey:UserDefaultkey(attr)]; \
}\
+ (void)set##attr:(attrType)attr \
{\
[[NSUserDefaults standardUserDefaults] setInteger:attr forKey:UserDefaultkey(attr)];\
[[NSUserDefaults standardUserDefaults] synchronize];\
}

static LoginUser *user;
@implementation LoginUser

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.email forKey:email];
    [aCoder encodeObject:self.phoneNumber forKey:phoneNumber];
    [aCoder encodeObject:self.tokenId forKey:tokenId];
    [aCoder encodeObject:self.userName forKey:userName];
    [aCoder encodeObject:self.userId forKey:userId];
    [aCoder encodeObject:self.photoId forKey:photoId];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.email = [aDecoder decodeObjectForKey:email];
        self.phoneNumber = [aDecoder decodeObjectForKey:phoneNumber];
        self.tokenId = [aDecoder decodeObjectForKey:tokenId];
        self.userName = [aDecoder decodeObjectForKey:userName];
        self.userId = [aDecoder decodeObjectForKey:userId];
        self.photoId = [aDecoder decodeObjectForKey:photoId];
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

- (NSArray *)rm_excludedProperties
{
    return @[];
}

- (Class)rm_itemClassForArrayProperty:(NSString*)property
{
    return nil;
}

@end

@implementation LoginUser(Extensions)
LoginUser_AttrImpl(currentLocation, NSString *)

@end

DEF_RMMapperModel(LoginUser)
