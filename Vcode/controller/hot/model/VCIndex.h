//
//  VCIndex.h
//  Linkage
//
//  Created by Mac mini on 2017/1/4.
//  Copyright © 2017年 LA. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface VCIndex : MTLModel<MTLJSONSerializing>
@property (nonatomic, strong) NSArray *ads;//
@property (nonatomic, strong) NSArray *pages;//任务
@end

@interface VCAd : MTLModel<MTLJSONSerializing>
@property (nonatomic, copy) NSString *gid;
@property (nonatomic, copy) NSString *thumb;
@property (nonatomic, strong) NSNumber *sort;
@end

@interface VCPage : MTLModel<MTLJSONSerializing>
@property (nonatomic, copy) NSString *gid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) NSNumber *sortNumber;
@end
