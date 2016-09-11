//
//  UITabBar+Badge.h
//  Linkage
//
//  Created by lihaijian on 16/9/11.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UITabBar (Badge)
- (void)showBadgeOnItemIndex:(int)index;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点
@end
