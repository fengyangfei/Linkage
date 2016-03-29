//
//  GlobalVariable.h
//  Linkage
//
//  Created by lihaijian on 16/3/25.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TRFormTextFieldCell.h"

#define UserDefault_Attr(attr,attrType) \
+ (attrType)attr; \
+ (void)set##attr:(attrType)attr;

#define UserDefaultkey(attr)      [NSString stringWithFormat:@"UserDefaultKey_%s", #attr]

#define UserDefault_AttrImpl(attr,attrType) \
+ (attrType)attr \
{ \
return [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultkey(attr)]; \
}\
+ (void)set##attr:(attrType)attr \
{\
[[NSUserDefaults standardUserDefaults] setObject:attr forKey:UserDefaultkey(attr)];\
[[NSUserDefaults standardUserDefaults] synchronize];\
}

#define UserDefault_AttrBoolImpl(attr,attrType) \
+ (attrType)attr \
{ \
return [[NSUserDefaults standardUserDefaults] boolForKey:UserDefaultkey(attr)]; \
}\
+ (void)set##attr:(attrType)attr \
{\
[[NSUserDefaults standardUserDefaults] setBool:attr forKey:UserDefaultkey(attr)];\
[[NSUserDefaults standardUserDefaults] synchronize];\
}

#define UserDefault_AttrIntegerImpl(attr,attrType) \
+ (attrType)attr \
{ \
return [[NSUserDefaults standardUserDefaults] integerForKey:UserDefaultkey(attr)]; \
}\
+ (void)set##attr:(attrType)attr \
{\
[[NSUserDefaults standardUserDefaults] setInteger:attr forKey:UserDefaultkey(attr)];\
[[NSUserDefaults standardUserDefaults] synchronize];\
}

#define HeaderColor UIColorFromRGB(0x272727)
#define ButtonColor UIColorFromRGB(0x0080FF)

#define BaseUrl @"http://120.25.82.122:8000"
#define Register4AdminUrl [NSString stringWithFormat:@"%@/api/session/register4admin", BaseUrl]
#define Register4InviteUrl [NSString stringWithFormat:@"%@/api/session/register4invitecode", BaseUrl]
#define LoginUrl [NSString stringWithFormat:@"%@/api/session/login", BaseUrl]
#define ForgotPasswordUrl [NSString stringWithFormat:@"%@/api/session/forgotpassword", BaseUrl]
#define ModPasswordUrl [NSString stringWithFormat:@"%@/api/profile/modpassword", BaseUrl]
#define ModMobileUrl [NSString stringWithFormat:@"%@/api/profile/modmobile", BaseUrl]
#define InfomationUrl [NSString stringWithFormat:@"%@/api/profile/information", BaseUrl]
#define ModInfomationUrl [NSString stringWithFormat:@"%@/api/profile/modinformation",BaseUrl]
#define VerifycodeUrl [NSString stringWithFormat:@"%@/api/code/verifycode",BaseUrl]
#define InvitecodeUrl [NSString stringWithFormat:@"%@/api/code/invitecode",BaseUrl]//生成邀请码
#define GenInvitecodeUrl [NSString stringWithFormat:@"%@/api/code/inviteurl",BaseUrl]//生成邀请链接
#define ModCompanyUrl [NSString stringWithFormat:@"%@/api/company/modcompany",BaseUrl]

//微信key
#define kWXAppId @"wxc88cd091086c438a"
#define kWXAppSecret @"d4624c36b6795d1d99dcf0547af5443d"

//QQ对应key
#define kQQAppId @"1104981294"
#define kQQAppkey @"uxbaaEdIiiPZGjub"

//易信key
#define kYixinAppkey @"yx35664bdff4db42c2b7be1e29390c1a06"
#define kYixinAppkey @"yx35664bdff4db42c2b7be1e29390c1a06"

//高德key
#define kAMapAppkey @"9f2ae179e79818e2e5c428135edc53f3"

//友盟key
#define kUmengSocialAppKey @"56f67ddce0f55a76730018f5"

#define kSocialTitle @"【XXXX】"
#define kAppIndexHtml @"http://app.ygsoft.com/travel/index.html"


extern NSString * const email;
extern NSString * const tokenId;
extern NSString * const userName;
extern NSString * const sex;
extern NSString * const userId;
extern NSString * const avatar;

extern NSString * const logo;
extern NSString * const companyName;
extern NSString * const introduction;
extern NSString * const contract;
extern NSString * const fax;
extern NSString * const url;
extern NSString * const photos;
extern NSString * const companyImages;
extern NSString * const customerPhones;

extern NSString * const phoneNum;
extern NSString * const address;