//
//  VCCategory.h
//  Linkage
//
//  Created by lihaijian on 2017/1/3.
//  Copyright © 2017年 LA. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "MTLManagedObjectAdapter.h"
#import "ModelOperation.h"

@interface VCCategory : MTLModel<MTLJSONSerializing,MTLManagedObjectSerializing>
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *imageName;
@property (nonatomic,strong) NSNumber *sort;
@property (nonatomic) BOOL visible;
@property (nonatomic) BOOL favor;
@end
