//
//  ModelBaseViewController.h
//  Linkage
//
//  Created by Mac mini on 16/4/28.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <XLForm/XLForm.h>
typedef NS_ENUM(NSUInteger, ControllerType) {
    ControllerTypeQuery,
    ControllerTypeManager
};
@protocol ModelBaseControllerConfigure <NSObject>
@optional
-(Class)modelUtilClass;
-(Class)viewControllerClass;
-(void)didSelectModel:(XLFormRowDescriptor *)chosenRow;
@end

@interface ModelBaseViewController : XLFormViewController<ModelBaseControllerConfigure, XLFormRowDescriptorViewController>

- (instancetype)initWithControllerType:(ControllerType)controllerType;
- (void)initializeForm:(NSArray *)models;
- (void)setupData;
@end