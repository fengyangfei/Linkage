//
//  VCCategoryUtil.h
//  Linkage
//
//  Created by lihaijian on 2017/1/3.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "ModelUtil.h"

@interface VCCategoryUtil : ModelUtil

+(void)syncCategory:(void(^)(NSArray *models))completion;
+(NSArray *)queryAllCategoryTitles;
+(NSArray *)queryAllCategories;
+(id)getModelByIndex:(NSInteger)index;
@end
