//
//  Address.h
//  Linkage
//
//  Created by Mac mini on 16/3/23.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Address : NSObject
@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, copy) NSString *address;
-(BOOL)save;
+(Address *)defaultAddress;
-(BOOL)remove;
@end
