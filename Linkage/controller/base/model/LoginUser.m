//
//  LoginUser.m
//  Linkage
//
//  Created by lihaijian on 16/3/12.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "LoginUser.h"

#define kUserDefalutLoginUserKey    @"kUserDefalutLoginUserKey"
static LoginUser *user;
@implementation LoginUser

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.email forKey:email];
    [aCoder encodeObject:self.phoneNum forKey:phoneNum];
    [aCoder encodeObject:self.tokenId forKey:tokenId];
    [aCoder encodeObject:self.userName forKey:userName];
    [aCoder encodeObject:self.userId forKey:userId];
    [aCoder encodeObject:self.avatar forKey:avatar];
    [aCoder encodeObject:self.sex forKey:sex];

}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.email = [aDecoder decodeObjectForKey:email];
        self.phoneNum = [aDecoder decodeObjectForKey:phoneNum];
        self.tokenId = [aDecoder decodeObjectForKey:tokenId];
        self.userName = [aDecoder decodeObjectForKey:userName];
        self.userId = [aDecoder decodeObjectForKey:userId];
        self.avatar = [aDecoder decodeObjectForKey:avatar];
        self.sex = [aDecoder decodeObjectForKey:sex];

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
DEF_RMMapperModel(LoginUser)

