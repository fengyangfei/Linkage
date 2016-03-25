//
//  GlobalVariable.h
//  Linkage
//
//  Created by lihaijian on 16/3/25.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TRFormTextFieldCell.h"

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


extern NSString * const email;
extern NSString * const phoneNumber;
extern NSString * const tokenId;
extern NSString * const userName;
extern NSString * const userId;
extern NSString * const photoId;

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