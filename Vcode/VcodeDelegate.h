//
//  AppDelegate.h
//  Linkage
//
//  Created by lihaijian on 16/2/21.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Message;
static BOOL isProduction = YES;
@interface VcodeDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Message *message;

@end

