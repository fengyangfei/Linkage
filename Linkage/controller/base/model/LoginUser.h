//
//  LoginUser.h
//  Linkage
//
//  Created by lihaijian on 16/3/12.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "MTLManagedObjectAdapter.h"

typedef NS_ENUM(NSUInteger,UserGender) {
    Male,
    Female
};
@interface LoginUser : MTLModel<MTLJSONSerializing>
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *password;
@property (nonatomic,copy) NSString *token;
@property (nonatomic,assign) UserGender gender;
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *email;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,strong) NSDate *birthday;
@property (nonatomic,copy) NSString *avatar;
@property (nonatomic, strong) NSDate *createTime;
@property (nonatomic, strong) NSDate *updateTime;

-(BOOL)save;
+(LoginUser *)shareInstance;
+(BOOL)clearUserInfo;
@end

@interface LoginUser (Extensions)
UserDefault_Attr(currentLocation, NSString *)//用户所在地
@end
