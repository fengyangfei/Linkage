//
//  ModelBaseViewController.h
//  Linkage
//
//  Created by Mac mini on 16/4/28.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <XLForm/XLForm.h>

@protocol ModelBaseControllerConfigure <NSObject>
@optional
-(Class)modelUtilClass;
-(Class)viewControllerClass;
@end

@interface ModelBaseViewController : XLFormViewController<ModelBaseControllerConfigure>

@end