//
//  AddressModel.h
//  Linkage
//
//  Created by lihaijian on 16/3/23.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddressModel : NSManagedObject
@property (nullable, nonatomic, retain) NSString *addressId;
@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSNumber *title;
@property (nullable, nonatomic, retain) NSString *userId;
@end

NS_ASSUME_NONNULL_END
