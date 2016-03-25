//
//  AccountModel.h
//  YGTravel
//
//  Created by Mac mini on 15/7/20.
//  Copyright (c) 2015年 ygsoft. All rights reserved.
//

#import "ImageToDataTransformer.h"


@implementation ImageToDataTransformer


+ (BOOL)allowsReverseTransformation {
	return YES;
}

+ (Class)transformedValueClass {
	return [NSData class];
}

- (id)transformedValue:(id)value {
    if ([value isKindOfClass:[UIImage class]]) {
        NSData *data = UIImagePNGRepresentation(value);
        if (!data) {
            data = UIImageJPEGRepresentation(value,1.0);
        }
        return data;
    }
    return value;
}

- (id)reverseTransformedValue:(id)value {
	UIImage *uiImage = [[UIImage alloc] initWithData:value];
	return uiImage;
}

@end
