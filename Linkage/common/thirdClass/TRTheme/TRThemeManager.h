//
//  TRThemeManager.h
//  YGTravel
//
//  Created by Mac mini on 16/1/11.
//  Copyright © 2016年 ygsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImage+TRTheme.h"
#import "TRTheme.h"
#define ThemeImage(imageName) [UIImage tr_imageNamed:imageName]
#define ThemeString(key) \
        NSLocalizedStringFromTableInBundle(key, nil, [TRThemeManager shareInstance].themeBundle, nil)

typedef NS_ENUM(NSUInteger, TRThemeType) {
    TRThemeTypeFactory,//厂商
    TRThemeTypeMerchant,//承运商
    TRThemeTypeStaff,//员工
    TRThemeTypeDriver//司机
};

extern NSString *const kTRThemeChangeNofication;
@interface TRThemeManager : NSObject

@property (nonatomic, assign) TRThemeType themeType;//主题枚举的类型
@property (nonatomic, readonly) NSBundle *themeBundle;//主题对应的bundle
@property (nonatomic, readonly) TRTheme *theme;//主题包(包括文字大小与颜色等)
@property (nonatomic, strong) NSMutableDictionary *viewControllerThemeMapping;//viewController与主题对应关系

//bundle的唯一标识
-(NSString *)bundleIndentifier;
+(TRThemeManager *)shareInstance;

@end
