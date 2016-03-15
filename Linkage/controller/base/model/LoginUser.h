//
//  LoginUser.h
//  Linkage
//
//  Created by lihaijian on 16/3/12.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Foundation/Foundation.h>
#define LoginUser_Attr(attr,attrType) \
+ (attrType)attr; \
+ (void)set##attr:(attrType)attr;

@interface LoginUser : NSObject<NSCoding,RMMapping>
@property (nonatomic,copy) NSString *email;
@property (nonatomic,copy) NSString *phoneNumber;
@property (nonatomic,copy) NSString *tokenId;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *photoId;
@property (nonatomic) UIImage  *avatarImage;

-(BOOL)save;
+(LoginUser *)shareInstance;
+(BOOL)clearUserInfo;
@end

@interface LoginUser (Extensions)
LoginUser_Attr(currentLocation, NSString *)//用户所在地
@end

AS_RMMapperModel(LoginUser)

@interface Company : NSObject
@property (nonatomic,copy) NSString *companyName;
@property (nonatomic,copy) NSString *companyNumber;
@property (nonatomic,copy) NSString *photoId;
@end
