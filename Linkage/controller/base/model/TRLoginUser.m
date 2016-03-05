//
//  TRLoginUser.m
//  YGTravel
//
//  Created by Mac mini on 15/9/18.
//  Copyright (c) 2015年 ygsoft. All rights reserved.
//

#import "TRLoginUser.h"

NSString * const email = @"email";
NSString * const phoneNumber = @"phoneNumber";
NSString * const tokenId = @"tokenId";
NSString * const userName = @"userName";
NSString * const userId = @"userId";
NSString * const photoId = @"photoId";

#define kUserDefalutLoginUserKey    @"kUserDefalutLoginUserKey"
#define TRUserDefaultkey(attr)      [NSString stringWithFormat:@"UserDefaultKey_%s", #attr]

#define TRLoginUser_AttrImpl(attr,attrType) \
+ (attrType)attr \
{ \
    return [[NSUserDefaults standardUserDefaults] objectForKey:TRUserDefaultkey(attr)]; \
}\
+ (void)set##attr:(attrType)attr \
{\
    [[NSUserDefaults standardUserDefaults] setObject:attr forKey:TRUserDefaultkey(attr)];\
    [[NSUserDefaults standardUserDefaults] synchronize];\
}

#define TRLoginUser_AttrBoolImpl(attr,attrType) \
+ (attrType)attr \
{ \
    return [[NSUserDefaults standardUserDefaults] boolForKey:TRUserDefaultkey(attr)]; \
}\
+ (void)set##attr:(attrType)attr \
{\
    [[NSUserDefaults standardUserDefaults] setBool:attr forKey:TRUserDefaultkey(attr)];\
    [[NSUserDefaults standardUserDefaults] synchronize];\
}

#define TRLoginUser_AttrIntegerImpl(attr,attrType) \
+ (attrType)attr \
{ \
    return [[NSUserDefaults standardUserDefaults] integerForKey:TRUserDefaultkey(attr)]; \
}\
+ (void)set##attr:(attrType)attr \
{\
    [[NSUserDefaults standardUserDefaults] setInteger:attr forKey:TRUserDefaultkey(attr)];\
    [[NSUserDefaults standardUserDefaults] synchronize];\
}

static TRLoginUser *user;
@implementation TRLoginUser

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
+(TRLoginUser *)shareInstance
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

@implementation TRLoginUser(Extensions)
TRLoginUser_AttrBoolImpl(authenticated, BOOL)
TRLoginUser_AttrBoolImpl(isTravelMode, BOOL)
TRLoginUser_AttrImpl(currentLocation, NSString *)
TRLoginUser_AttrImpl(currentCity, NSString *)
TRLoginUser_AttrImpl(latitude, NSNumber *)
TRLoginUser_AttrImpl(longitude, NSNumber *)
TRLoginUser_AttrImpl(type, NSString *)
TRLoginUser_AttrImpl(wendu, NSString *)
TRLoginUser_AttrImpl(fengli, NSString *)
TRLoginUser_AttrImpl(high, NSString *)
TRLoginUser_AttrImpl(low, NSString *)
TRLoginUser_AttrImpl(updateTime, NSNumber *)
TRLoginUser_AttrImpl(centerId, NSString *)
TRLoginUser_AttrImpl(centerName, NSString *)
TRLoginUser_AttrImpl(costItemId, NSString *)
TRLoginUser_AttrImpl(costItemName, NSString *)
TRLoginUser_AttrImpl(hotelLevel, NSString *)
TRLoginUser_AttrImpl(hotelLevelName, NSString *)
TRLoginUser_AttrImpl(accountRecentCostTypeId, NSNumber *)
TRLoginUser_AttrImpl(accountTransportationDic, NSDictionary *)
TRLoginUser_AttrIntegerImpl(todoCount, NSInteger)
TRLoginUser_AttrIntegerImpl(doneCount, NSInteger)
TRLoginUser_AttrImpl(lastCheckUpdateTime, NSDate *)//最后一次检查版本更新的日期
@end

DEF_RMMapperModel(TRLoginUser)
