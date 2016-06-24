//
//  SOImageModel.h
//  Linkage
//
//  Created by lihaijian on 16/3/19.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "MTLManagedObjectAdapter.h"

@interface SOImage : MTLModel<MTLJSONSerializing, MTLManagedObjectSerializing>
@property (nonatomic,strong) UIImage  *image;
@property (nonatomic,strong) NSDate   *createDate;
@property (nonatomic,copy  ) NSString *imageName;
@property (nonatomic,copy  ) NSString *imageUrl;
@end

@interface NSArray(SOImageModel)
-(NSString *)soImageStringValue;
@end