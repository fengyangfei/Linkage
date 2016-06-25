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
#define EmailRegex @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
#define CarRegex @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$"
#define UserNameRegex @"^[A-Za-z0-9]{6,20}+$"
#define IdentityCardRegex @"^(\\d{14}|\\d{17})(\\d|[xX])$"

//UI
#define HeaderColor HEXCOLOR(0x10bce6)
#define ButtonColor HEXCOLOR(0x10bce6)
#define TableBackgroundColor [TRThemeManager shareInstance].theme.tableViewBackgroundColor
#define BackgroundColor HEXCOLOR(0xeeefef)
#define TitleFontColor HEXCOLOR(0x676767)
#define ButtonFrameImage [[UIImage imageNamed:@"frame_btn"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 5, 12, 5) resizingMode:UIImageResizingModeStretch]
#define ButtonBgImage [[UIImage imageNamed:@"btn_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(25, 11, 25, 11) resizingMode:UIImageResizingModeStretch]
#define ButtonDisableBgImage [[UIImage imageNamed:@"btn_disable"] resizableImageWithCapInsets:UIEdgeInsetsMake(25, 11, 25, 11) resizingMode:UIImageResizingModeStretch]
#define CodeButtonImage [[UIImage imageNamed:@"get_code_btn"] resizableImageWithCapInsets:UIEdgeInsetsMake(16, 6, 16, 6) resizingMode:UIImageResizingModeStretch]

#define RowTitleColor [row.cellConfig setObject:IndexTitleFontColor forKey:@"textLabel.textColor"];

//首页UI
#define IndexTitleFontColor HEXCOLOR(0x606060)
#define IndexDetailFontColor HEXCOLOR(0xa8a8a8)
#define IndexButtonColor HEXCOLOR(0x2aa1ff)
#define IndexTitleFont [UIFont systemFontOfSize:16]
#define IndexDetailFont [UIFont systemFontOfSize:14]

//订单UI
#define OrderTitleFontColor HEXCOLOR(0x676767)
#define OrderDetailFontColor HEXCOLOR(0xaaaaaa)
#define OrderDetailFont [UIFont systemFontOfSize:12]

#define BaseUrl @"http://120.25.82.122:8000"
//个人
#define Register4AdminUrl [NSString stringWithFormat:@"%@/api/session/register4admin", BaseUrl]//注册
#define Register4InviteUrl [NSString stringWithFormat:@"%@/api/session/register4invitecode", BaseUrl]//注册
#define LoginUrl [NSString stringWithFormat:@"%@/api/session/login", BaseUrl]//登录
#define ForgotPasswordUrl [NSString stringWithFormat:@"%@/api/session/forgotpassword", BaseUrl]//忘记密码
#define ModPasswordUrl [NSString stringWithFormat:@"%@/api/profile/modpassword", BaseUrl]//修改密码
#define ModMobileUrl [NSString stringWithFormat:@"%@/api/profile/modmobile", BaseUrl]
#define ProfileInfomationUrl [NSString stringWithFormat:@"%@/api/profile/information", BaseUrl]//获取个人信息
#define ModInfomationUrl [NSString stringWithFormat:@"%@/api/profile/modinformation",BaseUrl]//修改个人信息
#define VerifycodeUrl [NSString stringWithFormat:@"%@/api/code/verifycode",BaseUrl]//验证码
#define InvitecodeUrl [NSString stringWithFormat:@"%@/api/code/invitecode",BaseUrl]//生成邀请码
#define GenInvitecodeUrl [NSString stringWithFormat:@"%@/api/code/inviteurl",BaseUrl]//生成邀请链接
#define SystemSettingUrl [NSString stringWithFormat:@"%@/api/profile/updatesysset",BaseUrl]//系统设置
#define UserIconUrl [NSString stringWithFormat:@"%@/api/upload/usericon",BaseUrl]//上传个人头像
#define UploadFileUrl [NSString stringWithFormat:@"%@/api/upload/uploadFiles",BaseUrl]//公有上传图片

//企业
#define CompanyInfomationUrl [NSString stringWithFormat:@"%@/api/company/information", BaseUrl]//获取企业信息
#define ModCompanyUrl [NSString stringWithFormat:@"%@/api/company/modcompany",BaseUrl]//修改厂商
#define CompanyLogoUrl [NSString stringWithFormat:@"%@/api/upload/companylogo",BaseUrl]//上传公司头像

//消息
#define MessagesUrl [NSString stringWithFormat:@"%@/api/message/list",BaseUrl]//消息列表
#define MessageDetailUrl [NSString stringWithFormat:@"%@/api/message/detail",BaseUrl]//消息详情

//车辆与司机
#define DriversUrl [NSString stringWithFormat:@"%@/api/transporter/drivers",BaseUrl]//司机查询接口
#define AddDriverUrl [NSString stringWithFormat:@"%@/api/transporter/adddriver",BaseUrl]//添加司机接口
#define DelDriverUrl [NSString stringWithFormat:@"%@/api/transporter/deldriver",BaseUrl]//删除司机接口
#define ModDriverUrl [NSString stringWithFormat:@"%@/api/transporter/moddriver",BaseUrl]//修改司机接口
#define DriverDetailUrl [NSString stringWithFormat:@"%@/api/transporter/driverdetail",BaseUrl]//司机详情接口

//车辆接口
#define CarsUrl [NSString stringWithFormat:@"%@/api/transporter/cars",BaseUrl]//车辆查询接口
#define AddCarUrl [NSString stringWithFormat:@"%@/api/transporter/addcar",BaseUrl]//添加车辆接口
#define DelCarUrl [NSString stringWithFormat:@"%@/api/transporter/delcar",BaseUrl]//删除车辆接口
#define ModCarUrl [NSString stringWithFormat:@"%@/api/transporter/modcar",BaseUrl]//修改车辆接口
#define CarDetailUrl [NSString stringWithFormat:@"%@/api/transporter/cardetail",BaseUrl]//车辆详情查询接口
#define DispatchUrl [NSString stringWithFormat:@"%@/api/transporter/dispatch",BaseUrl]//分配司机接口

//地址
#define AddressUrl [NSString stringWithFormat:@"%@/api/profile/addrlist",BaseUrl]//地址查询接口
#define AddAddressUrl [NSString stringWithFormat:@"%@/api/profile/addaddr",BaseUrl]//添加地址接口
#define DelAddressUrl [NSString stringWithFormat:@"%@/api/transporter/deladdr",BaseUrl]//删除地址接口
#define ModAddressUrl [NSString stringWithFormat:@"%@/api/profile/modAddr",BaseUrl]//修改地址接口

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
#define AcceptOrderUrl [NSString stringWithFormat:@"%@/api/order/accept",BaseUrl]//承运商确认接受订单接口（承运商用）
#define ConfirmOrderUrl [NSString stringWithFormat:@"%@/api/order/confirm",BaseUrl]//承运商确认订单完成接口（承运商用）
#define RejectOrderUrl [NSString stringWithFormat:@"%@/api/order/reject",BaseUrl]//承运商拒绝订单接口
#define Mod4exportUrl [NSString stringWithFormat:@"%@/api/order/mod4export",BaseUrl]//厂商修改出口订单接口
#define Mod4importUrl [NSString stringWithFormat:@"%@/api/order/mod4import",BaseUrl]//厂商修改进口订单接口
#define Mod4selfUrl [NSString stringWithFormat:@"%@/api/order/mod4self",BaseUrl]//厂商修改自备柜订单接口
#define CancelUrl [NSString stringWithFormat:@"%@/api/order/cancel",BaseUrl]//厂商取消订单接口
#define ListByStatusUrl [NSString stringWithFormat:@"%@/api/order/listbystatus",BaseUrl]//订单列表查询接口（厂商，承运商共用）
#define SearchOrderUrl [NSString stringWithFormat:@"%@/api/order/search",BaseUrl]//订单列表查询接口（厂商，承运商共用）
#define Detail4exportUrl [NSString stringWithFormat:@"%@/api/order/detail4export",BaseUrl]//出口订单详情查询接口
#define Detail4importUrl [NSString stringWithFormat:@"%@/api/order/detail4import",BaseUrl]//进口订单详情查询接口
#define Detail4selfUrl [NSString stringWithFormat:@"%@/api/order/detail4self",BaseUrl]//自备柜订单详情查询接口
#define CommentUrl [NSString stringWithFormat:@"%@/api/order/comment",BaseUrl]//订单评价接口
#define SoUrl [NSString stringWithFormat:@"%@/api/upload/so",BaseUrl]//上传公司头像

//微信key
#define kWXAppId @"wxc67be6173b1fdd64"
#define kWXAppSecret @"54c72b1b05e4cf38e27fc20e53d699bd"

//QQ对应key
#define kQQAppId @"1104981294"
#define kQQAppkey @"uxbaaEdIiiPZGjub"

//易信key
#define kYixinAppkey @"yx35664bdff4db42c2b7be1e29390c1a06"

//高德key
#define kAMapAppkey @"9f2ae179e79818e2e5c428135edc53f3"

//友盟key
#define kUmengSocialAppKey @"56f67ddce0f55a76730018f5"

//蒲公英key
#define kPgyerAppKey @"05cba0a3523866bc0d8d3792bbf4cab7"

#define kSocialTitle @"【物流拖车宝】"
#define kAppIndexHtml @"https://www.pgyer.com/linkage"
#define kAppInfomation @"欢迎使用物流拖车宝"


#endif /* LinkConstants_h */
