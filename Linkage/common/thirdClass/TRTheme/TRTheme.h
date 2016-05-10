//
//  TRTheme.h
//  YGTravel
//
//  Created by Mac mini on 16/1/26.
//  Copyright © 2016年 ygsoft. All rights reserved.
//
//  主题包(包括文字大小与颜色等)
//

#import <Mantle/Mantle.h>

@interface TRTheme : MTLModel<MTLJSONSerializing>
@property (nonatomic, strong) UIColor *headerBackgroundColor;
@property (nonatomic, strong) UIColor *buttonBackgroundColor;
@property (nonatomic, strong) UIColor *tableViewBackgroundColor;
@end