//
//  Company.h
//  Linkage
//
//  Created by lihaijian on 16/3/25.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "MTLManagedObjectAdapter.h"

@interface Company : MTLModel<MTLJSONSerializing>
@property (nonatomic,copy) NSString *logo;
@property (nonatomic,copy) NSString *companyName;
@property (nonatomic,copy) NSString *introduction;
@property (nonatomic,copy) NSString *contract;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *email;
@property (nonatomic,copy) NSString *fax;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,strong) NSArray *companyImages;
@property (nonatomic,strong) NSArray *customerPhones;

-(BOOL)save;
+(Company *)shareInstance;
@end
