//
//  TRLoginUser.h
//  YGTravel
//
//  Created by Mac mini on 15/9/18.
//  Copyright (c) 2015年 ygsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#define TRLoginUser_Attr(attr,attrType) \
+ (attrType)attr; \
+ (void)set##attr:(attrType)attr;

@interface TRLoginUser : NSObject<NSCoding,RMMapping>

@property (nonatomic,copy) NSString *email;
@property (nonatomic,copy) NSString *phoneNumber;
@property (nonatomic,copy) NSString *tokenId;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *photoId;
@property (nonatomic) UIImage  *avatarImage;

-(BOOL)save;
+(TRLoginUser *)shareInstance;
+(BOOL)clearUserInfo;
@end

@interface TRLoginUser (Extensions)
TRLoginUser_Attr(authenticated, BOOL)
TRLoginUser_Attr(isTravelMode, BOOL)//是否差旅模式
TRLoginUser_Attr(currentLocation, NSString *)//用户所在地
TRLoginUser_Attr(currentCity, NSString *)//用户所在城市
TRLoginUser_Attr(latitude, NSNumber *)//经纬度
TRLoginUser_Attr(longitude, NSNumber *)//经纬度
TRLoginUser_Attr(type, NSString *)//天气属性
TRLoginUser_Attr(fengli, NSString *)//天气属性
TRLoginUser_Attr(wendu, NSString *)//天气属性
TRLoginUser_Attr(high, NSString *)//天气属性
TRLoginUser_Attr(low, NSString *)//天气属性
TRLoginUser_Attr(updateTime, NSNumber *)//天气最后一次更新的时间
TRLoginUser_Attr(centerId, NSString *)//默认的成本中心ID
TRLoginUser_Attr(centerName, NSString *)//成本中心名称
TRLoginUser_Attr(costItemId, NSString *)
TRLoginUser_Attr(costItemName, NSString *)
TRLoginUser_Attr(hotelLevel, NSString *)//用户住宿标准
TRLoginUser_Attr(hotelLevelName, NSString *)//用户住宿标准
TRLoginUser_Attr(todoCount, NSInteger)//待办条数
TRLoginUser_Attr(doneCount, NSInteger)//已办条数
TRLoginUser_Attr(accountRecentCostTypeId, NSNumber *)//记一笔存放最近一次交通类型和不同交通类型数据
TRLoginUser_Attr(accountTransportationDic, NSDictionary *)//不同交通类型的数据(costTypeId-AccontModel)
TRLoginUser_Attr(lastCheckUpdateTime, NSDate *)//最后一次检查版本更新的日期
@end

AS_RMMapperModel(TRLoginUser)
