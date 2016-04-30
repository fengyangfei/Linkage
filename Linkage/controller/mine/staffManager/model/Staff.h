//
//  Staff.h
//  Linkage
//
//  Created by lihaijian on 16/4/30.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "MTLManagedObjectAdapter.h"
#import "ModelOperation.h"
#import "FormDescriptorCell.h"

@interface Staff : MTLModel<MTLJSONSerializing,MTLManagedObjectSerializing,ModelHttpParameter,XLFormTitleOptionObject>
@property (nonatomic,copy) NSString *staffId;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *realname;
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *staffIcon;
@property (nonatomic,copy) NSString *userId;
@end
