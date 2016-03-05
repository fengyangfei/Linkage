//
//  TRImagePicker.h
//  YGTravel
//
//  Created by Mac mini on 16/1/5.
//  Copyright © 2016年 ygsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QBImagePickerController.h>
#import "TRImagePickerDelegate.h"

@interface UIViewController (TRImagePicker)

//选择单个图片
- (void)addSignalPhoto:(void (^)(UIImage *image, NSString *fileName))block;

//选择多个图片
- (void)addMultiplePhoto:(void (^)(UIImage *image, NSString *fileName))block;

@end