//
//  GlobalSetting.h
//  Linkage
//
//  Created by Mac mini on 16/3/4.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "TRFormTextFieldCell.h"

#ifndef GlobalSetting_h
#define GlobalSetting_h

#define HeaderColor UIColorFromRGB(0x272727)

#define BaseUrl @"http://120.25.82.122:8000"
#define Register4AdminUrl [NSString stringWithFormat:@"%@/api/session/register4admin", BaseUrl]
#define Register4InviteUrl [NSString stringWithFormat:@"%@/api/session/register4invitecode", BaseUrl]
#define LoginUrl [NSString stringWithFormat:@"%@/api/session/login", BaseUrl]
#define ForgotPasswordUrl [NSString stringWithFormat:@"%@/api/session/forgotpassword", BaseUrl]
#define ModPasswordUrl [NSString stringWithFormat:@"%@/api/profile/modpassword", BaseUrl]
#define ModMobileUrl [NSString stringWithFormat:@"%@/api/profile/modmobile", BaseUrl]
#define InfomationUrl [NSString stringWithFormat:@"%@/api/profile/information", BaseUrl]
#define ModInfomationUrl [NSString stringWithFormat:@"%@/api/profile/modinformation",BaseUrl]
#define InvitecodeUrl [NSString stringWithFormat:@"%@/api/code/invitecode",BaseUrl]//生成邀请码
#define GenInvitecodeUrl [NSString stringWithFormat:@"%@/api/code/inviteurl",BaseUrl]//生成邀请链接
#define ModCompanyUrl [NSString stringWithFormat:@"%@/api/company/modcompany",BaseUrl]

#endif /* GlobalSetting_h */
