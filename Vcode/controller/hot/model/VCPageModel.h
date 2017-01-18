//
//  VCPageModel.h
//  Linkage
//
//  Created by lihaijian on 2017/1/7.
//  Copyright © 2017年 LA. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface VCPageModel : NSManagedObject
@property (nullable, nonatomic, retain) NSString *gid;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NSNumber *sortNumber;
@property (nullable, nonatomic, retain) NSString *imageIndex;
@end
