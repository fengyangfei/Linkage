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
    UserTypeSubCompanyDriver//承运商司机
};

@class LoginUser;
@protocol LoginUserDelegate <NSObject>
@required
-(BOOL)save;
+(LoginUser *)shareInstance;
+(BOOL)clearUserInfo;
@optional
-(NSDictionary *)baseHttpParameter;
-(NSDictionary *)basePageHttpParameter;
@end

@interface LoginUser : MTLModel<MTLJSONSerializingExt,LoginUserDelegate>
@property (nonatomic,copy   ) NSString   *cid;
@property (nonatomic,copy   ) NSString   *userId;
@property (nonatomic,copy   ) NSString   *userName;
@property (nonatomic,copy   ) NSString   *realName;
@property (nonatomic,copy   ) NSString   *password;
@property (nonatomic,copy   ) NSString   *token;
@property (nonatomic,assign ) UserGender gender;
@property (nonatomic,copy   ) NSString   *mobile;
@property (nonatomic,copy   ) NSString   *email;
@property (nonatomic,copy   ) NSString   *address;
@property (nonatomic,strong ) NSDate     *birthday;
@property (nonatomic,copy   ) NSString   *avatar;
@property (nonatomic,copy   ) NSString   *icon;//服务端返回的头像URL
@property (nonatomic,copy   ) NSString   *companyId;//用户所属公司ID
@property (nonatomic,copy   ) NSString   *identity;
@property (nonatomic, strong) NSDate     *createTime;
@property (nonatomic, strong) NSDate     *updateTime;
@property (nonatomic, assign) UserType   ctype;
@property (nonatomic, strong) NSArray    *companies;//首页的公司
@property (nonatomic, strong) NSArray    *advertes;//广告
@end

@interface LoginUser (Extensions)
UserDefault_Attr(receiveSms, BOOL)//接收平台短信
UserDefault_Attr(receiveEmail, BOOL)//接收平台邮件
UserDefault_Attr(searchKeys, NSArray *)//搜索历史
UserDefault_Attr(searchCompanyKeys, NSArray *)//搜索历史

+(Company *)findCompanyById:(NSString *)companyId;
-(void)setupTheme;
@end

@interface Advert : MTLModel<MTLJSONSerializing>
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *link;
@property (nonatomic,copy) NSString *title;
@end
