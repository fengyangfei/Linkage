//
//  LinkConstants.h
//  Linkage
//
//  Created by lihaijian on 16/4/20.
//  Copyright © 2016年 LA. All rights reserved.
//

#ifndef LinkConstants_h
#define LinkConstants_h

#define PhoneNumRegex @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$"
#define HeaderColor UIColorFromRGB(0x0099FF)
#define ButtonColor UIColorFromRGB(0x0080FF)
#define TableBackgroundColor UIColorFromRGB(0x0080FF)

//用户注册
#define BaseUrl @"http://120.25.82.122:8000"
#define Register4AdminUrl [NSString stringWithFormat:@"%@/api/session/register4admin", BaseUrl]//注册
#define Register4InviteUrl [NSString stringWithFormat:@"%@/api/session/register4invitecode", BaseUrl]//注册
#define LoginUrl [NSString stringWithFormat:@"%@/api/session/login", BaseUrl]//登录
#define ForgotPasswordUrl [NSString stringWithFormat:@"%@/api/session/forgotpassword", BaseUrl]//忘记密码
#define ModPasswordUrl [NSString stringWithFormat:@"%@/api/profile/modpassword", BaseUrl]//修改密码
#define ModMobileUrl [NSString stringWithFormat:@"%@/api/profile/modmobile", BaseUrl]
#define InfomationUrl [NSString stringWithFormat:@"%@/api/profile/information", BaseUrl]
#define ModInfomationUrl [NSString stringWithFormat:@"%@/api/profile/modinformation",BaseUrl]//修改信息
#define VerifycodeUrl [NSString stringWithFormat:@"%@/api/code/verifycode",BaseUrl]//验证码
#define InvitecodeUrl [NSString stringWithFormat:@"%@/api/code/invitecode",BaseUrl]//生成邀请码
#define GenInvitecodeUrl [NSString stringWithFormat:@"%@/api/code/inviteurl",BaseUrl]//生成邀请链接
#define ModCompanyUrl [NSString stringWithFormat:@"%@/api/company/modcompany",BaseUrl]//修改厂商

//车辆与司机
#define DriversUrl [NSString stringWithFormat:@"%@/api/transporter/drivers",BaseUrl]//司机查询接口
#define AddDriverUrl [NSString stringWithFormat:@"%@/api/transporter/adddriver",BaseUrl]//添加司机接口
#define DelDriverUrl [NSString stringWithFormat:@"%@/api/transporter/deldriver",BaseUrl]//删除司机接口
#define DriverDetailUrl [NSString stringWithFormat:@"%@/api/transporter/driverdetail",BaseUrl]//司机详情接口
#define CarsUrl [NSString stringWithFormat:@"%@/api/transporter/cars",BaseUrl]//车辆查询接口
#define AddCarUrl [NSString stringWithFormat:@"%@/api/transporter/addcar",BaseUrl]//添加车辆接口
#define DelCarUrl [NSString stringWithFormat:@"%@/api/transporter/delcar",BaseUrl]//删除车辆接口
#define CarDetailUrl [NSString stringWithFormat:@"%@/api/transporter/cardetail",BaseUrl]//车辆详情查询接口
#define DispatchUrl [NSString stringWithFormat:@"%@/api/transporter/dispatch",BaseUrl]//分配司机接口

//地址
#define AddressUrl [NSString stringWithFormat:@"%@/api/profile/addrlist",BaseUrl]//地址查询接口
#define AddAddressUrl [NSString stringWithFormat:@"%@/api/profile/addaddr",BaseUrl]//添加地址接口
#define DelAddressUrl [NSString stringWithFormat:@"%@/api/transporter/deladdr",BaseUrl]//删除地址接口

//员工
#define StaffsUrl [NSString stringWithFormat:@"%@/api/user/staff",BaseUrl]//员工查询接口
#define AddStaffUrl [NSString stringWithFormat:@"%@/api/profile/addaddr",BaseUrl]//添加员工接口
#define DelStaffUrl [NSString stringWithFormat:@"%@/api/user/delstaff",BaseUrl]//删除员工接口

//收藏
#define FavoritesUrl [NSString stringWithFormat:@"%@/api/profile/favlist",BaseUrl]//收藏查询接口
#define AddFavoriteUrl [NSString stringWithFormat:@"%@/api/profile/addfavorite",BaseUrl]//添加收藏接口
#define DelFavoriteUrl [NSString stringWithFormat:@"%@/api/profile/delfavorite",BaseUrl]//删除收藏接口

//订单
#define Place4exportUrl [NSString stringWithFormat:@"%@/api/order/place4export",BaseUrl]//厂商出口订单下单接口
#define Place4importUrl [NSString stringWithFormat:@"%@/api/order/place4import",BaseUrl]//厂商进口订单下单接口
#define Place4selfUrl [NSString stringWithFormat:@"%@/api/order/place4self",BaseUrl]//厂商自备柜订单下单接口
#define ConfirmUrl [NSString stringWithFormat:@"%@/api/order/confirm",BaseUrl]//承运商确认订单接口（承运商用）
#define RejectUrl [NSString stringWithFormat:@"%@/api/order/reject",BaseUrl]//承运商拒绝订单接口
#define Mod4exportUrl [NSString stringWithFormat:@"%@/api/order/mod4export",BaseUrl]//厂商修改出口订单接口
#define Mod4importUrl [NSString stringWithFormat:@"%@/api/order/mod4import",BaseUrl]//厂商修改进口订单接口
#define Mod4selfUrl [NSString stringWithFormat:@"%@/api/order/mod4self",BaseUrl]//厂商修改自备柜订单接口
#define CancelUrl [NSString stringWithFormat:@"%@/api/order/cancel",BaseUrl]//厂商取消订单接口
#define ListByStatusUrl [NSString stringWithFormat:@"%@/api/order/listbystatus",BaseUrl]//订单列表查询接口（厂商，承运商共用）
#define SearchUrl [NSString stringWithFormat:@"%@/api/order/search",BaseUrl]//订单列表查询接口（厂商，承运商共用）
#define Detail4exportUrl [NSString stringWithFormat:@"%@/api/order/detail4export",BaseUrl]//出口订单详情查询接口
#define Detail4importUrl [NSString stringWithFormat:@"%@/api/order/detail4import",BaseUrl]//进口订单详情查询接口
#define Detail4selfUrl [NSString stringWithFormat:@"%@/api/order/detail4self",BaseUrl]//自备柜订单详情查询接口
#define CommentUrl [NSString stringWithFormat:@"%@/api/order/comment",BaseUrl]//订单评价接口
#define SoUrl [NSString stringWithFormat:@"%@/api/upload/so",BaseUrl]//上传公司头像

//微信key
#define kWXAppId @"wxc88cd091086c438a"
#define kWXAppSecret @"d4624c36b6795d1d99dcf0547af5443d"

//QQ对应key
#define kQQAppId @"1104981294"
#define kQQAppkey @"uxbaaEdIiiPZGjub"

//易信key
#define kYixinAppkey @"yx35664bdff4db42c2b7be1e29390c1a06"

//高德key
#define kAMapAppkey @"9f2ae179e79818e2e5c428135edc53f3"

//友盟key
#define kUmengSocialAppKey @"56f67ddce0f55a76730018f5"

#define kSocialTitle @"【XXXX】"
#define kAppIndexHtml @"https://www.pgyer.com/linkage"

#endif /* LinkConstants_h */
