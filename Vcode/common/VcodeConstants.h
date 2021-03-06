//
//  LinkConstants.h
//  Linkage
//
//  Created by lihaijian on 16/4/20.
//  Copyright © 2016年 LA. All rights reserved.
//

#ifndef VcodeConstants_h
#define VcodeConstants_h

//通知
#define VGMViewEditNotificationKey @"kGMViewEditNotificationKey"
#define kSearchEngineUserDefaultKey @"kSearchEngineUserDefaultKey"

//UI
#define VHeaderColor HEXCOLOR(0x1aad19)

//#define VBaseUrl @"http://120.24.49.7:8007"
#define VBaseUrl @"http://120.24.49.7:8006"
//点赞
#define AddLikeUrl [NSString stringWithFormat:@"%@/index.php?mod=site&name=api&do=like&op=addLike",VBaseUrl]
//取消点赞
#define DeleteLikeUrl [NSString stringWithFormat:@"%@/index.php?mod=site&name=api&do=like&op=deleteLike",VBaseUrl]
//首页接口
#define HomePageUrl [NSString stringWithFormat:@"%@/index.php?mod=site&name=api&do=users&op=getHomePage",VBaseUrl]
//获取用户定制链接列表
#define UserPageUrl [NSString stringWithFormat:@"%@/index.php?mod=site&name=api&do=users&op=getUserPage",VBaseUrl]
//删除定制链接
#define DeleteUserPageUrl [NSString stringWithFormat:@"%@/index.php?mod=site&name=api&do=users&op=deleteUserPage",VBaseUrl]
//定制链接排序
#define SortUserPageUrl [NSString stringWithFormat:@"%@/index.php?mod=site&name=api&do=users&op=sortUserPage",VBaseUrl]
//添加访问记录
#define AddVisitRecordUrl [NSString stringWithFormat:@"%@/index.php?mod=site&name=api&do=users&op=addVisitRecord",VBaseUrl]

//收藏列表
#define FavorListUrl [NSString stringWithFormat:@"%@/index.php?mod=site&name=api&do=favor&op=favorList",VBaseUrl]
//收藏
#define AddFavorUrl [NSString stringWithFormat:@"%@/index.php?mod=site&name=api&do=favor&op=addFavor",VBaseUrl]
//取消收藏
#define DeleteFavorUrl [NSString stringWithFormat:@"%@/index.php?mod=site&name=api&do=favor&op=deleteFavor",VBaseUrl]
//收藏排序
#define SortFavorUrl [NSString stringWithFormat:@"%@/index.php?mod=site&name=api&do=favor&op=sortFavor",VBaseUrl]

//设置用户标签
#define SetUserLabelUrl [NSString stringWithFormat:@"%@/index.php?mod=site&name=api&do=users&op=setUserLabel",VBaseUrl]
//获取用户标签
#define GetUserLabelUrl [NSString stringWithFormat:@"%@/index.php?mod=site&name=api&do=users&op=getUserLabel",VBaseUrl]
//更新用户头像
#define UpdateUserPicUrl [NSString stringWithFormat:@"%@/index.php?mod=site&name=api&do=users&op=updateUserPic",VBaseUrl]
//更新用户信息
#define UpdateUserInfoUrl [NSString stringWithFormat:@"%@/index.php?mod=site&name=api&do=users&op=updateUserInfo",VBaseUrl]
//获取用户信息
#define GetUserInfoUrl [NSString stringWithFormat:@"%@/index.php?mod=site&name=api&do=users&op=getUserInfo",VBaseUrl]
//反馈
#define FeedbackUrl [NSString stringWithFormat:@"%@/index.php?mod=site&name=api&do=users&op=addFeedback",VBaseUrl]

//热门推荐
#define HotUrl [NSString stringWithFormat:@"%@/index.php?mod=site&name=api&do=recommend&op=hot",VBaseUrl]
//智能推荐
#define RecommendUrl [NSString stringWithFormat:@"%@/index.php?mod=site&name=api&do=recommend&op=recommend",VBaseUrl]
//本地推荐
#define LocalUrl [NSString stringWithFormat:@"%@/index.php?mod=site&name=api&do=recommend&op=local",VBaseUrl]

//全球排行
#define GlobalRankUrl [NSString stringWithFormat:@"%@/index.php?mod=site&name=api&do=rank&op=globalRank",VBaseUrl]
//地区排行
#define CountryRankUrl [NSString stringWithFormat:@"%@/index.php?mod=site&name=api&do=rank&op=countryRank",VBaseUrl]
//类型排行
#define CategoryRankUrl [NSString stringWithFormat:@"%@/index.php?mod=site&name=api&do=rank&op=categoryRank",VBaseUrl]
//获取所有分类接口(已废除)
#define GetCategoryUrl [NSString stringWithFormat:@"%@/index.php?mod=site&name=api&do=sys&op=getCategory",VBaseUrl]
//获取所有国家的接口(已废除)
#define DeleteShopcartUrl [NSString stringWithFormat:@"%@/index.php?mod=site&name=api&do=shopcart&op=deleteShopcart",VBaseUrl]

//生成邀请码
#define VInviteUrl [NSString stringWithFormat:@"%@/index.php?mod=site&name=api&do=invite&op=invite",VBaseUrl]
//完成分享(分享成功的callback 里面调用)
#define VFinishInviteUrl [NSString stringWithFormat:@"%@/index.php?mod=site&name=api&do=invite&op=finishInvite",VBaseUrl]
//短信分享
#define VMultiInviteUrl [NSString stringWithFormat:@"%@/index.php?mod=site&name=api&do=invite&op=multiInvite",VBaseUrl]
//获取已注册账户
#define VRegisterAccountUrl [NSString stringWithFormat:@"%@/index.php?mod=site&name=api&do=invite&op=getRegisterAccount",VBaseUrl]
//举报
#define VReportUrl [NSString stringWithFormat:@"%@/index.php?mod=site&name=api&do=sys&op=reportUrl",VBaseUrl]
//同步
#define VSyncDataUrl [NSString stringWithFormat:@"%@/index.php?mod=site&name=api&do=users&op=syncData",VBaseUrl]
//预支付信息接口
#define VSubmitOrderUrl [NSString stringWithFormat:@"%@/index.php?mod=site&name=api&do=charge&op=submitOrder",VBaseUrl]
//获取充值面额接口
#define VChargeUrl [NSString stringWithFormat:@"%@/index.php?mod=site&name=api&do=sys&op=getCharge",VBaseUrl]
//注册
#define VRegisterUrl [NSString stringWithFormat:@"%@/index.php?mod=site&name=api&do=users&op=register",VBaseUrl]
//登录
#define VLoginUrl [NSString stringWithFormat:@"%@/index.php?mod=site&name=api&do=users&op=login",VBaseUrl]
//修改密码
#define VModifyPasswordUrl [NSString stringWithFormat:@"%@/index.php?mod=site&name=api&do=users&op=modifyPassword",VBaseUrl]
//忘记密码
#define VForgotPwdUrl [NSString stringWithFormat:@"%@/index.php?mod=site&name=api&do=sys&op=forgotPwd",VBaseUrl]
//获取注册验证码
#define VRegisterSMSVerifyCodeUrl [NSString stringWithFormat:@"%@/index.php?mod=site&name=api&do=users&op=getRegisterSMSVerifyCode",VBaseUrl]
//获取忘记密码的验证码
#define VSMSVerifyCodeUrl [NSString stringWithFormat:@"%@/index.php?mod=site&name=api&do=users&op=getSMSVerifyCode",VBaseUrl]

/***********************URL的页面*********************************/
//法律申明(中文)
#define VLegalNoticesCNUrl [NSString stringWithFormat:@"%@/index.php?mod=mobile&name=shopwap&do=custom_page&op=legal_notices",VBaseUrl]
//法律申明(英文)
#define VLegalNoticesENUrl [NSString stringWithFormat:@"%@/index.php?mod=mobile&name=shopwap&do=custom_page&op=legal_notices_en",VBaseUrl]
//关于我们(英文)
#define VAboutusENUrl [NSString stringWithFormat:@"%@/index.php?mod=mobile&name=shopwap&do=custom_page&op=aboutus_en",VBaseUrl]
//关于我们(中文)
#define VAboutusCNUrl [NSString stringWithFormat:@"%@/index.php?mod=mobile&name=shopwap&do=custom_page&op=aboutus",VBaseUrl]
//帮助文档(英文)
#define VHelpENUrl [NSString stringWithFormat:@"%@/index.php?mod=mobile&name=shopwap&do=custom_page&op=help_en",VBaseUrl]
//帮助文档(中文)
#define VHelpCNUrl [NSString stringWithFormat:@"%@/index.php?mod=mobile&name=shopwap&do=custom_page&op=help",VBaseUrl]

//微信key
#define kVCodeWXAppId @"wxc67be6173b1fdd64"
#define kVCodeWXAppSecret @"54c72b1b05e4cf38e27fc20e53d699bd"

//QQ对应key
#define kVCodeQQAppId @"1105861191"
#define kVCodeQQAppkey @"8c2Ua362TLmtZtvi"

//蒲公英key
#define kVCodePgyerAppKey @"6907fc28e91533ee527c6d7594466ea4"

#endif
