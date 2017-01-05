//
//  MenuItem.h
//  Linkage
//
//  Created by Mac mini on 16/2/29.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Mantle/Mantle.h>

typedef NS_ENUM(NSUInteger, MenuItemType) {
    MenuItemTypeNormal,
    MenuItemTypeHeader
};
@interface MenuItem : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, copy) NSString *className;
@property (nonatomic, copy) NSString *selectorName;
@property (nonatomic, strong) Class viewControllerClass;
@property (nonatomic, assign) MenuItemType type;
@property (nonatomic, copy) NSString *entityName;
@property (nonatomic) id value;


- (instancetype)initWithTitle:(NSString *)title andIconName:(NSString *)iconName andClass:(Class)viewControllerClass;
+(MenuItem *)createItemWithTitle:(NSString *)title;
+(MenuItem *)createItemWithTitle:(NSString *)title andIconName:(NSString *)iconName;
+(MenuItem *)createItemWithTitle:(NSString *)title andIconName:(NSString *)iconName andClass:(Class)viewControllerClass;
+(NSArray *)menuItemsFromTheme;
@end
