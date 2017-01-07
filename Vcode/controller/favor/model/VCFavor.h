//
//  VCFavor.h
//  Linkage
//
//  Created by lihaijian on 2017/1/7.
//  Copyright © 2017年 LA. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "MTLManagedObjectAdapter.h"
#import "ModelOperation.h"

@interface VCFavor : MTLModel<MTLJSONSerializing,MTLManagedObjectSerializing>
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,strong) NSDate *createdDate;
@end
