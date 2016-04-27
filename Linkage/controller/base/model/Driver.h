//
//  Driver.h
//  Linkage
//
//  Created by Mac mini on 16/4/27.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "MTLManagedObjectAdapter.h"
#import "ModelOperation.h"

@interface Driver : MTLModel<MTLJSONSerializing,MTLManagedObjectSerializing,ModelHttpParameter>
@property (nonatomic,copy) NSString *driverId;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *gender;
@property (nonatomic,copy) NSString *license;//牌号
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *userId;
@end
