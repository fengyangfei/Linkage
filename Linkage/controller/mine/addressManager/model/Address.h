//
//  Address.h
//  Linkage
//
//  Created by Mac mini on 16/3/23.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTLManagedObjectAdapter.h"
#import "ModelOperation.h"
#import "FormDescriptorCell.h"

@interface Address : MTLModel<MTLJSONSerializing,MTLManagedObjectSerializing,ModelHttpParameter,XLFormTitleOptionObject>
@property (nonatomic, copy) NSString *addressId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *userId;
@end
