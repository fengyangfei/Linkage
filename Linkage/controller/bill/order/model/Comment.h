//
//  Comment.h
//  Linkage
//
//  Created by lihaijian on 16/7/24.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "MTLManagedObjectAdapter.h"

@interface Comment : MTLModel<MTLJSONSerializing, MTLManagedObjectSerializing>
@property (nonatomic,copy  ) NSString *comment;
@property (nonatomic,copy  ) NSString *commentId;
@property (nonatomic,strong) NSNumber *score;
@end