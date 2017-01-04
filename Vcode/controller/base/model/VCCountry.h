//
//  VCCountry.h
//  Linkage
//
//  Created by Mac mini on 2017/1/4.
//  Copyright © 2017年 LA. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface VCCountry : MTLModel<MTLJSONSerializing>
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *code;
@end
