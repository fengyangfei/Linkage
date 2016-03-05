//
//  TRPopManager.h
//  YGTravel
//
//  Created by Mac mini on 16/2/1.
//  Copyright © 2016年 ygsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRFloatingModel.h"
@interface TRPopManager : NSObject

+(TRPopManager *)shareInstance;
-(void)show;
-(void)hide;
-(void)addItemWithTitle:(NSString *)title andIcon:(UIImage *)icon handler:(FloatingButtonHandler)handler;

@end
