//
//  LoginUser.h
//  Linkage
//
//  Created by lihaijian on 16/3/12.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginUser : NSObject<NSCoding,RMMapping>
@property (nonatomic,copy) NSString *email;
@property (nonatomic,copy) NSString *phoneNum;
@property (nonatomic,copy) NSString *tokenId;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,strong) NSNumber *sex;

-(BOOL)save;
+(LoginUser *)shareInstance;
+(BOOL)clearUserInfo;
@end

@interface LoginUser (Extensions)
UserDefault_Attr(currentLocation, NSString *)//用户所在地
@end
AS_RMMapperModel(LoginUser)