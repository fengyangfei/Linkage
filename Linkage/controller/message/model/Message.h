//
//  Message.h
//  Linkage
//
//  Created by lihaijian on 16/5/1.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "MTLManagedObjectAdapter.h"
#import "ModelOperation.h"
#import "FormDescriptorCell.h"

@interface Message : MTLModel<MTLJSONSerializing,MTLManagedObjectSerializing,ModelHttpParameter>
@property (nonatomic,copy  ) NSString *messageId;
@property (nonatomic,strong) NSNumber *type;
@property (nonatomic,copy  ) NSString *icon;
@property (nonatomic,copy  ) NSString *title;
@property (nonatomic,copy  ) NSString *introduction;
@property (nonatomic,strong) NSDate   *createTime;
@property (nonatomic,copy  ) NSString *userId;
@end
