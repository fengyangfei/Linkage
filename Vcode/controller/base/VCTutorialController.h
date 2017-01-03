//
//  VCTutorialController.h
//  Linkage
//
//  Created by Mac mini on 2017/1/3.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "ICETutorialController.h"

#define UserDefault_hasShowIntroduce    @"hasShowIntroduce"
#define kNeedShowIntroduce ![[NSUserDefaults standardUserDefaults] boolForKey:UserDefault_hasShowIntroduce]
@interface VCTutorialController : ICETutorialController
+(instancetype)shareViewController;
@end
