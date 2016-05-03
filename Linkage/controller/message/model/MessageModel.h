//
//  MessageModel.h
//  Linkage
//
//  Created by Mac mini on 16/5/3.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageModel : NSManagedObject
@property (nullable, nonatomic, retain) NSString *messageId;
@property (nullable, nonatomic, retain) NSNumber *type;
@property (nullable, nonatomic, retain) NSString *icon;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *introduction;
@property (nullable, nonatomic, retain) NSDate *createTime;
@property (nullable, nonatomic, retain) NSString *userId;
@end

NS_ASSUME_NONNULL_END