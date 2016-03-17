//
//  MenuItem.h
//  Linkage
//
//  Created by Mac mini on 16/2/29.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MenuItemType) {
    MenuItemTypeNormal,
    MenuItemTypeHeader
};
@interface MenuItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *iconName;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) Class viewControllerClass;
@property (nonatomic, assign) MenuItemType type;

- (instancetype)initWithTitle:(NSString *)title andIconName:(NSString *)iconName andClass:(Class)viewControllerClass;

+(MenuItem *)createItemWithTitle:(NSString *)title andIconName:(NSString *)iconName andClass:(Class)viewControllerClass;
+(NSArray *)menuItemsFromTheme;
@end
AS_RMMapperModel(MenuItem)
