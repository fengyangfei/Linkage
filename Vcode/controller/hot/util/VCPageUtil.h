//
//  VCPageUtil.h
//  Linkage
//
//  Created by lihaijian on 2017/1/7.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "ModelUtil.h"

@interface VCPageUtil : ModelUtil
+(void)getModelByUrl:(NSString *)url completion:(void(^)(id<MTLJSONSerializing> model))completion;

@end
