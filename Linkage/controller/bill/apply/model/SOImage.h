//
//  SOImageModel.h
//  Linkage
//
//  Created by lihaijian on 16/3/19.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface SOImage : MTLModel<MTLJSONSerializing>
@property (nonatomic,strong) UIImage *photo;
@property (nonatomic,strong) NSDate *createDate;
@property (nonatomic,copy) NSString *imageName;
@end

@interface NSArray(SOImageModel)
-(NSString *)soImageStringValue;
@end