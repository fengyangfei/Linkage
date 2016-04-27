//
//  LoginUser.h
//  Linkage
//
//  Created by lihaijian on 16/3/12.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "MTLManagedObjectAdapter.h"
#import "MTLModel+Merge.h"
#import "Company.h"
#import "ModelOperation.h"

typedef NS_ENUM(NSUInteger,UserGender) {
    Female,
    Male
};

typedef NS_ENUM(NSUInteger,UserType) {
    UserTypeCompanyAdmin,//厂商管理员
    UserTypeCompanyUser,//厂商普通员工
    UserTypeSubCompanyAdmin,//承运商管理员
    UserTypeSubCompanyUser,//承运商普通员工
    UserTypeSubCompanyDriver////承运商司机
};

@interface LoginUser : MTLModel<MTLJSONSerializingExt,ModelHttpParameter>
@property (nonatomic,copy) NSString *cid;
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
@property (nonatomic, assign) UserType ctype;
@property (nonatomic, strong) NSArray *companies;

-(BOOL)save;
+(LoginUser *)shareInstance;
+(BOOL)clearUserInfo;
@end

@interface LoginUser (Extensions)
UserDefault_Attr(currentLocation, NSString *)//用户所在地

+(Company *)findCompanyById:(NSString *)companyId;
@end
