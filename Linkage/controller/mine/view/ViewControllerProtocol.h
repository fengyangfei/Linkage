//
//  ViewControllerProtocol.h
//  Linkage
//
//  Created by Mac mini on 16/9/7.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, ControllerType) {
    ControllerTypeNone,//...
    ControllerTypeQuery,//查看类型
    ControllerTypeManager//编辑类型
};

@protocol ViewControllerProtocol <NSObject>

@property (nonatomic) ControllerType controllerType;

@end
