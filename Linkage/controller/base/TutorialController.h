//
//  TutorialController.h
//  Linkage
//
//  Created by Mac mini on 16/2/25.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "ICETutorialController.h"

#define UserDefault_hasShowIntroduce    @"hasShowIntroduce"
#define kNeedShowIntroduce ![[NSUserDefaults standardUserDefaults] boolForKey:UserDefault_hasShowIntroduce]
@interface TutorialController : ICETutorialController

+(instancetype)shareViewController;
@end
