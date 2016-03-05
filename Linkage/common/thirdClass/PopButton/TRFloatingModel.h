//
//  TRFloatingModel.h
//  YGTravel
//
//  Created by Mac mini on 15/12/17.
//  Copyright © 2015年 ygsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^FloatingButtonHandler)(void);
@interface TRFloatingModel : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, copy) FloatingButtonHandler handler;

@end
