//
//  TRTheme.h
//  YGTravel
//
//  Created by Mac mini on 16/1/26.
//  Copyright © 2016年 ygsoft. All rights reserved.
//
//  主题包(包括文字大小与颜色等)
//

#import <Foundation/Foundation.h>

@interface TRTheme : NSObject

@property (nonatomic, strong) NSNumber *mainCostButtonSize;
@property (nonatomic, strong) UIColor *mainTipViewBackgroudColor;

+ (TRTheme *)populateThemes:(NSDictionary *)themeDic;
@end
