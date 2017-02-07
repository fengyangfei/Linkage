//
//  VCPageUtil.m
//  Linkage
//
//  Created by lihaijian on 2017/1/7.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCPageUtil.h"
#import "VCIndex.h"
#import "VCPageModel.h"

@implementation VCPageUtil
+(Class)modelClass{return [VCPage class];}
+(Class)managedObjectClass{ return  [VCPageModel class]; }

+(void)syncToDataBase:(id<MTLJSONSerializing>)model completion:(void(^)())completion
{
    NSError *error;
    VCPage *page = (VCPage *)model;
    if (page.url) {
        VCPageModel *existModel = [VCPageModel MR_findFirstByAttribute:@"url" withValue:page.url inContext:[NSManagedObjectContext MR_defaultContext]];
        if (existModel) {
            return;
        }
        VCPageModel *addModel = [MTLManagedObjectAdapter managedObjectFromModel:page insertingIntoContext:[NSManagedObjectContext MR_defaultContext] error:&error];
        if (addModel && !error) {
            if (completion) {
                completion();
            }
        }else{
            NSLog(@"同步到数据库失败 - %@",error);
        }
    }
}

+(void)getModelByUrl:(NSString *)url completion:(void(^)(id<MTLJSONSerializing> model))completion
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", @"url", url];
    [self queryModelFromDataBase:predicate completion:completion];
}

+(void)queryModelFromDataBase:(NSPredicate *)predicate completion:(void(^)(id<MTLJSONSerializing> model))completion
{
    VCPageModel *manageObj = [VCPageModel MR_findFirstWithPredicate:predicate inContext:[NSManagedObjectContext MR_defaultContext]];
    id<MTLJSONSerializing> result = [self modelFromManagedObject:manageObj];
    completion(result);
}

//数据库查询
+(void)queryModelsFromDataBase:(void(^)(NSArray *models))completion
{
    NSArray *managerObjects = [VCPageModel MR_findAllSortedBy:@"sortNumber" ascending:YES inContext:[NSManagedObjectContext MR_defaultContext]];
    NSMutableArray *mutableArray = [[NSMutableArray alloc]initWithCapacity:managerObjects.count];
    for (NSManagedObject *manageObj in managerObjects) {
        id<MTLJSONSerializing> model = [self modelFromManagedObject:manageObj];
        [mutableArray addObject:model];
    }
    if (completion) {
        completion([mutableArray copy]);
    }
}

+(void)deleteFromDataBase:(id<MTLJSONSerializing>)model completion:(void(^)())completion
{
    VCPage *page = (VCPage *)model;
    if (page.url) {
        VCPageModel *existModel = [VCPageModel MR_findFirstByAttribute:@"url" withValue:page.url inContext:[NSManagedObjectContext MR_defaultContext]];
        if (existModel) {
            [existModel MR_deleteEntityInContext:[NSManagedObjectContext MR_defaultContext]];
        }
        if (completion) {
            completion();
        }
    }
}

+ (void)truncateAll
{
    @try {
        [VCPageModel MR_truncateAllInContext:[NSManagedObjectContext MR_defaultContext]];
    }
    @catch (NSException *exception) {
        NSLog(@"error - %@", exception.reason);
    }
}

+(NSArray *)initializtionPages
{
    return [self initializtionPages2];
}

+(NSArray *)initializtionPages2
{
    VCPage *p1 = [[VCPage alloc]init];
    p1.name = @"新华网";
    p1.url = @"http://www.xinhuanet.com";
    p1.sortNumber = @(0);
    
    VCPage *p2 = [[VCPage alloc]init];
    p2.name = @"CNN";
    p2.url = @"http://edition.cnn.com";
    p2.sortNumber = @(1);
    
    VCPage *p3 = [[VCPage alloc]init];
    p3.name = @"学术Google";
    p3.url = @"http://scholar.google.com.cn";
    p3.sortNumber = @(2);
    
    VCPage *p4 = [[VCPage alloc]init];
    p4.name = @"微信";
    p4.url = @"http://weixin.qq.com";
    p4.sortNumber = @(3);
    
    VCPage *p5 = [[VCPage alloc]init];
    p5.name = @"IPv6.Facebook";
    p5.url = @"http://www.facebook.com";
    p5.sortNumber = @(4);
    
    VCPage *p6 = [[VCPage alloc]init];
    p6.name = @"IPv6.Youtube";
    p6.url = @"http://www.youtube.com";
    p6.sortNumber = @(5);
    
    VCPage *p7 = [[VCPage alloc]init];
    p7.name = @"维基百科";
    p7.url = @"http://www.wikipedia.org";
    p7.sortNumber = @(6);
    
    VCPage *p8 = [[VCPage alloc]init];
    p8.name = @"IPv6.Twitter";
    p8.url = @"http://www.twitter.com";
    p8.sortNumber = @(7);
    
    VCPage *p9 = [[VCPage alloc]init];
    p9.name = @"IPv6.淘宝";
    p9.url = @"http://ipv6.taobao.com";
    p9.sortNumber = @(8);
    
    VCPage *p10 = [[VCPage alloc]init];
    p10.name = @"IPv6.福建沙县政府";
    p10.url = @"http://ipv6.fjsx.gov.cn";
    p10.sortNumber = @(9);
    
    VCPage *p11 = [[VCPage alloc]init];
    p11.name = @"IPv6.中国电信";
    p11.url = @"http://www.chinatelecom.com.cn";
    p11.sortNumber = @(10);
    
    VCPage *p12 = [[VCPage alloc]init];
    p12.name = @"IPv6.CNNIC";
    p12.url = @"http://cnnic.cn";
    p12.sortNumber = @(11);
    
    VCPage *p13 = [[VCPage alloc]init];
    p13.name = @"IPv6.清华大学";
    p13.url = @"http://ipv6.tsinghua.edu.cn";
    p13.sortNumber = @(12);
    
    VCPage *p14 = [[VCPage alloc]init];
    p14.name = @"IPv6.论坛";
    p14.url = @"http://www.ipv6forum.com";
    p14.sortNumber = @(13);
    
    VCPage *p15 = [[VCPage alloc]init];
    p15.name = @"IPv6测试";
    p15.url = @"http://test-ipv6.com";
    p15.sortNumber = @(14);
    
    return @[p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15];
}

+(NSArray *)initializtionPages1
{
    VCPage *p1 = [[VCPage alloc]init];
    p1.name = @"faceBook";
    p1.url = @"http://www.facebook.com";
    p1.sortNumber = @(0);
    
    VCPage *p2 = [[VCPage alloc]init];
    p2.name = @"youtube";
    p2.url = @"http://www.youtube.com";
    p2.sortNumber = @(1);
    
    VCPage *p3 = [[VCPage alloc]init];
    p3.name = @"twitter";
    p3.url = @"http://www.twitter.com";
    p3.sortNumber = @(2);

    VCPage *p4 = [[VCPage alloc]init];
    p4.name = @"cnn";
    p4.url = @"http://www.cnn.com";
    p4.sortNumber = @(3);
    
    VCPage *p5 = [[VCPage alloc]init];
    p5.name = @"yelp";
    p5.url = @"http://www.yelp.com";
    p5.sortNumber = @(4);

    VCPage *p6 = [[VCPage alloc]init];
    p6.name = @"reddit";
    p6.url = @"http://www.reddit.com";
    p6.sortNumber = @(5);
    
    VCPage *p7 = [[VCPage alloc]init];
    p7.name = @"stackoverflow";
    p7.url = @"http://www.stackoverflow.com";
    p7.sortNumber = @(6);

    VCPage *p8 = [[VCPage alloc]init];
    p8.name = @"ebay";
    p8.url = @"http://www.ebay.com";
    p8.sortNumber = @(7);
    
    return @[p1,p2,p3,p4,p5,p6,p7,p8];
    
}
@end
