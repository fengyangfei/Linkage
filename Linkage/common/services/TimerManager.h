//
//  TimerUtil.h
//  Linkage
//
//  Created by Mac mini on 16/3/18.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^TimerBlock)(NSInteger second);
@interface TimerManager : NSObject

@property (nonatomic, copy) TimerBlock block;
+(TimerManager *)shareInstance;
-(void)fire;
-(void)invalidate;
@end
