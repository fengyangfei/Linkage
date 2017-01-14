//
//  VCThemeManager.h
//  Linkage
//
//  Created by Mac mini on 2017/1/14.
//  Copyright © 2017年 LA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImage+TRTheme.h"
#define VCThemeImage(imageName) [UIImage tr_imageNamed:imageName]
#define VCThemeString(key) \
NSLocalizedStringFromTableInBundle(key, nil, [VCThemeManager shareInstance].themeBundle, nil)

typedef NS_ENUM(NSUInteger, VCThemeType) {
    VCThemeTypeCN,//中文
    VCThemeTypeEN//英文
};

extern NSString *const kVCThemeChangeNofication;
@interface VCThemeManager : NSObject

@property (nonatomic, assign) VCThemeType themeType;//主题枚举的类型
@property (nonatomic, readonly) NSBundle *themeBundle;//主题对应的bundle
@property (nonatomic, strong) NSMutableDictionary *viewControllerThemeMapping;//viewController与主题对应关系

//bundle的唯一标识
-(NSString *)bundleIndentifier;
+(VCThemeManager *)shareInstance;
@end
