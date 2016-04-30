//
//  Favorite.h
//  Linkage
//
//  Created by lihaijian on 16/4/30.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "MTLManagedObjectAdapter.h"
#import "ModelOperation.h"
#import "FormDescriptorCell.h"

@interface Favorite : MTLModel<MTLJSONSerializing,MTLManagedObjectSerializing,ModelHttpParameter,XLFormTitleOptionObject>
@property (nonatomic,copy  ) NSString *companyId;
@property (nonatomic,copy  ) NSString *companyName;
@property (nonatomic,copy  ) NSString *contactName;
@property (nonatomic,copy  ) NSString *servicePhone;
@property (nonatomic,strong) NSNumber *score;
@property (nonatomic,strong) NSNumber *orderNum;
@property (nonatomic,copy  ) NSString *logo;
@property (nonatomic,copy  ) NSString *userId;
@end
