//
//  StaffModel.h
//  Linkage
//
//  Created by lihaijian on 16/4/30.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface StaffModel : NSManagedObject

@property (nullable, nonatomic, retain) NSString *staffId;
@property (nullable, nonatomic, retain) NSString *userName;
@property (nullable, nonatomic, retain) NSString *realname;
@property (nullable, nonatomic, retain) NSString *mobile;
@property (nullable, nonatomic, retain) NSString *staffIcon;
@property (nullable, nonatomic, retain) NSString *userId;
@end

NS_ASSUME_NONNULL_END