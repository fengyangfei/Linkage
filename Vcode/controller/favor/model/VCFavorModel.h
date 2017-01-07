//
//  VCFavorModel.h
//  Linkage
//
//  Created by lihaijian on 2017/1/7.
//  Copyright © 2017年 LA. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface VCFavorModel : NSManagedObject
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NSDate   *createdDate;
@end
