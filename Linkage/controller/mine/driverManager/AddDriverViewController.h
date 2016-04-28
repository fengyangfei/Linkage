//
//  AddDriverViewController.h
//  Linkage
//
//  Created by Mac mini on 16/4/27.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <XLForm/XLForm.h>
@class Driver;
@interface AddDriverViewController : XLFormViewController<XLFormRowDescriptorViewController>

- (instancetype)initWithDriver:(Driver *)driver;
@end
