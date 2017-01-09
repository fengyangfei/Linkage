//
//  VcodeUtil.h
//  Linkage
//
//  Created by lihaijian on 2017/1/4.
//  Copyright © 2017年 LA. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, SearchEngine) {
    SearchEngineGoogle,
    SearchEngineBaidu,
    SearchEngineBing,
    SearchEngineYahoo
};
@interface VcodeUtil : NSObject
+(NSString *)UUID;
+(NSString *)categoryImageName:(NSString *)category;
+(NSString *)searchImage:(SearchEngine)searchEngine;
+(NSString *)searchName:(SearchEngine)searchEngine;
+(NSString *)searchUrl:(SearchEngine)searchEngine;
@end
