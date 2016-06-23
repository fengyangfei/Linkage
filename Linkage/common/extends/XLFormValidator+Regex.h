//
//  XLFormValidator+Regex.h
//  Linkage
//
//  Created by Mac mini on 16/6/23.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <XLForm/XLForm.h>

@interface XLFormValidator (Regex)

+(XLFormValidator *)emailRegexValidator;
+(XLFormValidator *)phoneNumValidator;
+(XLFormValidator *)passswordValidator;
@end
