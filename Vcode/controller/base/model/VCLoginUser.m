//
//  VCLoginUser.m
//  Linkage
//
//  Created by Mac mini on 2017/1/18.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCLoginUser.h"

#define kVCUserDefalutLoginUserKey @"kVCUserDefalutLoginUserKey"
static VCLoginUser *user;
@implementation VCLoginUser
//保存登录用户信息
-(BOOL)save
{
    user = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kVCUserDefalutLoginUserKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    });
    return YES;
}

//获取用户信息
+(VCLoginUser *)loginUserInstance
{
    if (!user) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kVCUserDefalutLoginUserKey];
        if(data){
            user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }
    return user;
}

@end
