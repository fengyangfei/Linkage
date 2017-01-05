//
//  MenuItem.m
//  Linkage
//
//  Created by Mac mini on 16/2/29.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "MenuItem.h"

@implementation MenuItem

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *keys = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    return keys;
}

-(UIImage *)icon
{
    if (!_icon) {
        _icon = [UIImage imageNamed:self.iconName];
    }
    return _icon;
}

-(Class)viewControllerClass
{
    return NSClassFromString(self.className);
}

+(MenuItem *)createItemWithTitle:(NSString *)title
{
    return [[self alloc]initWithTitle:title andIconName:nil andClass:nil];
}

+(MenuItem *)createItemWithTitle:(NSString *)title andIconName:(NSString *)iconName
{
    return [[self alloc]initWithTitle:title andIconName:iconName andClass:nil];
}

+(MenuItem *)createItemWithTitle:(NSString *)title andIconName:(NSString *)iconName andClass:(Class)viewControllerClass
{
    return [[self alloc]initWithTitle:title andIconName:iconName andClass:viewControllerClass];
}

- (instancetype)initWithTitle:(NSString *)title andIconName:(NSString *)iconName andClass:(Class)viewControllerClass
{
    self = [super init];
    if (self) {
        self.title = title;
        if(StringIsNotEmpty(iconName)){
            self.icon = [UIImage imageNamed:iconName];
        }
        self.viewControllerClass = viewControllerClass;
    }
    return self;
}

+(NSArray *)menuItemsFromTheme
{
    NSMutableArray *result = [NSMutableArray array];
    NSString *sourcePath = [[TRThemeManager shareInstance].themeBundle pathForResource:@"MineProperties" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:sourcePath];
    for (NSArray *items in array) {
        NSArray *models = [MTLJSONAdapter modelsOfClass:[MenuItem class] fromJSONArray:items error:NULL];
        [result addObject:models];
    }
    return result;
}

@end
