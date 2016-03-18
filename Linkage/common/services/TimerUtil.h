//
//  TimerUtil.h
//  Linkage
//
//  Created by Mac mini on 16/3/18.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^TimerBlock)(NSInteger second);
@interface TimerUtil : NSObject

@property (nonatomic, copy) TimerBlock block;
+(TimerUtil *)shareInstance;
-(void)fire;
-(void)invalidate;
@end
