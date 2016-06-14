//
//  Company.h
//  Linkage
//
//  Created by lihaijian on 16/3/25.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "Favorite.h"

@interface Company : Favorite
@property (nonatomic,copy  ) NSString *introduction;
@property (nonatomic,copy  ) NSString *contactorPhone;
@property (nonatomic,copy  ) NSString *address;
@property (nonatomic,copy  ) NSString *email;
@property (nonatomic,copy  ) NSString *fax;
@property (nonatomic,copy  ) NSString *url;
@property (nonatomic,copy  ) NSString *servicePhone2;
@property (nonatomic,copy  ) NSString *servicePhone3;
@property (nonatomic,copy  ) NSString *servicePhone4;
@property (nonatomic,strong) NSArray  *companyImages;
@property (nonatomic,strong) NSArray  *customerPhones;
-(BOOL)save;
+(Company *)shareInstance;
@end